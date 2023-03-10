import 'dart:isolate';

/*
 * Execution entry point
 */
void main() async {
  const TAG = "main():   ";

  // 1. create port
  final rPort = ReceivePort();

  // 2. create isolate
  Isolate.spawn(isolateCallback, rPort.sendPort);

  print("$TAG isolate created");

  // Get the port to talk to new isolate
  // Listens 1 time and shuts it down
  SendPort sPort = await rPort.first;

  print("$TAG received $sPort");

  // Send a message to the Isolate through received port
  sPort.send("Hello isolate!");

  print("$TAG msg sent!");
}

/*
 * Callback executed when work is done
 */
void isolateCallback(SendPort sPort) async {
  const String TAG = "isolate(): ";

  // Open the ReceivePort to listen for incoming messages (optional)
  final rPort = ReceivePort();

  // Send your port to other isolates so they can reach you
  sPort.send(rPort.sendPort);

  print("$TAG port sent");

  // Listen for messages (optional)
  await for (var msg in rPort) {
    // `data` is the message received.
    print("$TAG received $msg");
  }
}
