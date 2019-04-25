import 'dart:io';

import 'package:server_app_example/server_app_example.dart' as server_app_example;

final File file = File('index.html');

Future main() async {

  HttpServer server = await HttpServer.bind('127.0.0.1', 8888);

  print('Listening on ${server.address} port: ${server.port}');

  await for(var req in server) {
    if(await file.exists()) {
      print('Serving ${file.path}');
      req.response.headers.contentType = ContentType.html;
      await file.openRead().pipe(req.response);
    }
  }
}