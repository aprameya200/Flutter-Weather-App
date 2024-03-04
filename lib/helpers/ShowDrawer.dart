// import 'package:flutter/material.dart';
// import 'package:new_app/pages/WeatherPage.dart';
// import 'package:velocity_x/velocity_x.dart';
//
// import '../model/SavedLocation.dart';
//
// class ShowDrawer {
//   static Drawer initDrawer(BuildContext context, VoidCallback vCF) {
//     TextEditingController controller = TextEditingController();
//
//     return Drawer(
//       elevation: 0,
//       shape: null,
//       backgroundColor: Color(0xFFFFFFFF),
//       child: Padding(
//         padding: EdgeInsets.symmetric(vertical: 50.0, horizontal: 20),
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.start,
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             RawAutocomplete(
//               optionsBuilder: (TextEditingValue textEditingValue) {
//                 if (textEditingValue.text == '') {
//                   return const Iterable<String>.empty();
//                 } else {
//                   List<String> matches = <String>[];
//                   matches.addAll(SavedLocation.lowercaseList);
//
//                   matches.retainWhere((s) {
//                     return s
//                         .toLowerCase()
//                         .contains(textEditingValue.text.toLowerCase());
//                   });
//                   return matches;
//                 }
//               },
//               onSelected: (String selection) {
//
//                 WeatherPage weatherPage = WeatherPage(cityName: selection);
//                 vCF();
//                 Navigator.pop(context,true);
//
//
//                 // Navigator.push(
//                 //   context,
//                 //   MaterialPageRoute(builder: (context) => weatherPage),
//                 // );
//               },
//               fieldViewBuilder: (BuildContext context,
//                   TextEditingController textEditingController,
//                   FocusNode focusNode,
//                   VoidCallback onFieldSubmitted) {
//                 return Container(
//                   alignment: Alignment.center,
//                   height: 60,
//                   decoration: BoxDecoration(
//                       color: Color.fromARGB(12, 12, 12, 12),
//                       borderRadius: BorderRadius.circular(14.2)),
//                   padding: EdgeInsets.only(left: 16, right: 16),
//                   child: TextField(
//                     decoration: const InputDecoration(
//                       border: InputBorder.none,
//                       hintText: "Search",
//                       icon: Icon(Icons.search),
//                     ),
//                     controller: textEditingController,
//                     focusNode: focusNode,
//                     onSubmitted: (String value) {},
//                   ),
//                 );
//               },
//               optionsViewBuilder: (BuildContext context,
//                   void Function(String) onSelected, Iterable<String> options) {
//                 return IntrinsicHeight(
//                   child: Container(
//                     height: 200,
//                     child: Material(
//                         //adjust height and width
//                         color: Colors.transparent,
//                         child: SizedBox(
//                             height: 300,
//                             child: Container(
//                               height: 200,
//                               child: SingleChildScrollView(
//                                   child: Container(
//                                 color: Colors.transparent,
//                                 width: 0,
//                                 child: Column(
//                                   crossAxisAlignment: CrossAxisAlignment.start,
//                                   children: options.map((opt) {
//                                     return InkWell(
//                                         onTap: () {
//                                           onSelected(opt);
//                                         },
//                                         child: Container(
//                                           padding:
//                                               EdgeInsets.symmetric(vertical: 6),
//                                           color: Colors.white,
//                                           alignment: Alignment.topLeft,
//                                           width: 270,
//                                           child: Text(
//                                             opt,
//                                             textAlign: TextAlign.left,
//                                             style: TextStyle(fontSize: 18),
//                                           ),
//                                         ));
//                                   }).toList(),
//                                 ),
//                               )),
//                             ))),
//                   ),
//                 );
//               },
//             ),
//             SquareBox(20),
//             Padding(
//               padding: EdgeInsets.all(8.0),
//               child: Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 crossAxisAlignment: CrossAxisAlignment.center,
//                 children: [
//                   const Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       // Container(child: Lottie.asset("assets/mountains.json",height: 100),),
//                       Text(
//                         "Kathmandu",
//                         style: TextStyle(fontSize: 20),
//                       ),
//                       Text(
//                         "Cloudy",
//                         style: TextStyle(fontSize: 15),
//                       )
//                     ],
//                   ),
//                   Container(
//                     height: 50,
//                     alignment: Alignment.topRight,
//                     child: const Text(
//                       "19°",
//                       style:
//                           TextStyle(fontSize: 25, fontWeight: FontWeight.w500),
//                     ),
//                   )
//                 ],
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

import 'package:carbon_icons/carbon_icons.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:new_app/database/WeatherDatabase.dart';
import 'package:new_app/pages/WeatherPage.dart';
import 'package:new_app/services/shared_preferences.dart';

import '../model/SavedLocation.dart';

class ShowDrawer extends StatelessWidget{

  final Function fetchWeatherForCity;
  final Function displayFromFav;

  ShowDrawer(this.fetchWeatherForCity,this.displayFromFav);


  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return initDrawer(context, fetchWeatherForCity,displayFromFav);
  }

  Future<Map> weatherData() async{
    final sharePrefLocations = await SharedPreferencesManager.getFavouritesList();
    final dbWeatherList = await WeatherDatabase().getWeather();

    final data = {sharePrefLocations :dbWeatherList};

    return data;
  }


  Drawer initDrawer(BuildContext? context, Function? fetchWeatherForCity, Function? displayFromFav) {
    //passing function from Weather page to take new cityname as a input and call api accordingly to make state changes.
    TextEditingController controller = TextEditingController();

    double screenHeight = MediaQuery.of(context!).size.height;

    return Drawer(
      elevation: 0,
      shape: Border.all(width: 0), // No border radius, only rectangular shape
      backgroundColor: Color(0xFFFFFFFF),
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            RawAutocomplete(
              optionsBuilder: (TextEditingValue textEditingValue) {
                if (textEditingValue.text == '') {
                  return const Iterable<String>.empty();
                } else {
                  List<String> matches = <String>[];
                  matches.addAll(SavedLocation.lowercaseList);

                  matches.retainWhere((s) {
                    return s
                        .toLowerCase()
                        .contains(textEditingValue.text.toLowerCase());
                  });
                  return matches;
                }
              },
              onSelected: (String selection) {
                FocusManager.instance.primaryFocus?.unfocus();
                fetchWeatherForCity!(selection);
                Navigator.pop(context, true);
              },
              fieldViewBuilder: (BuildContext context,
                  TextEditingController textEditingController,
                  FocusNode focusNode,
                  VoidCallback onFieldSubmitted) {
                return Container(
                  alignment: Alignment.center,
                  height: 60,
                  decoration: BoxDecoration(
                      color: Color.fromARGB(12, 12, 12, 12),
                      borderRadius: BorderRadius.circular(14.2)),
                  padding: EdgeInsets.only(left: 16, right: 16),
                  child: TextField(
                    decoration: const InputDecoration(
                      border: InputBorder.none,
                      hintText: "Search",
                      icon: Icon(Icons.search),
                    ),
                    controller: textEditingController,
                    focusNode: focusNode,
                    onSubmitted: (String value) {},
                  ),
                );
              },
              optionsViewBuilder: (BuildContext context,
                  void Function(String) onSelected, Iterable<String> options) {
                return IntrinsicHeight(
                  child: Container(
                    height: 200,
                    child: Material(
                        //adjust height and width
                        color: Colors.transparent,
                        child: SizedBox(
                            height: 300,
                            child: Container(
                              height: 200,
                              child: SingleChildScrollView(
                                  child: Container(
                                color: Colors.transparent,
                                width: 0,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: options.map((opt) {
                                    return InkWell(
                                        onTap: () {
                                          onSelected(opt);
                                        },
                                        child: Container(
                                          padding:
                                              EdgeInsets.symmetric(vertical: 6),
                                          color: Colors.white,
                                          alignment: Alignment.topLeft,
                                          width: 270,
                                          child: Text(
                                            opt,
                                            textAlign: TextAlign.left,
                                            style: TextStyle(fontSize: 18),
                                          ),
                                        ));
                                  }).toList(),
                                ),
                              )),
                            ))),
                  ),
                );
              },
            ),
            SizedBox(
              height: 20,
            ),
            Container(
              height: screenHeight * 0.8,
              padding: EdgeInsets.all(0),
              child: FutureBuilder<List<String>>(
                future: SharedPreferencesManager.getFavouritesList(),
                builder: (context,snapshot){
                  print( snapshot.data?.length);
                  return ListView.builder(
                    // itemCount: 2,
                    itemCount: snapshot.data?.length ?? 3,
                    itemBuilder: (BuildContext context, int index) {
                      return InkWell(
                        onTap: () {
                          // fetchWeatherForCity!(snapshot.data != null ? snapshot.data![index] : "OK");
                          displayFromFav!(snapshot.data![index]);
                          Navigator.pop(context, true);
                        },
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 3.0),
                          child: Container(
                            padding: EdgeInsets.symmetric(vertical: 2,horizontal: 10),
                            height: 45,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(14.2)),
                            child: Align(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                snapshot.data != null ? snapshot.data![index] : "OK",
                                style: TextStyle(fontSize: 25),
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  );
                },
              )

            ),
          ],
        ),
      ),
    );
  }


}
