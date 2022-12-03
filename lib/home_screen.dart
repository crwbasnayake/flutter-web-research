// Copyright 2021 The Flutter team. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'dart:async';

import 'data/user.dart';
import 'simple_table_keepalive_image.dart';
import 'package:context_menus/context_menus.dart';

import 'package:flutter/material.dart';
// import 'dart:io' if (dart.library.html) 'dart:ui' as ui;
import 'dart:ui' as ui;
import 'dart:html' as html;

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context)
        .textTheme
        .apply(displayColor: Theme.of(context).colorScheme.onSurface);

    final theme = Theme.of(context).colorScheme.onSurface;

    return Expanded(
        child: Column(children: <Widget>[
      Container(
        height: 300,
        color: Color.fromARGB(255, 232, 232, 232),
        child: Iframe(),
      ),
      const WatchList()
    ]));
  }
}

class WatchList extends StatelessWidget {
  const WatchList({super.key});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context)
        .textTheme
        .apply(displayColor: Theme.of(context).colorScheme.onSurface);
    final List<ListItem> items = List<ListItem>.generate(
      500,
      (i) => i % 6 == 0
          ? HeadingItem('Heading $i')
          : MessageItem('Sender $i', 'Message body $i'),
    );

    final User _user = User();
    _user.initData(100);

    return Expanded(
        child: Column(children: <Widget>[
      Container(height: 20, color: const Color.fromARGB(255, 240, 240, 240)),
      Expanded(
          child: ContextMenuOverlay(
        child: ContextMenuRegion(
          contextMenu: GenericContextMenu(
            buttonConfigs: [
              ContextMenuButtonConfig(
                "View image in browser",
                onPressed: () => {},
              ),
              ContextMenuButtonConfig("Show Modal Dialog",
                  onPressed: () => {
                        showGeneralDialog(
                            context: context,
                            barrierDismissible: true,
                            barrierLabel: MaterialLocalizations.of(context)
                                .modalBarrierDismissLabel,
                            barrierColor: Colors.black45,
                            transitionDuration:
                                const Duration(milliseconds: 100),
                            pageBuilder: (BuildContext buildContext,
                                Animation animation,
                                Animation secondaryAnimation) {
                              return Center(
                                child: Container(
                                  width:
                                      MediaQuery.of(context).size.width - 200,
                                  height:
                                      MediaQuery.of(context).size.height - 180,
                                  padding: const EdgeInsets.all(20),
                                  color: Colors.white,
                                  child: Column(
                                    children: [
                                      ElevatedButton(
                                          onPressed: () {
                                            Navigator.of(context).pop();
                                          },
                                          child: const Text("Close"))
                                    ],
                                  ),
                                ),
                              );
                            })
                      })
            ],
          ),
          child: SimpleTableKeepAliveImagePage(
            user: _user,
          ),
        ),
      )

          // ListView.builder(
          //   // Let the ListView know how many items it needs to build.
          //   itemCount: items.length,
          //   // Provide a builder function. This is where the magic happens.
          //   // Convert each item into a widget based on the type of item it is.
          //   itemBuilder: (context, index) {
          //     final item = items[index];

          //     return ListTile(
          //       title: item.buildTitle(context),
          //       subtitle: item.buildSubtitle(context),
          //     );
          //   },
          // ),
          ),
    ]));
  }
}

/// The base class for the different types of items the list can contain.
abstract class ListItem {
  /// The title line to show in a list item.
  Widget buildTitle(BuildContext context);

  /// The subtitle line, if any, to show in a list item.
  Widget buildSubtitle(BuildContext context);
}

/// A ListItem that contains data to display a heading.
class HeadingItem implements ListItem {
  final String heading;

  HeadingItem(this.heading);

  @override
  Widget buildTitle(BuildContext context) {
    return Text(
      heading,
      style: Theme.of(context).textTheme.headline5,
    );
  }

  @override
  Widget buildSubtitle(BuildContext context) => const SizedBox.shrink();
}

/// A ListItem that contains data to display a message.
class MessageItem implements ListItem {
  final String sender;
  final String body;

  MessageItem(this.sender, this.body);

  @override
  Widget buildTitle(BuildContext context) => Text(sender);

  @override
  Widget buildSubtitle(BuildContext context) => Text(body);
}

class Iframe extends StatelessWidget {
  Iframe({super.key}) {
    // ignore: undefined_prefixed_name
    ui.platformViewRegistry.registerViewFactory('iframe', (int viewId) {
      var iframe = html.IFrameElement();
      iframe.src =
          'https://www.tradingview.com/widgetembed/?frameElementId=tradingview_78dee&symbol=AAPL&interval=D&hidesidetoolbar=0&symboledit=1&saveimage=0&toolbarbg=f1f3f6&studies=ROC%40tv-basicstudies%1FStochasticRSI%40tv-basicstudies%1FMASimple%40tv-basicstudies&theme=light&style=1&timezone=exchange&withdateranges=1&showpopupbutton=1&studies_overrides=%7B%7D&overrides=%7B%7D&enabled_features=%5B%5D&disabled_features=%5B%5D&showpopupbutton=1&locale=en&utm_source=www.tradingview.com&utm_medium=widget_new&utm_campaign=chart&utm_term=AAPL#%7B%22page-uri%22%3A%22www.tradingview.com%2Fwidget%2Fadvanced-chart%2F%22%7D';
      return iframe;
    });
  }
  @override
  Widget build(BuildContext context) {
    return Container(
        alignment: Alignment.topLeft,
        child: Container(
            width: 1000, child: const HtmlElementView(viewType: 'iframe')));
  }
}
