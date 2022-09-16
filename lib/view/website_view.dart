import 'dart:async';

import 'package:flutter/material.dart';
import 'package:suzuki/util/system.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:webview_flutter_web/webview_flutter_web.dart';

// ignore: use_key_in_widget_constructors
class WebsiteView extends StatefulWidget {
  final String? url;

  const WebsiteView({
    Key? key,
    required this.url,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return WebsiteViewState();
  }
}

class WebsiteViewState extends State<WebsiteView> {
  final Completer<WebViewController> _controller =
      Completer<WebViewController>();

  @override
  Widget build(BuildContext context) {
    WebView.platform = WebWebViewPlatform();

    return Scaffold(
      backgroundColor: System.data.color!.background,
      body: WebView(
        initialUrl: widget.url ?? 'https://flutter.dev',
        onWebViewCreated: (WebViewController controller) {
          _controller.complete(controller);
        },
      ),
    );
  }
}
