import 'dart:io';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:versa_tribe/Screens/PersonDetails/add_experience_screen.dart';
import 'Providers/project_provider.dart';
import 'Screens/person_details_screen.dart';
import 'Screens/splash_screen.dart';
import 'package:versa_tribe/extension.dart';

void main() {
  HttpOverrides.global = MyHttpOverrides();
  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider<OnBoardingProvider>(create: (_) => OnBoardingProvider()),
      ChangeNotifierProvider<SignInPwdProvider>(create: (_) => SignInPwdProvider()),
      ChangeNotifierProvider<ConfirmPwdProvider>(create: (_) => ConfirmPwdProvider()),
      ChangeNotifierProvider<SignUpPwdProvider>(create: (_) => SignUpPwdProvider()),
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
      ChangeNotifierProvider<SearchDepartmentProvider>(create: (_) => SearchDepartmentProvider()),
      ChangeNotifierProvider<SearchParentDPProvider>(create: (_) => SearchParentDPProvider()),
      ChangeNotifierProvider<RadioComIndProvider>(create: (_) => RadioComIndProvider()),
      ChangeNotifierProvider<AddRadioComIndProvider>(create: (_) => AddRadioComIndProvider()),
      ChangeNotifierProvider<SwitchProvider>(create: (_) => SwitchProvider()),
      ChangeNotifierProvider<OrgProfileBtnVisibility>(create: (_) => OrgProfileBtnVisibility()),
      ChangeNotifierProvider<DepartmentProvider>(create: (_) => DepartmentProvider()),
      ChangeNotifierProvider<DisplayOrgMemberProvider>(create: (_) => DisplayOrgMemberProvider()),
      ChangeNotifierProvider<TrainingDobProvider>(create: (_) => TrainingDobProvider()),
      ChangeNotifierProvider<GiveTrainingListProvider>(create: (_) => GiveTrainingListProvider()),
      ChangeNotifierProvider<TakeTrainingListProvider>(create: (_) => TakeTrainingListProvider()),
      ChangeNotifierProvider<TrainingExperienceProvider>(create: (_) => TrainingExperienceProvider()),
      ChangeNotifierProvider<TrainingQualificationProvider>(create: (_) => TrainingQualificationProvider()),
      ChangeNotifierProvider<TrainingSkillProvider>(create: (_) => TrainingSkillProvider()),
      ChangeNotifierProvider<TrainingHobbyProvider>(create: (_) => TrainingHobbyProvider()),
      ChangeNotifierProvider<TrainingJoinedMembersProvider>(create: (_) => TrainingJoinedMembersProvider()),
      ChangeNotifierProvider<TrainingPendingRequestProvider>(create: (_) => TrainingPendingRequestProvider()),
      ChangeNotifierProvider<RequestTrainingListProvider>(create: (_) => RequestTrainingListProvider()),
      ChangeNotifierProvider<AcceptTrainingListProvider>(create: (_) => AcceptTrainingListProvider()),
      ChangeNotifierProvider<CirculerIndicationProvider>(create: (_) => CirculerIndicationProvider()),
      ChangeNotifierProvider<ProjectListProvider>(create: (_) => ProjectListProvider()),
      ChangeNotifierProvider<ProjectExperienceProvider>(create: (_) => ProjectExperienceProvider()),
      ChangeNotifierProvider<ProjectQualificationProvider>(create: (_) => ProjectQualificationProvider()),
      ChangeNotifierProvider<ProjectSkillProvider>(create: (_) => ProjectSkillProvider()),
      ChangeNotifierProvider<ProjectHobbyProvider>(create: (_) => ProjectHobbyProvider()),
      ChangeNotifierProvider<CheckInternet>(create: (_) => CheckInternet())
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
          bottomAppBarTheme: const BottomAppBarTheme(color: CustomColors.kBlackColor),
        inputDecorationTheme: const InputDecorationTheme(border: OutlineInputBorder(),
          focusedBorder: OutlineInputBorder (
              borderSide: BorderSide (color: CustomColors.kBlueColor,width: 1),
          ),
        ),
      ),
      home: const SplashScreen(),
      routes: {
        '/addExScreen': (context) => const AddExperienceScreen(),
        '/personDetailScreen': (context) => const PersonDetailsScreen()
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
