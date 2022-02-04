import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_application_projet/services/api.dart';
import 'package:flutter_application_projet/services/storage.dart';
import 'package:flutter_application_projet/widgets/drawer.dart';
import 'package:flutter_application_projet/models/report.dart';
import 'package:flutter_application_projet/pages/history_detail.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import 'package:intl/intl.dart';

class HistoryPage extends StatefulWidget {
  const HistoryPage({ Key? key }) : super(key: key);

  @override
  _HistoryPageState createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {
  List<Report> _reports = [];
  bool _isLoading = true;
  bool _deleting = false;
  List<Report> _toDelete = [];

  bool _mounted = true;

  @override
  void initState() {
    super.initState();
    fetchData(false);
  }

  void fetchData(bool force) async {
    if (!force) {
      List<Report> reports = await StorageService().reports.getAll();
      setState(() {
        _reports = reports;
        _isLoading = false;
      });
    } else {
      try {
        await ApiService.all.then((response) async {
          if (response.statusCode == HttpStatus.ok) {
            List<Report> reports = await StorageService().reports.set(json.decode(response.body).map<Report>((json) => Report.fromJson(json)).toList());
            setState(() {
              _isLoading = false;
              _reports = reports;
            });
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(AppLocalizations.of(context)!.error + ' ' + response.statusCode.toString())),
            );
          }
        }).timeout(
          const Duration(seconds: 5),
        );
      } catch (e) {
        if (!_mounted) {return;}
        setState(() {
          _isLoading = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(AppLocalizations.of(context)!.error + ' ' + e.toString())),
        );
      }
    }
    setState(() {
      _reports.sort((Report a, Report b) => b.datetime.compareTo(a.datetime));
    });
  }

  Widget getReportCard(Report report) {
    List<String> dateParts = DateFormat('dd/MM/yyyy – kk:mm').format(report.datetime.toLocal())
        .split(" – ");

    return Card(
      child: Column(
        children: <Widget>[
          ListTile(
            leading: _leadingCard(report),
            title: Text(report.id),
            subtitle: 
              report.done
              ? (report.success
                ? Text("${report.calculated/100} € | ${AppLocalizations.of(context)!.coins} : ${report.zones.length}") // Success
                : Text(AppLocalizations.of(context)!.failed, style: const TextStyle(color: Colors.red))) // Failed
              : Text(AppLocalizations.of(context)!.pending), // Pending
            trailing: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(dateParts[0], style: TextStyle(color: Colors.grey.shade600)),
                Text(dateParts[1], style: TextStyle(color: Colors.grey.shade600)),
                report.ratingWidget
              ]
            ),
            onLongPress: () {
              setState(() {
                _toDelete.add(report);
                _deleting = true;
              });
            },
            onTap: () async {
              MaterialPageRoute route = MaterialPageRoute(
                  builder: (_) => HistoryDetailPage(
                        report: report,
                      ));
              Report reportUpdated = await Navigator.push(context, route);
              setState(() {
                _reports = _reports.map((report) {
                  if (report.id == reportUpdated.id) {
                    return reportUpdated;
                  }
                  return report;
                }).toList();
                _reports.sort((Report a, Report b) => b.datetime.compareTo(a.datetime));
              });
            },
          ),
        ],
      ),
    );
  }

  List<Widget> _actions() {
    return <Widget>[
      IconButton(
        icon: const Icon(Icons.refresh),
        onPressed: () {
          setState(() {
            _isLoading = true;
          });
          fetchData(true);
        }
      ),
    ];
  }

  bool _isSelected(Report report) {
    return _toDelete.contains(report);
  }

  Widget _leadingCard(Report report) {
    if (_deleting) {
      return Checkbox(
        value: _isSelected(report), 
        onChanged: (value) {
          setState(() {
            if (value!) {
              _toDelete.add(report);
            } else {
              _toDelete.remove(report);
            }
          });
        }
      );
    }
    return report.done
      ? (report.success
        ? const Icon(Icons.check_circle_outlined, color: Colors.green, size: 30) // Success
        : const Icon(Icons.error_outline_outlined, color: Colors.red, size: 30)) // Failed
      : const Icon(Icons.watch_later_outlined, color: Colors.grey, size: 30); // Pending
  }

  List<Widget> _actionsDeleting() {
    return <Widget>[
      IconButton(
        icon: const Icon(Icons.cancel),
        onPressed: () {
          setState(() {
            _deleting = false;
            _toDelete.clear();
          });
        }
      ),
      IconButton(
        icon: const Icon(Icons.delete),
        onPressed: () {
          setState(() {
            _delete();
            _deleting = false;
            _toDelete.clear();
          });
        }
      ),
    ];
  }

  void _delete() {
    for (Report report in _toDelete) {
      ApiService.deleteReport(report).then((response) {
        if (response.statusCode == HttpStatus.ok) {
          setState(() {
            _reports.remove(report);
            StorageService().reports.remove(report);
          });
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(AppLocalizations.of(context)!.error),
          ));
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      drawer: const NavigationDrawer(),
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.history),
        actions: _deleting
          ? _actionsDeleting()
          : _actions(),
      ),
      body: Center(
        child: _isLoading
          ? CircularProgressIndicator(
              color: Theme.of(context).primaryColor
            )
          : _reports.isEmpty 
            ? Center(child: Text(AppLocalizations.of(context)!.noData))
            : ListView(
                children: _reports.map((report) => getReportCard(report)).toList()
              ),
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
    _mounted = false;
  }

}