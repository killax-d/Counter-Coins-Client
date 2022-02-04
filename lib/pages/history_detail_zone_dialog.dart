import 'package:flutter/material.dart';
import 'package:flutter_application_projet/models/coin.dart';
import 'package:flutter_application_projet/models/report.dart';
import 'package:flutter_application_projet/models/zone.dart';
import 'package:flutter_application_projet/services/api.dart';

import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class HistoryDetailZoneDialog {
  final Report _report;
  ReportZone _zone;
  late ReportZone _zoneEdited;
  late bool isCoin;
  bool saving = false;

  HistoryDetailZoneDialog(this._report, this._zone);

  Future<ReportZone> show(BuildContext context) async {
    _zoneEdited = _zone.clone();
    isCoin = _zone.coin != null && _zone.coin!.id != '0';

    await showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return build(context);
      },
    );
    return _zone;
  }

  Coin _setCoin(Coin coin) {
    _zoneEdited.coin = coin;
    return coin;
  }

  Widget _cancelButton(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: TextButton(
        child: Row(
          children: [
            Padding(
              padding: const EdgeInsets.only(right: 8), 
              child: Icon(Icons.cancel, color: Colors.grey.shade400),
            ),
            Text(AppLocalizations.of(context)!.cancel.toUpperCase(), style: TextStyle(color: Colors.grey.shade400),),
          ],
        ),
        onPressed: () {
          Navigator.of(context).pop();
        },
      ),
    );
  }
  
  Widget _saveButton(BuildContext context, StateSetter setState) {
    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: ElevatedButton(
        child: Row(
          children: [
            Padding(
              padding: const EdgeInsets.only(right: 8), 
              child: saving 
                ? const SizedBox(width: 16, height: 16, child: CircularProgressIndicator(color: Colors.white))
                : const Icon(Icons.save, color: Colors.white),
            ),
            Text(AppLocalizations.of(context)!.save.toUpperCase(), style: const TextStyle(color: Colors.white),),
          ],
        ),
        onPressed: () => _save(context, setState),
      ),
    );
  }

  List<Widget> _form(StateSetter setState) {
    return [
      Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text("Is that a coin ?"),
          Checkbox(value: isCoin, onChanged: (value) {
            setState(() {
              isCoin = value!;
              _zoneEdited.coin = Coin.getCoin(CoinType.NOT_A_COIN);
            });
          }),
        ],
      ),
      const SizedBox(height: 10),
      Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          isCoin 
            ? DropdownButton<Coin>(
              value: _zoneEdited.coin!.id == '0' ? _setCoin(Coin.getCoin(CoinType.ONE_CENT)!) : _zoneEdited.coin,
              items: Coin.coins.map((Coin coin) {
                return DropdownMenuItem<Coin>(
                  value: coin,
                  child: Text(coin.label),
                );
              }).toList(),
              onChanged: (Coin? newCoin) {
                setState(() {
                  _zoneEdited.setCoin(newCoin!);
                });
              },
            )
            : Container(),
        ],
      ),
      // Coin Face
      isCoin ? const SizedBox(height: 10) : Container(),
      isCoin 
        ? Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            DropdownButton<CoinFace>(
              value: _zoneEdited.face ?? Coin.getFace(CoinFaceType.FRONT),
              items: Coin.faces.map((CoinFace face) {
                return DropdownMenuItem<CoinFace>(
                  value: face,
                  child: Text(face.label),
                );
              }).toList(),
              onChanged: (CoinFace? newFace) {
                setState(() {
                  _zoneEdited.setFace(newFace!);
                });
              },
            )
          ],
        )
        : Container(),
    ];
  }

  void _save(BuildContext context, StateSetter setState) {
    setState(() {
      saving = true;
    });
    ApiService.updateZoneDetail(_report, _zoneEdited).then((response) {
      if (response.statusCode == 200) {
        setState(() {
          _zone = _zoneEdited;
        });
        Navigator.of(context).pop(_zone);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(AppLocalizations.of(context)!.error),
        ));
      }
      setState(() {
        saving = false;
      });
    });
  }

  Widget build(BuildContext context) {
    return StatefulBuilder(
        builder: (context, setState) { 
        return AlertDialog(
          title: const Text('Zone'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (_zone.image != null) _zone.image!,
              const Divider(),
            ] + _form(setState),
          ),
          actions: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                _cancelButton(context),
                _saveButton(context, setState),
              ],
            ),
          ],
        );
      }
    );
  }
}
