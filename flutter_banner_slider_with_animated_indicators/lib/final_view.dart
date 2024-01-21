import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_banner_slider_with_animated_indicators/data.dart';
import 'package:flutter_banner_slider_with_animated_indicators/image_viewer.dart';
import 'package:motion_tab_bar/MotionTabBar.dart';
import 'package:motion_tab_bar/MotionTabBarController.dart';

class FinalView extends StatefulWidget {
  const FinalView({super.key});

  @override
  State<FinalView> createState() => _FinalViewState();
}

class _FinalViewState extends State<FinalView>
    with SingleTickerProviderStateMixin {
  MotionTabBarController? _motionTabBarController;

  late CarouselController innerCarouselController;
  late CarouselController outerCarouselController;
  int innerCurrentPage = 0;
  int outerCurrentPage = 0;

  @override
  void initState() {
    innerCarouselController = CarouselController();
    outerCarouselController = CarouselController();
    _motionTabBarController = MotionTabBarController(
      initialIndex: 1,
      length: 4,
      vsync: this,
    );
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();

    _motionTabBarController!.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Size size;
    double height, width;

    size = MediaQuery.of(context).size;
    height = size.height;
    width = size.width;

    return Scaffold(
      /// AppBar
      appBar: _buildAppBar(),

      /// bottom Navigation Bar
      bottomNavigationBar: _buildBottomNavigationBar(),
      body: SizedBox.expand(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            /// Inner Style Indicators Banner Slider
            _innerBannerSlider(height, width),

            /// Some Space
            const SizedBox(height: 50),

            /// Divider
            const Divider(),

            /// Outer Style Indicators Banner Slider
            _outerBannerSlider(),
          ],
        ),
      ),
    );
  }

  /// Bottom Navigation bar
  MotionTabBar _buildBottomNavigationBar() {
    return MotionTabBar(
      controller: _motionTabBarController,
      initialSelectedTab: "Home",
      labels: const ["Dashboard", "Home", "Profile", "Settings"],
      icons: const [
        Icons.dashboard,
        Icons.home,
        Icons.people_alt,
        Icons.settings
      ],
      tabSize: 50,
      tabBarHeight: 55,
      textStyle: const TextStyle(
        fontSize: 12,
        color: Colors.black,
        fontWeight: FontWeight.w500,
      ),
      tabIconColor: Colors.grey.shade400,
      tabIconSize: 28.0,
      tabIconSelectedSize: 26.0,
      tabSelectedColor: Colors.indigo,
      tabIconSelectedColor: Colors.white,
      tabBarColor: Colors.white,
      onTabItemSelected: (int value) {
        setState(() {
          _motionTabBarController!.index = value;
        });
      },
    );
  }

  /// Outer Style Indicators Banner Slider
  Widget _outerBannerSlider() {
    return Column(
      children: [
        const Padding(
          padding: EdgeInsets.all(15),
          child: Text(
            "Outer Indicator Style",
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
          ),
        ),
        CarouselSlider(
          carouselController: outerCarouselController,

          /// It's options
          options: CarouselOptions(
            autoPlay: true,
            enlargeCenterPage: true,
            enableInfiniteScroll: true,
            aspectRatio: 16 / 8,
            viewportFraction: .95,
            onPageChanged: (index, reason) {
              setState(() {
                outerCurrentPage = index;
              });
            },
          ),

          /// Items
          items: AppData.outerStyleImages.map((imagePath) {
            return Builder(
              builder: (BuildContext context) {
                /// Custom Image Viewer widget
                return CustomImageViewer.show(
                    context: context,
                    url: imagePath,
                    fit: BoxFit.fill,
                    radius: 0);
              },
            );
          }).toList(),
        ),
        const SizedBox(
          height: 10,
        ),

        /// Indicators
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(
            AppData.outerStyleImages.length,
            (index) {
              bool isSelected = outerCurrentPage == index;
              return GestureDetector(
                onTap: () {
                  outerCarouselController.animateToPage(index);
                },
                child: AnimatedContainer(
                  width: isSelected ? 30 : 10,
                  height: 10,
                  margin: EdgeInsets.symmetric(horizontal: isSelected ? 6 : 3),
                  decoration: BoxDecoration(
                    color: isSelected
                        ? Colors.deepPurpleAccent
                        : Colors.grey.shade400,
                    borderRadius: BorderRadius.circular(
                      40,
                    ),
                  ),
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.ease,
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  /// Inner Style Indicators Banner Slider
  Widget _innerBannerSlider(double height, double width) {
    return Column(
      children: [
        /// Slider Style
        const Padding(
          padding: EdgeInsets.all(15),
          child: Text(
            "Inner Indicator Style",
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
          ),
        ),

        SizedBox(
          height: height * .25,
          width: width,
          child: Stack(
            alignment: Alignment.center,
            children: [
              /// Carouse lSlider
              Positioned.fill(
                child: CarouselSlider(
                  carouselController: innerCarouselController,

                  /// It's options
                  options: CarouselOptions(
                    autoPlay: true,
                    enlargeCenterPage: true,
                    enableInfiniteScroll: true,
                    viewportFraction: 0.8,
                    onPageChanged: (index, reason) {
                      setState(() {
                        innerCurrentPage = index;
                      });
                    },
                  ),

                  /// Items
                  items: AppData.innerStyleImages.map((imagePath) {
                    return Builder(
                      builder: (BuildContext context) {
                        /// Custom Image Viewer widget
                        return CustomImageViewer.show(
                          context: context,
                          url: imagePath,
                          fit: BoxFit.cover,
                        );
                      },
                    );
                  }).toList(),
                ),
              ),

              /// Indicators
              Positioned(
                bottom: height * .02,
                child: Row(
                  children: List.generate(
                    AppData.innerStyleImages.length,
                    (index) {
                      bool isSelected = innerCurrentPage == index;
                      return GestureDetector(
                        onTap: () {
                          innerCarouselController.animateToPage(index);
                        },
                        child: AnimatedContainer(
                          width: isSelected ? 55 : 17,
                          height: 10,
                          margin: EdgeInsets.symmetric(
                              horizontal: isSelected ? 6 : 3),
                          decoration: BoxDecoration(
                            color: isSelected
                                ? Colors.white
                                : Colors.grey.shade200,
                            borderRadius: BorderRadius.circular(
                              40,
                            ),
                          ),
                          duration: const Duration(milliseconds: 300),
                          curve: Curves.ease,
                        ),
                      );
                    },
                  ),
                ),
              ),

              /// Left Icon
              Positioned(
                left: 11,
                child: CircleAvatar(
                  backgroundColor: Colors.black.withOpacity(0.2),
                  child: IconButton(
                    onPressed: () {
                      innerCarouselController
                          .animateToPage(innerCurrentPage - 1);
                    },
                    icon: const Icon(
                      Icons.arrow_back_ios,
                      size: 20,
                    ),
                  ),
                ),
              ),

              /// Right Icon
              Positioned(
                right: 11,
                child: CircleAvatar(
                  backgroundColor: Colors.black.withOpacity(0.2),
                  child: IconButton(
                    onPressed: () {
                      innerCarouselController
                          .animateToPage(innerCurrentPage + 1);
                    },
                    icon: const Icon(
                      Icons.arrow_forward_ios,
                      size: 20,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  /// AppBar
  AppBar _buildAppBar() {
    return AppBar(
      title: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(50),
            child: SizedBox(
              height: 50,
              width: 50,
              child: Image.network(
                  'https://avatars.githubusercontent.com/u/91388754?v=4'),
            ),
          ),
          const SizedBox(
            width: 10,
          ),
          const Text(
            "Programming With FlexZ",
            style: TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
