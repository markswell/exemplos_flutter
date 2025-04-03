class DateTimeUtil {
  static Map<String, DateTime> getMonthBoundaryDates(DateTime date) {
    final firstDay = DateTime(date.year, date.month, 1);

    final lastDay = DateTime(date.year, date.month + 1, 0, 23, 59, 59, 999);

    return {'firstDay': firstDay, 'lastDay': lastDay};
  }

  static List<String> getMonths() {
    return [
      'Janeiro',
      'Fevereiro',
      'Março',
      'Abril',
      'Maio',
      'Junho',
      'Julho',
      'Agosto',
      'Setembro',
      'Outubro',
      'Novembro',
      'Dezembro',
    ];
  }
}
