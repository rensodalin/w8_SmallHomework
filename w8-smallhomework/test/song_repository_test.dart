import 'package:w5/asyn/data/repositories/songs/song_repository_mock.dart';

void main() async {
  //   Instantiate the  song_repository_mock
  final repo = SongRepositoryMock();

  // Test both the success and the failure of the post request
  // - Using then() with .catchError().

  // Handle the Future using 2 ways  (2 tests)
  repo
      .fetchSongById('s1')
      .then((song) {
        print('Song received ${song?.title}');
      })
      .catchError((e) {
        print('Exception: $e');
      });
  repo
      .fetchSongById('s9')
      .then((song) {
        print('Song received ${song?.title}');
      })
      .catchError((e) {
        print('Exception: $e');
      });
  // - Using async/await with try/catch.
  try {
    final song = await repo.fetchSongById('s2');
    print('Song received ${song?.title}');
  } catch (e) {
    print('Exception: $e');
  }
  try {
    final song = await repo.fetchSongById('s9');
    print('Song received ${song?.title}');
  } catch (e) {
    print('Exception: $e');
  }
}
