import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:http/http.dart';
import 'package:socomtronics/SoccerViewPages/soccermodel.dart';

class SoccerApi {


//   var headers = {
//   'x-rapidapi-key': 'XxXxXxXxXxXxXxXxXxXxXxXx',
//   'x-rapidapi-host': 'v3.football.api-sports.io'
// };
// var request = http.Request('GET', Uri.parse('https://v3.football.api-sports.io/{endpoint}'));

// request.headers.addAll(headers);

// http.StreamedResponse response = await request.send();

// if (response.statusCode == 200) {
//   print(await response.stream.bytesToString());
// }
// else {
//   print(response.reasonPhrase);
// }

  //now let's set our variables
  //first : let's add the endpoint URL
  // we will get all the data from api-sport.io
  // we will just change our endpoint
  //the null means that the match didn't started yet
  //let's fix that
  final dynamic apiUrl =
      "https://v3.football.api-sports.io/fixtures?season=2020&league=39";
  //In our tutorial we will only see how to get the live matches
  //make sure to read the api documentation to be ables too understand it

  // you will find your api key in your dashboard
  //so create your account it's free
  //Now let's add the headers
  static const headers = {
    'x-rapidapi-host': "v3.football.api-sports.io",
    //Always make sure to check the api key and the limit of a request in a free api
    'x-rapidapi-key': "aa6d2e6e0caf2d39eea60686b3b3882a"
  };

  //Now we will create our method
  //but before this we need to create our model

  //Now we finished with our Model
  Future<List<SoccerMatch>> getAllMatches() async {
    Response res = await get(apiUrl, headers: headers);
    var body;

    if (res.statusCode == 200) {
      // this mean that we are connected to the data base
      body = jsonDecode(res.body);
      List<dynamic> matchesList = body['response'];
      print("Api service: ${body}"); // to debug
      List<SoccerMatch> matches = matchesList
          .map((dynamic item) => SoccerMatch.fromJson(item))
          .toList();

      return matches;
    }

  }
}
