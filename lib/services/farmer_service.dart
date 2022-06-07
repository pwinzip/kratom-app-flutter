import 'dart:io';
import 'package:http/http.dart' as http;
import '../env.dart';

// Farmers
Future<http.Response> getPlantAmount(farmerid, String token) async {
  // var url = Uri.parse(apiURL + 'amountplants/$farmerid');
  var url = Uri.parse(apiURL + 'latestplant/$farmerid');

  var response = await http.get(url, headers: {
    HttpHeaders.contentTypeHeader: 'application/json',
    HttpHeaders.authorizationHeader: 'Bearer $token',
  });

  print(response.statusCode);
  print(response.body);

  return response;
}

Future<http.Response> getAllPlants(farmerid, String token) async {
  var url = Uri.parse(apiURL + 'plantsfarmer/$farmerid');

  var response = await http.get(url, headers: {
    HttpHeaders.contentTypeHeader: 'application/json',
    HttpHeaders.authorizationHeader: 'Bearer $token',
  });

  return response;
}

Future<http.Response> saveFarmerPlant(json, farmerid, String token) async {
  var url = Uri.parse(apiURL + 'newplant/$farmerid');

  var response = await http.post(url, body: json, headers: {
    HttpHeaders.contentTypeHeader: 'application/json',
    HttpHeaders.authorizationHeader: 'Bearer $token',
  });
  return response;
}

Future<http.Response> getFarmer(farmerid, String? token) async {
  var url = Uri.parse(apiURL + 'farmer/$farmerid');

  var response = await http.get(url, headers: {
    HttpHeaders.contentTypeHeader: 'application/json',
    HttpHeaders.authorizationHeader: 'Bearer $token',
  });
  return response;
}

// edit farmer
Future<http.Response> editFarmer(json, farmerid, String? token) async {
  print(farmerid);
  var url = Uri.parse(apiURL + 'updatefarmer/$farmerid');

  var response = await http.post(url, body: json, headers: {
    HttpHeaders.contentTypeHeader: 'application/json',
    HttpHeaders.authorizationHeader: 'Bearer $token',
  });
  return response;
}
