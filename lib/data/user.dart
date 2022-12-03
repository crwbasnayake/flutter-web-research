import 'dart:async';
import 'dart:math';

class User {
  List<UserInfo> userInfo = [];

  void initData(int size) {
    userInfo.clear();
    Random random = Random();

    for (int i = 0; i < size; i++) {
      var n = generateRandomString(3).toUpperCase();
      var n1 = random.nextInt(9999).toString().padLeft(4, '0');
      var n2 = random.nextInt(9999).toString().padLeft(4, '0');
      var n3 = random.nextInt(11) + 10;
      var n4 = random.nextInt(12).toString().padLeft(2, '0');
      var n5 = random.nextInt(30).toString().padLeft(2, '0');
      userInfo.add(UserInfo("$n.N0000", random.nextBool(), '+001 $n1 $n2',
          '20$n3-$n4-$n5', 'Company Name $n'));
    }
  }

  String generateRandomString(int len) {
    var r = Random();
    const chars = 'AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz';
    return List.generate(len, (index) => chars[r.nextInt(chars.length)]).join();
  }

  ///
  /// Single sort, sort Name's id
  void sortName(bool isAscending) {
    userInfo.sort((a, b) {
      int aId = int.tryParse(a.name.replaceFirst('User_', '')) ?? 0;
      int bId = int.tryParse(b.name.replaceFirst('User_', '')) ?? 0;
      return (aId - bId) * (isAscending ? 1 : -1);
    });
  }

  ///
  /// sort with Status and Name as the 2nd Sort
  void sortStatus(bool isAscending) {
    userInfo.sort((a, b) {
      if (a.status == b.status) {
        int aId = int.tryParse(a.name.replaceFirst('User_', '')) ?? 0;
        int bId = int.tryParse(b.name.replaceFirst('User_', '')) ?? 0;
        return (aId - bId);
      } else if (a.status) {
        return isAscending ? 1 : -1;
      } else {
        return isAscending ? -1 : 1;
      }
    });
  }
}

class UserInfo {
  String name;
  bool status;
  String phone;
  String registerDate;
  String terminationDate;

  UserInfo(this.name, this.status, this.phone, this.registerDate,
      this.terminationDate);

  dynamic get(String fieldName) {
    if (fieldName == 'Name') {
      return name;
    } else if (fieldName == 'Status') {
      return status;
    } else if (fieldName == 'Phone') {
      return phone;
    } else if (fieldName == 'Register') {
      return registerDate;
    } else if (fieldName == 'Termination') {
      return terminationDate;
    }
    throw Exception('Invalid field name');
  }
}

class UserColumnInfo {
  final String name;
  final double width;
  const UserColumnInfo(this.name, this.width);
}
