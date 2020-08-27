import 'package:get/get.dart';

class CountController extends GetxController {
  int _index = 0;

  void selectPage(int index) {
    _index = index;
  }
}
