enum Periods {
  day,
  week,
  month,
  year;

  (DateTime, DateTime) calculatePeriodBoundaries() {
    final DateTime currentDate = DateTime.now();

    final DateTime from = switch (this) {
      Periods.day => DateTime(
          currentDate.year,
          currentDate.month,
          currentDate.day,
        ),
      Periods.week => DateTime(
          currentDate.year,
          currentDate.month,
          currentDate.day - (currentDate.weekday - 1),
        ),
      Periods.month => DateTime(
          currentDate.year,
          currentDate.month,
        ),
      Periods.year => DateTime(
          currentDate.year,
        ),
    };

    final DateTime to = switch (this) {
      Periods.day => DateTime(
          currentDate.year,
          currentDate.month,
          currentDate.day,
          23,
          59,
          59,
        ),
      Periods.week => DateTime(
          currentDate.year,
          currentDate.month,
          currentDate.day + (7 - currentDate.weekday),
          23,
          59,
          59,
        ),
      Periods.month => DateTime(
          currentDate.year,
          currentDate.month + 1,
          0,
          23,
          59,
          59,
        ),
      Periods.year => DateTime(
          currentDate.year,
          DateTime.monthsPerYear,
          31,
          23,
          59,
          59,
        ),
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
