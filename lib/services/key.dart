import 'dart:async';
// ignore: depend_on_referenced_packages
import 'package:rxdart/subjects.dart';

class KeyService {
  final seconds = const Duration(seconds: 1);

  final BehaviorSubject<String?> _keySubject = BehaviorSubject.seeded(null);
  final BehaviorSubject<String?> _aeskeySubject = BehaviorSubject.seeded(null);

  final BehaviorSubject<int?> _durationSubject = BehaviorSubject.seeded(null);

  Stream get keystream$ => _keySubject.stream;
  Stream get durationStream$ => _durationSubject.stream;
  Stream get aesStream$ => _aeskeySubject.stream;

  String? get currentKey => _keySubject.valueWrapper?.value;
  String? get aesKey => _aeskeySubject.valueWrapper?.value;
  int? get duration => _durationSubject.valueWrapper?.value;

  final BehaviorSubject<int> _remainingTimeSubject = BehaviorSubject.seeded(0);
  Stream get remainingTimestream$ => _remainingTimeSubject.stream;
  int get currentRemainingTime =>
      _remainingTimeSubject.valueWrapper?.value ?? 0;

  DateTime? _startTime;
  DateTime? _endTime;

  Timer? _timer;

  int getElapsedTime() {
    if (_startTime != null && _endTime != null) {
      DateTime curTime = DateTime.now();
      if (curTime.isAfter(_startTime!)) {
        Duration difference = curTime.difference(_startTime!);
        return difference.inSeconds;
      }
    }
    return 0;
  }

  int getRemainingTime() {
    if (_startTime != null && _endTime != null) {
      DateTime curTime = DateTime.now();
      if (curTime.isBefore(_endTime!)) {
        Duration difference = _endTime!.difference(curTime);
        return difference.inSeconds;
      }
    }
    return 0;
  }

  void resetRemainingTime() {
    if (_timer != null) {
      _timer!.cancel();
      _timer = null;
      _startTime = null;
      _endTime = null;
      _keySubject.add(null);
      _remainingTimeSubject.add(0);
    }
  }

  void _timerCallback(Timer timer) {
    // console(ConsoleLevel.Info, "Ticks: ${_timer.tick.toString()}");
    int remainingTime = getRemainingTime();
    if (remainingTime > 0) {
      _remainingTimeSubject.add(remainingTime);
    } else {
      resetRemainingTime();
    }
  }

  storeKey(String newValue) {
    _keySubject.add(newValue);
  }

  storeAesKey(String aesKey) {
    _aeskeySubject.add(aesKey);
  }

  storeSessionDuration(DateTime startTime, int? duration) {
    if (_timer != null) {
      _timer!.cancel();
      _timer = null;
    }
    if (duration != null) {
      _startTime = startTime;
      // _startTime = DateTime.now();
      _endTime = _startTime!.add(Duration(seconds: duration));

      _timer = Timer.periodic(seconds, _timerCallback);
      _remainingTimeSubject.add(getRemainingTime());

      _durationSubject.add(duration);
    }
  }

  void removeKey() {
    if (_timer != null && _timer!.isActive) {
      resetRemainingTime();
      _keySubject.add(null);
      // _encryptionkeySubject.add(null);
    }
  }
}
