import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:horizontal_data_table/horizontal_data_table.dart';
import 'package:http/http.dart' as http;
import 'data/user.dart';

class SimpleTableKeepAliveImagePage extends StatefulWidget {
  const SimpleTableKeepAliveImagePage({
    Key? key,
    required this.user,
  }) : super(key: key);
  final User user;

  @override
  State<SimpleTableKeepAliveImagePage> createState() =>
      _SimpleTableKeepAliveImagePageState();
}

class _SimpleTableKeepAliveImagePageState
    extends State<SimpleTableKeepAliveImagePage> {
  @override
  void initState() {
    widget.user.initData(100);

    Timer.periodic(const Duration(seconds: 2), (timer) {
      setState(() {
        widget.user.initData(100);
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final backgroundColor = Theme.of(context).colorScheme.background;
    return Scaffold(
      appBar: AppBar(title: const Text('Watch List')),
      body: HorizontalDataTable(
        leftHandSideColumnWidth: 100,
        rightHandSideColumnWidth: 1000,
        isFixedHeader: true,
        headerWidgets: _getTitleWidget(),
        isFixedFooter: false,
        footerWidgets: _getTitleWidget(),
        leftSideItemBuilder: _generateFirstColumnRow,
        rightSideItemBuilder: _generateRightHandSideColumnRow,
        itemCount: widget.user.userInfo.length,
        rowSeparatorWidget: const Divider(
          color: Colors.black38,
          height: 1.0,
          thickness: 0.0,
        ),
        leftHandSideColBackgroundColor: backgroundColor,
        rightHandSideColBackgroundColor: backgroundColor,
      ),
    );
  }

  List<Widget> _getTitleWidget() {
    return [
      _getTitleItemWidget('Security', 100),
      _getTitleItemWidget('Company Name', 200),
      _getTitleItemWidget('Status', 200),
      _getTitleItemWidget('Phone', 200),
      _getTitleItemWidget('Chart', 200),
      _getTitleItemWidget('Termination', 200),
    ];
  }

  Widget _getTitleItemWidget(String label, double width) {
    return Container(
      width: width,
      height: 56,
      padding: const EdgeInsets.fromLTRB(5, 0, 0, 0),
      alignment: Alignment.centerLeft,
      child: Text(label, style: const TextStyle(fontWeight: FontWeight.bold)),
    );
  }

  Widget _generateFirstColumnRow(BuildContext context, int index) {
    return Container(
      width: 100,
      height: 52,
      padding: const EdgeInsets.fromLTRB(5, 0, 0, 0),
      alignment: Alignment.centerLeft,
      child: Text(widget.user.userInfo[index].name),
    );
  }

  Widget _generateRightHandSideColumnRow(BuildContext context, int index) {
    return Row(
      children: <Widget>[
        Container(
          width: 200,
          height: 52,
          padding: const EdgeInsets.fromLTRB(5, 0, 0, 0),
          alignment: Alignment.centerLeft,
          child: Text(widget.user.userInfo[index].terminationDate),
        ),
        Container(
          width: 200,
          height: 52,
          padding: const EdgeInsets.fromLTRB(5, 0, 0, 0),
          alignment: Alignment.centerLeft,
          child: Row(
            children: <Widget>[
              Icon(
                  widget.user.userInfo[index].status
                      ? Icons.notifications_off
                      : Icons.notifications_active,
                  color: widget.user.userInfo[index].status
                      ? Colors.red
                      : Colors.green),
              Text(widget.user.userInfo[index].status ? 'Disabled' : 'Active')
            ],
          ),
        ),
        Container(
          width: 200,
          height: 52,
          padding: const EdgeInsets.fromLTRB(5, 0, 0, 0),
          alignment: Alignment.centerLeft,
          child: Text(widget.user.userInfo[index].phone),
        ),
        Container(
          width: 200,
          height: 52,
          padding: const EdgeInsets.fromLTRB(5, 0, 0, 0),
          alignment: Alignment.centerLeft,
          child: const ImageKeepAliveWidget(),
        ),
        Container(
          width: 200,
          height: 52,
          padding: const EdgeInsets.fromLTRB(5, 0, 0, 0),
          alignment: Alignment.centerLeft,
          child: Text(widget.user.userInfo[index].registerDate),
        )
      ],
    );
  }
}

class ImageKeepAliveWidget extends StatefulWidget {
  const ImageKeepAliveWidget({Key? key}) : super(key: key);

  @override
  State<ImageKeepAliveWidget> createState() => _ImageKeepAliveWidgetState();
}

/// use [AutomaticKeepAliveClientMixin] keeping the state
class _ImageKeepAliveWidgetState extends State<ImageKeepAliveWidget>
    with AutomaticKeepAliveClientMixin<ImageKeepAliveWidget> {
  String? _imageUrl;

  @override
  void initState() {
    super.initState();
    _fetchUrl();
  }

  void _fetchUrl() async {
    try {
      http.Response res =
          await http.get(Uri.parse('https://dog.ceo/api/breeds/image/random'));
      _imageUrl = json.decode(res.body)['message'];
      setState(() {});
    } catch (e) {
      debugPrint('error in getting image url');
    }
  }

  @override
  Widget build(BuildContext context) {
    /// must add super.build(context) to preserve state
    super.build(context);
    if (_imageUrl?.isNotEmpty == true) {
      return Image.network(_imageUrl!);
    } else {
      return const CircularProgressIndicator();
    }
  }

  /// since this is an simple example, this [wantKeepAlive] is hardcoded. However, if you always keep alive all, that's mean you are keeping all the children. In other words, you have closed the listview recycling mechanism which may causing bad memory usage. You can make your own keep alive rules with the [updateKeepAlive] in order to reduce the memory impact for using this.
  @override
  bool get wantKeepAlive => true;
}
