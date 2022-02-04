import 'package:flutter/material.dart';
import 'package:flutter_application_projet/models/report.dart';
import 'package:flutter_application_projet/models/zone.dart';
import 'package:flutter_application_projet/pages/history_detail_zone_dialog.dart';
import 'package:flutter_application_projet/services/api.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class HistoryDetailZonePage extends StatefulWidget {
  final Report report;

  const HistoryDetailZonePage({ Key? key, required this.report }) : super(key: key);

  @override
  _HistoryDetailZonePageState createState() => _HistoryDetailZonePageState();
}

class _HistoryDetailZonePageState extends State<HistoryDetailZonePage> {

  @override
  void initState() {
    super.initState();
    _loadImages();
  }

  void _loadImages() async {
    for (ReportZone zone in widget.report.zones) {
      zone.imageBytes ??= await ApiService.zoneImage(widget.report, zone.id);
      setState(() {
        zone.image = Image.memory(zone.imageBytes!, fit: BoxFit.contain, width: 64, height: 64);
      });
    }
  }

  Widget getZoneCard(int id) {
    ReportZone zone = widget.report.zones.firstWhere((ReportZone zone) => zone.id == id);

    return Card(
      child: Column(
        children: <Widget>[
          ListTile(
            leading: zone.image,
            title: 
              zone.coin != null && zone.coin!.id != '0'
                ? Text(zone.coin!.label)
                : Text(AppLocalizations.of(context)!.notACoin, style: const TextStyle(color: Colors.red)),
            subtitle: 
              zone.coin != null && zone.coin!.id != '0' && zone.confidence > 0.0
                ? Text("${AppLocalizations.of(context)!.confidence} : ${zone.confidence.toStringAsFixed(2)}%") // Success
                : Text(AppLocalizations.of(context)!.failed, style: const TextStyle(color: Colors.red)), // Failed,
            trailing: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                zone.coin != null && zone.coin!.id != '0'
                  ? Text("${zone.coin!.value/100} €", style: TextStyle(color: Colors.grey.shade600))
                  : const Text("0 €", style: TextStyle(color: Colors.red)),
                Icon(Icons.edit, color: Colors.grey.shade600)
              ],
            ),
            onTap: () async {
              ReportZone edited = await HistoryDetailZoneDialog(widget.report, zone).show(context);
              setState(() {
                widget.report.updateZone(edited);
              });
            },
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      child: Scaffold(
        appBar: AppBar(
          title: Text(AppLocalizations.of(context)!.historyDetailZone),
        ),
        body: Center(
          child: widget.report.zones.isEmpty
            ? Text(AppLocalizations.of(context)!.noData)
            : ListView(
              children: widget.report.zones.map((zone) => getZoneCard(zone.id)).toList()
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