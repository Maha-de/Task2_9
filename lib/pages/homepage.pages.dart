import 'dart:convert';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:dots_indicator/dots_indicator.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:task_3/bloc/ads_cubit.dart';
import 'package:task_3/pages/login.pages.dart';
import 'package:task_3/services/ads_repository.dart';
import 'package:task_3/services/preferences.services.dart';
import 'package:task_3/utilities/edges.dart';
import 'package:task_3/widgets/recommended_widget.dart';
import 'package:task_3/widgets/section_header.dart';
import 'package:task_3/widgets/today_widget.dart';

import '../models/ad.model.dart';
import '../models/ad_model.dart';

class HomePageScreen extends StatefulWidget {
  HomePageScreen({super.key});

  @override
  State<HomePageScreen> createState() => _HomePageScreenState();
}

class _HomePageScreenState extends State<HomePageScreen> {
  var sliderIndex = 0;
  CarouselController carouselControllerEx = CarouselController();

  var images = [
    "images/slider_image1.jpg",
    "images/slider_image2.jpg",
    "images/slider_image3.jpg",
    "images/slider_image4.jpg",
    "images/slider_image5.jpg",
  ];
  late AdsRepository adsRepository;
  late AdsCubit adsCubit;

  late List<Recipe> allRecipes;

  // @override
  // void initState() {
  //   allRecipes = BlocProvider.of<AdsCubit>(context).getAllAds();
  //   super.initState();
  // }

  Widget buildBlocWidget() {
    allRecipes = BlocProvider.of<AdsCubit>(context).getAllAds();
    return BlocBuilder<AdsCubit, AdsState>(
      builder: (context, state) {
        if (state is AdsLoaded) {
          allRecipes = (state).recipes;
          return buildAdsList();
        } else {
          return showLoadingIndicator();
        }
      },
    );
  }

  Widget showLoadingIndicator() {
    return Center(
      child: CircularProgressIndicator(),
    );
  }

  // Widget buildLoadedListWidget(){
  //   return SingleChildScrollView(
  //     child: Container(
  //       color: Colors.brown,
  //       child: Column(
  //         children: [
  //           buildAdsList(),
  //         ],
  //       ),
  //     ),
  //   );
  // }

  Widget buildAdsList() {
    return CarouselSlider(
      carouselController: carouselControllerEx,
      options: CarouselOptions(
          height: 200.0,
          autoPlay: true,
          onPageChanged: (index, _) {
            sliderIndex = index;
            setState(() {});
          }),
      items: allRecipes.map((i) {
        return Container(
          width: MediaQuery.of(context).size.width,
          margin: EdgeInsets.symmetric(horizontal: 5.0),
          decoration: BoxDecoration(color: Colors.amber),
          child:
              // i.imageUrl.isNotEmpty ? FadeInImage.assetNetwork(placeholder: "images/loading.gif", image: i.imageUrl, fit: BoxFit.cover,)
              //     : Image.asset(images as String)
              Image.network(
            i.imageUrl,
            fit: BoxFit.cover,
          ),
        );
      }).toList(),
    );
  }

  // List<Ad> adsList = [];
  //
  // void getAds() async {
  //   try{
  //     var adsData = await rootBundle.loadString('data/sample.json');
  //     var dataDecoded =
  //     List<Map<String, dynamic>>.from(jsonDecode(adsData)['ads']);
  //
  //     adsList = dataDecoded.map((e) => Ad.fromJson(e)).toList();
  //     setState(() {});
  //   }
  // catch (e) {
  // print("Error in init Prefrenceshjkhjhkjhkjhkjhkjhjh ${e}");
  // }
  //   }
  //
  //
  // @override
  // void initState() {
  //   getAds();
  //   super.initState();
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: Padding(
          padding: const EdgeInsets.symmetric(
              horizontal: Edges.appHorizontalPadding),
          child: Icon(Icons.menu),
        ),
        actions: [
          Icon(Icons.notifications),
          PopupMenuButton<int>(
              onSelected: (item) => onSelected(context, item),
              itemBuilder: (context) =>
                  [PopupMenuItem<int>(value: 0, child: Text("Logout"))])
        ],
      ),
      body: Stack(children: [
        // allRecipes.isEmpty
        //     ? const CircularProgressIndicator()
        //     :
        Padding(
          padding: const EdgeInsets.symmetric(
              horizontal: Edges.appHorizontalPadding),
          child: ListView(scrollDirection: Axis.vertical, children: [
            SizedBox(
              height: 10,
            ),
            Text("Bonjour, Maha", style: TextStyle(fontSize: 20)),
            SizedBox(
              height: 10,
            ),
            Expanded(
                child: Text(
              "What would you like to cook today?",
              style: TextStyle(fontSize: 30),
            )),
            SizedBox(
              height: 10,
            ),

            Row(
              children: [
                Container(
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: Colors.grey.shade300),
                  height: 50,
                  width: 280,
                  child: TextFormField(
                    decoration: InputDecoration(
                      prefixIcon: Icon(Icons.search),
                      labelText: "Search for recipes",
                      border: OutlineInputBorder(borderSide: BorderSide.none),
                    ),
                  ),
                ),
                SizedBox(
                  width: 20,
                ),
                Container(
                  height: 50,
                  width: 50,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: Colors.grey.shade300,
                  ),
                  child: IconButton(
                    icon: Icon(Icons.menu),
                    onPressed: () {},
                  ),
                )
              ],
            ),

            SizedBox(
              height: 10,
            ),

            // BlocConsumer<AdsCubit, AdsState>(
            //     builder: (context, state) {
            //       return buildBlocWidget();
            //     },
            //     listener: (_, __) {}),

            buildBlocWidget(),

            // CarouselSlider(
            //   carouselController: carouselControllerEx,
            //   options: CarouselOptions(
            //       height: 200.0, autoPlay: true,
            //       onPageChanged: (index,_){
            //         sliderIndex = index;
            //         setState(() {
            //         });
            //       }),
            //   items: allRecipes.map((i) {
            //         return Container(
            //             width: MediaQuery.of(context).size.width,
            //             margin: EdgeInsets.symmetric(horizontal: 5.0),
            //             decoration: BoxDecoration(
            //                 color: Colors.amber
            //             ),
            //             child:
            //             Image.network(i.image!, fit: BoxFit.cover,),
            //             // Image.asset(i, fit: BoxFit.cover,)
            //             // Text('text $i', style: TextStyle(fontSize: 16.0),)
            //         );
            //
            //   }).toList(),
            // ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                    onPressed: () {
                      carouselControllerEx.previousPage(
                        duration: Duration(microseconds: 300),
                        curve: Curves.linear,
                      );
                    },
                    icon: Icon(
                      Icons.arrow_back,
                      size: 30,
                    )),
                IconButton(
                    onPressed: () {
                      carouselControllerEx.nextPage(
                        duration: Duration(microseconds: 300),
                        curve: Curves.linear,
                      );
                    },
                    icon: Icon(Icons.arrow_forward, size: 30)),
              ],
            ),
            DotsIndicator(
              dotsCount: images.length,
              position: sliderIndex,
              decorator: DotsDecorator(
                color: Colors.black87, // Inactive color
                activeColor: Colors.redAccent,
              ),
              onTap: (position) async {
                await carouselControllerEx.animateToPage(position);
                sliderIndex = position;
                setState(() {});
              },
            ),
            SizedBox(
              height: 10,
            ),
            SectionHeader(sectionName: "Today's Fresh Recipes"),

            SizedBox(
              height: 10,
            ),

            Container(
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SizedBox(
                      height: 200,
                      child: ListView.builder(
                          itemCount: 1,
                          scrollDirection: Axis.horizontal,
                          itemBuilder: (context, index) {
                            return Row(
                              children: [
                                Container(
                                  height: 320,
                                  width: 200,
                                  margin: EdgeInsets.fromLTRB(0, 10, 40, 5),
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(20),
                                      color: Colors.grey.shade300),
                                  child: TodayWidget(
                                      imageName: Image.asset(
                                        "images/french_toast_large.png",
                                        height: 80,
                                        width: 150,
                                      ),
                                      headerText: "Breakfast",
                                      titleText: "French Toast with Berries",
                                      caloriesText: "120 Calories",
                                      timeText: "10 mins",
                                      servingText: "1 Serving"),
                                ),
                                Container(
                                  height: 320,
                                  width: 220,
                                  margin: EdgeInsets.fromLTRB(0, 10, 40, 5),
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(20),
                                      color: Colors.grey.shade300),
                                  child: TodayWidget(
                                      imageName: Image.asset(
                                        "images/cinnamon_large.png",
                                        height: 80,
                                        width: 150,
                                      ),
                                      headerText: "Breakfast",
                                      titleText: "Brown Sugar Cinnamon Toast",
                                      caloriesText: "135 Calories",
                                      timeText: "15 mins",
                                      servingText: "1 Serving"),
                                ),
                              ],
                            );
                          }),
                    ),
                    SectionHeader(sectionName: "Recommended"),
                    SizedBox(
                      height: 10,
                    ),
                    Flexible(
                        child: ListView.separated(
                      itemCount: 1,
                      physics: NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemBuilder: (context, index) {
                        return Column(
                          children: [
                            RecommendedWidget(
                                imageName: Image.asset(
                                  "images/muffins_large2.png",
                                  height: 180,
                                  width: 100,
                                ),
                                headerText: "Breakfast",
                                titleText: "Blueberry Muffins",
                                caloriesText: "120 Calories",
                                timeText: "10 mins",
                                servingText: "1 Serving"),
                            SizedBox(
                              height: 10,
                            ),
                            RecommendedWidget(
                                imageName: Image.asset(
                                  "images/glazed_large.png",
                                  height: 180,
                                  width: 100,
                                ),
                                headerText: "Main Dish",
                                titleText: "Glazed Salmon",
                                caloriesText: "280 Calories",
                                timeText: "45 mins",
                                servingText: "1 Serving"),
                          ],
                        );
                      },
                      separatorBuilder: (context, index) {
                        return SizedBox(
                          height: 15,
                        );
                      },
                    ))
                  ],
                ),
              ),
            )
          ]),
        ),
      ]),
    );
  }

  onSelected(BuildContext context, int item) {
    switch (item) {
      case 0:
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => LoginPage()));
        PrefrencesService.prefs?.remove("user");
        PrefrencesService.prefs?.remove("password");
        break;
    }
  }
}
