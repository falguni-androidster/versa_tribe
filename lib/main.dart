import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:versa_tribe/Screens/home_screen.dart';
import 'Screens/PersonDetails/add_experience_screen.dart';
import 'Screens/call_screen.dart';
import 'Screens/person_details_screen.dart';
import 'Screens/splash_screen.dart';
import 'package:versa_tribe/extension.dart';
import 'package:sip_ua/sip_ua.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  HttpOverrides.global = MyHttpOverrides();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown
  ]);
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
      ChangeNotifierProvider<RequestManageOrgProvider>(create: (_) => RequestManageOrgProvider()),
      ChangeNotifierProvider<OrganizationProvider>(create: (_) => OrganizationProvider()),
      ChangeNotifierProvider<SearchOrgProvider>(create: (_) => SearchOrgProvider()),
      ChangeNotifierProvider<SearchDepartmentProvider>(create: (_) => SearchDepartmentProvider()),
      ChangeNotifierProvider<SearchParentDPProvider>(create: (_) => SearchParentDPProvider()),
      ChangeNotifierProvider<RadioComIndProvider>(create: (_) => RadioComIndProvider()),
      ChangeNotifierProvider<AddRadioComIndProvider>(create: (_) => AddRadioComIndProvider()),
      ChangeNotifierProvider<SwitchProvider>(create: (_) => SwitchProvider()),
      ChangeNotifierProvider<OrgProfileBtnVisibility>(create: (_) => OrgProfileBtnVisibility()),
      ChangeNotifierProvider<DepartmentProvider>(create: (_) => DepartmentProvider()),
      ChangeNotifierProvider<RequestMemberProvider>(create: (_) => RequestMemberProvider()),
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
      ChangeNotifierProvider<ProjectListProvider>(create: (_) => ProjectListProvider()),
      ChangeNotifierProvider<ProjectExperienceProvider>(create: (_) => ProjectExperienceProvider()),
      ChangeNotifierProvider<ProjectQualificationProvider>(create: (_) => ProjectQualificationProvider()),
      ChangeNotifierProvider<ProjectSkillProvider>(create: (_) => ProjectSkillProvider()),
      ChangeNotifierProvider<ProjectHobbyProvider>(create: (_) => ProjectHobbyProvider()),
      ChangeNotifierProvider<CheckInternet>(create: (_) => CheckInternet()),
      ChangeNotifierProvider<CirculerIndicationProvider>(create: (_) => CirculerIndicationProvider()),
      ChangeNotifierProvider<ApprovedMemberProvider>(create: (_) => ApprovedMemberProvider()),
      ChangeNotifierProvider<ApprovedManageOrgProvider>(create: (_) => ApprovedManageOrgProvider()),
      ChangeNotifierProvider<ProjectListByOrgIdProvider>(create: (_) => ProjectListByOrgIdProvider()),
      ChangeNotifierProvider<ProjectListManageUserProvider>(create: (_) => ProjectListManageUserProvider()),
      ChangeNotifierProvider<ProjectRequestProvider>(create: (_) => ProjectRequestProvider()),
      ChangeNotifierProvider<ProjectAcceptedProvider>(create: (_) => ProjectAcceptedProvider()),

    ],
    child: MyApp()
  ));
}

typedef PageContentBuilder = Widget Function(
    [SIPUAHelper? helper, Object? arguments]);

class MyApp extends StatelessWidget {

  final SIPUAHelper _helper = SIPUAHelper();

  MyApp({super.key});

  Route<dynamic>? _onGenerateRoute(RouteSettings settings) {
    final String? name = settings.name;

    switch (name) {
      case '/home':
        return MaterialPageRoute<Widget>(
          builder: (context) => HomeScreen(
            helper: _helper,
            settings.arguments as bool?,
          ),
        );
      case '/callscreen':
        return MaterialPageRoute<Widget>(
          builder: (context) => CallScreenWidget(
            _helper,
            settings.arguments as Call?,
          ),
        );
      case '/addExScreen':
        return MaterialPageRoute<Widget>(
          builder: (context) => const AddExperienceScreen(),
        );
      case '/personDetailScreen':
        return MaterialPageRoute<Widget>(
          builder: (context) => const PersonDetailsScreen(),
        );
      default:
      // Handle unknown routes or use a default route
        return MaterialPageRoute<Widget>(
          builder: (context) => const SplashScreen(),
        );
    }
  }

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
      initialRoute: '/',
      onGenerateRoute: _onGenerateRoute,
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
