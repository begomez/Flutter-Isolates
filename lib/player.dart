import 'dart:math';

class Player {
  static const int TOP_SCORE = 100;

  int pos;
  int score;

  factory Player.empty() => Player(pos: 0, score: 0);

  Player({this.pos, this.score}) {
    init();
  }

  void init() {}

  void processTurn() {
    final inc = this.generateRand();

    this.increment(inc);

    if (this.finished()) {
      this.win();
    }
  }

  int generateRand() => Random().nextInt(10);

  void increment(int num) {
    this.score += num;
  }

  bool finished() => this.score > TOP_SCORE;

  bool validate() => this.pos > 0;

  void win() {
    print("Player $pos WINNER!");
  }

  @override
  String toString() {
    return "Player $pos with score: $score";
  }
}
