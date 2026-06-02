String formatDuration(Duration duration) {
  final hours = duration.inHours;
  final minutes = duration.inMinutes.remainder(60);
  final seconds = duration.inSeconds.remainder(60);

  final minuteStr =
      hours > 0 ? minutes.toString().padLeft(2, '0') : minutes.toString();
  final secondStr = seconds.toString().padLeft(2, '0');

  if (hours > 0) return '$hours:$minuteStr:$secondStr';
  return '$minuteStr:$secondStr';
}
