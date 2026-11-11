
import 'pick.dart';

abstract class PickSource {
  Future<List<Pick>> fetchPicks();
}
