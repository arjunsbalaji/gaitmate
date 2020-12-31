Duration strToDuration(String s) {
    int hours = 0;
    int minutes = 0;
    //int seconds = 0;
    int micros;
    if (s == '') {
      return Duration(hours:0, minutes:0,microseconds:0);
    }
    
    List<String> parts = s.split(':');
    if (parts.length > 2) {
      hours = int.parse(parts[parts.length - 3]);
    }
    if (parts.length > 1) {
      minutes = int.parse(parts[parts.length - 2]);
    }
    micros = (double.parse(parts[parts.length - 1]) * 1000000).round();
    return Duration(hours: hours, minutes: minutes, microseconds: micros);
}
