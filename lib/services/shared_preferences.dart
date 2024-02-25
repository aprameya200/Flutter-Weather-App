import 'package:new_app/config/constants.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferencesManager {

  static Future<void> setCurrentLocation(String location) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString(CURRENT_LOCATION, location);
  }

  static Future<String> getCurrentLocation() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    return pref.getString(CURRENT_LOCATION) ?? "error";
  }

  static Future<List<String>> getFavouritesList() async{
    SharedPreferences pref = await SharedPreferences.getInstance();
    return pref.getStringList(FAVOURITES_LIST) ?? [];
  }

  static Future<bool> addToFavouritesList(String location) async{

    // print("Hi");
    SharedPreferences pref = await SharedPreferences.getInstance();

    try{

      final locationList = pref.getStringList(FAVOURITES_LIST) ?? [];
      locationList.add(location);
      await pref.setStringList(FAVOURITES_LIST, locationList);

      return true;
      // clearFavouriteList();

    } catch(e){
      return false;
    }


  }

  static Future<void> removeFromFavouritesList(String location) async{
    SharedPreferences pref = await SharedPreferences.getInstance();
    final list = pref.getStringList(FAVOURITES_LIST) ?? [];
    list.remove(location);
    await pref.setStringList(FAVOURITES_LIST, list);
  }

  static Future<void> clearFavouriteList() async{
    SharedPreferences pref = await SharedPreferences.getInstance();
    await pref.setStringList(FAVOURITES_LIST, []);
  }


}
