import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_application_projet/models/model.dart';
import 'package:flutter_application_projet/models/report.dart';
import 'package:flutter_application_projet/pages/history_detail_model.dart';
import 'package:flutter_application_projet/providers/model.dart';
import 'package:flutter_application_projet/services/api.dart';
import 'package:flutter_application_projet/services/storage.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'history_detail_zone.dart';

class HistoryDetailPage extends StatefulWidget {
  final Report report;

  const HistoryDetailPage({ Key? key, required this.report }) : super(key: key);

  @override
  _HistoryDetailPageState createState() => _HistoryDetailPageState();
}

class _HistoryDetailPageState extends State<HistoryDetailPage> {
  bool debug = true;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadImage();
  }

  void _loadImage() async {
    bool update = widget.report.imageBytes != null && widget.report.imageDebugBytes != null;
    widget.report.imageBytes ??= await FlutterImageCompress.compressWithList(
      await ApiService.image(widget.report, false),
      minHeight: 400,
      minWidth: 800,
      quality: 75,
    );
    widget.report.imageDebugBytes ??= await FlutterImageCompress.compressWithList(
      await ApiService.image(widget.report, true),
      minHeight: 400,
      minWidth: 800,
      quality: 75,
    );
    if (update) {
      await StorageService().reports.add(await StorageService().reports.remove(widget.report));
    }
    setState(() {
      widget.report;
      _isLoading = false;
    });
  }

  List<Widget> getDetailsBoard() {
    return [
      Padding(
        padding: const EdgeInsets.all(8),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              AppLocalizations.of(context)!.showDebug,
              style: Theme.of(context).textTheme.headline6
            ),
            Switch(value: debug, onChanged: (value) {
              setState(() {
                debug = value;
              });
            }),
          ]
        )
      ),
      Padding(
        padding: const EdgeInsets.all(8),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Text(
              AppLocalizations.of(context)!.status,
              style: Theme.of(context).textTheme.headline6,
            ),
            widget.report.done
            ? (widget.report.success
              ? Row(children: [Text(AppLocalizations.of(context)!.success), const Icon(Icons.check_circle_outlined, color: Colors.green, size: 30)]) // Success
              : Row(children: [Text(AppLocalizations.of(context)!.failed), const Icon(Icons.error_outline_outlined, color: Colors.red, size: 30)])) // Failed
            : Row(children: [Text(AppLocalizations.of(context)!.pending), const Icon(Icons.watch_later_outlined, color: Colors.grey, size: 30)]), // Pending
          ],
        ),
      ),
      Padding(
        padding: const EdgeInsets.all(8),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Text(
              AppLocalizations.of(context)!.totalValue,
              style: Theme.of(context).textTheme.headline6,
            ),
            Text(
              '${widget.report.calculated/100} €',
              style: Theme.of(context).textTheme.headline6,
            ),
          ],
        ),
      ),
      ListTile(
        title: Text(
          AppLocalizations.of(context)!.zones,
          style: Theme.of(context).textTheme.headline6,
        ),
        trailing: const Icon(
          Icons.keyboard_arrow_right,
        ),
        onTap: () async {
          MaterialPageRoute route = MaterialPageRoute(
              builder: (_) => HistoryDetailZonePage(
                    report: widget.report,
                  ));
          Report reportUpdated = await Navigator.push(context, route);
          await StorageService().reports.remove(widget.report);
          await StorageService().reports.add(reportUpdated);
          setState(() {
            widget.report.zones = reportUpdated.zones;
          });
        },
      ),
      ListTile(
        title: Text(
          AppLocalizations.of(context)!.model,
          style: Theme.of(context).textTheme.headline6,
        ),
        trailing: const Icon(
          Icons.keyboard_arrow_right,
        ),
        onTap: () async {
          Model? model = await ModelProvider().getFirst({"id": widget.report.model});
          if (model == null) {
            Map<String, dynamic> data = json.decode((await ApiService.model(widget.report.model)).body);
            ModelProvider().insert(data);
            model = Model.fromJson(data);
          }
          MaterialPageRoute route = MaterialPageRoute(
              builder: (_) => HistoryDetailModelPage(
                    model: model!,
                  ));
          await Navigator.push(context, route);
        },
      )
    ];
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      child: Scaffold(
        appBar: AppBar(
          title: Text(AppLocalizations.of(context)!.historyDetail),
        ),
        body: SingleChildScrollView(
          child: Center(
            child: Column(
              children: <Widget>[
                _isLoading 
                  ? Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    child: CircularProgressIndicator(
                      color: Theme.of(context).primaryColor
                    ) 
                  )
                  : RotatedBox(quarterTurns: -1,child: Image.memory(debug ? widget.report.imageDebugBytes! : widget.report.imageBytes!)),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8),
                      child: Text(
                        widget.report.id,
                        style: TextStyle(color : Colors.grey.shade600)
                      ),
                    ),
                    widget.report.ratingWidget,
                  ],
                ),
                const Divider(),
                Column(
                  children: getDetailsBoard(),
                ),
              ],
            ),
          ),
        ),
      ),
      onWillPop: () async {
        Navigator.pop(context, widget.report);
        return false;
      },
    );
  }
}