import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:suzuki/util/system.dart';

class CircularLoaderComponent extends StatelessWidget {
  final CircularLoaderController controller;
  final Widget? child;
  final bool cover;
  final Widget? loadingBuilder;

  const CircularLoaderComponent({
    Key? key,
    required this.controller,
    this.child,
    this.cover = true,
    this.loadingBuilder,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<CircularLoaderValue>(
      valueListenable: controller,
      builder: (ctx, value, widget) {
        return GestureDetector(
          onTap: () {
            controller.close();
          },
          child: Container(
            width: double.infinity,
            height: double.infinity,
            color: Colors.transparent,
            child: Stack(
              children: [
                child ?? const SizedBox(),
                Container(
                  color: (cover && value.state != CircularLoaderState.idle) ==
                          false
                      ? null
                      : Colors.grey.shade400.withOpacity(0.6),
                  child: childBuilder(value.state),
                )
              ],
            ),
          ),
        );
      },
    );
  }

  Widget childBuilder(CircularLoaderState state) {
    switch (state) {
      case CircularLoaderState.idle:
        return const SizedBox();
      case CircularLoaderState.onLoading:
        return loadingBuilder == null ? onLoading() : loadingBuilder!;
      case CircularLoaderState.showError:
        return messageError();
      case CircularLoaderState.showMessage:
        return message();
    }
  }

  Widget onLoading() {
    return Align(
      alignment: Alignment.center,
      child: Container(
        margin: const EdgeInsets.only(left: 40, right: 40),
        height: 80,
        width: 80,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: const BorderRadius.all(Radius.circular(5)),
          border: Border.all(
            color: Colors.grey,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.shade400,
              blurRadius: 5,
              offset: const Offset(2, 2),
            )
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              height: 50,
              width: 50,
              padding: const EdgeInsets.all(10),
              color: Colors.transparent,
              child: CircularProgressIndicator(
                color: System.data.color!.primaryColor,
                strokeWidth: 4,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget message() {
    return Align(
      alignment: Alignment.center,
      child: Container(
        margin: const EdgeInsets.only(left: 40, right: 40),
        padding: const EdgeInsets.all(15),
        width: 400,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: const BorderRadius.all(Radius.circular(5)),
          border: Border.all(
            color: Colors.grey,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.shade400,
              blurRadius: 5,
              offset: const Offset(2, 2),
            )
          ],
        ),
        child: IntrinsicHeight(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              const Icon(
                FontAwesomeIcons.checkCircle,
                color: Colors.green,
                size: 50,
              ),
              const SizedBox(
                height: 20,
              ),
              !controller.value.message!.contains("<div")
                  ? Text(
                      controller.value.message ?? "Error",
                      textAlign: TextAlign.center,
                    )
                  : Container(
                      height: 300,
                      color: Colors.transparent,
                      child: SingleChildScrollView(
                        child: Html(
                          data: controller.value.message,
                        ),
                      ),
                    ),
            ],
          ),
        ),
      ),
    );
  }

  Widget messageError() {
    controller.value.message ?? "Error";
    return Align(
      alignment: Alignment.center,
      child: Container(
        margin: const EdgeInsets.only(left: 40, right: 40),
        padding: const EdgeInsets.all(15),
        width: 400,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: const BorderRadius.all(Radius.circular(5)),
          border: Border.all(
            color: Colors.grey,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.shade400,
              blurRadius: 5,
              offset: const Offset(2, 2),
            )
          ],
        ),
        child: IntrinsicHeight(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              const Icon(
                FontAwesomeIcons.timesCircle,
                color: Colors.red,
                size: 50,
              ),
              const SizedBox(
                height: 20,
              ),
              !controller.value.message!.contains("<div")
                  ? Text(
                      controller.value.message ?? "Error",
                      textAlign: TextAlign.center,
                    )
                  : Container(
                      height: 300,
                      color: Colors.transparent,
                      child: SingleChildScrollView(
                        child: Html(
                          data: controller.value.message,
                        ),
                      ),
                    ),
            ],
          ),
        ),
      ),
    );
  }
}

class CircularLoaderController extends ValueNotifier<CircularLoaderValue> {
  CircularLoaderController({CircularLoaderValue? value})
      : super(value ?? CircularLoaderValue());

  VoidCallback? onCloseCallback;

  void startLoading() {
    value.onclosed = false;
    value.state = CircularLoaderState.onLoading;
    commit();
  }

  void stopLoading({
    String? message,
    bool isError = false,
    Duration? duration,
    VoidCallback? onCloseCallBack,
  }) {
    onCloseCallback = onCloseCallBack;
    value.state = isError == true
        ? CircularLoaderState.showError
        : CircularLoaderState.showMessage;

    if (duration != null) {
      Timer.periodic(duration, (timer) {
        timer.cancel();
        close();
      });
    }

    if (message != null) {
      value.message = message;
    }

    commit();
  }

  void forceStop({String? message}) {
    value.message = message;
    value.onclosed = true;
    value.state = CircularLoaderState.idle;
    commit();
  }

  void close() {
    if (value.state == CircularLoaderState.onLoading) return;
    value.state = CircularLoaderState.idle;
    if (onCloseCallback != null && value.onclosed == false) {
      value.onclosed = true;
      onCloseCallback!();
    }
    value.onclosed = true;
    commit();
  }

  bool get onLoading {
    if (value.state == CircularLoaderState.onLoading) {
      return true;
    } else {
      return false;
    }
  }

  void commit() {
    notifyListeners();
  }
}

class CircularLoaderValue {
  CircularLoaderState state = CircularLoaderState.idle;
  String? message;
  bool onclosed = true;
}

enum CircularLoaderState {
  idle,
  onLoading,
  showError,
  showMessage,
}
