import 'package:dtcameo/utils/color.dart';
import 'package:dtcameo/utils/shareperf.dart';
import 'package:dtcameo/utils/utils.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';

class AboutInFormation extends StatefulWidget {
  final String appBarTitle, loadURL;

  const AboutInFormation({
    super.key,
    required this.appBarTitle,
    required this.loadURL,
  });

  @override
  State<AboutInFormation> createState() => _AboutInFormationState();
}

class _AboutInFormationState extends State<AboutInFormation> {
  var loadingPercentage = 0;
  InAppWebViewController? webViewController;
  PullToRefreshController? pullToRefreshController;
  SharePre sharedPref = SharePre();

  @override
  void initState() {
    super.initState();
    printLog("loadURL ========> ${widget.loadURL}");
    pullToRefreshController = (kIsWeb) ||
            ![TargetPlatform.iOS, TargetPlatform.android]
                .contains(defaultTargetPlatform)
        ? null
        : PullToRefreshController(
            options: PullToRefreshOptions(color: red),
            onRefresh: () async {
              if (defaultTargetPlatform == TargetPlatform.android) {
                webViewController?.reload();
              } else if (defaultTargetPlatform == TargetPlatform.iOS ||
                  defaultTargetPlatform == TargetPlatform.macOS) {
                webViewController?.loadUrl(
                    urlRequest:
                        URLRequest(url: await webViewController?.getUrl()));
              }
            },
          );
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (kIsWeb) {
      return Scaffold(
        resizeToAvoidBottomInset: true,
        backgroundColor: colorPrimaryDark,
        body: Container(
          constraints: BoxConstraints(
            minHeight: MediaQuery.of(context).size.height,
            minWidth: MediaQuery.of(context).size.width,
          ),
          child: setWebView(),
        ),
      );
    } else {
      return Scaffold(
        resizeToAvoidBottomInset: true,
        backgroundColor: colorPrimary,
        appBar: AppBar(
          backgroundColor: colorPrimary,
          leading: Utils.backButton(context),
        ),
        body: Column(
          children: [
            // AdMob Banner /
            Container(
              child: Utils.showBannerAd(context),
            ),
            Expanded(
              child: setWebView(),
            ),
          ],
        ),
      );
    }
  }

  Widget setWebView() {
    String formattedUrl = widget.loadURL.replaceAll('//', '/');
    return Stack(
      children: [
        InAppWebView(
          initialUrlRequest: URLRequest(url: Uri.parse(formattedUrl)),
          initialOptions: InAppWebViewGroupOptions(
            crossPlatform: InAppWebViewOptions(
              supportZoom: true,
              javaScriptEnabled: true,
              clearCache: true,
              disableHorizontalScroll: true,
              disableVerticalScroll: false,
            ),
          ),
          pullToRefreshController: pullToRefreshController,
          onLoadStart: (controller, url) async {
            setState(() {
              loadingPercentage = 0;
            });
          },
          shouldOverrideUrlLoading: (controller, navigationAction) async {
            return NavigationActionPolicy.ALLOW;
          },
          onLoadStop: (controller, url) async {
            setState(() {
              loadingPercentage = 100;
            });
          },
          onProgressChanged: (controller, progress) {
            setState(() {
              loadingPercentage = progress;
            });
          },
          onUpdateVisitedHistory: (controller, url, isReload) {
            printLog("onUpdateVisitedHistory url =========> $url");
          },
          onConsoleMessage: (controller, consoleMessage) {
            printLog("consoleMessage =========> $consoleMessage");
          },
        ),
        if (loadingPercentage < 100)
          LinearProgressIndicator(
            color: red,
            backgroundColor: colorPrimaryDark,
            value: loadingPercentage / 100.0,
          ),
      ],
    );
  }
}
