import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:get/get.dart';
import 'package:takaful/app/modules/membership/renew/views/renew_success_view.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../../utils/storage_util.dart';
import '../../../../data/models/subscription_model.dart';

class RenewKHQRView extends StatefulWidget {
  final SubscriptionModel subscription;
  final String checkoutUrl;
  final String deepLink;

  const RenewKHQRView({
    super.key,
    required this.subscription,
    required this.checkoutUrl,
    required this.deepLink,
  });

  @override
  State<RenewKHQRView> createState() => _RenewKHQRViewState();
}

class _RenewKHQRViewState extends State<RenewKHQRView> {
  final GlobalKey webViewKey = GlobalKey();
  InAppWebViewController? _webViewController;
  PullToRefreshController? pullToRefreshController;

  double progress = 0;
  String? error;

  @override
  void initState() {
    _launchABADeeplink(widget.deepLink);

    pullToRefreshController = PullToRefreshController(
      options: PullToRefreshOptions(
        color: Colors.blue,
      ),
      onRefresh: () async {
        if (Platform.isAndroid) {
          _webViewController?.reload();
        } else if (Platform.isIOS) {
          _webViewController?.loadUrl(urlRequest: URLRequest(url: await _webViewController?.getUrl()));
        }
      },
    );

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Get.back(result: true);
          },
          icon: const Icon(Icons.close),
        ),
        title: Text('Pay with KHQR'.tr),
        centerTitle: false,

        /// add progress bar in bottom app bar
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(2),
          child: LinearProgressIndicator(
            value: progress,
            backgroundColor: Colors.transparent,
            valueColor: const AlwaysStoppedAnimation<Color>(Colors.white),
          ),
        ),
      ),
      body: SafeArea(
        child: SizedBox(
          width: Get.width,
          child: FutureBuilder(
            future: StorageUtil.securedRead('token'),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return InAppWebView(
                  key: webViewKey,
                  initialUrlRequest: URLRequest(
                    url: WebUri(widget.checkoutUrl),
                    headers: {
                      'Accept': 'application/json',
                      'authorization': "Bearer ${snapshot.data}",
                      'Content-type': 'application/json; charset=utf-8',
                    },
                    method: 'GET',
                  ),
                  initialOptions: InAppWebViewGroupOptions(
                    crossPlatform: InAppWebViewOptions(
                      supportZoom: false,
                      verticalScrollBarEnabled: true,
                      clearCache: true,
                      disableContextMenu: false,
                      cacheEnabled: true,
                      javaScriptEnabled: true,
                      javaScriptCanOpenWindowsAutomatically: true,
                      transparentBackground: true,
                      mediaPlaybackRequiresUserGesture: false,
                      useShouldOverrideUrlLoading: true,
                    ),
                    ios: IOSInAppWebViewOptions(
                      sharedCookiesEnabled: true,
                      allowsPictureInPictureMediaPlayback: true,
                      ignoresViewportScaleLimits: true,
                      useOnNavigationResponse: true,
                    ),
                    android: AndroidInAppWebViewOptions(
                      allowContentAccess: true,
                      thirdPartyCookiesEnabled: true,
                      supportMultipleWindows: true,
                      loadsImagesAutomatically: true,
                      allowFileAccess: true,
                      useHybridComposition: true,
                      useWideViewPort: true,
                      useShouldInterceptRequest: true,
                    ),
                  ),

                  /// Set progress bar
                  onProgressChanged: (webViewController, progress) {
                    if (progress == 100) {
                      pullToRefreshController?.endRefreshing();
                    }

                    setState(() {
                      this.progress = progress / 100;
                    });
                  },
                  onWebViewCreated: (webViewController) {
                    _webViewController = webViewController;
                  },

                  /// check if user click on continue button on iOS
                  iosOnNavigationResponse: (webViewController, IOSWKNavigationResponse navigationResponse) async {
                    if (navigationResponse.response?.url.toString() == 'https://portal.takafulcambodia.org/') {
                      Get.off(() => RenewSuccessView(subscription: widget.subscription));
                      return IOSNavigationResponseAction.CANCEL;
                    }
                    return IOSNavigationResponseAction.ALLOW;
                  },

                  /// check if user click on continue button on android
                  androidShouldInterceptRequest: (webViewController, WebResourceRequest request) async {
                    if (request.url.toString() == 'https://portal.takafulcambodia.org/') {
                      Get.off(() => RenewSuccessView(subscription: widget.subscription));
                    }
                    return null;
                  },
                );
              }

              return const Text('loading...');
            },
          ),
        ),
      ),
    );
  }

  Future<void> _launchABADeeplink(String deepLink) async {
    Uri uri = Uri.parse(deepLink);

    /// wait 0 seconds before launch deep link
    await Future.delayed(const Duration(seconds: 0));
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    } else {
      Get.rawSnackbar(
        title: 'ABA Bank is not installed'.tr,
        message: 'Please scan to pay with any banking app'.tr,
        margin: const EdgeInsets.all(8),
        borderRadius: 16,
      );
    }
  }
}
