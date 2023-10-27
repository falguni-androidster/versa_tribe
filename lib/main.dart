import 'dart:io';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:versa_tribe/Providers/bottom_tab_provider.dart';
import 'package:versa_tribe/Providers/confirm_password_provider.dart';
import 'package:versa_tribe/Providers/organization_provider.dart';
import 'package:versa_tribe/Providers/profile_gender_provider.dart';
import 'package:versa_tribe/Screens/PersonDetails/add_experience_screen.dart';

import 'Providers/call_switch_provider.dart';
import 'Providers/date_provider.dart';
import 'Providers/manage_org_index_provider.dart';
import 'Providers/onboarding_provider.dart';
import 'Providers/password_provider.dart';
import 'Providers/person_details_provider.dart';
import 'Screens/splash_screen.dart';
import 'Utils/custom_colors.dart';

void main() {
  HttpOverrides.global = MyHttpOverrides();
  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider<OnBoardingProvider>(create: (_) => OnBoardingProvider()),
      ChangeNotifierProvider<PwdProvider>(create: (_) => PwdProvider()),
      ChangeNotifierProvider<ConfirmPwdProvider>(create: (_) => ConfirmPwdProvider()),
      ChangeNotifierProvider<ProfileGenderProvider>(create: (_) => ProfileGenderProvider()),
      ChangeNotifierProvider<DobProvider>(create: (_) => DobProvider()),
      ChangeNotifierProvider<ManageBottomTabProvider>(create: (_) => ManageBottomTabProvider()),
      ChangeNotifierProvider<CallSwitchProvider>(create: (_) => CallSwitchProvider()),
      ChangeNotifierProvider<DateProvider>(create: (_) => DateProvider()),
      ChangeNotifierProvider<YOPDateProvider>(create: (_) => YOPDateProvider()),
      ChangeNotifierProvider<PersonExperienceProvider>(create: (_) => PersonExperienceProvider()),
      ChangeNotifierProvider<PersonQualificationProvider>(create: (_) => PersonQualificationProvider()),
      ChangeNotifierProvider<PersonSkillProvider>(create: (_) => PersonSkillProvider()),
      ChangeNotifierProvider<PersonHobbyProvider>(create: (_) => PersonHobbyProvider()),
      ChangeNotifierProvider<SearchCourseProvider>(create: (_) => SearchCourseProvider()),
      ChangeNotifierProvider<SearchInstituteProvider>(create: (_) => SearchInstituteProvider()),
      ChangeNotifierProvider<SearchSkillProvider>(create: (_) => SearchSkillProvider()),
      ChangeNotifierProvider<SearchHobbyProvider>(create: (_) => SearchHobbyProvider()),
      ChangeNotifierProvider<SearchExCompanyProvider>(create: (_) => SearchExCompanyProvider()),
      ChangeNotifierProvider<SearchExIndustryProvider>(create: (_) => SearchExIndustryProvider()),
      ChangeNotifierProvider<IndexProvider>(create: (_) => IndexProvider()),
      ChangeNotifierProvider<DisplayManageOrgProvider>(create: (_) => DisplayManageOrgProvider()),
      ChangeNotifierProvider<OrganizationProvider>(create: (_) => OrganizationProvider()),
      ChangeNotifierProvider<SearchOrgProvider>(create: (_) => SearchOrgProvider()),
      ChangeNotifierProvider<SearchDepartmentProvider>(create: (_) => SearchDepartmentProvider())
    ],
    child: const MyApp()
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: CustomColors.kWhiteColor,
        inputDecorationTheme: const InputDecorationTheme(border: OutlineInputBorder(),
          focusedBorder: OutlineInputBorder (
              borderSide: BorderSide (color: CustomColors.kBlackColor),
          ),
        )
      ),
      home: const SplashScreen(),
      routes: {
        '/addExScreen': (context) => const AddExperienceScreen(),
      },
    );
  }
}

class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
  }
}