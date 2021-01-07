enum Period { OVERALL, WEEK, MONTH, THREE_MONTHS, SIX_MONTHS, YEAR }

enum ImageType {
  USER,
  TRACK,
  ALBUM,
  ARTIST
}

extension PeriodExtension on Period {

  String get name {
    switch (this) {
      case Period.OVERALL:
        return 'overall';
      case Period.WEEK:
        return '7day';
      case Period.MONTH:
        return '1month';
      case Period.THREE_MONTHS:
        return '3month';
      case Period.SIX_MONTHS:
        return '6month';
      case Period.YEAR:
        return '12month';
      default:
        return null;
    }
  }
}