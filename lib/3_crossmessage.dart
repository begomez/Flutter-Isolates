import 'dart:isolate';

void spawner(SendPort to) async {
  ReceivePort r2 = ReceivePort();
  SendPort s2 = r2.sendPort;

  to.send(s2);

  r2.listen((message) {
    if (message is CrossIsolatesMessage) {
      print("Isolate received ${message.message}");
    }
  });
}

void main() async {
  print("main()");
  ReceivePort r1 = ReceivePort();
  SendPort s1 = r1.sendPort;
  Isolate.spawn(spawner, s1);

  SendPort to;
  r1.listen((message) {
    if (message is SendPort) {
      to = message;
      print("Received isolate port");
      to.send(CrossIsolatesMessage<String>(
          sender: s1, message: "Hello from main!"));
    }
  });
}

//
// Helper class
//
class CrossIsolatesMessage<T> {
  final SendPort sender;
  final T message;

  CrossIsolatesMessage({
    this.sender,
    this.message,
  });
}
