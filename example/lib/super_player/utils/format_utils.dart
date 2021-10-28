String formatTime(int seconds) {
  final h = seconds ~/ 3600 % 24;
  final m = seconds ~/ 60 % 60;
  final s = seconds % 60;
  String str;
  if (h > 0) {
    str =
        '${h < 10 ? '0' : ''}$h:${m < 10 ? '0' : ''}$m:${s < 10 ? '0' : ''}$s';
  } else {
    str = '${m < 10 ? '0' : ''}$m:${s < 10 ? '0' : ''}$s';
  }
  return str;
}
