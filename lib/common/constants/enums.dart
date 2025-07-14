enum Periods {
  day,
  week,
  month,
  year;

  (DateTime, DateTime) calculatePeriodBoundaries() {
    final currentDate = DateTime.now();

    final from = switch (this) {
      Periods.day => DateTime(
          currentDate.year,
          currentDate.month,
          currentDate.day,
        ),
      Periods.week => DateTime(
          currentDate.year,
          currentDate.month,
          currentDate.day,
        ).subtract(
          Duration(days: currentDate.weekday - 1),
        ),
      Periods.month => DateTime(currentDate.year, currentDate.month),
      Periods.year => DateTime(currentDate.year),
    };

    final to = switch (this) {
      Periods.day => DateTime(
          currentDate.year,
          currentDate.month,
          currentDate.day,
          23,
          59,
          59,
        ),
      Periods.week => currentDate
          .add(Duration(days: 7 - currentDate.weekday))
          .copyWith(hour: 23, minute: 59, second: 59),
      Periods.month => DateTime(
          currentDate.month == 12 ? currentDate.year + 1 : currentDate.year,
          currentDate.month == 12 ? 1 : currentDate.month + 1,
          0,
          23,
          59,
          59,
        ),
      Periods.year => DateTime(
          currentDate.year + 1,
          1,
          1,
        ).subtract(Duration(seconds: 1)),
    };

    return (from, to);
  }
}

enum Languages {
  english("English"),
  russian("Русский");

  const Languages(this.label);
  final String label;
}

enum DateFormat {
  ddmmyy("dd.mm.yyyy"),
  mmddyy("mm.dd.yyyy");

  const DateFormat(this.label);
  final String label;
}
