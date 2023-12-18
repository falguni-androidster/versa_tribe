import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:versa_tribe/Screens/sign_in_screen.dart';
import 'package:versa_tribe/extension.dart';

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
    final size = MediaQuery.of(context).size;
    return AnimatedContainer(
      duration: const Duration(milliseconds: 150),
      margin: EdgeInsets.symmetric(horizontal: size.width*0.01),
      height: size.height*0.015,
      width: isActive ? size.width*0.1 : size.width*0.03,
      decoration: BoxDecoration(
        color: isActive ? CustomColors.kBlueColor : CustomColors.kBlackColor,
        borderRadius: const BorderRadius.all(Radius.circular(12)),
      ),
    );
  }

  Widget _onBoardingPages({required img, required onBoardingTitle, required onBoardingDis}) {
    final size = MediaQuery.of(context).size;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        SizedBox(height: size.height*0.08,),
        Image(
          image: AssetImage(img),
          height: size.height*0.45,
        ),
        const Spacer(),
        Text(onBoardingTitle, style: const TextStyle(color: CustomColors.kBlackColor, fontFamily: 'Poppins', fontSize: 30)),
        SizedBox(height: size.height*0.02),
        SizedBox(
          height: size.height*0.3,
          child: Text(onBoardingDis,
              style: const TextStyle(color: CustomColors.kBlackColor, fontSize: 20,
                fontFamily: 'Poppins'), textAlign: TextAlign.center),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
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
            margin: EdgeInsets.only(bottom: size.height*0.15),
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
                        onBoardingDis: CustomString.onBoardingScreenDescription),
                    _onBoardingPages(
                        img: ImagePath.onBoardingPath,
                        onBoardingTitle: CustomString.onBoardingScreenTitle,
                        onBoardingDis: CustomString.onBoardingScreenDescription),
                    _onBoardingPages(
                        img: ImagePath.onBoardingPath,
                        onBoardingTitle: CustomString.onBoardingScreenTitle,
                        onBoardingDis: CustomString.onBoardingScreenDescription),
                    _onBoardingPages(
                        img: ImagePath.onBoardingPath,
                        onBoardingTitle: CustomString.onBoardingScreenTitle,
                        onBoardingDis: CustomString.onBoardingScreenDescription),
                  ],
                );
              }),

          /// Button
          Consumer<OnBoardingProvider>(builder: (context, val, child) {
            final size = MediaQuery.of(context).size;
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
                  height: size.height*0.08,
                  width: defaultTargetPlatform==TargetPlatform.iOS?size.width*0.17: size.width*0.16,
                  margin: EdgeInsets.all(size.height*0.02+size.width*0.02/2),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(100),
                      color: CustomColors.kBlueColor),
                  child: const Icon(
                      Icons.arrow_forward_ios_sharp,
                      color: CustomColors.kWhiteColor
                  ),
                ),
              ),
            ) :
            Align(
              alignment: FractionalOffset.bottomCenter,
              child: Container(
                width: size.width*0.4,
                height: defaultTargetPlatform==TargetPlatform.iOS?size.height*0.05: size.height*0.06,
                margin: EdgeInsets.all(size.height*0.02+size.width*0.02/2),
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
                        fontFamily: 'Poppins',
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
