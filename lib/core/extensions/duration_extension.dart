enum DurationLevel { HIGH, NORMAL, LOW }

extension DurationExtension on DurationLevel {
  Duration get duration {
    switch (this) {
      case DurationLevel.HIGH:
        return Duration(
          milliseconds: 1200,
        );
        break;
      case DurationLevel.NORMAL:
        return Duration(
          milliseconds: 800,
        );
        break;
      case DurationLevel.LOW:
        return Duration(
          milliseconds: 600,
        );
        break;
      default:
        throw new Exception("Duration Hatası.");
        break;
    }
  }
}
