import 'package:flutter/material.dart';
import 'package:geekcontrol/core/library/page_builder/exceptions_pages/hitagi_error_page.dart';
import 'package:geekcontrol/core/library/page_builder/exceptions_pages/hitagi_no_content_page.dart';
import 'package:geekcontrol/core/utils/global_variables.dart';
import 'package:geekcontrol/core/utils/loader_indicator.dart';
import 'package:geekcontrol/view/services/cache/local_cache.dart';
import 'package:go_router/go_router.dart';
import 'package:logger/logger.dart';
import 'package:provider/provider.dart';

enum ControllerState {
  idle,
  loading,
  success,
  error,
  refresh,
  empty,
}

abstract class HitagiController extends ChangeNotifier {
  LocalCache get cache => di<LocalCache>();
  final _log = Logger();

  ControllerState _state = ControllerState.idle;
  String? _errorMessage;

  ControllerState get state => _state;
  String? get errorMessage => _errorMessage;

  Future<void> init({dynamic param});

  void refresh() {
    setState(ControllerState.refresh);
    _log.i('Controller refreshed');
    init();
  }

  void setState(ControllerState newState) {
    _state = newState;
    _log.i('State changed to: $_state');
    notifyListeners();
  }

  void setError(String message) {
    _errorMessage = message;
    _log.e('Controller error: $message');
    setState(ControllerState.error);
  }

  Future<T?> handleTry<T>(
    Future<T> Function() callback, {
    void Function(Object error, StackTrace stack)? onError,
  }) async {
    try {
      setState(ControllerState.loading);
      _log.i('Starting async operation...');
      final result = await callback();
      setState(ControllerState.success);
      _log.i('Async operation completed successfully.');
      return result;
    } catch (e, stack) {
      setError(e.toString());
      _log.e('Exception caught in handleTry', error: e, stackTrace: stack);
      onError?.call(e, stack);
      return null;
    }
  }
}

abstract class HitagiPage<T extends HitagiController> extends StatefulWidget {
  const HitagiPage({super.key});

  T createController();

  Widget build(BuildContext context, T controller);

  Widget? buildLoading(BuildContext context, T controller) {
    return null;
  }

  @override
  State<HitagiPage<T>> createState() => _HitagiPageState<T>();
}

class _HitagiPageState<T extends HitagiController>
    extends State<HitagiPage<T>> {
  late final T controller;

  @override
  void initState() {
    super.initState();
    controller = widget.createController();
    controller.init();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<T>.value(
      value: controller,
      child: Consumer<T>(
        builder: (_, ctrl, __) {
          switch (ctrl.state) {
            case ControllerState.loading:
            case ControllerState.refresh:
              return widget.buildLoading.call(context, ctrl) ??
                  Scaffold(body: Center(child: Loader.ballPulse()));
            case ControllerState.error:
              return HitagiErrorPage(
                onRetry: () => ctrl.refresh(),
                onBack: () => context.canPop()
                    ? context.pop()
                    : GoRouter.of(context).push('/'),
              );
            case ControllerState.success:
            case ControllerState.idle:
              return widget.build(context, ctrl);
            case ControllerState.empty:
              return HitagiNoContentPage();
          }
        },
      ),
    );
  }
}
