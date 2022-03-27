import'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class ThemeServices {
  final GetStorage _box=GetStorage();
  final _Key='isDarkMode';
  _saveThemeTOBox(bool isDarkMode){
    _box.write(_Key, isDarkMode);
  }

 bool _loadThemeFormBox(){
   return _box.read<bool>(_Key)??false;
  }

  ThemeMode get theme=>_loadThemeFormBox()?ThemeMode.dark:ThemeMode.light;
  void switchTheme(){
    Get.changeThemeMode(_loadThemeFormBox()?ThemeMode.light:ThemeMode.dark);
    _saveThemeTOBox(!_loadThemeFormBox());
  }



}


