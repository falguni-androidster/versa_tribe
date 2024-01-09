import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

import '../Screens/OrgAdmin/update_admin_profile.dart';
import '../Screens/Profile/create_profile_screen.dart';
import '../Screens/Training/TakeTraining/take_training_item_screen.dart';
import '../Screens/home_screen.dart';
import '../Screens/person_details_screen.dart';
import '../Screens/sign_in_screen.dart';
import '../extension.dart';
import '../Screens/Profile/profile_exist_screen.dart';

class ApiConfig {

  // static const String baseUrl = 'https://srv1.ksgs.local:9443';
  static const String baseUrl = 'https://api.gigpro.in';


  /*------------------------------------------- Authentication Application -------------------------*/

  //google authentication
  static externalAuthentication({context, authToken, provider}) async {
    try {
      Map<String, String> bodyParameters = {
        'Token': authToken,
        "Provider": provider,
        "grant_type":"password"
      };
      String externalLoginUrl = '$baseUrl/token';
      final response = await http.post(Uri.parse(externalLoginUrl),
          headers: {'Content-Type': 'application/x-www-form-urlencoded'}, body: bodyParameters);
      if (response.statusCode == 200) {
        Map<String, dynamic> jsonData = await jsonDecode(response.body); // Return Single Object
         LoginResponseModel loginResponseModel = LoginResponseModel.fromJson(jsonData);
        if (loginResponseModel.accessToken != null) {
          final SharedPreferences pref = await SharedPreferences.getInstance();
          pref.setSharedPrefStringValue(key: CustomString.accessToken, loginResponseModel.accessToken.toString());
          pref.setSharedPrefBoolValue(key: CustomString.isLoggedIn, true);
          showToast(context, CustomString.accountLoginSuccess);

          await pref.setString("ProfileStatus", loginResponseModel.profileExist!);
          debugPrint("--------------cheque profile status------>${loginResponseModel.profileExist}");

          if (loginResponseModel.profileExist != "True") {
            Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => const CreateProfileScreen()));
          } else {
            Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => const ProfileExistScreen()));
          }
        } else {
          showToast(context, CustomString.checkYourEmail);
        }

        debugPrint("<---Authenticated Successfully-->");
      } else {
        debugPrint("<---Authentication denied-->${response.body}");
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Authentication denied..")));
      }
    }
    catch (e) {
      debugPrint("External login setup error: ${e.toString()}");
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Authentication denied..")));
    }
  }

  Future<void> signInClick({context, emailController, passwordController}) async {

    final provider = Provider.of<CheckInternet>(context,listen:false);

    LoginResponseModel loginResponseModel;
    if (provider.status == "Connected") {
      Map signInParameter = {
        "username": emailController.text.toString(),
        "password": passwordController.text.toString(),
        "grant_type": "password"
      };
      String loginUrl = '$baseUrl/token';
      var response = await http.post(Uri.parse(loginUrl), body: signInParameter);
      Map<String, dynamic> jsonData = jsonDecode(response.body); // Return Single Object
      loginResponseModel = LoginResponseModel.fromJson(jsonData);
      if (response.body.isNotEmpty) {
        debugPrint("------->${loginResponseModel.accessToken}");
        if (loginResponseModel.accessToken != null) {
          final SharedPreferences pref = await SharedPreferences.getInstance();
          pref.setSharedPrefStringValue(key: CustomString.accessToken, loginResponseModel.accessToken.toString());
          pref.setSharedPrefBoolValue(key: CustomString.isLoggedIn, true);
          showToast(context, CustomString.accountLoginSuccess);
          if (loginResponseModel.profileExist != "True") {
            Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => const CreateProfileScreen()));
          } else {
            Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => const ProfileExistScreen()));
          }
        } else {
          showToast(context, CustomString.checkYourEmail);
        }
      } else {
        const CircularProgressIndicator();
        showToast(context, CustomString.loginFailed);
      }
    }
    else{
      showToast(context, CustomString.checkNetworkConnection);
    }
  }

  Future<void> signUpClick({context, emailController, passwordController, confirmPasswordController}) async {

    if (passwordController.text.toString() != confirmPasswordController.text.toString()) {
      showToast(context, CustomString.passwordAndConfirmPasswordNotMatch);
    }
    Map data = {
      'Email': emailController.text.toString(),
      'Password': passwordController.text.toString(),
      'ConfirmPassword': confirmPasswordController.text.toString()
    };

    String signupUrl = '$baseUrl/api/Account/Register';
    var response = await http.post(Uri.parse(signupUrl), body: data);
    const CircularProgressIndicator();
    if (response.statusCode == 200) {
      showToast(context, CustomString.accountSuccessCreated);
      Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => const SignInScreen()));
    } else if (response.statusCode == 400){
      showToast(context, CustomString.accountAlreadyTaken);
    } else {
      showToast(context, CustomString.somethingWrongMessage);
    }
  }

  Future<void> forgotPasswordClick({context, emailController}) async {

    Map data = {
      'Email': emailController.text.toString(),
    };

    const String forgotUrl =
        '$baseUrl/api/Account/ForgotPassword';
    final response = await http.post(Uri.parse(forgotUrl), body: data);
    if (response.statusCode == 200) {
      showToast(context, CustomString.forgotPwdMessage);
      Navigator.of(context).pop();
    } else if (response.statusCode == 400) {
      showToast(context, response.body);
    } else {
      showToast(context, CustomString.wrongEmail);
    }
  }

  Future<void> logoutClick(context) async {

    final provider = Provider.of<ManageBottomTabProvider>(context, listen: false);
    SharedPreferences prefs = await SharedPreferences.getInstance();

    String logOutUrl = '$baseUrl/api/Account/Logout';
    final response = await http.post(Uri.parse(logOutUrl));
    if (response.statusCode == 200) {
      provider.manageBottomTab(0);
      prefs.clearSharedPreferencesKey(key: CustomString.organizationName);
      prefs.clearSharedPreferencesKey(key: CustomString.accessToken);
      prefs.clearSharedPreferencesKey(key: CustomString.personId);
      prefs.clearSharedPreferencesKey(key: CustomString.organizationAdmin);
      prefs.clearSharedPreferencesKey(key: CustomString.isLoggedIn);
      prefs.clearSharedPreferencesKey(key: CustomString.organizationId);
      showToast(context, CustomString.logOutSuccess);
      Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => const SignInScreen()));
    } else {
      showToast(context, CustomString.somethingWrongMessage);
    }
  }

  /*------------------------------------------ Profile Screen ---------------------------------------*/
  Future<ProfileResponse> getProfileData() async {

    SharedPreferences pref = await SharedPreferences.getInstance();
    String? token = pref.getSharedPrefStringValue(key: CustomString.accessToken);

    String profileUrl = '$baseUrl/api/Person/MyProfile';
    final response = await http.get(Uri.parse(profileUrl), headers: {
      'Authorization': 'Bearer $token',
    });

    if (response.statusCode == 200) {
      debugPrint('OrgPerson Profile data-----------> ${response.body}');
      Map<String, dynamic> jsonMap = json.decode(response.body);
      ProfileResponse yourModel = ProfileResponse.fromJson(jsonMap);
      pref.setSharedPrefStringValue(key: CustomString.personId, yourModel.personId.toString());
      return yourModel;
    } else {
      throw Exception('Failed to load data');
    }
  }

  Future<void> createProfile({context, popUp, fNameController, lNameController, genderController, cityController, countryController, dobController}) async {

    SharedPreferences pref = await SharedPreferences.getInstance();
    String? token = pref.getString(CustomString.accessToken);

    Map data = {
      'FirstName': fNameController.text.toString(),
      'LastName': lNameController.text.toString(),
      'Gender': genderController.text.toString(),
      'City': cityController.text.toString(),
      'Country': countryController.text.toString(),
      'DOB': dobController.text.toString()
    };

    const String profileUrl = '$baseUrl/api/Person/Create';
    final response = await http.post(Uri.parse(profileUrl), body: jsonEncode(data), headers: {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    });
    if (response.statusCode == 200) {
      showToast(context, CustomString.profileSuccessCreated);
      Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => HomeScreen(popUp: popUp)));
    } else {
      showToast(context, CustomString.somethingWrongMessage);
    }
  }

  Future<void> updateProfile({context, fNameController, lNameController, genderController, cityController, countryController, dobController}) async {

    SharedPreferences pref = await SharedPreferences.getInstance();
    String? token = pref.getSharedPrefStringValue(key: CustomString.accessToken);

    Map data = {
      'FirstName': fNameController.text.toString(),
      'LastName': lNameController.text.toString(),
      'Gender': genderController.text.toString(),
      'City': cityController.text.toString(),
      'Country': countryController.text.toString(),
      'DOB': dobController.text.toString()
    };

    const String profileUrl = '$baseUrl/api/Person/Update';
    final response = await http.put(Uri.parse(profileUrl), body: data, headers: {
      'Authorization': 'Bearer $token',
    });
    const CircularProgressIndicator();
    if (response.statusCode == 200) {
      showToast(context, CustomString.profileSuccessUpdated);
      Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => const PersonDetailsScreen()));
    } else {
      showToast(context, CustomString.somethingWrongMessage);
    }
  }

  /*------------------------------------------ Training Screen  ---------------------------------------------*/

  Future<void> createTrainingClick({context, orgId, trainingNameController, trainingDescriptionController, startDateController, endDateController, personLimitController}) async {

    SharedPreferences pref = await SharedPreferences.getInstance();
    String? token = pref.getSharedPrefStringValue(key: CustomString.accessToken);

    Map<String, dynamic> data = {
      'Org_Id': orgId,
      'Training_Name': trainingNameController.text.toString(),
      'Description': trainingDescriptionController.text.toString(),
      'Start_Date': startDateController.text.toString(),
      'End_Date': endDateController.text.toString(),
      'PersonLimit': personLimitController.text.toString(),
    };
    String trainingUrl = '$baseUrl/api/Training/Create';
    final response = await http.post(Uri.parse(trainingUrl), body: jsonEncode(data), headers: {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    });
    if (response.statusCode == 200) {
      debugPrint(response.body);
      ApiConfig.getGiveTrainingData(context);
      showToast(context, CustomString.trainingCreatedSuccess);
      Navigator.pop(context);
    } else {
      debugPrint(response.body);
      showToast(context, CustomString.somethingWrongMessage);
    }
  }

  static getGiveTrainingData(context) async {

    final provider = Provider.of<GiveTrainingListProvider>(context, listen: false);
    provider.getGiveTrainingList.clear();

    SharedPreferences pref = await SharedPreferences.getInstance();
    String? token = pref.getSharedPrefStringValue(key: CustomString.accessToken);

    try {
      String trainingUrl = '$baseUrl/api/Training/User/GetList';
      final response = await http.get(Uri.parse(trainingUrl), headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      });
      if (response.statusCode == 200) {
        debugPrint('Give Training data-----------> ${response.body}');
        List<dynamic> data = jsonDecode(response.body);
        provider.getGiveTrainingList.clear();
        provider.setGiveListTraining(data);
      } else {
        showToast(context, CustomString.noDataFound);
        debugPrint("Give Training Data not found...");
      }
    } catch (e) {
      debugPrint("Training------>$e");
    }
  }

  static getTakeTrainingData({context, orgId}) async {

    final provider = Provider.of<TakeTrainingListProvider>(context, listen: false);
    provider.getTakeTrainingList.clear();

    SharedPreferences pref = await SharedPreferences.getInstance();
    String? token = pref.getSharedPrefStringValue(key: CustomString.accessToken);

    try {
      String trainingUrl = '$baseUrl/api/Training/Org/GetList?org_Id=$orgId';
      final response = await http.get(Uri.parse(trainingUrl), headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      });
      if (response.statusCode == 200) {
        debugPrint('Take Training data-----------> ${response.body}');
        List<dynamic> data = jsonDecode(response.body);
        provider.setTakeListTraining(data);
      } else {
        showToast(context, CustomString.noDataFound);
        debugPrint("Take Training Data not found...");
      }
    } catch (e) {
      debugPrint("Training------>$e");
    }
  }

  static getRequestedTraining({context, isJoin}) async {

    final provider = Provider.of<RequestTrainingListProvider>(context, listen: false);
    provider.getRequestedTrainingList.clear();

    SharedPreferences pref = await SharedPreferences.getInstance();
    String? token = pref.getSharedPrefStringValue(key: CustomString.accessToken);

    try {
      String trainingUrl = '$baseUrl/api/Training_Join/User/Trainings?is_Join=$isJoin';
      final response = await http.get(Uri.parse(trainingUrl), headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      });
      if (response.statusCode == 200) {
        debugPrint('Requested Training data-----------> ${response.body}');
        List<dynamic> data = jsonDecode(response.body);
        provider.getRequestedTrainingList.clear();
        provider.setRequestedTrainingList(data);
      } else {
        showToast(context, CustomString.noDataFound);
        debugPrint("Requested Training Data not found...");
      }
    } catch (e) {
      debugPrint("Training------>$e");
    }
  }

  static getAcceptedTraining({context, isJoin}) async {

    final provider = Provider.of<AcceptTrainingListProvider>(context, listen: false);
    provider.getAcceptedTrainingList.clear();

    SharedPreferences pref = await SharedPreferences.getInstance();
    String? token = pref.getSharedPrefStringValue(key: CustomString.accessToken);

    try {
      String trainingUrl = '$baseUrl/api/Training_Join/User/Trainings?is_Join=$isJoin';
      final response = await http.get(Uri.parse(trainingUrl), headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      });
      if (response.statusCode == 200) {
        debugPrint('Accepted Training data-----------> ${response.body}');
        List<dynamic> data = jsonDecode(response.body);
        provider.getAcceptedTrainingList.clear();
        provider.setAcceptedTrainingList(data);
      } else {
        showToast(context, CustomString.noDataFound);
        debugPrint("Accepted Training Data not found...");
      }
    } catch (e) {
      debugPrint("Training------>$e");
    }
  }

  joinTraining({context, trainingId, isJoin, trainingResponse}) async {

    SharedPreferences pref = await SharedPreferences.getInstance();
    String? token = pref.getSharedPrefStringValue(key: CustomString.accessToken);
    String? personId = pref.getSharedPrefStringValue(key: CustomString.personId);

    Map<String, dynamic> requestData = {
      "Training_Id": trainingId,
      "Person_Id": personId,
      "Is_Join": isJoin,
    };
    String url = "$baseUrl/api/Training_Join/Create";
    final response = await http.post(Uri.parse(url),body: jsonEncode(requestData) , headers: {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    });
    debugPrint('Training Joined----------------->>>> ${response.body}');
    if (response.statusCode == 200) {
      showToast(context, CustomString.trainingJoined);
      Navigator.pop(context); // Pop the current screen
      Navigator.push(context, MaterialPageRoute(builder: (context) => TakeTrainingItemScreen(trainingResponse: trainingResponse)));// Push the screen again
    } else {
      showToast(context, 'Try Again.....');
    }
  }

  static deleteTraining(context, int? trainingId) async {

    String url = '$baseUrl/api/Training/Delete?id=$trainingId';
    SharedPreferences pref = await SharedPreferences.getInstance();
    String? token = pref.getSharedPrefStringValue(key: CustomString.accessToken);

    final response = await http.delete(Uri.parse(url), headers: {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    });
    if (response.statusCode == 200) {
      debugPrint("Delete training--------->${response.body}");
      getGiveTrainingData(context);
      Navigator.pop(context);
    } else {
      debugPrint("Not Delete training--------->${response.body}");
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text("Try again Data not delete..."),
      ));
    }
    return response.body;
  }

  static getTrainingExperience(context, int? trainingId) async {

    final provider = Provider.of<TrainingExperienceProvider>(context, listen: false);
    provider.trainingEx.clear();

    SharedPreferences pref = await SharedPreferences.getInstance();
    String? token = pref.getSharedPrefStringValue(key: CustomString.accessToken);

    try {
      String url =
          '$baseUrl/api/Training_Criteria/GetExpCriteria?trainingId=$trainingId';
      final response = await http.get(Uri.parse(url), headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      });
      if (response.statusCode == 200) {
        debugPrint("Experience Training Data----->${response.body}");
        List<dynamic> data = jsonDecode(response.body);
        provider.trainingEx.clear();
        provider.setTrainingEx(data);
      } else {
        debugPrint("Experience Training Data not found...");
      }
    } catch (e) {
      debugPrint("experience------>$e");
    }
  }

  static getTrainingQualification(context, int? trainingId) async {

    final provider = Provider.of<TrainingQualificationProvider>(context, listen: false);
    provider.trainingQua.clear();

    SharedPreferences pref = await SharedPreferences.getInstance();
    String? token = pref.getSharedPrefStringValue(key: CustomString.accessToken);

    try {
      String url =
          '$baseUrl/api/Training_Criteria/GetQualifications?trainingId=$trainingId';
      final response = await http.get(Uri.parse(url), headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      });
      if (response.statusCode == 200) {
        debugPrint("Qualification Training Data----->${response.body}");
        List<dynamic> data = jsonDecode(response.body);
        provider.trainingQua.clear();
        provider.setTrainingQua(data);
      } else {
        debugPrint("Qualification Training Data not found...");
      }
    } catch (e) {
      debugPrint("qualification------>$e");
    }
  }

  static getTrainingSkill(context, int? trainingId) async {

    final provider = Provider.of<TrainingSkillProvider>(context, listen: false);
    provider.trainingSkill.clear();

    SharedPreferences pref = await SharedPreferences.getInstance();
    String? token = pref.getSharedPrefStringValue(key: CustomString.accessToken);

    try {
      String url =
          '$baseUrl/api/Training_Criteria/GetSkillsByTrainingId?trainingId=$trainingId';
      final response = await http.get(Uri.parse(url), headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      });
      if (response.statusCode == 200) {
        debugPrint("Skill Training Data----->${response.body}");
        List<dynamic> data = jsonDecode(response.body);
        provider.trainingSkill.clear();
        provider.setTrainingSkill(data);
      } else {
        debugPrint("Skill Training Data not found...");
      }
    } catch (e) {
      debugPrint("Skill------>$e");
    }
  }

  static getTrainingHobby(context, int? trainingId) async {

    final provider = Provider.of<TrainingHobbyProvider>(context, listen: false);
    provider.trainingHobby.clear();

    SharedPreferences pref = await SharedPreferences.getInstance();
    String? token = pref.getSharedPrefStringValue(key: CustomString.accessToken);

    try {
      String url =
          '$baseUrl/api/Training_Criteria/Hobby/GetByTrainingId?trainingId=$trainingId';
      final response = await http.get(Uri.parse(url), headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      });
      if (response.statusCode == 200) {
        debugPrint("Hobby Training Data----->${response.body}");
        List<dynamic> data = jsonDecode(response.body);
        provider.trainingHobby.clear();
        provider.setTrainingHobby(data);
      } else {
        debugPrint("Hobby Training Data not found...");
      }
    } catch (e) {
      debugPrint("hobby------>$e");
    }
  }

  static getTrainingJoinedMembers(context, trainingId, isJoin) async {

    final provider = Provider.of<TrainingJoinedMembersProvider>(context, listen: false);
    provider.trainingJoinedMembers.clear();

    SharedPreferences pref = await SharedPreferences.getInstance();
    String? token = pref.getSharedPrefStringValue(key: CustomString.accessToken);
    try {
      String url =
          '$baseUrl/api/Training_Join/Training/Persons?training_Id=$trainingId&is_Join=$isJoin';
      final response = await http.get(Uri.parse(url), headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      });
      if (response.statusCode == 200) {
        debugPrint("Get Training Joined Member Data----->${response.body}");
        List<dynamic> data = await jsonDecode(response.body);
        provider.trainingJoinedMembers.clear();
        provider.setTrainingJoinedMembers(data);
      } else {
        debugPrint("Get Training Joined Member Data not found...");
      }
    } catch (e) {
      debugPrint("Joined Members------>$e");
    }
  }

  static getTrainingPendingRequests(context, trainingId, isJoin) async {

    final provider = Provider.of<TrainingPendingRequestProvider>(context, listen: false);
    provider.trainingPendingRequests.clear();

    SharedPreferences pref = await SharedPreferences.getInstance();
    String? token = pref.getSharedPrefStringValue(key: CustomString.accessToken);
    try {
      String url =
          '$baseUrl/api/Training_Join/Training/Persons?training_Id=$trainingId&is_Join=$isJoin';
      final response = await http.get(Uri.parse(url), headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      });
      if (response.statusCode == 200) {
        debugPrint("Get Training Pending Requests Data----->${response.body}");
        List<dynamic> data = await jsonDecode(response.body);
        provider.setTrainingPendingRequests(data);
      } else {
        debugPrint('Get Training Pending Requests Data Not Found...');
      }
    } catch (e) {
      debugPrint("Pending Requests------>$e");
    }
  }

  /// Cancel Request Training
  static deleteRequestTraining({context, trainingId, screen}) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    String? token = pref.getSharedPrefStringValue(key: CustomString.accessToken);
    String? personId = pref.getSharedPrefStringValue(key: CustomString.personId);

    String apiUrl = '$baseUrl/api/Training_Join/Delete?training_Id=$trainingId&person_Id=$personId';
    final response = await http.delete(Uri.parse(apiUrl), headers: {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    });
    if (response.statusCode == 200) {
      debugPrint("Delete Request----->${response.body}");
      showToast(context, CustomString.delete);
      getAcceptedTraining(context: context, isJoin: true);
      getRequestedTraining(context: context, isJoin: false);
    } else {
      debugPrint("Not Delete Request----->${response.body}");
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text("Try again not delete request..."),
      ));
    }
  }

  /// Approve Request Training
  static approveRequestTraining({context, trainingId, isJoin}) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    String? token = pref.getSharedPrefStringValue(key: CustomString.accessToken);
    String? personId = pref.getSharedPrefStringValue(key: CustomString.personId);

    Map<String, dynamic> requestData = {
      "Training_Id": trainingId,
      "Person_Id": personId,
      "Is_Join": isJoin,
    };
    String url = '$baseUrl/api/Training_Join/Update';
    final response =
        await http.put(Uri.parse(url), body: jsonEncode(requestData), headers: {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    });
    if (response.statusCode == 200) {
      debugPrint("Approve Request----->${response.body}");
      showToast(context, CustomString.approved);
      getTrainingPendingRequests(context, trainingId, false);
    } else {
      debugPrint("Not Approve Request----->${response.body}");
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text("Try again not approved..."),
      ));
    }
  }

  /*------------------------------------------   Project Screen   ---------------------------------------------*/

  static getProjectData(context) async {

    final provider = Provider.of<ProjectListProvider>(context, listen: false);
    provider.getProjectList.clear();

    SharedPreferences pref = await SharedPreferences.getInstance();
    String? token = pref.getSharedPrefStringValue(key: CustomString.accessToken);

    try {
      String trainingUrl = '$baseUrl/api/Projects/List';
      final response = await http.get(Uri.parse(trainingUrl), headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      });
      if (response.statusCode == 200) {
        debugPrint('Project data-------------${response.body}');
        List<dynamic> data = jsonDecode(response.body);
        provider.getProjectList.clear();
        provider.setListProject(data);
      } else {
        showToast(context, CustomString.noDataFound);
        debugPrint("Project Data Not Found");
      }
    } catch (e) {
      debugPrint("Project ------>$e");
    }
  }

  static getProjectDataByOrgID(context, int? orgId) async {
    final provider = Provider.of<ProjectListByOrgIdProvider>(context, listen: false);
    provider.getProjectListByOrgId.clear();

    SharedPreferences pref = await SharedPreferences.getInstance();
    String? token = pref.getSharedPrefStringValue(key: CustomString.accessToken);

    try {
      String trainingUrl = '$baseUrl/api/Projects/OrgProjectsList?OrgId=$orgId';
      final response = await http.get(Uri.parse(trainingUrl), headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      });
      debugPrint('data -----------> ${response.body}');
      if (response.statusCode == 200) {
        debugPrint('Project Data By orgID-----------> ${response.body}');
        List<dynamic> data = jsonDecode(response.body);
        provider.getProjectListByOrgId.clear();
        provider.setListProjectByOrgId(data);
      } else {
        showToast(context, CustomString.noDataFound);
        debugPrint("Project Data By OrgID Not Found...");
      }
    } catch (e) {
      debugPrint("Project ------>$e");
    }
  }

  static getProjectManageUserData(context, int? projectId) async {

    final provider = Provider.of<ProjectListManageUserProvider>(context, listen: false);
    provider.getProjectListManageUser.clear();

    SharedPreferences pref = await SharedPreferences.getInstance();
    String? token = pref.getSharedPrefStringValue(key: CustomString.accessToken);

    try {
      String trainingUrl =
          '$baseUrl/api/ProjectUsers/GetUsersByProject?Project_Id=$projectId';
      final response = await http.get(Uri.parse(trainingUrl), headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      });
      debugPrint('data -----------> ${response.body}');
      if (response.statusCode == 200) {
        debugPrint('Project Manage User Data -----------> ${response.body}');
        List<dynamic> data = jsonDecode(response.body);
        provider.getProjectListManageUser.clear();
        provider.setListProjectManageUser(data);
      } else {
        showToast(context, CustomString.noDataFound);
        debugPrint("Project Manage User Data not found...");
      }
    } catch (e) {
      debugPrint("Project ------>$e");
    }
  }

  static getRequestedProject({context, isApproved}) async {
    final provider = Provider.of<ProjectRequestProvider>(context, listen: false);
    provider.projectRequest.clear();

    SharedPreferences pref = await SharedPreferences.getInstance();
    String? token = pref.getSharedPrefStringValue(key: CustomString.accessToken);

    try {
      String trainingUrl = '$baseUrl/api/ProjectUsers/User/Projects?isApproved=$isApproved';
      final response = await http.get(Uri.parse(trainingUrl), headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      });
      if (response.statusCode == 200) {
        debugPrint('Requested Project data-----------> ${response.body}');
        List<dynamic> data = jsonDecode(response.body);
        provider.projectRequest.clear();
        provider.setProjectRequest(data);
      } else {
        showToast(context, CustomString.noDataFound);
        debugPrint("Requested Project Data not found...");
      }
    }
    catch (e)
    {
      debugPrint("requested project------>$e");
    }
  }

  static getAcceptedProject({context, isApproved}) async {
    final provider = Provider.of<ProjectAcceptedProvider>(context, listen: false);
    provider.projectAccepted.clear();

    SharedPreferences pref = await SharedPreferences.getInstance();
    String? token = pref.getSharedPrefStringValue(key: CustomString.accessToken);

    try {
      String trainingUrl = '$baseUrl/api/ProjectUsers/User/Projects?isApproved=$isApproved';
      final response = await http.get(Uri.parse(trainingUrl), headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      });
      if (response.statusCode == 200) {
        debugPrint('Approved Project data-----------> ${response.body}');
        List<dynamic> data = jsonDecode(response.body);
        provider.projectAccepted.clear();
        provider.setProjectAccepted(data);
      } else {
        showToast(context, CustomString.noDataFound);
        debugPrint("Approved Project Data not found...");
      }
    } catch (e) {
      debugPrint("approved project------>$e");
    }
  }

  static getProjectExperience(context, int? projectId) async {

    final provider = Provider.of<ProjectExperienceProvider>(context, listen: false);
    provider.projectEx.clear();

    SharedPreferences pref = await SharedPreferences.getInstance();
    String? token = pref.getSharedPrefStringValue(key: CustomString.accessToken);

    try {
      String url =
          '$baseUrl/api/Project_Criteria/Get_Proj_ExpCriteria?projectId=$projectId';
      final response = await http.get(Uri.parse(url), headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      });
      if (response.statusCode == 200) {
        debugPrint("Experience Project Data ----->${response.body}");
        List<dynamic> data = jsonDecode(response.body);
        provider.projectEx.clear();
        provider.setProjectEx(data);
      } else {
        debugPrint("Experience Project Data Not Found...");
      }
    } catch (e) {
      debugPrint("experience------>$e");
    }
  }

  static getProjectQualification(context, int? projectId) async {

    final provider = Provider.of<ProjectQualificationProvider>(context, listen: false);
    provider.projectQua.clear();

    SharedPreferences pref = await SharedPreferences.getInstance();
    String? token = pref.getSharedPrefStringValue(key: CustomString.accessToken);

    try {
      String url = '$baseUrl/api/Project_Criteria/GetQualifications?projectId=$projectId';
      final response = await http.get(Uri.parse(url), headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      });
      if (response.statusCode == 200) {
        debugPrint("Qualification Project Data ------->${response.body}");
        List<dynamic> data = jsonDecode(response.body);
        provider.projectQua.clear();
        provider.setProjectQua(data);
      } else {
        debugPrint("Qualification Project Data Not Found...");
      }
    } catch (e) {
      debugPrint("qualification------>$e");
    }
  }

  static getProjectSkill(context, int? projectId) async {

    final provider = Provider.of<ProjectSkillProvider>(context, listen: false);
    provider.projectSkill.clear();

    SharedPreferences pref = await SharedPreferences.getInstance();
    String? token = pref.getSharedPrefStringValue(key: CustomString.accessToken);

    try {
      String url = '$baseUrl/api/Project_Criteria/GetSkillsByProjectId?ProjectId=$projectId';
      final response = await http.get(Uri.parse(url), headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      });
      if (response.statusCode == 200) {
        debugPrint("Skill Project Data ----->${response.body}");
        List<dynamic> data = jsonDecode(response.body);
        provider.projectSkill.clear();
        provider.setProjectSkill(data);
      } else {
        debugPrint("Skill Project Data Not Found...");
      }
    } catch (e) {
      debugPrint("skill------>$e");
    }
  }

  static getProjectHobby(context, int? projectId) async {

    final provider = Provider.of<ProjectHobbyProvider>(context, listen: false);
    provider.projectHobby.clear();

    SharedPreferences pref = await SharedPreferences.getInstance();
    String? token = pref.getSharedPrefStringValue(key: CustomString.accessToken);

    try {
      String url = '$baseUrl/api/Project_Criteria/Hobby/GetByProjectId?ProjectId=$projectId';
      final response = await http.get(Uri.parse(url), headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      });
      if (response.statusCode == 200) {
        debugPrint("Hobby Project Data----->${response.body}");
        List<dynamic> data = jsonDecode(response.body);
        provider.projectHobby.clear();
        provider.setProjectHobby(data);
      } else {
        debugPrint("Hobby Project Data not found...");
      }
    } catch (e) {
      debugPrint("hobby------>$e");
    }
  }

  static rejectProjectManageUser(context, int? id, int? projectId) async {

    SharedPreferences pref = await SharedPreferences.getInstance();
    String? token = pref.getSharedPrefStringValue(key: CustomString.accessToken);

    String url = '$baseUrl/api/ProjectUsers/Delete?id=$id&project_Id=$projectId';
    final response = await http.delete(Uri.parse(url), headers: {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    });
    if (response.statusCode == 200) {
      debugPrint("Reject Project Manage User--------->${response.body}");
      showToast(context, 'Rejected SuccessFully..');
      getProjectManageUserData(context, projectId);
    } else {
      debugPrint("Not Reject Project Manage User--------->${response.body}");
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text("Try again Data not reject..."),
      ));
    }
    return response.body;
  }

  static approveProjectManageUser(context, int? id, int? projectId) async {

    SharedPreferences pref = await SharedPreferences.getInstance();
    String? token = pref.getSharedPrefStringValue(key: CustomString.accessToken);
    String? personId = pref.getSharedPrefStringValue(key: CustomString.personId);

    Map<String, dynamic> requestData = {
      "Id": id,
      "Person_Id": personId,
      "Project_Id": projectId,
      "IsApproved": true
    };
    String url = '$baseUrl/api/ProjectUsers/Update';
    final response = await http.put(Uri.parse(url), body: jsonEncode(requestData), headers: {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    });
    if (response.statusCode == 200) {
      debugPrint("Approve Project Manage User--------->${response.body}");
      showToast(context, 'Accepted Successfully..');
      getProjectManageUserData(context, projectId);
    } else {
      debugPrint("Not Approve Project Manage User--------->${response.body}");
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text("Try again Data not accept..."),
      ));
    }
  }

  /*---------------------------------------  Profile Details Screen  -------------------------------------------*/

  static getPersonExperience(context) async {

    final provider = Provider.of<PersonExperienceProvider>(context, listen: false);
    provider.personEx.clear();

    SharedPreferences pref = await SharedPreferences.getInstance();
    String? token = pref.getSharedPrefStringValue(key: CustomString.accessToken);
    String? personId = pref.getSharedPrefStringValue(key: CustomString.personId);

    try {
      String url = '$baseUrl/api/PersonExperiences/MyList?id=$personId';
      final response = await http.get(Uri.parse(url), headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      });
      if (response.statusCode == 200) {
        debugPrint("Experience Profile Data----->${response.body}");
        List<dynamic> data = jsonDecode(response.body);
        provider.personEx.clear();
        provider.setPersonEx(data);
      } else {
        debugPrint("Experience Profile Data not found...");
      }
    } catch (e) {
      debugPrint("experience------>$e");
    }
  }

  static getPersonQualification(context) async {

    final provider = Provider.of<PersonQualificationProvider>(context, listen: false);
    provider.personQl.clear();

    SharedPreferences pref = await SharedPreferences.getInstance();
    String? token = pref.getSharedPrefStringValue(key: CustomString.accessToken);

    String url = '$baseUrl/api/GetUserPerQual';
    final response = await http.get(Uri.parse(url), headers: {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    });
    if (response.statusCode == 200) {
      debugPrint("Qualification Profile Data----->${response.body}");
      List<dynamic> data = jsonDecode(response.body);
      provider.personQl.clear();
      provider.setPersonQl(data);
    } else {
      debugPrint("Qualification Profile Data not found...");
    }
  }

  static getPersonSkill(context) async {

    final provider = Provider.of<PersonSkillProvider>(context, listen: false);
    provider.personSkill.clear();

    SharedPreferences pref = await SharedPreferences.getInstance();
    String? token = pref.getSharedPrefStringValue(key: CustomString.accessToken);

    String url = '$baseUrl/api/PersonSkills/GetSkillsByUser';
    final response = await http.get(Uri.parse(url), headers: {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    });
    if (response.statusCode == 200) {
      debugPrint("Skill Profile Data----->${response.body}");
      List<dynamic> data = jsonDecode(response.body);
      provider.personSkill.clear();
      provider.setPersonSkill(data);
    } else {
      debugPrint("Skill Profile Data Not Found...");
    }
  }

  static getPersonHobby(context) async {

    final provider = Provider.of<PersonHobbyProvider>(context, listen: false);
    provider.personHobby.clear();

    SharedPreferences pref = await SharedPreferences.getInstance();
    String? token = pref.getSharedPrefStringValue(key: CustomString.accessToken);

    String url = '$baseUrl/api/PersonHobbies/MyHobbies';
    final response = await http.get(Uri.parse(url), headers: {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    });
    if (response.statusCode == 200) {
      debugPrint("Hobby Profile Data----->${response.body}");
      List<dynamic> data = jsonDecode(response.body);
      provider.personHobby.clear();
      provider.setPersonHobby(data);
    } else {
      debugPrint("Hobby Profile Data Not Found...");
    }
  }

  static getDepartment({context, orgId}) async {

    final provider = Provider.of<DepartmentProvider>(context, listen: false);
    provider.department.clear();

    SharedPreferences pref = await SharedPreferences.getInstance();
    String? token = pref.getSharedPrefStringValue(key: CustomString.accessToken);

    String url = '$baseUrl/api/Departments/ByOrgId?Org_Id=$orgId';
    final response = await http.get(Uri.parse(url), headers: {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    });
    if (response.statusCode == 200) {
      debugPrint("Department Data ------->${response.body}");
      List<dynamic> data = jsonDecode(response.body);
      provider.department.clear();
      provider.setDepartment(data);
    } else {
      debugPrint("Department Data Not Found--->${response.body}");
    }
  }

  static deletePersonExperience(context, int? perExpId) async {

    try {
      SharedPreferences pref = await SharedPreferences.getInstance();
      String? token = pref.getSharedPrefStringValue(key: CustomString.accessToken);

      String url = '$baseUrl/api/PersonExperiences/Delete?id=$perExpId';
      final response = await http.delete(Uri.parse(url), headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      });
      if (response.statusCode == 200) {
        debugPrint("Delete Person Experience--------->${response.body}");
        getPersonExperience(context);
        Navigator.pop(context);
      } else {
        debugPrint("Not Delete Person Experience--------->${response.body}");
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text("Try again person experience not delete..."),
        ));
      }
      return response.body;
    } catch (e) {
      debugPrint("Exception------->$e");
    }
  }

  static deletePersonQualification(context, int? perQLId) async {

    try {
      SharedPreferences pref = await SharedPreferences.getInstance();
      String? token = pref.getSharedPrefStringValue(key: CustomString.accessToken);

      String url = "$baseUrl/api/PersonQualifications?id=$perQLId";
      final response = await http.delete(Uri.parse(url), headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      });
      if (response.statusCode == 200) {
        debugPrint("Delete Person Qualification--------->${response.body}");
        getPersonQualification(context);
        Navigator.pop(context);
      } else {
        debugPrint("Not Delete Person Qualification--------->${response.body}");
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text("Try again person qualification not delete..."),
        ));
      }
    } catch (e) {
      debugPrint("Exception------->$e");
    }
  }

  static deletePersonSkill(context, int? perSkillId) async {

    try {
      SharedPreferences pref = await SharedPreferences.getInstance();
      String? token = pref.getSharedPrefStringValue(key: CustomString.accessToken);

      String url = '$baseUrl/api/PersonSkills/Delete?id=$perSkillId';
      final response = await http.delete(Uri.parse(url), headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      });
      if (response.statusCode == 200) {
        debugPrint("Delete Person Skill--------->${response.body}");
        getPersonSkill(context);
        Navigator.of(context).pop();
      } else {
        debugPrint("Not Delete Person Skill--------->${response.body}");
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text("Try again person skill not delete..."),
        ));
      }
    } catch (e) {
      debugPrint("Exception------->$e");
    }
  }

  static deletePersonHobby(context, personId, int? perHobbyId) async {

    try {
      SharedPreferences pref = await SharedPreferences.getInstance();
      String? token = pref.getSharedPrefStringValue(key: CustomString.accessToken);

      String url = '$baseUrl/api/PersonHobbies/Delete?personId=$personId&hobbyId=$perHobbyId';
      final response = await http.delete(Uri.parse(url), headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      });
      if (response.statusCode == 200) {
        debugPrint("Delete Person Hobby--------->${response.body}");
        ApiConfig.getPersonHobby(context);
        Navigator.pop(context);
      } else {
        debugPrint("Not Delete Person Hobby--------->${response.body}");
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text("Try again person hobby not delete..."),
        ));
      }
    } catch (e) {
      debugPrint("Exception------->$e");
    }
  }

  static addExperienceData({context, jobTitle, comName, indName, sDate, eDate}) async {

    DateTime startDate = DateTime.parse(sDate);
    DateTime endDate = DateTime.parse(eDate);
    int result = monthsBetweenDates(startDate, endDate);

    Map<String, dynamic> requestData = {
      "Company_Name": comName,
      "Industry_Field_Name": indName,
      "Exp_months": result,
      "Job_Title": jobTitle,
      "Start_date": sDate,
      "End_Date": eDate
    };
    SharedPreferences pref = await SharedPreferences.getInstance();
    String? token = pref.getSharedPrefStringValue(key: CustomString.accessToken);

    String url = '$baseUrl/api/PersonExperiences/Create';
    final response = await http.post(Uri.parse(url), body: jsonEncode(requestData), headers: {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    });
    if (response.statusCode == 200) {
      debugPrint("Add Person Experience Data ------>${response.body}");
      getPersonExperience(context);
      Navigator.pop(context);
    } else {
      debugPrint("Person Add Experience Data Failed ------>${response.body}");
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text("Try again person experience not added..."),
      ));
    }
  }

  static addQualificationData({context, courseName, instituteName, city, grade, yop}) async {

    Map<String, dynamic> requestData = {
      "Cou_Name": courseName,
      "Inst_Name": instituteName,
      "City": city,
      "YOP": yop,
      "Grade": grade,
    };

    SharedPreferences pref = await SharedPreferences.getInstance();
    String? token = pref.getSharedPrefStringValue(key: CustomString.accessToken);

    String url = '$baseUrl/api/PersonQualifications/Create';
    final response = await http.post(Uri.parse(url), body: jsonEncode(requestData), headers: {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    });
    if (response.statusCode == 200) {
      debugPrint("Add Person Qualification Data ------>${response.body}");
      getPersonQualification(context);
      Navigator.pop(context);
    } else {
      debugPrint("Add Person Qualification Data Failed ------>${response.body}");
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text("Try again person qualification not added..."),
      ));
    }
  }

  static addHobbyData({context, hobbyName}) async {

    Map<String, dynamic> requestData = {
      "Hobby": {"name": hobbyName}
    };
    SharedPreferences pref = await SharedPreferences.getInstance();
    String? token = pref.getSharedPrefStringValue(key: CustomString.accessToken);

    String url = '$baseUrl/api/PersonHobbies/PerHobCreate';
    final response = await http.post(Uri.parse(url), body: jsonEncode(requestData), headers: {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    });
    if (response.statusCode == 200) {
      debugPrint("Add Person Hobby Data ------>${response.body}");
      ApiConfig.getPersonHobby(context);
      Navigator.pop(context);
    } else {
      debugPrint("Add Person Hobby Data Failed ------>${response.body}");
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text("Try again person hobby not added..."),
      ));
    }
  }

  static addSkillData({context, skill, month}) async {

    Map<String, dynamic> requestData = {
      "Experience": month,
      "Skill_Name": skill
    };

    SharedPreferences pref = await SharedPreferences.getInstance();
    String? token = pref.getSharedPrefStringValue(key: CustomString.accessToken);

    String url = '$baseUrl/api/PersonSkills/Create';
    final response = await http.post(Uri.parse(url), body: jsonEncode(requestData), headers: {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    });
    if (response.statusCode == 200) {
      debugPrint("Add Person Skill Data ------>${response.body}");
      getPersonSkill(context);
      Navigator.of(context).pop();
    } else {
      debugPrint("Add Person Skill Data Failed ------>${response.body}");
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text("Try again person skill not added..."),
      ));
    }
  }

  static addOrgPersonData({context, orgId, aboutORG, city, country, email, mobileNo, orgName}) async {

    Map<String, dynamic> requestData = {
      "Org_Id": orgId,
      "About_org": aboutORG,
      "City": city,
      "Country": country,
      "Contact_email": email,
      "Contact_number": mobileNo,
    };

    SharedPreferences pref = await SharedPreferences.getInstance();
    String? token = pref.getSharedPrefStringValue(key: CustomString.accessToken);

    String url = '$baseUrl/api/OrgInfo/Create';
    final response = await http.post(Uri.parse(url), body: jsonEncode(requestData), headers: {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    });
    if (response.statusCode == 200) {
      debugPrint("Add OrgPerson Data Success--------->${response.body}");
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => UpdateAdminProfile(orgId: orgId, orgName: orgName)));
    } else {
      debugPrint("Add OrgPerson Data failed--------->${response.body}");
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text("Try again orgPerson data failed..."),
      ));
    }
  }

  static updateExperienceData({context, peronExperienceId, jobTitle, comName, indName, sDate, eDate}) async {

    DateTime startDate = DateTime.parse(sDate);
    DateTime endDate = DateTime.parse(eDate);
    int result = monthsBetweenDates(startDate, endDate);

    Map<String, dynamic> requestData = {
      "PerExp_Id": peronExperienceId,
      "Company_Name": comName,
      "Industry_Field_Name": indName,
      "Exp_months": result,
      "Job_Title": jobTitle,
      "Start_date": sDate,
      "End_Date": eDate
    };

    try {
      SharedPreferences pref = await SharedPreferences.getInstance();
      String? token = pref.getSharedPrefStringValue(key: CustomString.accessToken);

      String url = '$baseUrl/api/PersonExperiences/Update';
      final response = await http.put(Uri.parse(url), body: jsonEncode(requestData), headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      });
      if (response.statusCode == 200) {
        debugPrint("Update Person Experience Data ------>${response.body}");
        getPersonExperience(context);
        Navigator.pop(context);
      } else {
        debugPrint("Update Person Experience Data Failed ------>${response.body}");
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text("Try again person experience not update..."),
        ));
      }
    } catch (e) {
      debugPrint("Exception------->$e");
    }
  }

  static updateQualificationData({context, courseName, instituteName, grade, city, yop, personQualificationID}) async {

    Map<String, dynamic> requestData = {
      "PQ_Id": personQualificationID,
      "YOP": yop,
      "Grade": grade,
      "City": city,
      "Cou_Name": courseName,
      "Inst_Name": instituteName,
    };

    SharedPreferences pref = await SharedPreferences.getInstance();
    String? token = pref.getSharedPrefStringValue(key: CustomString.accessToken);

    String url = '$baseUrl/api/PersonQualifications/Update';
    final response = await http.put(Uri.parse(url), body: jsonEncode(requestData), headers: {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    });
    if (response.statusCode == 200) {
      debugPrint("Update Person Qualification Data ------>${response.body}");
      getPersonQualification(context);
      Navigator.pop(context);
    } else {
      debugPrint("Update Person Qualification Data Failed ------>${response.body}");
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text("Try again person qualification not update ..."),
      ));
    }
  }

  static updateSkillData({context, skill, months, personSkillId}) async {

    Map<String, dynamic> requestData = {
      "PerSk_Id": personSkillId,
      "Experience": months,
      "Skill_Name": skill,
    };

    SharedPreferences pref = await SharedPreferences.getInstance();
    String? token = pref.getSharedPrefStringValue(key: CustomString.accessToken);

    String url = '$baseUrl/api/PersonSkills/Update';
    final response =
        await http.put(Uri.parse(url), body: jsonEncode(requestData), headers: {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    });
    if (response.statusCode == 200) {
      debugPrint("Update Person Skill Data ------>${response.body}");
      getPersonSkill(context);
      Navigator.of(context).pop();
    } else {
      debugPrint("Update Person Skill Data Failed ------>${response.body}");
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text("Try again person skill not update..."),
      ));
    }
  }

  static updateOrgAdminProfile({context, orgId, aboutOrg, city, country, number, email}) async {

    final provider = Provider.of<CirculerIndicationProvider>(context, listen: false);

    Map<String, dynamic> requestData = {
      "Org_Id": orgId,
      "About_org": aboutOrg,
      "City": city,
      "Country": country,
      "Contact_email": email,
      "Contact_number": number,
    };

    SharedPreferences pref = await SharedPreferences.getInstance();
    String? token = pref.getSharedPrefStringValue(key: CustomString.accessToken);

    String url = '$baseUrl/api/OrgInfo/Update';
    final response = await http.put(Uri.parse(url), body: jsonEncode(requestData), headers: {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    });
    if (response.statusCode == 200) {
      debugPrint("Update OrgAdminProfile Success--------->${response.body}");
      provider.setLoading(true);
      Navigator.pop(context);
    } else {
      debugPrint("Update OrgAdminProfile failed--------->${response.body}");
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text("Try again orgAdmin profile not update..."),
      ));
    }
  }

  static searchCourse({context, courseString}) async {

    final provider = Provider.of<SearchCourseProvider>(context, listen: false);
    provider.courseList.clear();

    SharedPreferences pref = await SharedPreferences.getInstance();
    String? token = pref.getSharedPrefStringValue(key: CustomString.accessToken);

    String apiUrl = '$baseUrl/api/Courses/AutoCompleteCourse?search_str=$courseString';
    final response = await http.get(Uri.parse(apiUrl), headers: {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    });

    if (response.statusCode == 200) {
      debugPrint("Search Course Data ------>${response.body}");
      List<dynamic> data = jsonDecode(response.body);
      provider.courseList.clear();
      provider.setSearchedCourse(data);
    } else {
      debugPrint("Failed to Search Course Data ------>${response.body}");
    }
  }

  static searchInstitute({context, instituteString}) async {

    final provider = Provider.of<SearchInstituteProvider>(context, listen: false);
    provider.instituteList.clear();

    SharedPreferences pref = await SharedPreferences.getInstance();
    String? token = pref.getSharedPrefStringValue(key: CustomString.accessToken);

    String apiUrl = '$baseUrl/api/Institutes/AutoCompleteInstitute?search_str=$instituteString';
    final response = await http.get(Uri.parse(apiUrl), headers: {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    });

    if (response.statusCode == 200) {
      debugPrint("Search Institute Data ------>${response.body}");
      List<dynamic> data = jsonDecode(response.body);
      provider.instituteList.clear();
      provider.setSearchedInstitute(data);
    } else {
      debugPrint("Failed to Search Institute Data ------>${response.body}");
    }
  }

  static searchSkill({context, skillString}) async {

    final provider = Provider.of<SearchSkillProvider>(context, listen: false);
    provider.skillList.clear();

    SharedPreferences pref = await SharedPreferences.getInstance();
    String? token = pref.getSharedPrefStringValue(key: CustomString.accessToken);

    String apiUrl = '$baseUrl/api/Skills/AutoCompleteSkills?search_str=$skillString';
    final response = await http.get(Uri.parse(apiUrl), headers: {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    });

    if (response.statusCode == 200) {
      debugPrint("Search Skill Data ------>${response.body}");
      List<dynamic> data = jsonDecode(response.body);
      provider.skillList.clear();
      provider.setSearchedSkill(data);
    } else {
      debugPrint("Failed to Search Skill Data ------>${response.body}");
    }
  }

  static searchHobby({context, hobbyString}) async {

    final provider = Provider.of<SearchHobbyProvider>(context, listen: false);
    provider.hobbyList.clear();

    SharedPreferences pref = await SharedPreferences.getInstance();
    String? token = pref.getSharedPrefStringValue(key: CustomString.accessToken);

    String apiUrl = '$baseUrl/api/Hobbies/AutoCompleteHobbies?search_str=$hobbyString';
    final response = await http.get(Uri.parse(apiUrl), headers: {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    });

    if (response.statusCode == 200) {
      debugPrint("Search Hobby Data ------>${response.body}");
      List<dynamic> data = jsonDecode(response.body);
      provider.setSearchedHobby(data);
    } else {
      debugPrint("Failed to Search Hobby Data ------>${response.body}");
    }
  }

  static searchExperienceCompany({context, companyString}) async {

    final provider = Provider.of<SearchExCompanyProvider>(context, listen: false);
    provider.cmpList.clear();

    SharedPreferences pref = await SharedPreferences.getInstance();
    String? token = pref.getSharedPrefStringValue(key: CustomString.accessToken);

    String apiUrl = '$baseUrl/api/Experience/AutoCompleteCompanyNames?search_str=$companyString';
    final response = await http.get(Uri.parse(apiUrl), headers: {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    });

    if (response.statusCode == 200) {
      debugPrint("Search Experience company Data ------>${response.body}");
      List<dynamic> data = jsonDecode(response.body);
      provider.cmpList.clear();
      provider.setSearchedCompany(data);
    } else {
      debugPrint("Failed to Search Experience company Data ------>${response.body}");
    }
  }

  static searchExperienceIndustry({context, industryString}) async {

    final provider = Provider.of<SearchExIndustryProvider>(context, listen: false);
    provider.indList.clear();

    SharedPreferences pref = await SharedPreferences.getInstance();
    String? token = pref.getSharedPrefStringValue(key: CustomString.accessToken);

    String apiUrl = '$baseUrl/api/Experience/AutoCompleteIndustryNames?search_str=$industryString';
    final response = await http.get(Uri.parse(apiUrl), headers: {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    });

    if (response.statusCode == 200) {
      debugPrint("Search Experience Industry Data ------>${response.body}");
      List<dynamic> data = jsonDecode(response.body);
      provider.indList.clear();
      provider.setSearchedIndustry(data);
    } else {
      debugPrint("Failed to Search Experience Industry Data ------>${response.body}");
    }
  }

  /*-----------------------------------------  Manage Organization Screen  -------------------------------------*/

  static getDataSwitching({context}) async {

    final provider = Provider.of<SwitchProvider>(context, listen: false);

    SharedPreferences pref = await SharedPreferences.getInstance();
    String? token = pref.getSharedPrefStringValue(key: CustomString.accessToken);
    try {
      String url = '$baseUrl/api/Person/MySessionInfo';
      final response = await http.post(Uri.parse(url), headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      });
      if (response.statusCode == 200) {
        debugPrint("Switching OrgPersonAdmin Data------->${response.body}");
        Map<String, dynamic> data = jsonDecode(response.body);
        await provider.setSwitchData(SwitchDataModel.fromJson(data));
        provider.notify();
      } else {
        debugPrint("Failed to Switching OrgPersonAdmin Data------->${response.body}");
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text("Try again switching failed..."),
        ));
      }
    } catch (e) {
      debugPrint("Switching OrgPersonAdmin------>$e");
    }
  }

  static getManageOrgData({context, tabIndex}) async {

    final requestProvider = Provider.of<RequestManageOrgProvider>(context, listen: false);
    final approvedProvider = Provider.of<ApprovedManageOrgProvider>(context, listen: false);
    requestProvider.requestOrgDataList.clear();
    approvedProvider.approveOrgDataList.clear();

    SharedPreferences pref = await SharedPreferences.getInstance();
    String? token = pref.getSharedPrefStringValue(key: CustomString.accessToken);
    try {
      String url = '$baseUrl/api/OrgPersons/ListByMe?Request_Status=$tabIndex';
      final response = await http.get(Uri.parse(url), headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      });
      if (response.statusCode == 200) {
        tabIndex == 0 ? debugPrint("Requested Org Data------->${response.body}") : debugPrint("Approved Org Data------->${response.body}");
        List<dynamic> data = await jsonDecode(response.body);
        tabIndex == 0 ? requestProvider.setRequestOrgData(data) : approvedProvider.setApproveOrgData(data);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text("Something went wrong..."),
        ));
      }
    } catch (e) {
      debugPrint("manage org data------>$e");
    }
  }

  static getOrgMemberData({context, orgName, tabIndex}) async {

    final requestProvider = Provider.of<RequestMemberProvider>(context, listen: false);
    final approvedProvider = Provider.of<ApprovedMemberProvider>(context, listen: false);
    requestProvider.requestPendingOrgDataList.clear();
    approvedProvider.approveOrgDataList.clear();

    SharedPreferences pref = await SharedPreferences.getInstance();
    String? token = pref.getSharedPrefStringValue(key: CustomString.accessToken);
    try {
      String url = '$baseUrl/api/OrgPersons/ListByOrg?org_Name=$orgName&Request_Status=$tabIndex';
      final response = await http.get(Uri.parse(url), headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      });
      if (response.statusCode == 200) {
        tabIndex == 0 ? debugPrint("Pending Requested Org Member Data ------->${response.body}") : debugPrint("Approved Org Member Data ------->${response.body}");
        List<dynamic> data = await jsonDecode(response.body);
        tabIndex == 0 ? requestProvider.setPendingRequestOrgData(data) : approvedProvider.setApproveOrgData(data);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text("Something went wrong..."),
        ));
      }
    } catch (e) {
      debugPrint("org member data------>$e");
    }
  }

  static updateAssignOrgRequestStatus({context, orgID, personID, depID, orgName, reqStatus}) async {

    Map<String, dynamic> requestData = {
      "Org_Id": orgID,
      "Perosn_Id": personID,
      "Dept_Id": depID,
      "Request_Status": reqStatus,
      "Dept_Req": ""
    };

    SharedPreferences pref = await SharedPreferences.getInstance();
    String? token = pref.getSharedPrefStringValue(key: CustomString.accessToken);

    String url = '$baseUrl/api/OrgPersons/Request/Update';
    final response = await http.put(Uri.parse(url), body: jsonEncode(requestData), headers: {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    });
    if (response.statusCode == 200) {
      ApiConfig.getOrgMemberData(
          context: context, orgName: orgName, tabIndex: 0);
      debugPrint("Update Department Assign --------->${response.body}");
    } else {
      debugPrint("Update Department Assign failed--------->${response.body}");
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text("Department Assign failed..."),
      ));
    }
  }

  static searchOrganization({context, orgString}) async {

    final provider = Provider.of<SearchOrgProvider>(context, listen: false);
    provider.orgList.clear();

    SharedPreferences pref = await SharedPreferences.getInstance();
    String? token = pref.getSharedPrefStringValue(key: CustomString.accessToken);

    String apiUrl = '$baseUrl/api/Orgs/AutoCompleteOrgs?search_str=$orgString';
    final response = await http.get(Uri.parse(apiUrl), headers: {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    });

    if (response.statusCode == 200) {
      debugPrint("Search Organization ------->${response.body}");
      List<dynamic> data = jsonDecode(response.body);
      provider.orgList.clear();
      provider.setSearchedOrg(data);
    } else {
      debugPrint("Failed to Search Organization ------->${response.body}");
    }
  }

  static searchDepartment({context, orgId}) async {

    final provider = Provider.of<SearchDepartmentProvider>(context, listen: false);
    provider.departmentList.clear();

    SharedPreferences pref = await SharedPreferences.getInstance();
    String? token = pref.getSharedPrefStringValue(key: CustomString.accessToken);

    String apiUrl = '$baseUrl/api/Departments/ByOrgId?org_Id=$orgId';
    final response = await http.get(Uri.parse(apiUrl), headers: {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    });

    if (response.statusCode == 200) {
      debugPrint("Search Department ------->${response.body}");
      List<dynamic> data = jsonDecode(response.body);
      provider.departmentList.clear();
      provider.setSearchedDepartment(data);
    } else {
      debugPrint("Failed to Search Department ------->${response.body}");
    }
  }

  static joinOrgRequest({context, orgID, dpID, dpName}) async {

    Map<String, dynamic> parameter = {
      "Org_Id": orgID,
      "Dept_Id": dpID,
      "Dept_Req": dpName
    };
    SharedPreferences pref = await SharedPreferences.getInstance();
    String? token = pref.getSharedPrefStringValue(key: CustomString.accessToken);

    const String apiUrl = '$baseUrl/api/OrgPersons/Create';
    final response = await http.post(Uri.parse(apiUrl), body: jsonEncode(parameter), headers: {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    });
    if (response.statusCode == 200) {
      debugPrint("Join Organization Request--------->${response.body}");
      ApiConfig.getManageOrgData(context: context, tabIndex: 0);
      Navigator.pop(context);
    } else {
      debugPrint("Failed to Join Organization Request--------->${response.body}");
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Try again data will not added..")));
    }
  }

  static deleteOrgRequest({context, orgID, personID, screen}) async {

    SharedPreferences pref = await SharedPreferences.getInstance();
    String? token = pref.getSharedPrefStringValue(key: CustomString.accessToken);

    String apiUrl = '$baseUrl/api/OrgPersons/Delete?org_Id=$orgID&person_Id=$personID';
    final response = await http.delete(Uri.parse(apiUrl), headers: {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    });
    if (response.statusCode == 200) {
      debugPrint("Delete Organization Request--------->${response.body}");
      if (screen == CustomString.approved) {
        getManageOrgData(context: context, tabIndex: 1);
      } else if (screen == CustomString.requested) {
        getManageOrgData(context: context, tabIndex: 0);
      }
    } else {
      debugPrint("Failed to Delete Organization Request--------->${response.body}");
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Try again data not delete...")));
    }
  }

  static deleteOrgFromAdminSide({context, indexedOrgID, personID, orgName, orgID, screen}) async {

    SharedPreferences pref = await SharedPreferences.getInstance();
    String? token = pref.getSharedPrefStringValue(key: CustomString.accessToken);

    String apiUrl = '$baseUrl/api/OrgPersons/Delete?org_Id=$indexedOrgID&person_Id=$personID';
    final response = await http.delete(Uri.parse(apiUrl), headers: {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    });
    if (response.statusCode == 200) {
      debugPrint("Delete Organization From Admin Side --------->${response.body}");
      if (screen == CustomString.approved) {
        ApiConfig.getOrgMemberData(context: context, orgName: orgName, tabIndex: 1);
      } else if (screen == CustomString.pendingRequested) {
        ApiConfig.getOrgMemberData(context: context, orgName: orgName, tabIndex: 0);
      }
    } else {
      debugPrint("Failed to Delete Organization From Admin Side --------->${response.body}");
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Try again data not delete...")));
    }
  }

  static deleteDepartment({context, departmentID, orgId}) async {

    SharedPreferences pref = await SharedPreferences.getInstance();
    String? token = pref.getSharedPrefStringValue(key: CustomString.accessToken);

    String apiUrl = '$baseUrl/api/Departments/Delete?dept_Id=$departmentID';
    final response = await http.delete(Uri.parse(apiUrl), headers: {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    });
    if (response.statusCode == 200) {
      debugPrint("Delete Department --------->${response.body}");
      await getDepartment(context: context, orgId: orgId);
      Navigator.pop(context);
    } else {
      debugPrint("Failed to Delete Department --------->${response.body}");
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Try again Department not delete...")));
    }
  }

  static addNewDepartment({context, departmentName, depId, orgID}) async {

    Map<String, dynamic> requestData = {
      "Org_Id": orgID,
      "Dept_Name": departmentName,
      "Parent_dept_Id": depId
    };
    SharedPreferences pref = await SharedPreferences.getInstance();
    String? token = pref.getSharedPrefStringValue(key: CustomString.accessToken);

    String url = '$baseUrl/api/Departments/Create';
    final response = await http.post(Uri.parse(url), body: jsonEncode(requestData), headers: {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    });
    if (response.statusCode == 200) {
      debugPrint("Add Department --------->${response.body}");
      await getDepartment(context: context, orgId: orgID);
      Navigator.pop(context);
    } else {
      debugPrint("Failed to Add Department --------->${response.body}");
      Image.asset(ImagePath.noData, fit: BoxFit.cover);
    }
  }

  static updateDepartment({context, departmentName, depId, parentDepId, orgID}) async {

    Map<String, dynamic> requestData = {
      "Org_Id": orgID,
      "Dept_Id": depId,
      "Dept_Name": departmentName,
      "Parent_dept_Id": parentDepId
    };
    SharedPreferences pref = await SharedPreferences.getInstance();
    String? token = pref.getSharedPrefStringValue(key: CustomString.accessToken);

    String url = '$baseUrl/api/Departments/Update';
    final response = await http.put(Uri.parse(url), body: jsonEncode(requestData), headers: {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    });
    if (response.statusCode == 200) {
      debugPrint("Update department --------->${response.body}");
      await getDepartment(context: context, orgId: orgID);
      Navigator.pop(context);
    } else {
      debugPrint("Failed to Update Department-------->${response.body}");
      Image.asset(ImagePath.noData, fit: BoxFit.cover);
    }
  }
}
