import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:get/get.dart';
import 'package:takaful/app/modules/donate/views/donate_success_view.dart';

import '../../../../../utils/storage_util.dart';
import '../../../data/models/donation_model.dart';
import '../../../services/api_service.dart';

class DonatePayWayView extends StatefulWidget {
  final DonationModel donation;

  const DonatePayWayView({super.key, required this.donation});

  @override
  State<DonatePayWayView> createState() => _DonatePayWayViewState();
}

class _DonatePayWayViewState extends State<DonatePayWayView> {
  final GlobalKey webViewKey = GlobalKey();
  InAppWebViewController? _webViewController;
  PullToRefreshController? pullToRefreshController;

  double progress = 0;
  String? error;

  @override
  void initState() {
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
        title: Text('Credit/Debit Card'.tr),
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
                    url: WebUri('${ApiService.baseUrl}insurance/payway/donate?payment_method_code=cards&donation_uuid=${widget.donation.uuid}'),
                    headers: {
                      'Accept': 'application/json',
                      'authorization': "Bearer ${snapshot.data}",
                      'Content-type': 'application/json; charset=utf-8',
                    },
                    method: 'GET',
                  ),
                  initialOptions: InAppWebViewGroupOptions(
                    crossPlatform: InAppWebViewOptions(
                      supportZoom: true,
                      verticalScrollBarEnabled: true,
                      clearCache: true,
                      disableContextMenu: false,
                      cacheEnabled: true,
                      javaScriptEnabled: true,
                      javaScriptCanOpenWindowsAutomatically: true,
                      transparentBackground: true,
                      mediaPlaybackRequiresUserGesture: false,
                      useShouldOverrideUrlLoading: true,
                      useShouldInterceptAjaxRequest: true,
                      useShouldInterceptFetchRequest: true,
                      incognito: false,
                      userAgent: "Mozilla/5.0 (Linux; Android 9; LG-H870 Build/PKQ1.190522.001) AppleWebKit/537.36 (KHTML, like Gecko) Version/4.0 Chrome/83.0.4103.106 Mobile Safari/537.36",
                      allowFileAccessFromFileURLs: true,
                      allowUniversalAccessFromFileURLs: true,
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
                      Get.off(() => DonateSuccessView(donation: widget.donation));
                      return IOSNavigationResponseAction.CANCEL;
                    }
                    return IOSNavigationResponseAction.ALLOW;
                  },

                  /// check if user click on continue button on android
                  androidShouldInterceptRequest: (webViewController, WebResourceRequest request) async {
                    if (request.url.toString() == 'https://portal.takafulcambodia.org/') {
                      Get.off(
                        () => DonateSuccessView(donation: widget.donation),
                      );
                    }
                    return null;
                  },

                  shouldOverrideUrlLoading: (
                    controller,
                    navigationAction,
                  ) async {
                    return NavigationActionPolicy.ALLOW;
                  },

                  shouldInterceptAjaxRequest: (
                    InAppWebViewController controller,
                    AjaxRequest ajaxRequest,
                  ) async {
                    return ajaxRequest;
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
}
