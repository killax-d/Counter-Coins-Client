// ignore_for_file: constant_identifier_names
import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:flutter_application_projet/models/setting.dart';
import 'package:flutter_application_projet/models/zone.dart';
import 'package:flutter_application_projet/services/auth.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_application_projet/models/report.dart';


class ApiService {
  static final AuthService _auth = AuthService();

  static String _apiDomain = Settings.get(Settings.API_DOMAIN);
  static String _apiKey = Settings.get(Settings.API_KEY);
  static bool _isSecure = Settings.get(Settings.API_SECURE);
  static const String _loremPicsum = "https://picsum.photos";

  static get _apiUrl => _isSecure ? "https://$_apiDomain" : "http://$_apiDomain";


  static set secure(bool secure) => { _isSecure = secure };
  static set domain(String domain) => { _apiDomain = domain };
  static set key(String key) => { _apiKey = key };
  static bool get secure => _isSecure;
  static String get domain => _apiDomain;
  static String get key => _apiKey;
  static String get uid => _auth.user!.uid;

  static String get _report => "$_apiUrl/report";
  static String get _classify => "$_apiUrl/classify";
  static String get _model => "$_apiUrl/model";

  static get all async => http.get(Uri.parse("$_apiUrl?uid=$uid"));

  static get loremPicsumUrl => _loremPicsum;

  static classify(String imagePath) async => http.post(Uri.parse("$_classify?uid=$uid"), headers: {"Content-Type": "image/png"}, body: File(imagePath).readAsBytesSync());

  static detail(Report report) async => http.get(Uri.parse("$_report?uid=$uid&id=${report.id}"));

  static model(String id) async => http.get(Uri.parse("$_model?uid=$uid&id=$id"));

  static updateZoneDetail(Report report, ReportZone zone) async => http.put(Uri.parse("$_report?uid=$uid&id=${report.id}&zone=${zone.id}"), headers: {"Content-Type": "Application/Json"}, body: jsonEncode({
    "coin": zone.coin != null ? "${zone.coin!.id}_${zone.face!.label}" : "",
  }));

  static deleteReport(Report report) async => http.delete(Uri.parse("$_report?uid=$uid&id=${report.id}"));

  static Future<Uint8List> image(Report report, bool debug) async => http.get(Uri.parse(imageUrl(report, debug))).then((value) => value.bodyBytes);

  static imageUrl(Report report, bool debug) => "$_report/image?uid=$uid&id=${report.id}" + (debug ? "&debug=true" : "");

  static Future<Uint8List> zoneImage(Report report, int id) async => http.get(Uri.parse(zoneImageUrl(report, id))).then((value) => value.bodyBytes);

  static zoneImageUrl(Report report, int id) => "$_report/image?uid=$uid&id=${report.id}&zone=$id";


  // TODO: Remove Placeholders
  static zoneImagePlaceholderUrl(Report report, int id) => "$_loremPicsum/200/200/";

  static zoneImagePlaceholder(Report report, int id) async => http.get(Uri.parse(zoneImagePlaceholderUrl(report, id)));

}