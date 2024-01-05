import 'package:get/get.dart';
import 'package:intl/intl.dart';

class CAddHistory extends GetxController {
  final _date = DateFormat('yyyy-MM-dd').format(DateTime.now()).obs;
  String get date => _date.value;

  String? get idUser => null;
  setDate(n) => _date.value = n;

  final _type = 'Pemasukan'.obs;
  String get type => _type.value;
  setType(n) => _type.value = n;

  final _items = [].obs;
  List get items => _items;
  addItem(n) {
    _items.add(n);
    count();
    update();
  }

  deleteItem(i) {
    _items.removeAt(i);
    count();
    update();
  }

  final _total = 0.0.obs;
  double get total => _total.value;
  SetTotal(n) => _total.value = n;

  count() {
    _total.value = items.map((e) => e['price']).toList().fold(0.0,
        (previousValue, element) {
      return double.parse(previousValue.toString()) + double.parse(element);
    });
    // update();
  }
}
