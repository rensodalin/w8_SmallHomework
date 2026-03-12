import 'package:flutter/material.dart';
import '../../../../data/repositories/songs/song_repository.dart';
import '../../../states/player_state.dart';
import '../../../../model/songs/song.dart';

class LibraryViewModel extends ChangeNotifier {
  final SongRepository songRepository;
  final PlayerState playerState;
  // List<Song>? _songs;
  AsyncValue<List<Song>> _songs = AsyncValue.loading();

  LibraryViewModel({required this.songRepository, required this.playerState}) {
    playerState.addListener(notifyListeners);

    // init
    _init();
  }

  // List<Song> get songs => _songs == null ? [] : _songs!;
  AsyncValue<List<Song>> get songs => _songs;

  @override
  void dispose() {
    playerState.removeListener(notifyListeners);
    super.dispose();
  }

  void _init() async {
    // 1 - Fetch songs
    _songs = AsyncValue.loading();

    // 2 - notify listeners
    notifyListeners();

    try {
      List<Song> songs = await songRepository.fetchSongs();
      _songs = AsyncValue.success(songs);
    } catch (e) {
      _songs = AsyncValue.error(e);
    }

    notifyListeners();
  }

  bool isSongPlaying(Song song) => playerState.currentSong == song;

  void start(Song song) => playerState.start(song);
  void stop(Song song) => playerState.stop();
}

enum AsyncValueState { loading, error, success }

class AsyncValue<T> {
  final T? data;
  final Object? error;
  final AsyncValueState state;

  AsyncValue._({this.data, this.error, required this.state});

  factory AsyncValue.loading() {
    return AsyncValue._(state: AsyncValueState.loading);
  }

  factory AsyncValue.success(T data) {
    return AsyncValue._(state: AsyncValueState.success, data: data);
  }

  factory AsyncValue.error(Object error) {
    return AsyncValue._(state: AsyncValueState.error, error: error);
  }
}
