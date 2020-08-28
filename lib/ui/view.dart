import 'package:flutter/material.dart';
import 'package:hn_state_example/core/i18n/strings.dart';
import 'package:hn_state_example/core/locator.dart';
import 'package:hn_state_example/core/models/base_model.dart';

class ModelCache {
  final Map<Type, BaseModel> modelCache = {};

  Model builder<Model extends BaseModel>(Model Function() newModel) {
    var cached = modelCache[Model] as Model;
    if (cached == null) {
      cached = newModel();
      modelCache[Model] = cached;
    }
    return cached;
  }

  void dispose() {
    for (final model in modelCache.values) {
      model.dispose();
    }
    modelCache.clear();
  }
}

/// Adds the posibility to cache the model higher up in the widget tree
/// To use this either pass a [CachedModelBuilder<Model>] to the [View]
/// or use a [ModelCache] and pass its builder function
/// **Note that the model will no longer be disposed automatically so this
/// needs to be handled where you are caching the model**
typedef CachedModelBuilder<Model> = Model Function(Model Function() newModel);

class View<Model extends BaseModel> extends StatefulWidget {
  final Widget child;

  final Widget Function(BuildContext context, Model value, Widget child) builder;

  final Widget Function(BuildContext context) loaderBuilder;

  final Widget Function(BuildContext context, Model model) errorBuilder;

  final bool showLoader;

  final void Function(Model model) onModelReady;

  final bool showError;

  /// Adds the posibility to cache the model higher up in the widget tree
  /// To use this either pass a [CachedModelBuilder<Model>] to the [View]
  /// or use a [ModelCache] and pass its builder function
  /// **Note that the model will no longer be disposed automatically so this
  /// needs to be handled where you are caching the model**
  final CachedModelBuilder<Model> cachedModelBuilder;

  /// Adds the posibility to cache the model higher up in the widget tree
  /// **Note that the model will no longer be disposed automatically so this
  /// needs to be handled where you are caching the model**
  final Model cachedModel;

  const View({
    Key key,
    @required this.builder,
    this.child,
    this.onModelReady,
    this.cachedModelBuilder,
    this.cachedModel,
    this.loaderBuilder,
    this.errorBuilder,
    this.showLoader = true,
    this.showError = true,
  })  : assert(cachedModel == null || cachedModelBuilder == null,
            'You can only pass one of `cachedModel` and `cachedModelBuilder`'),
        super(key: key);

  @override
  _ViewState<Model> createState() => _ViewState<Model>();
}

class _ViewState<Model extends BaseModel> extends State<View<Model>> with WidgetsBindingObserver {
  Model _model;
  var _isCachedModel = false;

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    _model.didChangeAppLifecycleState(state);
  }

  Model _createModel() {
    final model = locate<Model>();
    widget.onModelReady?.call(model);
    return model;
  }

  @override
  void initState() {
    if (widget.cachedModel == null && widget.cachedModelBuilder == null) {
      _model = _createModel();
    } else {
      _isCachedModel = true;
      _model =
          widget.cachedModel ?? widget.cachedModelBuilder?.call(_createModel) ?? _createModel();
    }
    if (_model.usesAppLifecycle) {
      WidgetsBinding.instance.addObserver(this);
    }
    _model.addListener(_modelChanged);
    super.initState();
  }

  void _modelChanged() {
    setState(() {});
  }

  @override
  void dispose() {
    _model.removeListener(_modelChanged);
    if (!_isCachedModel) {
      _model.dispose();
    }
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _model.refreshProvided(context);
    return (widget.showLoader ?? false || widget.showError ?? false)
        ? AnimatedSwitcher(
            duration: const Duration(milliseconds: 330),
            child: _model.isLoading && (widget.showLoader ?? false)
                ? widget.loaderBuilder?.call(context) ??
                    const Center(
                      child: CircularProgressIndicator(),
                    )
                : _model.hasError && (widget.showError ?? false)
                    ? widget.errorBuilder?.call(context, _model) ??
                        ConnectionErrorIndicator(model: _model)
                    : widget.builder(context, _model, widget.child),
          )
        : widget.builder(context, _model, widget.child);
  }
}

class ConnectionErrorIndicator extends StatelessWidget {
  final BaseModel model;
  final double topPadding;

  const ConnectionErrorIndicator({
    Key key,
    @required this.model,
    this.topPadding = 24,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          SizedBox(height: topPadding),
          const Icon(Icons.error),
          const SizedBox(height: 16),
          Text(
            Strings.of(context).errors.failedLoading,
            textAlign: TextAlign.center,
          ),
          RaisedButton(
            onPressed: model.retryLoading,
            child: Text(Strings.of(context).errors.tryAgain),
          ),
        ],
      ),
    );
  }
}
