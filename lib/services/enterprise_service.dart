import 'dart:io';
import 'package:http/http.dart' as http;
import '../env.dart';

// Enterprise
Future<http.Response> getEnterpriseMembers(entid, String? token) async {
  var url = Uri.parse(apiURL + 'enterprises/$entid');

  var response = await http.get(url, headers: {
    HttpHeaders.contentTypeHeader: 'application/json',
    HttpHeaders.authorizationHeader: 'Bearer $token',
  });
  return response;
}

//update Enterprise
Future<http.Response> editEnterprise(json, entid, String? token) async {
  var url = Uri.parse(apiURL + 'updateenterprise/$entid');

  var response = await http.post(url, body: json, headers: {
    HttpHeaders.contentTypeHeader: 'application/json',
    HttpHeaders.authorizationHeader: 'Bearer $token',
  });
  return response;
}

Future<http.Response> getSales(entid, String? token) async {
  var url = Uri.parse(apiURL + 'salesenterprise/$entid');

  var response = await http.get(url, headers: {
    HttpHeaders.contentTypeHeader: 'application/json',
    HttpHeaders.authorizationHeader: 'Bearer $token',
  });
  return response;
}

Future<http.Response> addSale(json, entid, String? token) async {
  var url = Uri.parse(apiURL + 'newsale/$entid');

  var response = await http.post(url, body: json, headers: {
    HttpHeaders.contentTypeHeader: 'application/json',
    HttpHeaders.authorizationHeader: 'Bearer $token',
  });
  return response;
}

// Future<http.Response> getCountPlantFarmer(entid, String token) async {
//   var url = Uri.parse(apiURL + 'enterprises/$entid');

//   var response = await http.get(url, headers: {
//     HttpHeaders.contentTypeHeader: 'application/json',
//     HttpHeaders.authorizationHeader: 'Bearer $token',
//   });
//   return response;
// }


