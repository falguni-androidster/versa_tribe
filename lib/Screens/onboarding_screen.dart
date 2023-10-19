import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:versa_tribe/Screens/sign_in_screen.dart';
import 'package:versa_tribe/Utils/image_path.dart';

import '../Providers/onboarding_provider.dart';
import '../Utils/custom_colors.dart';
import '../Utils/custom_string.dart';

class OnBoardingScreen extends StatefulWidget {
  const OnBoardingScreen({super.key});

  @override
  State<OnBoardingScreen> createState() => _OnBoardingScreenState();
}

class _OnBoardingScreenState extends State<OnBoardingScreen> {

  final int _numPages = 4;
  final PageController _pageController = PageController(initialPage: 0);

  List<Widget> _buildPageIndicator(int currentPage) {
    List<Widget> list = [];
    for (int i = 0; i < _numPages; i++) {
      list.add(i == currentPage ? _indicator(true) : _indicator(false));
    }
    return list;
  }

  Widget _indicator(bool isActive) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 150),
      margin: const EdgeInsets.symmetric(horizontal: 8),
      height: 8,
      width: isActive ? 32 : 8,
      decoration: BoxDecoration(
        color: isActive ? CustomColors.kBlueColor : CustomColors.kBlackColor,
        borderRadius: const BorderRadius.all(Radius.circular(12)),
      ),
    );
  }

  Widget _onBoardingPages({required img, required onBoardingTitle, required onBoardingDis}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        const Spacer(),
        Image(
          image: AssetImage(img),
          height: 300,
        ),
        const Spacer(),
        Text(onBoardingTitle, style: const TextStyle(color: CustomColors.kBlackColor, fontSize: 30)),
        const SizedBox(height: 20),
        SizedBox(
          width: 300,
          child: Text(onBoardingDis,
              style: const TextStyle(color: CustomColors.kBlackColor, fontSize: 20), textAlign: TextAlign.center),
        ),
        const Spacer(),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: <Widget>[
          /*/// skip button
          Align(
            alignment: Alignment.bottomLeft,
            child: TextButton(
              onPressed: () {
                _pageController.jumpToPage(_numPages);
              },
              child: const Text(
                CustomString.skip,
                style: TextStyle(
                  color: CustomColors.kBlueColor,
                  fontSize: 14,
                ),
              ),
            ),
          ),*/

          /// Manage Indicator
          Container(
            alignment: Alignment.bottomCenter,
            margin: const EdgeInsets.only(bottom: 100),
            child: Consumer<OnBoardingProvider>(builder: (context, val, child) {
              return Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: _buildPageIndicator(val.currentPage),
              );
            }),
          ),

          /// pageView
          Consumer<OnBoardingProvider>(
              builder: (context, val, child) {
                return PageView(
                  physics: const ClampingScrollPhysics(),
                  controller: _pageController,
                  onPageChanged: (int page) {
                    val.setOnBoardingPages(page);
                  },
                  children: <Widget>[
                    _onBoardingPages(
                        img: ImagePath.onBoardingPath,
                        onBoardingTitle: CustomString.onBoardingScreenTitle,
                        onBoardingDis: CustomString.onBoardingScreenDiscription),
                    _onBoardingPages(
                        img: ImagePath.onBoardingPath,
                        onBoardingTitle: CustomString.onBoardingScreenTitle,
                        onBoardingDis: CustomString.onBoardingScreenDiscription),
                    _onBoardingPages(
                        img: ImagePath.onBoardingPath,
                        onBoardingTitle: CustomString.onBoardingScreenTitle,
                        onBoardingDis: CustomString.onBoardingScreenDiscription),
                    _onBoardingPages(
                        img: ImagePath.onBoardingPath,
                        onBoardingTitle: CustomString.onBoardingScreenTitle,
                        onBoardingDis: CustomString.onBoardingScreenDiscription),
                  ],
                );
              }),

          /// Button
          Consumer<OnBoardingProvider>(builder: (context, val, child) {
            return val.currentPage != _numPages - 1 ? Align(
              alignment: FractionalOffset.bottomCenter,
              child: TextButton(
                onPressed: () {
                  _pageController.nextPage(
                    duration: const Duration(milliseconds: 500),
                    curve: Curves.ease,
                  );
                },
                child: Container(
                  height: 60,
                  width: 60,
                  margin: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(100),
                      color: CustomColors.kBlueColor),
                  child: const Icon(
                      Icons.arrow_forward_ios_sharp,
                      color: CustomColors.kWhiteColor
                  ),
                ),
              ),
            ) : Align(
              alignment: FractionalOffset.bottomCenter,
              child: Container(
                width: 200,
                height: 50,
                margin: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: CustomColors.kBlueColor),
                child: InkWell(
                  onTap: () => {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                          builder: (BuildContext context) =>
                          const SignInScreen()),
                    )
                  },
                  child: const Center(
                    child: Text(
                      CustomString.getStarted,
                      style: TextStyle(
                        color: CustomColors.kWhiteColor,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
            );
          })
        ],
      ),
    );
  }
}
