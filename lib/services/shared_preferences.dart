import 'package:new_app/config/constants.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferencesManager {
  static Future<void> setCurrentLocation(String location) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    final locationList = prefs.getStringList(FAVOURITES_LIST) ?? [];
    
    locationList.insert(0,location);

    await prefs.setStringList(FAVOURITES_LIST, locationList);

  }

  static Future<String> getCurrentLocation() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    return pref.getString(CURRENT_LOCATION) ?? "error";
  }

  static Future<List<String>> getFavouritesList() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    return pref.getStringList(FAVOURITES_LIST) ?? [];
  }

  static Future<bool> toggleFavouritesList(String location) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    // clearFavouriteList();

    try {
      final locationList = pref.getStringList(FAVOURITES_LIST) ?? [];

      if (!locationList.contains(location)) {
        locationList.add(location);
        await pref.setStringList(FAVOURITES_LIST, locationList);
      } else {
        locationList.remove(location);
        await pref.setStringList(FAVOURITES_LIST, locationList);
      }
      return true;
    } catch (e) {
      return false;
    }
  }

  static Future<bool> containsLocation(String location) async {

    SharedPreferences pref = await SharedPreferences.getInstance();
    final list = pref.getStringList(FAVOURITES_LIST) ?? [];

    for (int i = 0; i < list.length; i++) {
      if (list[i].trim().toUpperCase() == location.trim().toUpperCase()) {
        print("Contains location from loop");
        return true;
      }
    }

    return false;
  }

  static Future<void> removeFromFavouritesList(String location) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    final list = pref.getStringList(FAVOURITES_LIST) ?? [];
    list.remove(location);
    await pref.setStringList(FAVOURITES_LIST, list);
  }

  static Future<void> clearFavouriteList() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    await pref.setStringList(FAVOURITES_LIST, []);
  }
}
