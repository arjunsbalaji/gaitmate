import 'package:flutter/cupertino.dart';
import 'package:gaitmate/helpers/db_helper.dart';

class Details with ChangeNotifier {
  Map<String, Object> _userProperties = {};

  Map<String, Object> get userProperties {
    return {..._userProperties};
  }

  Future<void> fetchAndSetDetails() async {
    final dataList = await DBHelper.getData('user_details');
    print(dataList.toString());
    dataList.forEach(
      (element) {
        element.forEach(
          (key, value) {
            _userProperties[key] = value;
          },
        );
      },
    );
    notifyListeners();
  }

  void updateUserProperties(Map<String, Object> newUserProperties) {
    _userProperties = newUserProperties;
    notifyListeners();
    DBHelper.insert('user_details', newUserProperties);
  }
}
