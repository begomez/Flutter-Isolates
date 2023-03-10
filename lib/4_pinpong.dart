import 'dart:io';
import 'dart:isolate';
import 'dart:math';

import 'package:flutter_isolates/player.dart';

const String MAIN = "main   : ";
const String ISOLATE = "isolate: ";

void printMsg({String tag = "", String msg = ""}) {
  print("$tag $msg");
}

void spawner(CrossIsolatesMessage fromMain) {
  Player p2 = Player(pos: 2, score: 0);

  ReceivePort isolateInbox = ReceivePort();
  SendPort isolateOutbox = isolateInbox.sendPort;

  // channel "ISOLATE -> main"
  fromMain.sender.send(CrossIsolatesMessage<Player>(
      sender: isolateOutbox, message: Player.empty()));

  isolateInbox.listen((message) {
    Player receivedPlayer = (message.message) as Player;

    printMsg(tag: ISOLATE, msg: "received $receivedPlayer");

    // VALID
    if (receivedPlayer.validate()) {
      fromMain.sender.send(CrossIsolatesMessage<Player>(
          message: Random().nextBool() ? p2 : receivedPlayer,
          sender: isolateOutbox));

      // INVALID
    } else {
      fromMain.sender.send(
          CrossIsolatesMessage<Player>(sender: isolateOutbox, message: p2));
    }
  });
}

void main() async {
  Player p1 = Player(pos: 1, score: 0);

  ReceivePort mainInbox = ReceivePort();
  SendPort mainOutbox = mainInbox.sendPort;

  // channel "MAIN -> isolate"
  Isolate rival = await Isolate.spawn(
      spawner,
      CrossIsolatesMessage<Player>(
          message: Player.empty(), sender: mainOutbox));

  mainInbox.listen((fromIsolate) {
    Player receivedPlayer = fromIsolate.message;

    printMsg(tag: MAIN, msg: "received $receivedPlayer");

    // VALID
    if (receivedPlayer.validate()) {
      // FINISHED
      if (receivedPlayer.finished()) {
        rival.kill(priority: Isolate.immediate);
        exit(0);

        // STILL PLAYING
      } else {
        fromIsolate.sender.send(CrossIsolatesMessage<Player>(
            message: Random().nextBool() ? receivedPlayer : p1,
            sender: mainOutbox));
      }

      // INVALID
    } else {
      fromIsolate.sender
          .send(CrossIsolatesMessage<Player>(message: p1, sender: mainOutbox));
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
  }) {
    (message as Player).processTurn();
  }

  @override
  String toString() {
    return "$sender $message";
  }
}
