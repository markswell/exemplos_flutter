class PayingSource {
  int? id;
  String name;
  double balance;
  String? intentAndroid;
  String? intentIos;

  PayingSource({
    this.id,
    required this.name,
    required this.balance,
    this.intentAndroid,
    this.intentIos,
  });
}
