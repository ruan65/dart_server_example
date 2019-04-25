import 'dart:io';

import 'package:server_app_example/server_app_example.dart'
    as server_app_example;

final File file = File('index.html');

Future main() async {
  HttpServer server;

  try {
    server = await HttpServer.bind('127.0.0.1', 8888);
  } catch (ex, st) {
    print('failed to start server: $ex');
    print(st);
    exit(-1);
  }

  print('Listening on ${server.address} port: ${server.port}');

  await for (var req in server) {
    print(req.uri.queryParameters['q']);
    if (await file.exists()) {
      print('Serving ${file.path}');
      req.response.headers.contentType = ContentType.html;
      try {
        await file.openRead().pipe(req.response);
      } catch (e) {
        print("Couldn't read file: $file");
        exit(-1);
      }
    } else {
      print('File does not exists');
      req.response
        ..statusCode = HttpStatus.notFound
        ;
      await req.response.close();
    }
  }
}
