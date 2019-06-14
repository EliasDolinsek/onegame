import 'game.dart';
import 'question.dart';

class GameManager {

  final Game game;
  final Duration timeToAnswer;

  GameManager(this.game, this.timeToAnswer);

  get question => game.questions.firstWhere((Question q) => !q.answered);
}