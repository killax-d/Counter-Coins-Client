import 'package:flutter/material.dart';
import 'package:flutter_application_projet/widgets/lang.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class HelpPage extends StatefulWidget {
  const HelpPage({ Key? key }) : super(key: key);

  @override
  _HelpPageState createState() => _HelpPageState();
}

class _HelpPageState extends State<HelpPage> {

  int _index = 0;
  // Preload images to avoid flickering
  final List<Image> _images = [
    Image.asset('assets/images/undraw_take_picture.png'),
    Image.asset('assets/images/undraw_send.png'),
    Image.asset('assets/images/undraw_result_received.png'),
    Image.asset('assets/images/undraw_read_report.png'),
  ];
  List<Widget Function()> _widgets = [];
  
  @override
  void initState() {
    super.initState();
    setState(() {
      _index = 0;
      _widgets = [_takePicture, _sendPicture, _waitReport, _readReport];
    });
  }

  Widget _takePicture() {
    return Material(
      color: Colors.white,
      child: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _images[0],
            const SizedBox(height: 20),
            Text(AppLocalizations.of(context)!.takePicture, style: TextStyle(fontSize: 20, color: Colors.grey.shade500, fontWeight: FontWeight.w400),),
          ]
        )
      ),
    );
  }

  Widget _sendPicture() {
    return Material(
      color: Colors.white,
      child: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _images[1],
            const SizedBox(height: 20),
            Text(AppLocalizations.of(context)!.sendPicture, style: TextStyle(fontSize: 20, color: Colors.grey.shade500, fontWeight: FontWeight.w400),),
          ]
        )
      ),
    );
  }

  Widget _waitReport() {
    return Material(
      color: Colors.white,
      child: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _images[2],
            const SizedBox(height: 20),
            Text(AppLocalizations.of(context)!.waitReport, style: TextStyle(fontSize: 20, color: Colors.grey.shade500, fontWeight: FontWeight.w400),),
          ]
        )
      ),
    );
  }

  Widget _readReport() {
    return Material(
      color: Colors.white,
      child: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _images[3],
            const SizedBox(height: 20),
            Text(AppLocalizations.of(context)!.readReport, style: TextStyle(fontSize: 20, color: Colors.grey.shade500, fontWeight: FontWeight.w400),),
          ]
        )
      ),
    );
  }
  
  Widget get currentWidget => _widgets[_index]();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.help),
      ),
      body: GestureDetector(
        onPanEnd: (details) {
          if (details.velocity.pixelsPerSecond.dx > 20) {
            if (_index > 0) {
              setState(() {
                _index--;
              });
            }
          }
          if (details.velocity.pixelsPerSecond.dx < 20) {
            if (_index < _widgets.length - 1) {
              setState(() {
                _index++;
              });
            }
          }
        },

        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              const LangDropdown(),
              currentWidget,
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: _widgets.asMap().map((index, widget) => MapEntry(index, 
                      Padding(
                        padding: const EdgeInsets.all(1),
                        child: Icon(
                          Icons.circle, 
                          color: index == _index 
                            ? Colors.green.shade400 
                            : Colors.grey.shade400, 
                          size: index == _index
                            ? 16
                            : 10
                        )))).values.toList(),
                  ),
                  Column(
                    children: [
                      TextButton(
                        child: Row(
                          children: [
                            Text(AppLocalizations.of(context)!.skip.toUpperCase(), style: TextStyle(color: Colors.green.shade400),),
                            Icon(Icons.arrow_forward, color: Colors.green.shade400),
                          ],
                        ),
                        onPressed: () {
                          Navigator.of(context).pushReplacementNamed('/home');
                        },
                      )
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

}