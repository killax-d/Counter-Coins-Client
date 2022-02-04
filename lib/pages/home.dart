import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_application_projet/pages/camera.dart';
import 'package:flutter_application_projet/pages/history_detail.dart';
import 'package:flutter_application_projet/services/api.dart';
import 'package:flutter_application_projet/services/storage.dart';
import 'package:flutter_application_projet/widgets/drawer.dart';
import 'package:flutter_application_projet/models/report.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class HomePage extends StatefulWidget {
  const HomePage({ Key? key }) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String imagePath = '';
  bool sending = false;

  Widget _takePictureButton() {
    return FloatingActionButton(
      onPressed: () async {
        MaterialPageRoute route = MaterialPageRoute(
          builder: (context) => const CameraPage());
        String path = await Navigator.push(context, route);
        setState(() {
          imagePath = path;
        });
      },
      tooltip: AppLocalizations.of(context)!.takePicture,
      child: const Icon(Icons.camera),
    );
  }

  Widget _sendButton() {
    return Padding(
      padding: const EdgeInsets.all(8),
      child: ElevatedButton(
        child: Row(
          children: [
            Padding(
              padding: const EdgeInsets.only(right: 8), 
              child: sending 
                ? const SizedBox(width: 16, height: 16, child: CircularProgressIndicator(color: Colors.white))
                : const Icon(Icons.send, color: Colors.white),
            ),
            Text(AppLocalizations.of(context)!.send.toUpperCase(), style: const TextStyle(color: Colors.white),),
          ],
        ),
        onPressed: () => _send(context, setState),
      ),
    );
  }
  
  Widget _cancelButton() {
    return Padding(
      padding: const EdgeInsets.all(8),
      child: TextButton(
        child: Row(
          children: [
            Padding(
              padding: const EdgeInsets.only(right: 8), 
              child: Icon(Icons.cancel, color: Colors.grey.shade600),
            ),
            Text(AppLocalizations.of(context)!.cancel.toUpperCase(), style: TextStyle(color: Colors.grey.shade600),),
          ],
        ),
        onPressed: () => setState(() { sending = false; }),
      ),
    );
  }

  void _send(BuildContext context, setState) async {
    if (imagePath.isEmpty) {
      setState(() {
        sending = false;
      });
      return;
    }
    if (sending) return;
    
    setState(() {
      sending = true;
    });

    try {
      await ApiService.classify(imagePath).then((response) async {
        if (response.statusCode == 200) {
          Report report = Report.fromJson(json.decode(response.body));
          StorageService().reports.add(report);
          MaterialPageRoute route = MaterialPageRoute(
            builder: (_) => HistoryDetailPage(
              report: report,
            ));
          Navigator.push(context, route);
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(AppLocalizations.of(context)!.error),
          ));
        }
        setState(() {
          sending = false;
        });
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("${AppLocalizations.of(context)!.error}: ${e.toString()}"),
      ));
      setState(() {
        sending = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.home),
      ),
      floatingActionButton: _takePictureButton(),
      drawer: const NavigationDrawer(),
      body: Center(
        child: imagePath != ''
          ? Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              RotatedBox(
                quarterTurns: -1,
                child: Image.file(File(imagePath))
              ),
              Column( 
                children: [
                  _sendButton(),
                  sending ? _cancelButton() : Container(),
                ]
              )
            ]
          )
          : Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Image.asset('assets/images/undraw_no_photo.png'),
              Padding(
                padding: const EdgeInsets.all(16),
                child: Text(AppLocalizations.of(context)!.noPhoto, style: TextStyle(fontSize: 20, color: Colors.grey.shade600), textAlign: TextAlign.center),
              ),
            ],
          )
      ),
    );
  }
}