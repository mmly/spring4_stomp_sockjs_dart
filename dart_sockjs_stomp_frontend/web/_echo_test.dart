 
part of echo_test;


Future testEcho()
  => SockJS.connect('http://localhost:8080/hello', onDisconnect: (_) {
    print("Disconnected");
  }).then((client) {
    test("echo test", () {
      final String destination = "/foo";
      final List<String> sends = ["1. apple", "2. orange\nand 2nd line", "3. mango"];
      final List<String> sendExtraHeader = ["123", "abc:", "xyz"];
      final List<String> receives = [], receiveExtraHeader = [];

      client.subscribeString("0", 'http://localhost:8080/topic/greetings',
          (headers, message) {
        //print("<<received: $headers, $message");
        receiveExtraHeader.add(headers["extra"]);
        receives.add(message);
      });

    for (int i = 0; i < sends.length; ++i) {
      final hds = {"extra": sendExtraHeader[i]};
      client.sendString('http://localhost:8080/app/hello', sends[i], headers: hds);
    }

    return new Future.delayed(const Duration(milliseconds: 200), () {
      expect(receives.length, sends.length);
      for (int i = 0; i < sends.length; ++i) {
        expect(receives[i], sends[i]);
        expect(receiveExtraHeader[i], sendExtraHeader[i]);
      }

      //client.unsubscribe("0"); //optional
      client.disconnect();
    });
  });
});