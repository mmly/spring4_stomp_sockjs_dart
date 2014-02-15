library echo;

import "dart:html";

import 'package:logging/logging.dart';
import 'dart:convert';
//import "package:sockjs_client/sockjs.dart" as SockJS;
import 'stomp_sockjs.dart' as SockJS;
import "package:stomp/stomp.dart";
import "dart:async";
//import "dart:io";
import 'package:unittest/unittest.dart';
//import "package:stomp/websocket.dart" show connect;


//part "_echo_test.dart";



DivElement div  = querySelector('#first div');
InputElement inp  = querySelector('#first input');
FormElement form = querySelector('#first form');

_log(LogRecord l) {
  div
    ..append(new Element.html("<code/>")..text = "${l.message}")
    ..append(new Element.html("<br>"))
    ..scrollTop += 10000;
}

main() {
  // Setup Logging
  Logger.root.level = Level.INFO;
  Logger.root.onRecord.listen(_log);

  final LOG = new Logger("sockjs");

  LOG.info("Starting");

  /*
  //PURE SOCKJS_DART
  var sockjs_url = 'http://localhost:8080/hello';
  var sockjs = new SockJS.Client(sockjs_url, protocolsWhitelist:['websocket', 'xhr-streaming'], debug: true);
  querySelector('#first input').focus();

  sockjs.onOpen.listen( (_) => LOG.info('[*] open ${sockjs.protocol}') );
  sockjs.onMessage.listen( (e) => LOG.info('[.] message ${e.data}') );
  sockjs.onClose.listen( (_) => LOG.info('[*] close') );

  inp.onKeyUp.listen( (KeyboardEvent e) {
    if (e.keyCode == 13) {
      LOG.info('[ ] sending ${inp.value}');
      sockjs.send(inp.value);
      inp.value = '';
    }
  });
  */
  
  
  
  
  print("before connect");
  //STOMP+SOCKJS 3.  
  SockJS.connect('/hello', host: 'http://localhost:8080').then((StompClient client) {  
    print("success sockjs connection");        

    //sending STOMP message
    print(JSON.encode({ "name": "hi dart" }));
    client.sendString('/app/hello', JSON.encode({ "name": "hi dart" }));    
    //client.sendJson('/app/hello', JSON.encode({ "name": "hi dart" }));
    
    //subscribe STOMP messages
    client.subscribeString("0", '/topic/greetings',
        (headers, message) {  
      print("get message"+message);
    });
    
    
  });

   
  
  
  
  
    
}