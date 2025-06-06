library flutter_pagewise;

import 'package:flutter/material.dart';

import 'helpers/grid_helper.dart';

typedef ItemBuilder<T> = Widget Function(BuildContext context, T entry, int index);
typedef PageFuture<T> = Future<List<T>> Function(int? pageIndex, Map<String, dynamic>? params);
typedef ErrorBuilder = Widget Function(BuildContext context, Object? error);
typedef LoadingBuilder = Widget Function(BuildContext context);
typedef NoItemsFoundBuilder = Widget Function(BuildContext context);
typedef RetryBuilder = Widget Function(BuildContext context, RetryCallback retryCallback);
typedef RetryCallback = void Function();
typedef PagewiseBuilder<T> = Widget Function(PagewiseState<T> state);

/// An abstract base class for widgets that fetch their content one page at a
/// time.
///
/// The widget fetches the page when we scroll down to it, and then keeps it in
/// memory
///
/// You can build your own Pagewise widgets by extending this class and
/// returning your builder in the [builder] function which provides you with the
/// Pagewise state. Look [PagewiseListView] and [PagewiseGridView] for examples.
///
/// See also:
///
///  * [PagewiseGridView], a [Pagewise] implementation of [GridView](https://docs.flutter.io/flutter/widgets/GridView-class.html)
///  * [PagewiseListView], a [Pagewise] implementation of [ListView](https://docs.flutter.io/flutter/widgets/ListView-class.html)
abstract class Pagewise<T> extends StatefulWidget {
  /// The number  of entries per page
  final int? pageSize;

  /// Called whenever a new page (or batch) is to be fetched
  ///
  /// It is provided with the page index, and expected to return a [Future](https://api.dartlang.org/stable/1.24.3/dart-async/Future-class.html) that
  /// resolves to a list of entries. Please make sure to return only [pageSize]
  /// or less entries (in the case of the last page) for each page.
  final PageFuture<T>? pageFuture;

  /// Called when loading each page.
  ///
  /// It is expected to return a widget to display while the page is loading.
  /// For example:
  /// ```dart
  /// (BuildContext context) {
  ///   return Text('Loading...');
  /// }
  /// ```
  ///
  /// If not specified, a [CircularProgressIndicator](https://docs.flutter.io/flutter/material/CircularProgressIndicator-class.html) will be shown
  final LoadingBuilder? loadingBuilder;

  /// Called with an error object if an error occurs when loading the page
  ///
  /// It is expected to return a widget to display in place of the page that
  /// failed to load. For example:
  /// ```dart
  /// (BuildContext context, Object error) {
  ///   return Text('Failed to load page: $error');
  /// }
  /// ```
  /// If not specified, a [Text] containing the error will be displayed
  final ErrorBuilder? errorBuilder;

  /// Whether to show a retry button when page fails to load.
  ///
  /// If set to true, [retryBuilder] is called to show appropriate retry button.
  ///
  /// If set to false, [errorBuilder] is called instead to show appropriate
  /// error.
  final bool showRetry;

  /// Called when a page fails to load and [showRetry] is set to true.
  ///
  /// It is expected to return a widget that gives the user the idea that retry
  /// is possible. The builder is provided with a [RetryCallback] that must be
  /// called for the retry to happen.
  ///
  /// For example:
  /// ```dart
  /// (context, retryCallback) {
  ///   return FloatingActionButton(
  ///     onPressed: retryCallback,
  ///     backgroundColor: Colors.red,
  ///     child: Icon(Icons.refresh),
  ///   );
  /// }
  /// ```
  ///
  /// In the code above, when the button is pressed, retryCallback is called,
  /// which will retry to fetch the page.
  ///
  /// If not specified, a simple retry button will be shown
  final RetryBuilder? retryBuilder;

  /// Called when no items are found
  ///
  /// It is expected to return a widget that gives the user the idea that no
  /// items exist in the list
  /// For example:
  ///  ```dart
  ///  (BuildContext context) {
  ///    return Text('No Items Found!');
  ///  }
  ///  ```
  final NoItemsFoundBuilder? noItemsFoundBuilder;

  /// Called to build each entry in the view.
  ///
  /// It is called for each of the entries fetched by [pageFuture] and provided
  /// with the [BuildContext](https://docs.flutter.io/flutter/widgets/BuildContext-class.html) and the entry. It is expected to return the widget
  /// that we want to display for each entry
  ///
  /// For example, the [pageFuture] might return a list that looks like:
  /// ```dart
  ///[
  ///  {
  ///    'name': 'product1',
  ///    'price': 10
  ///  },
  ///  {
  ///    'name': 'product2',
  ///    'price': 15
  ///  },
  ///]
  /// ```
  /// Then itemBuilder will be called twice, once for each entry. We can for
  /// example do:
  /// ```dart
  /// (BuildContext context, dynamic entry) {
  ///   return Text(entry['name'] + ' - ' + entry['price']);
  /// }
  /// ```
  final ItemBuilder<T> itemBuilder;

  /// The actual builder that builds the Pagewise widget. It is called and
  /// provided the PagewiseState. This function is important only for classes
  /// extending Pagewise. See [PagewiseListView] and [PagewiseGridView] for
  /// examples.
  final PagewiseBuilder<T> builder;

  /// The controller that controls the loading of pages.
  ///
  /// You don't have to provide this parameter unless you want to control or
  /// listen to the data that Pagewise fetches. Review the documentation of
  /// [PagewiseLoadController] for more details
  final PagewiseLoadController<T>? pageLoadController;

  /// Creates a pagewise widget.
  ///
  /// This is an abstract class, this constructor should only be called from
  /// constructors of widgets that extend this class
  const Pagewise(
      {this.pageSize,
      this.pageFuture,
      super.key,
      this.pageLoadController,
      this.loadingBuilder,
      this.retryBuilder,
      this.noItemsFoundBuilder,
      this.showRetry = true,
      required this.itemBuilder,
      this.errorBuilder,
      required this.builder})
      : assert((pageLoadController == null && pageSize != null && pageFuture != null) || (pageLoadController != null && pageSize == null && pageFuture == null)),
        assert(showRetry == false || errorBuilder == null, 'Cannot specify showRetry and errorBuilder at the same time'),
        assert(showRetry == true || retryBuilder == null, "Cannot specify retryBuilder when showRetry is set to false");

  @override
  PagewiseState<T> createState() => PagewiseState<T>();
}

class PagewiseState<T> extends State<Pagewise<T>> {
  PagewiseLoadController<T>? _controller;

  PagewiseLoadController<T>? get _effectiveController => widget.pageLoadController ?? _controller;

  late VoidCallback _controllerListener;

  @override
  void initState() {
    super.initState();

    if (widget.pageLoadController == null) {
      _controller = PagewiseLoadController<T>(pageFuture: widget.pageFuture, pageSize: widget.pageSize);
    }

    _effectiveController!.init();

    _controllerListener = () {
      setState(() {});
    };

    _effectiveController!.addListener(_controllerListener);
  }

  @override
  void dispose() {
    super.dispose();
    _effectiveController!.removeListener(_controllerListener);
  }

  @override
  void didUpdateWidget(Pagewise<T> oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.pageLoadController == null && oldWidget.pageLoadController != null) {
      oldWidget.pageLoadController!.removeListener(_controllerListener);
      _controller = PagewiseLoadController<T>(pageFuture: oldWidget.pageLoadController!.pageFuture, pageSize: oldWidget.pageLoadController!.pageSize);
      _effectiveController!.addListener(_controllerListener);
      _effectiveController!.init();
    } else if (widget.pageLoadController != null && oldWidget.pageLoadController == null) {
      _controller!.removeListener(_controllerListener);
      _controller = null;
      _effectiveController!.addListener(_controllerListener);
      _effectiveController!.init();
    } else if (widget.pageLoadController != null && (widget.pageLoadController != oldWidget.pageLoadController)) {
      oldWidget.pageLoadController!.removeListener(_controllerListener);
      _effectiveController!.addListener(_controllerListener);
      _effectiveController!.init();
    }
  }

  int get _itemCount => _effectiveController!.loadedItems!.length + 1;

  @override
  Widget build(BuildContext context) {
    return widget.builder(this);
  }

  Widget _itemBuilder(BuildContext context, int index) {
    // The total number of widgets, is the number of loaded items, plus the
    // number of items that we appended to make all pages the same size,
    // plus 1 for the loader
    final total = _effectiveController!.loadedItems!.length + _effectiveController!._appendedItems.length + 1;

    if (index >= total) return const SizedBox.shrink();

    if (index == total - 1) {
      if (_effectiveController!.noItemsFound) {
        return _getNoItemsFoundWidget();
      }

      if (_effectiveController!.error != null) {
        if (widget.showRetry) {
          return _getRetryWidget();
        } else {
          return _getErrorWidget(_effectiveController!.error);
        }
      }

      if (_effectiveController!.hasMoreItems!) {
        _effectiveController!.fetchNewPage();
        return _getLoadingWidget();
      } else {
        return Container();
      }
    } else {
      if (index >= _effectiveController!.loadedItems!.length) {
        // this means that the function is asking for an element from the
        // appended items, so we return an empty container
        return Container();
      }
      // Otherwise, we return the actual item
      return widget.itemBuilder(context, _effectiveController!.loadedItems![index], index);
    }
  }

  Widget _getLoadingWidget() {
    return _getStandardContainer(child: widget.loadingBuilder != null ? widget.loadingBuilder!(context) : const CircularProgressIndicator());
  }

  Widget _getNoItemsFoundWidget() {
    return _getStandardContainer(child: widget.noItemsFoundBuilder != null ? widget.noItemsFoundBuilder!(context) : Container());
  }

  Widget _getErrorWidget(Object? error) {
    return _getStandardContainer(
        child: widget.errorBuilder != null
            ? widget.errorBuilder!(context, _effectiveController!.error)
            : Text('Error: $error', style: TextStyle(color: Theme.of(context).disabledColor, fontStyle: FontStyle.italic)));
  }

  Widget _getRetryWidget() {
    var defaultRetryButton = TextButton(
      onPressed: _effectiveController!.retry,
      child: const Icon(
        Icons.refresh,
        color: Colors.white,
      ),
    );

    return _getStandardContainer(child: widget.retryBuilder != null ? widget.retryBuilder!(context, _effectiveController!.retry) : defaultRetryButton);
  }

  Widget _getStandardContainer({Widget? child}) {
    return Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: Align(
          alignment: Alignment.topCenter,
          child: child,
        ));
  }
}

/// The controller responsible for managing page loading in Pagewise
///
/// You don't have to provide a controller yourself when creating a Pagewise
/// widget. The widget will create one for you. However you might wish to create
/// one yourself in order to achieve some effects.
///
/// Notice though that if you provide a controller yourself, you should provide
/// the [pageFuture] and [pageSize] parameters to the *controller* instead of
/// the widget.
///
/// A possible use case of the controller is to force a reset of the loaded
/// pages using a [RefreshIndicator](https://docs.flutter.io/flutter/material/RefreshIndicator-class.html).
/// you could achieve that as follows:
///
/// ```dart
/// final _pageLoadController = PagewiseLoadController(
///   pageSize: 6,
///   pageFuture: BackendService.getPage
/// );
///
/// @override
/// Widget build(BuildContext context) {
///   return RefreshIndicator(
///     onRefresh: () async {
///       await this._pageLoadController.reset();
///     },
///     child: PagewiseListView(
///         itemBuilder: this._itemBuilder,
///         pageLoadController: this._pageLoadController,
///     ),
///   );
/// }
/// ```
///
/// Another use case for creating the controller yourself is if you want to
/// listen to the state of Pagewise and act accordingly.
/// For example, you might want to show a specific widget when the list is empty
/// In that case, you could do:
/// ```dart
/// final _pageLoadController = PagewiseLoadController(
///   pageSize: 6,
///   pageFuture: BackendService.getPage
/// );
///
/// bool _empty = false;
///
/// @override
/// void initState() {
///   super.initState();
///
///   this._pageLoadController.addListener(() {
///     if (this._pageLoadController.noItemsFound) {
///       setState(() {
///         this._empty = this._pageLoadController.noItemsFound;
///       });
///     }
///   });
/// }
/// ```
///
/// And then in your `build` function you do:
/// ```dart
/// if (this._empty) {
///   return Text('NO ITEMS FOUND');
/// }
/// ```
class PagewiseLoadController<T> extends ChangeNotifier {
  List<T>? _loadedItems;
  late List _appendedItems;
  int _numberOfLoadedPages = 0;
  bool? _hasMoreItems;
  Object? _error;
  late bool _isFetching;

  /// Called whenever a new page (or batch) is to be fetched
  ///
  /// It is provided with the page index, and expected to return a [Future](https://api.dartlang.org/stable/1.24.3/dart-async/Future-class.html) that
  /// resolves to a list of entries. Please make sure to return only [pageSize]
  /// or less entries (in the case of the last page) for each page.
  final PageFuture<T>? pageFuture;

  /// The number  of entries per page
  final int? pageSize;

  Map<String, dynamic>? params;

  /// Creates a PagewiseLoadController.
  ///
  /// You must provide both the [pageFuture] and the [pageSize]
  PagewiseLoadController({required this.pageFuture, required this.pageSize, this.params});

  /// The list of items that have already been loaded
  List<T>? get loadedItems => _loadedItems;

  /// The number of pages that have already been loaded
  int? get numberOfLoadedPages => _numberOfLoadedPages;

  /// Whether there are still more items to load
  bool? get hasMoreItems => _hasMoreItems;

  /// The latest error that has been faced when trying to load a page
  Object? get error => _error;

  /// set to true if no data was found
  bool get noItemsFound => _loadedItems!.isEmpty && hasMoreItems == false;

  /// Called to initialize the controller. Same as [reset]
  void init() {
    reset();
  }

  /// Resets all the information of the controller
  void reset({Map<String, dynamic>? params}) {
    _appendedItems = [];
    _loadedItems = [];
    _numberOfLoadedPages = 0;
    _hasMoreItems = true;
    _error = null;
    _isFetching = false;
    this.params = params;
    notifyListeners();
  }

  /// Fetches a new page by calling [pageFuture]
  Future<void> fetchNewPage() async {
    if (!_isFetching) {
      _isFetching = true;

      List<T> page;
      pageFuture;
      try {
        page = await pageFuture!(_numberOfLoadedPages, params);
        _numberOfLoadedPages++;
      } catch (error) {
        _error = error;
        _isFetching = false;
        notifyListeners();
        return;
      }

      // Get length accounting for possible null Future return. We'l treat a null Future as an empty return
      final int length = (page.length);

      if (length > pageSize!) {
        _isFetching = false;
        throw ('Page length ($length) is greater than the maximum size ($pageSize)');
      }

      if (length > 0 && length < pageSize!) {
        // This should only happen when loading the last page.
        // In that case, we append the last page with a few items to make its size
        // similar to normal pages. This is useful especially with GridView,
        // because we want the loading to show on a new line on its own
        _appendedItems = List.generate(pageSize! - length, (_) => {});
      }

      if (length == 0) {
        _hasMoreItems = false;
      } else {
        _loadedItems!.addAll(page);
      }
      _isFetching = false;
      notifyListeners();
    }
  }

  /// Attempts to retry in case an error occurred
  void retry() {
    _error = null;
    notifyListeners();
  }
}

class PagewiseListView<T> extends Pagewise<T> {
  /// Creates a Pagewise ListView.
  ///
  /// All the properties are either those documented for normal [ListViews](https://docs.flutter.io/flutter/widgets/ListView-class.html),
  /// or those inherited from [Pagewise]
  PagewiseListView(
      {super.key,
      EdgeInsetsGeometry? padding,
      bool? primary,
      bool addSemanticIndexes = true,
      int? semanticChildCount,
      bool shrinkWrap = false,
      ScrollController? controller,
      super.pageLoadController,
      double? itemExtent,
      bool addAutomaticKeepAlives = true,
      Axis scrollDirection = Axis.vertical,
      bool addRepaintBoundaries = true,
      double? cacheExtent,
      ScrollPhysics? physics,
      bool reverse = false,
      super.pageSize,
      super.pageFuture,
      super.loadingBuilder,
      super.retryBuilder,
      super.noItemsFoundBuilder,
      super.showRetry,
      required super.itemBuilder,
      super.errorBuilder})
      : super(
            builder: (PagewiseState<T> state) {
              return ListView.builder(
                  itemExtent: itemExtent,
                  addAutomaticKeepAlives: addAutomaticKeepAlives,
                  scrollDirection: scrollDirection,
                  addRepaintBoundaries: addRepaintBoundaries,
                  cacheExtent: cacheExtent,
                  physics: physics,
                  reverse: reverse,
                  padding: padding,
                  addSemanticIndexes: addSemanticIndexes,
                  semanticChildCount: semanticChildCount,
                  shrinkWrap: shrinkWrap,
                  primary: primary,
                  controller: controller,
                  itemCount: state._itemCount,
                  itemBuilder: state._itemBuilder);
            });
}

class PagewiseGridView<T> extends Pagewise<T> {
  /// Creates a Pagewise GridView with a crossAxisCount.
  ///
  /// All the properties are either those documented for normal [GridViews](https://docs.flutter.io/flutter/widgets/GridView-class.html)
  /// or those inherited from [Pagewise]
  PagewiseGridView.count(
      {super.key,
      EdgeInsetsGeometry? padding,
      required int crossAxisCount,
      double childAspectRatio = 1.0,
      double crossAxisSpacing = 0.0,
      double mainAxisSpacing = 0.0,
      bool addSemanticIndexes = true,
      int? semanticChildCount,
      bool? primary,
      bool shrinkWrap = false,
      ScrollController? controller,
      super.pageLoadController,
      bool addAutomaticKeepAlives = true,
      Axis scrollDirection = Axis.vertical,
      bool addRepaintBoundaries = true,
      double? cacheExtent,
      ScrollPhysics? physics,
      bool reverse = false,
      super.pageSize,
      super.pageFuture,
      super.loadingBuilder,
      super.retryBuilder,
      super.noItemsFoundBuilder,
      super.showRetry,
      required super.itemBuilder,
      super.errorBuilder})
      : super(
            builder: (PagewiseState<T> state) {
              return GridView.builder(
                  reverse: reverse,
                  physics: physics,
                  cacheExtent: cacheExtent,
                  addRepaintBoundaries: addRepaintBoundaries,
                  scrollDirection: scrollDirection,
                  addAutomaticKeepAlives: addAutomaticKeepAlives,
                  controller: controller,
                  primary: primary,
                  shrinkWrap: shrinkWrap,
                  padding: padding,
                  addSemanticIndexes: addSemanticIndexes,
                  semanticChildCount: semanticChildCount,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCountAndLoading(
                      crossAxisCount: crossAxisCount, childAspectRatio: childAspectRatio, crossAxisSpacing: crossAxisSpacing, mainAxisSpacing: mainAxisSpacing, itemCount: state._itemCount),
                  itemCount: state._itemCount,
                  itemBuilder: state._itemBuilder);
            });

  /// Creates a Pagewise GridView with a maxCrossAxisExtent.
  ///
  /// All the properties are either those documented for normal [GridViews](https://docs.flutter.io/flutter/widgets/GridView-class.html)
  /// or those inherited from [Pagewise]
  PagewiseGridView.extent(
      {super.key,
      EdgeInsetsGeometry? padding,
      required double maxCrossAxisExtent,
      double childAspectRatio = 1.0,
      double crossAxisSpacing = 0.0,
      double mainAxisSpacing = 0.0,
      bool addSemanticIndexes = true,
      int? semanticChildCount,
      bool? primary,
      bool shrinkWrap = false,
      ScrollController? controller,
      super.pageLoadController,
      bool addAutomaticKeepAlives = true,
      Axis scrollDirection = Axis.vertical,
      bool addRepaintBoundaries = true,
      double? cacheExtent,
      ScrollPhysics? physics,
      bool reverse = false,
      super.pageSize,
      super.pageFuture,
      super.loadingBuilder,
      super.retryBuilder,
      super.noItemsFoundBuilder,
      super.showRetry,
      required super.itemBuilder,
      super.errorBuilder})
      : super(
            builder: (PagewiseState<T> state) {
              return GridView.builder(
                  reverse: reverse,
                  physics: physics,
                  cacheExtent: cacheExtent,
                  addRepaintBoundaries: addRepaintBoundaries,
                  scrollDirection: scrollDirection,
                  addAutomaticKeepAlives: addAutomaticKeepAlives,
                  addSemanticIndexes: addSemanticIndexes,
                  semanticChildCount: semanticChildCount,
                  controller: controller,
                  primary: primary,
                  shrinkWrap: shrinkWrap,
                  padding: padding,
                  gridDelegate: SliverGridDelegateWithMaxCrossAxisExtentAndLoading(
                      maxCrossAxisExtent: maxCrossAxisExtent, childAspectRatio: childAspectRatio, crossAxisSpacing: crossAxisSpacing, mainAxisSpacing: mainAxisSpacing, itemCount: state._itemCount),
                  itemCount: state._itemCount,
                  itemBuilder: state._itemBuilder);
            });
}

int _kDefaultSemanticIndexCallback(Widget _, int localIndex) => localIndex;

class PagewiseSliverList<T> extends Pagewise<T> {
  /// Creates a Pagewise SliverList.
  ///
  /// All the properties are either those documented for normal [SliverList](https://docs.flutter.io/flutter/widgets/SliverList-class.html)
  /// or those inherited from [Pagewise]
  PagewiseSliverList(
      {super.key,
      bool addSemanticIndexes = true,
      bool addAutomaticKeepAlives = true,
      bool addRepaintBoundaries = true,
      SemanticIndexCallback semanticIndexCallback = _kDefaultSemanticIndexCallback,
      int semanticIndexOffset = 0,
      super.pageLoadController,
      super.pageSize,
      super.pageFuture,
      super.loadingBuilder,
      super.retryBuilder,
      super.noItemsFoundBuilder,
      super.showRetry,
      required super.itemBuilder,
      super.errorBuilder})
      : super(
            builder: (PagewiseState<T> state) {
              return SliverList(
                delegate: SliverChildBuilderDelegate(state._itemBuilder,
                    addAutomaticKeepAlives: addAutomaticKeepAlives,
                    addRepaintBoundaries: addRepaintBoundaries,
                    addSemanticIndexes: addSemanticIndexes,
                    semanticIndexCallback: semanticIndexCallback,
                    semanticIndexOffset: semanticIndexOffset,
                    childCount: state._itemCount),
              );
            });
}

class PagewiseSliverGrid<T> extends Pagewise<T> {
  /// Creates a Pagewise SliverGrid with a crossAxisCount.
  ///
  /// All the properties are either those documented for normal [SliverGrid](https://docs.flutter.io/flutter/widgets/SliverGrid-class.html)
  /// or those inherited from [Pagewise]
  PagewiseSliverGrid.count(
      {super.key,
      bool addSemanticIndexes = true,
      bool addAutomaticKeepAlives = true,
      bool addRepaintBoundaries = true,
      SemanticIndexCallback semanticIndexCallback = _kDefaultSemanticIndexCallback,
      int semanticIndexOffset = 0,
      required int crossAxisCount,
      double childAspectRatio = 1.0,
      double crossAxisSpacing = 0.0,
      double mainAxisSpacing = 0.0,
      super.pageLoadController,
      super.pageSize,
      super.pageFuture,
      super.loadingBuilder,
      super.retryBuilder,
      super.noItemsFoundBuilder,
      super.showRetry,
      required super.itemBuilder,
      super.errorBuilder})
      : super(
            builder: (PagewiseState<T> state) {
              return SliverGrid(
                delegate: SliverChildBuilderDelegate(state._itemBuilder,
                    addAutomaticKeepAlives: addAutomaticKeepAlives,
                    addRepaintBoundaries: addRepaintBoundaries,
                    addSemanticIndexes: addSemanticIndexes,
                    semanticIndexCallback: semanticIndexCallback,
                    semanticIndexOffset: semanticIndexOffset,
                    childCount: state._itemCount),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCountAndLoading(
                    crossAxisCount: crossAxisCount, childAspectRatio: childAspectRatio, crossAxisSpacing: crossAxisSpacing, mainAxisSpacing: mainAxisSpacing, itemCount: state._itemCount),
              );
            });

  /// Creates a Pagewise SliverGrid with a maxCrossAxisExtent.
  ///
  /// All the properties are either those documented for normal [SliverGrid](https://docs.flutter.io/flutter/widgets/SliverGrid-class.html)
  /// or those inherited from [Pagewise]
  PagewiseSliverGrid.extent(
      {super.key,
      bool addSemanticIndexes = true,
      bool addAutomaticKeepAlives = true,
      bool addRepaintBoundaries = true,
      SemanticIndexCallback semanticIndexCallback = _kDefaultSemanticIndexCallback,
      int semanticIndexOffset = 0,
      required double maxCrossAxisExtent,
      double childAspectRatio = 1.0,
      double crossAxisSpacing = 0.0,
      double mainAxisSpacing = 0.0,
      super.pageLoadController,
      super.pageSize,
      super.pageFuture,
      super.loadingBuilder,
      super.retryBuilder,
      super.noItemsFoundBuilder,
      super.showRetry,
      required super.itemBuilder,
      super.errorBuilder})
      : super(
            builder: (PagewiseState<T> state) {
              return SliverGrid(
                delegate: SliverChildBuilderDelegate(state._itemBuilder,
                    addAutomaticKeepAlives: addAutomaticKeepAlives,
                    addRepaintBoundaries: addRepaintBoundaries,
                    addSemanticIndexes: addSemanticIndexes,
                    semanticIndexCallback: semanticIndexCallback,
                    semanticIndexOffset: semanticIndexOffset,
                    childCount: state._itemCount),
                gridDelegate: SliverGridDelegateWithMaxCrossAxisExtentAndLoading(
                    maxCrossAxisExtent: maxCrossAxisExtent, childAspectRatio: childAspectRatio, crossAxisSpacing: crossAxisSpacing, mainAxisSpacing: mainAxisSpacing, itemCount: state._itemCount),
              );
            });
}
