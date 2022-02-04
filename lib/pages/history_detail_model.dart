import 'package:flutter/material.dart';
import 'package:flutter_application_projet/models/coin.dart';
import 'package:flutter_application_projet/models/model.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:intl/intl.dart';
import 'package:path/path.dart';

class HistoryDetailModelPage extends StatefulWidget {
  final Model model;

  const HistoryDetailModelPage({ Key? key, required this.model }) : super(key: key);

  @override
  _HistoryDetailModelPageState createState() => _HistoryDetailModelPageState();
}

class _HistoryDetailModelPageState extends State<HistoryDetailModelPage> {

  @override
  void initState() {
    super.initState();
  }

  Widget getTypeList(BuildContext context) {
    List<ListTile> list = [];
    for (String key in widget.model.picturesCount.keys) {
      list.add(ListTile(
        title: Text((Coin.getCoin(getCoinTypeFromId(key)!)!).label),
        subtitle: Text("${widget.model.picturesCount[key].toString()} ${AppLocalizations.of(context)!.images}"),
      ));
    }
    return ListView(
      children: list
    );
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      child: Scaffold(
        appBar: AppBar(
          title: Text(AppLocalizations.of(context)!.historyDetailModel),
        ),
        body: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: Text(
                "ID: ${widget.model.id}",
                style: Theme.of(context).textTheme.headline5,
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: Text(
                DateFormat('dd/MM/yyyy – kk:mm').format(widget.model.datetime.toLocal()),
                style: Theme.of(context).textTheme.subtitle1,
              ),
            ),
            const Divider(),
            Expanded(
              child: getTypeList(context),
            ),
          ]
        ),
      ),
      onWillPop: () async {
        Navigator.pop(context);
        return false;
      },
    );
  }
}