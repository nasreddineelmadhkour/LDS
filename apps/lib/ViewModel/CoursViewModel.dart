import 'dart:convert';
import 'package:LDS/Models/StaticAccount.dart';
import 'package:LDS/Network/BaseURL.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class CoursViewModel extends ChangeNotifier {


  Future<List<dynamic>> getCours() async {
    final String apiUrl = '${BaseURL.baseURL}/cours/all';

    try {
      final response = await http.get(
        Uri.parse(apiUrl),
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
          //'Authorization': 'Bearer ${StaticAccount.staticAccount.token}',
        },
      );

      if (response.statusCode == 200) {
        // Decode the response body as UTF-8
        List<dynamic> jsonList = jsonDecode(utf8.decode(response.bodyBytes));
        print('GET /cours/all response.status: ${response.statusCode}');

        return jsonList;
      } else {
        print(apiUrl);
        print('GET /cours/all response.status: ${response.statusCode}');
        throw Exception('Failed to load /cours/all');
      }
    } catch (error) {
      print('Error during /cours/all: $error');
      throw Exception('Failed to load /cours/all');
    }
  }

  Future<List<dynamic>> getCoursCompleted() async {
    final String apiUrl = '${BaseURL.baseURL}/cours/get_cours_completed';

    try {
      final response = await http.get(
        Uri.parse(apiUrl),
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
          //'Authorization': 'Bearer ${StaticAccount.staticAccount.token}',
        },
      );

      if (response.statusCode == 200) {
        // Decode the response body as UTF-8
        List<dynamic> jsonList = jsonDecode(utf8.decode(response.bodyBytes));
        print('GET /cours/get_cours_completed response.status: ${response.statusCode}');

        return jsonList;
      } else {
        print(apiUrl);
        print('GET /cours/get_cours_completed response.status: ${response.statusCode}');
        throw Exception('Failed to load /cours/get_cours_completed');
      }
    } catch (error) {
      print('Error during /cours/all: $error');
      throw Exception('Failed to load /cours/get_cours_completed');
    }
  }

  Future<List<dynamic>> getCoursInProgress() async {
    final String apiUrl = '${BaseURL.baseURL}/cours/get_cours_in_progress';

    try {
      final response = await http.get(
        Uri.parse(apiUrl),
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
          //'Authorization': 'Bearer ${StaticAccount.staticAccount.token}',
        },
      );

      if (response.statusCode == 200) {
        // Decode the response body as UTF-8
        List<dynamic> jsonList = jsonDecode(utf8.decode(response.bodyBytes));
        print('GET /cours/get_cours_in_progress response.status: ${response.statusCode}');

        return jsonList;
      } else {
        print(apiUrl);
        print('GET /cours/get_cours_in_progress response.status: ${response.statusCode}');
        throw Exception('Failed to load /cours/get_cours_in_progress');
      }
    } catch (error) {
      print('Error during /cours/all: $error');
      throw Exception('Failed to load /cours/get_cours_in_progress');
    }
  }

  Future<dynamic> addCours(String name) async {

    final String apiUrl = BaseURL.baseURL+'/cours/add';
    try {

      final response = await http.post(
        Uri.parse(apiUrl),
        body: jsonEncode({
          'name': name,
          'nameprofessor': StaticAccount.staticAccount.name,
        }),
        headers: {
          'Content-Type': 'application/json',
         // 'Authorization': 'Bearer $token',
        },
      );
      if (response.statusCode == 200) {
        //StaticAccount.staticAccount=Account.fromJson(json.decode(response.body));
        dynamic cours = jsonDecode(utf8.decode(response.bodyBytes));
        print('200 /cours CREATED');
        notifyListeners();
        return cours;
      } else {
        print('cours CREATED failed. Status code: ${response.statusCode}');
        throw Exception('Failed to load /cours/add');
      }
    } catch (error) {
      print('Error during cours CREATED: $error');
      throw Exception('Failed to add cours');
    }
  }




  Future<bool> savedCours(int id) async {

    final String apiUrl = BaseURL.baseURL+'/cours/saved/'+id.toString();
    try {

      final response = await http.post(
        Uri.parse(apiUrl),
        body: jsonEncode({
        }),
        headers: {
          'Content-Type': 'application/json',
          // 'Authorization': 'Bearer $token',
        },
      );
      if (response.statusCode == 200) {
        //StaticAccount.staticAccount=Account.fromJson(json.decode(response.body));
        print('200 /cours saved');
        notifyListeners();
        return true;
      } else {
        print('cours CREATED failed. Status code: ${response.statusCode}');
        throw Exception('Failed to load /cours/saved');
      }
    } catch (error) {
      print('Error during cours CREATED: $error');
      throw Exception('Failed to saved cours');
    }
  }







}