import 'package:flutter/material.dart';
import '../utils/constants.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:async';

class SampleHttp extends StatefulWidget {
  const SampleHttp({Key key}) : super(key: key);

  @override
  _SampleHttpState createState() => _SampleHttpState();
}

class _SampleHttpState extends State<SampleHttp> {
  Future<Ok> ok;

  @override
  void initState() {
    super.initState();
    ok = fetchSomething();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: FutureBuilder<Ok>(
        future: ok,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return Text(snapshot.data.ok);
          } else {
            return Text("${snapshot.error}");
          }
          return CircularProgressIndicator();
        },
      ),
    );
  }
}

Future<Ok> fetchSomething() async {
  final response = await http.get(Uri.parse('$API_URL/api/test'));
  if (response.statusCode == 200) {
    return Ok.fromJson(jsonDecode(response.body));
  } else {
    throw Exception('Failed');
  }
}

class Ok {
  final String ok;

  Ok({@required this.ok});

  factory Ok.fromJson(Map<String, dynamic> json) {
    return Ok(
      ok: json['ok'],
    );
  }
}

class StreamSample {
  final _controller = StreamController();

  void dispose() => _controller.close();
}
