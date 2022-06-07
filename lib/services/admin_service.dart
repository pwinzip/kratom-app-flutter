import 'dart:io';
import 'package:http/http.dart' as http;
import '../env.dart';

// Admin

Future<http.Response> addEnterprise(json, String? token) async {
  var url = Uri.parse(apiURL + 'newenterprise');

  var response = await http.post(url, body: json, headers: {
    HttpHeaders.contentTypeHeader: 'application/json',
    HttpHeaders.authorizationHeader: 'Bearer $token',
  });
  return response;
}

Future<http.Response> addFarmer(json, String? token) async {
  var url = Uri.parse(apiURL + 'newfarmer');

  var response = await http.post(url, body: json, headers: {
    HttpHeaders.contentTypeHeader: 'application/json',
    HttpHeaders.authorizationHeader: 'Bearer $token',
  });
  return response;
}

Future<http.Response> addAdmin(json, String? token) async {
  var url = Uri.parse(apiURL + 'newadmin');

  var response = await http.post(url, body: json, headers: {
    HttpHeaders.contentTypeHeader: 'application/json',
    HttpHeaders.authorizationHeader: 'Bearer $token',
  });
  return response;
}

Future<http.Response> getAllAdmins(String? token) async {
  var url = Uri.parse(apiURL + 'admins');

  var response = await http.get(url, headers: {
    HttpHeaders.contentTypeHeader: 'application/json',
    HttpHeaders.authorizationHeader: 'Bearer $token',
  });
  return response;
}

Future<http.Response> getAllEnterprises(String? token) async {
  var url = Uri.parse(apiURL + 'enterprises');
  var response = await http.get(url, headers: {
    HttpHeaders.contentTypeHeader: 'application/json',
    HttpHeaders.authorizationHeader: 'Bearer $token',
  });
  return response;
}

Future<http.Response> getAllFarmers(String? token) async {
  var url = Uri.parse(apiURL + 'farmers');

  var response = await http.get(url, headers: {
    HttpHeaders.contentTypeHeader: 'application/json',
    HttpHeaders.authorizationHeader: 'Bearer $token',
  });
  return response;
}

Future<http.Response> getEnterpriseNumber(String? token) async {
  var url = Uri.parse(apiURL + 'numenterprises');
  var response = await http.get(url, headers: {
    HttpHeaders.contentTypeHeader: 'application/json',
    HttpHeaders.authorizationHeader: 'Bearer $token',
  });

  return response;
}

Future<http.Response> getFarmerNumber(String? token) async {
  var url = Uri.parse(apiURL + 'numfarmers');
  var response = await http.get(url, headers: {
    HttpHeaders.contentTypeHeader: 'application/json',
    HttpHeaders.authorizationHeader: 'Bearer $token',
  });

  return response;
}

Future<http.Response> getAgentNumber(String? token) async {
  var url = Uri.parse(apiURL + 'numagents');
  var response = await http.get(url, headers: {
    HttpHeaders.contentTypeHeader: 'application/json',
    HttpHeaders.authorizationHeader: 'Bearer $token',
  });

  return response;
}

Future<http.Response> getPlantNumber(String? token) async {
  var url = Uri.parse(apiURL + 'numplants');
  var response = await http.get(url, headers: {
    HttpHeaders.contentTypeHeader: 'application/json',
    HttpHeaders.authorizationHeader: 'Bearer $token',
  });

  return response;
}

// Future<http.Response> addFarmerEnterprise(json, entid, String? token) async {
//   var url = Uri.parse(apiURL + 'addfarmers/' + entid);

//   var response = await http.post(url, body: json, headers: {
//     HttpHeaders.contentTypeHeader: 'application/json',
//     HttpHeaders.authorizationHeader: 'Bearer $token',
//   });
//   return response;
// }

// Future<void> changeUserStatus(int? uid, String? token) async {
//   var url = Uri.parse(apiURL + 'changeuserstatus/' + uid!.toString());

//   await http.post(url, headers: {
//     HttpHeaders.contentTypeHeader: 'application/json',
//     HttpHeaders.authorizationHeader: 'Bearer $token',
//   });
// }

// Future<http.Response> getAllEnterpriseMembers(int entid, String token) async {
//   var url = Uri.parse(apiURL + 'enterprisemembers/$entid');
//   var response = await http.get(url, headers: {
//     HttpHeaders.contentTypeHeader: 'application/json',
//     HttpHeaders.authorizationHeader: 'Bearer $token',
//   });

//   print(response.statusCode);
//   return response;
// }


