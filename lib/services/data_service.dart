import 'package:http/http.dart' as http;
import 'package:http/http.dart';
import 'dart:convert';
class DataService{
  var send_alert_url="https://wa.weflysoftware.com/communications/api/alertes/";
  var get_alert_url="https://wa.weflysoftware.com/communications/api/alerte-receive-status/";
  var send_pieces_url="https://wa.weflysoftware.com/communications/api/files/";
  var get_categories_url="https://wa.weflysoftware.com/communications/api/categorie-alerte/";
  var get_activites_url="https://wa.weflysoftware.com/noeuds/api/activite/";
  var send_activites_images_url="https://wa.weflysoftware.com/noeuds/api/images/";
  var send_report_url="https://wa.weflysoftware.com/geolocation/get-user-position/";


}