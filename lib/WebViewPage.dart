// Copyright 2013 The Flutter Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

// ignore_for_file: public_member_api_docs

import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:spiral_vis/Universals.dart';
import 'package:webview_flutter/webview_flutter.dart';

void main() => runApp(MaterialApp(home: WebViewPage(url: '', name: '')));

class WebViewPage extends StatefulWidget {
  final String url;
  final String name;

  const WebViewPage({Key? key, required this.url, required this.name}) : super(key: key);

  @override
  _WebViewPageState createState() => _WebViewPageState();
}

class _WebViewPageState extends State<WebViewPage> {
  late final WebViewController controller;

  @override
  void initState() {
    super.initState();
    controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(
        NavigationDelegate(
          onProgress: (int progress) {
            // Update loading bar.
          },
          onPageStarted: (String url) {},
          onPageFinished: (String url) {},
          onWebResourceError: (WebResourceError error) {},
        ),
      )
      ..loadRequest(Uri.parse(widget.url));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.name),
        actions: [
          NavigationControls(controller),
        ],
      ),
      body: WebViewWidget(controller: controller),
    );
  }
}

class NavigationControls extends StatelessWidget {
  final WebViewController controller;

  const NavigationControls(this.controller, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        IconButton(
          icon: const Icon(Icons.arrow_back_ios),
          onPressed: () async {
            if (await controller.canGoBack()) {
              await controller.goBack();
            } else {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text("No back history item")),
              );
            }
          },
        ),
        IconButton(
          icon: const Icon(Icons.arrow_forward_ios),
          onPressed: () async {
            if (await controller.canGoForward()) {
              await controller.goForward();
            } else {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text("No forward history item")),
              );
            }
          },
        ),
        IconButton(
          icon: const Icon(Icons.replay),
          onPressed: () {
            controller.reload();
          },
        ),
      ],
    );
  }
}