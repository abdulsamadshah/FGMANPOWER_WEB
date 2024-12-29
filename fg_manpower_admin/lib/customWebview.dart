
import 'dart:io';


import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

import 'Services.dart';

class CustomWebviewScreen extends StatefulWidget {
  CustomWebviewScreen({Key? key}) : super(key: key);

  @override
  State<CustomWebviewScreen> createState() => _CustomWebviewScreenState();
}

class _CustomWebviewScreenState extends State<CustomWebviewScreen> {
  late WebViewController _webViewController;

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        if (await _webViewController.canGoBack()) {
          _webViewController.goBack();
          return false;
        } else {
          _showExitDialog(context);
          return false;
        }
      },
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.deepPurpleAccent,
          title: const Text('DEVELOPMENT',style: TextStyle(color: Colors.white),),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back,color: Colors.white,),
            onPressed: () async {
              if (await _webViewController.canGoBack()) {
                _webViewController.goBack();
              } else {
                _showExitDialog(context);
              }
            },
          ),
        ),
        backgroundColor: Colors.white,
        body: SafeArea(
          child: WebView(
            initialUrl: Services.url,
            javascriptMode: JavascriptMode.unrestricted,
            onPageFinished: (url) {},
            onWebViewCreated: (WebViewController controller) {
              _webViewController = controller;
            },
          ),
        ),
      ),
    );
  }

  void _showExitDialog(BuildContext context) {
    popupdialog(
      context,
      title: "Are you sure?",
      content: "Do you want to exit the App?",
      yes: () {
        exit(0);
      },
      no: () {
        Navigator.of(context).pop(false);
      },
    );
  }

  static popupdialog(BuildContext context,
      {String? title, String? content, void Function()? yes, void Function()? no}) {
    return showCupertinoDialog(
      context: context,
      builder: (BuildContext context) {
        return CupertinoAlertDialog(
          title: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 15, bottom: 10),
                child: Text(
                  title ?? '',
                  style: const TextStyle(
                    fontWeight: FontWeight.normal,
                    fontSize: 16,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              Text(
                content ?? '',
                style: const TextStyle(fontSize: 12),
                textAlign: TextAlign.center,
              ),
            ],
          ),
          actions: [
            CupertinoDialogAction(
              onPressed: no,
              child: const Text(
                "NO",
                style: TextStyle(color: Colors.black),
              ),
            ),
            CupertinoDialogAction(
              onPressed: yes,
              child: const Text(
                "YES",
                style: TextStyle(color: Colors.deepPurpleAccent),
              ),
            ),
          ],
        );
      },
    );
  }
}
