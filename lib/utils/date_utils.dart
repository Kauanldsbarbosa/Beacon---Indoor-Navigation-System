Duration timeSince(DateTime past) {
  final now = DateTime.now();
  return now.difference(past);
}

String formatDuration(Duration duration) {
  if (duration.inDays > 0) {
    return '${duration.inDays} dias';
  } else if (duration.inHours > 0) {
    return '${duration.inHours} horas';
  } else if (duration.inMinutes > 0) {
    return '${duration.inMinutes} minutos';
  } else {
    return '${duration.inSeconds} segundos';
  }
}
