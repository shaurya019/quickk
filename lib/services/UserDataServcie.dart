import 'package:quickk/modal/UserData.dart';

class UserDataService{

  UserData _userdata;


  setUserdata(UserData userdata) {
    _userdata = userdata;
  }

   UserData get userData => _userdata;
}