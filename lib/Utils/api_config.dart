import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:versa_tribe/Screens/PersonDetails/add_experience_screen.dart';

import '../Model/profile_response.dart';
import '../Providers/manage_org_index_provider.dart';
import '../Providers/person_details_provider.dart';
import '../Screens/manage_organization_screen.dart';
import '../Screens/person_details_screen.dart';
import 'custom_string.dart';

class ApiConfig {

  static const String baseUrl = 'https://192.168.2.111:9443';


// Usage example
// You can use ApiConfig.baseUrl wherever you need to make API calls in your app.
// For instance, when using the http package for making network requests:
// http.get('${ApiConfig.baseUrl}/endpoint')

  /*------------ Profile Screen --------------*/
  Future<ProfileResponse> getProfileData() async {
    const String profileUrl = '${ApiConfig.baseUrl}/api/Person/MyProfile';

    SharedPreferences pref = await SharedPreferences.getInstance();
    String? token = pref.getString(CustomString.accessToken);

    final response = await http.get(Uri.parse(profileUrl), headers: {
      'Authorization': 'Bearer $token',
    });

    if (response.statusCode == 200) {
      // If server returns a 200 OK response, parse the JSON
      // print('Response data: ${response.body}');
      Map<String, dynamic> jsonMap = json.decode(response.body);
      ProfileResponse yourModel = ProfileResponse.fromJson(jsonMap);
      pref.setString('PersonId', yourModel.personId.toString());
      return yourModel;
    } else {
      // If the server did not return a 200 OK response, throw an exception.
      throw Exception('Failed to load data');
    }
  }



  /*-----------  Profile Details Screen  ----------------*/
  static getUserExperience(context) async {
    final provider = Provider.of<PersonExperienceProvider>(context, listen: false);
    provider.personEx.clear();

    SharedPreferences pref = await SharedPreferences.getInstance();
    String? token = pref.getString(CustomString.accessToken);
    String? personId = pref.getString('PersonId');
    try{
      String url = "$baseUrl/api/PersonExperiences/MyList?id=$personId";
      final response = await http.get(Uri.parse(url), headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      });
      if (response.statusCode == 200) {
        List<dynamic> data = jsonDecode(response.body);
        provider.setPersonEx(data);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text("Data not found...")
        ));
      }
    }catch(e){
      debugPrint("experience------>$e");
    }
  }
  static getUserQualification(context) async {
    final provider = Provider.of<PersonQualificationProvider>(context, listen: false);
    provider.personQl.clear();
    String url = "$baseUrl/api/GetUserPerQual";
    SharedPreferences pref = await SharedPreferences.getInstance();
    String? token = pref.getString(CustomString.accessToken);
    final response = await http.get(Uri.parse(url), headers: {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    });
    if (response.statusCode == 200) {
      List<dynamic> data = jsonDecode(response.body);
      provider.setPersonQl(data);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text("Data not found..."),
      ));
    }
  }
  static getUserSkills(context) async {
    final provider = Provider.of<PersonSkillProvider>(context, listen: false);
    provider.personSkill.clear();
    String url = "$baseUrl/api/PersonSkills/GetSkillsByUser";
    SharedPreferences pref = await SharedPreferences.getInstance();
    String? token = pref.getString(CustomString.accessToken);
    final response = await http.get(Uri.parse(url), headers: {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    });
    if (response.statusCode == 200) {
      List<dynamic> data = jsonDecode(response.body);
      provider.setPersonSkill(data);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text("Data not found..."),
      ));
    }
  }
  static getUserHobby(context) async {
    final provider = Provider.of<PersonHobbyProvider>(context, listen: false);
    provider.personHobby.clear();
    String url = "$baseUrl/api/PersonHobbies/MyHobbies";
    SharedPreferences pref = await SharedPreferences.getInstance();
    String? token = pref.getString(CustomString.accessToken);
    final response = await http.get(Uri.parse(url), headers: {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    });
    if (response.statusCode == 200) {
      List<dynamic> data = jsonDecode(response.body);
      provider.setPersonHobby(data);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text("Data not found..."),
      ));
    }
  }
  static deletePersonEx(context, int? perExpId) async {
    try{
      String url = "$baseUrl/api/PersonExperiences/Delete?id=$perExpId";
      SharedPreferences pref = await SharedPreferences.getInstance();
      String? token = pref.getString(CustomString.accessToken);
      final response = await http.delete(Uri.parse(url), headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      });
      if (response.statusCode == 200) {
        debugPrint("if--------->${response.body}");
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>const PersonDetailsScreen()));
      } else {
        debugPrint("else--------->${response.body}");
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text("Try again Data not delete..."),
        ));
      }
    }catch(e){
      debugPrint("Exception------->$e");
    }
  }
  static deletePersonQL(context, int? perQLId) async {
    try{
      String url = "$baseUrl/api/PersonQualifications/5?id=$perQLId";
      SharedPreferences pref = await SharedPreferences.getInstance();
      String? token = pref.getString(CustomString.accessToken);
      final response = await http.delete(Uri.parse(url), headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      });
      if (response.statusCode == 200) {
        debugPrint("if--------->${response.body}");
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>const PersonDetailsScreen()));
      } else {
        debugPrint("else--------->${response.body}");
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text("Try again Data not delete..."),
        ));
      }
    }catch(e){
      debugPrint("Exception------->$e");
    }
  }
  static deletePersonSkill(context, int? perSkillId) async {
    try{
      String url = "$baseUrl/api/PersonSkills/Delete?id=$perSkillId";
      SharedPreferences pref = await SharedPreferences.getInstance();
      String? token = pref.getString(CustomString.accessToken);
      final response = await http.delete(Uri.parse(url), headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      });
      if (response.statusCode == 200) {
        debugPrint("skill delete success--------->${response.body}");
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>const PersonDetailsScreen()));
      } else {
        debugPrint("skill delete failed--status-code--->${response.statusCode}-->${response.body}");
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text("Try again Data not delete..."),
        ));
      }
    }catch(e){
      debugPrint("Exception------->$e");
    }
  }
  static deletePersonHobby(context, personId, int? perHobbyId) async {
    try{
      debugPrint("-=-=-=->$personId and $perHobbyId");
      String url = "$baseUrl/api/PersonHobbies/Delete?personId=$personId&hobbyId=$perHobbyId";
      SharedPreferences pref = await SharedPreferences.getInstance();
      String? token = pref.getString(CustomString.accessToken);
      final response = await http.delete(Uri.parse(url), headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      });
      if (response.statusCode == 200) {
        debugPrint("hobby delete success--------->${response.body}");
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>const PersonDetailsScreen()));
      } else {
        debugPrint("hobby delete failed---status-code--->${response.statusCode} and error-->${response.body}");
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text("Try again Data not delete..."),
        ));
      }
    }catch(e){
      debugPrint("Exception------->$e");
    }
  }
  static addExData({context, jobTitle, comName, indName, sDate, eDate}) async {
    /* String jobTitle = jobTitleController.text;
    String? companyN = companyNController.text;
    String? industryN = industryNController.text;*/

    DateTime startDate = DateTime.parse(sDate);
    DateTime endDate = DateTime.parse(eDate);

    int result = monthsBetweenDates(startDate, endDate);
    debugPrint('Number of months between the two dates:--->> $result');

    Map<String, dynamic> requestData = {
      "Experience": {
        "Company_Name": comName,
        "Industry_Field_Name": indName
      },
      "Exp_months": result,
      "Job_Title": jobTitle,
      "Start_date": sDate,
      "End_Date": eDate
    };
    String url = "$baseUrl/api/PersonExperiences/Create";
    SharedPreferences pref = await SharedPreferences.getInstance();
    String? token = pref.getString(CustomString.accessToken);
    final response = await http.post(Uri.parse(url),body: jsonEncode(requestData) , headers: {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    });
    if (response.statusCode == 200) {
      debugPrint("--------->${response.body}");
      //Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>const PersonDetailsScreen()));
      ApiConfig.getUserExperience(context);
      Navigator.pop(context);
    } else {
      debugPrint("--------->${response.body}");
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text("Try again..."),
      ));
    }
  }
  static updateExData({context, peronExperienceId, jobTitle, comName, indName, sDate, eDate}) async {
    DateTime startDate = DateTime.parse(sDate);
    DateTime endDate = DateTime.parse(eDate);

    int result = monthsBetweenDates(startDate, endDate);
    debugPrint('Number of months between the two dates:-----> $result');
    debugPrint('person ex id-----> $peronExperienceId');
    debugPrint('company-----> $comName');
    debugPrint('industry-----> $indName');
    debugPrint('job title-----> $jobTitle');
    debugPrint('state date-----> $sDate');
    debugPrint('end date-----> $eDate');

    Map<String, dynamic> requestData = {
      "Experience": {
        "Company_Name": comName,
        "Industry_Field_Name": indName
      },
      "PerExp_Id": peronExperienceId,
      "Exp_months": result,
      "Job_Title": jobTitle,
      "Start_date": sDate,
      "End_Date": eDate
    };

    try{
      String url = "$baseUrl/api/PersonExperiences/Update";
      SharedPreferences pref = await SharedPreferences.getInstance();
      String? token = pref.getString(CustomString.accessToken);
      final response = await http.put(Uri.parse(url),body: jsonEncode(requestData) , headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      });
      if (response.statusCode == 200) {
        // debugPrint("if--------->${response.body}");
       // Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>const PersonDetailsScreen()));
        ApiConfig.getUserExperience(context);
        Navigator.pop(context);
      } else {
        debugPrint("else--------->${response.body}");
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text("Try again details not update..."),
        ));
      }
    }catch(e){
      debugPrint("Exception------->$e");
    }
  }
  static int monthsBetweenDates(DateTime startDate, DateTime endDate) {
    int months = 0;

    while (startDate.isBefore(endDate)) {
      months++;
      startDate = DateTime(startDate.year, startDate.month + 1, startDate.day);
    }

    return months;
  }
  static addHobbyData({context, hobbyName}) async {
    String hobby = hobbyName;
    Map<String, dynamic> requestData = {
      "Hobby":{"name": hobby}
    };
    String url = "$baseUrl/api/PersonHobbies/PerHobCreate";
    SharedPreferences pref = await SharedPreferences.getInstance();
    String? token = pref.getString(CustomString.accessToken);
    final response = await http.post(Uri.parse(url),body: jsonEncode(requestData) , headers: {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    });
    if (response.statusCode == 200) {
      debugPrint("Add hobby success--------->${response.body}");
      //Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>const PersonDetailsScreen()));
      ApiConfig.getUserHobby(context);
      Navigator.pop(context);
    } else {
      debugPrint("hobby adding failed--------->${response.body}");
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text("hobby adding failed try again..."),
      ));
    }
  }
  static addQualificationData({context, courseName, instituteName, grade, yop}) async {
    Map<String, dynamic> requestData = {
      "YOP": yop,
      "Grade": grade,
      "Qualification": {
        "Course": {
          "Cou_Name": courseName
        },
        "Institute": {
          "Inst_Name": instituteName,
        },
      }
    };

    String url = "$baseUrl/api/PersonQualifications";
    SharedPreferences pref = await SharedPreferences.getInstance();
    String? token = pref.getString(CustomString.accessToken);
    final response = await http.post(Uri.parse(url),body: jsonEncode(requestData) , headers: {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    });
    if (response.statusCode == 200) {
      debugPrint("Qualification added--------->${response.body}");
      //Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>const PersonDetailsScreen()));
      ApiConfig.getUserQualification(context);
      Navigator.pop(context);
    } else {
      debugPrint("Qualification added failed--------->${response.body}");
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text("Qualification not add please try again..."),
      ));
    }
  }
  static addSkillData({context, skill, month}) async {
    Map<String, dynamic> requestData =
    {
      "Experience": month,
      "Skill": {
        "Skill_Name":skill,
      }
    };

    String url = "$baseUrl/api/PersonSkills/Create";
    SharedPreferences pref = await SharedPreferences.getInstance();
    String? token = pref.getString(CustomString.accessToken);
    final response = await http.post(Uri.parse(url),body: jsonEncode(requestData) , headers: {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    });
    if (response.statusCode == 200) {
      debugPrint("Add Skills Success--------->${response.body}");
      //Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>const PersonDetailsScreen()));
      ApiConfig.getUserSkills(context);
      Navigator.pop(context);
    } else {
      debugPrint("Skill adding failed--------->${response.body}");
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text("Skill add failed try again..."),
      ));
    }
  }
  static editQualificationData({context, courseName, instituteName, grade, yop, personQualificationID}) async {
    debugPrint("course--->$courseName");
    debugPrint("instituteName--->$instituteName");
    debugPrint("grade--->$grade");
    debugPrint("yop--->$yop");

    Map<String, dynamic> requestData = {
      "PQ_Id":personQualificationID,
      "YOP": yop,
      "Grade": grade,
      "Qualification": {
        "Course": {
          "Cou_Name": courseName
        },
        "Institute": {
          "Inst_Name": instituteName,
        },
      }
    };
    String url = "$baseUrl/api/PersonQualifications";
    SharedPreferences pref = await SharedPreferences.getInstance();
    String? token = pref.getString(CustomString.accessToken);
    final response = await http.put(Uri.parse(url),body: jsonEncode(requestData) , headers: {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    });
    if (response.statusCode == 200) {
      debugPrint("Qualification edit success--------->${response.body}");
     // Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>const PersonDetailsScreen()));
      ApiConfig.getUserQualification(context);
      Navigator.pop(context);
    } else {
      debugPrint("Qualification edit failed--------->${response.body}");
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text("Qualification not add please try again..."),
      ));
    }
  }
  static editSkillData({context, skill, months, personSkillId}) async {
    debugPrint("skill----->$skill");
    Map<String, dynamic> requestData =
    {
      "PerSk_Id": personSkillId,
      "Experience": months,
      "Skill": {
        "Skill_Name":skill,
      }
    };

    String url = "$baseUrl/api/PersonSkills/Update";
    SharedPreferences pref = await SharedPreferences.getInstance();
    String? token = pref.getString(CustomString.accessToken);
    final response = await http.put(Uri.parse(url),body: jsonEncode(requestData) , headers: {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    });
    if (response.statusCode == 200) {
      debugPrint("edit Skills Success--------->${response.body}");
      //Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>const PersonDetailsScreen()));
      ApiConfig.getUserSkills(context);
      Navigator.pop(context);
    } else {
      debugPrint("Skill edit failed--------->${response.body}");
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text("Skill edit failed try again..."),
      ));
    }
  }

  static searchCourse({context, courseString}) async {
    final provider = Provider.of<SearchCourseProvider>(context,listen: false);
    const String apiUrl = "$baseUrl/api/Courses/AutoCompleteCourse";
    SharedPreferences pref = await SharedPreferences.getInstance();
    String? token = pref.getString(CustomString.accessToken);
    final response = await http.get(Uri.parse('$apiUrl?search_str=$courseString'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        });

    if (response.statusCode == 200) {
      provider.courseList.clear();
      debugPrint("---------------yes-->${response.body}");
      // Data found in the API, update the display controller
      List<dynamic> data = jsonDecode(response.body);

      provider.setSearchedCourse(data);
    } else {
      debugPrint("---------------No-->${response.body}");
    }
  }

  static searchInstitute({context, instituteString}) async {
    final provider = Provider.of<SearchInstituteProvider>(context,listen: false);
    const String apiUrl = "$baseUrl/api/Institutes/AutoCompleteInstitute";
    SharedPreferences pref = await SharedPreferences.getInstance();
    String? token = pref.getString(CustomString.accessToken);
    final response = await http.get(Uri.parse('$apiUrl?search_str=$instituteString'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        });

    if (response.statusCode == 200) {
      provider.instituteList.clear();
      debugPrint("Institute---------------yes-->${response.body}");
      // Data found in the API, update the display controller
      List<dynamic> data = jsonDecode(response.body);
      provider.setSearchedInstitute(data);
    } else {
      debugPrint("---------------No-->${response.body}");
    }
  }

  static searchSkill({context, skillString}) async {
    final provider = Provider.of<SearchSkillProvider>(context,listen: false);
    const String apiUrl = "$baseUrl/api/Skills/AutoCompleteSkills";
    SharedPreferences pref = await SharedPreferences.getInstance();
    String? token = pref.getString(CustomString.accessToken);
    final response = await http.get(Uri.parse('$apiUrl?search_str=$skillString'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        });

    if (response.statusCode == 200) {
      provider.skillList.clear();
      debugPrint("skill---------------yes-->${response.body}");
      // Data found in the API, update the display controller
      List<dynamic> data = jsonDecode(response.body);
      provider.setSearchedSkill(data);
    } else {
      debugPrint("---------------No-->${response.body}");
    }
  }

  static searchHobby({context, hobbyString}) async {
    final provider = Provider.of<SearchHobbyProvider>(context,listen: false);
    const String apiUrl = "$baseUrl/api/Hobbies/AutoCompleteHobbies";
    SharedPreferences pref = await SharedPreferences.getInstance();
    String? token = pref.getString(CustomString.accessToken);
    final response = await http.get(Uri.parse('$apiUrl?search_str=$hobbyString'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        });

    if (response.statusCode == 200) {
      provider.hobbyList.clear();
      debugPrint("hobby---------------yes-->${response.body}");
      // Data found in the API, update the display controller
      List<dynamic> data = jsonDecode(response.body);
      provider.setSearchedHobby(data);
    } else {
      debugPrint("---------------No-->${response.body}");
    }
  }

  static searchExCompany({context, companyString}) async {
    final provider = Provider.of<SearchExCompanyProvider>(context,listen: false);
    const String apiUrl = "$baseUrl/api/Experience/AutoCompleteCompanyNames";
    SharedPreferences pref = await SharedPreferences.getInstance();
    String? token = pref.getString(CustomString.accessToken);
    final response = await http.get(Uri.parse('$apiUrl?search_str=$companyString'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        });

    if (response.statusCode == 200) {
      provider.cmpList.clear();
      debugPrint("ExCompany---------------yes-->${response.body}");
      // Data found in the API, update the display controller
      List<dynamic> data = jsonDecode(response.body);
      provider.setSearchedCompany(data);
    } else {
      debugPrint("---------------No-->${response.body}");
    }
  }
  static searchExIndustry({context, industryString}) async {
    final provider = Provider.of<SearchExIndustryProvider>(context,listen: false);
    const String apiUrl = "$baseUrl/api/Experience/AutoCompleteIndustryNames";
    SharedPreferences pref = await SharedPreferences.getInstance();
    String? token = pref.getString(CustomString.accessToken);
    final response = await http.get(Uri.parse('$apiUrl?search_str=$industryString'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        });

    if (response.statusCode == 200) {
      provider.indList.clear();
      debugPrint("ExIndustry---------------yes-->${response.body}");
      // Data found in the API, update the display controller
      List<dynamic> data = jsonDecode(response.body);
      provider.setSearchedIndustry(data);
    } else {
      debugPrint("---------------No-->${response.body}");
    }
  }

  /*-----------  Manage ORG Screen  ----------------*/
  static getManageOrgData({context, tabIndex}) async {
    final provider = Provider.of<DisplayManageOrgProvider>(context, listen: false);
    provider.manageOrgDataList.clear();
    SharedPreferences pref = await SharedPreferences.getInstance();
    String? token = pref.getString(CustomString.accessToken);
    // String? personId = pref.getString('PersonId');
    try{
      String url = "$baseUrl/api/OrgPersons/ListByMe?Request_Status=$tabIndex";
      final response = await http.get(Uri.parse(url), headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      });
      if (response.statusCode == 200) {
        debugPrint("check Data------->${response.body}");
        List<dynamic> data = jsonDecode(response.body);
        provider.setManageOrgData(data);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text("Something went wrong..."),
        ));
      }
    }catch(e){
      debugPrint("experience------>$e");
    }
  }
  static searchOrg({context, orgString}) async {
    final provider = Provider.of<SearchOrgProvider>(context,listen: false);
    String apiUrl = "$baseUrl/api/Orgs/AutoCompleteOrgs?search_str=$orgString";
    SharedPreferences pref = await SharedPreferences.getInstance();
    String? token = pref.getString(CustomString.accessToken);
    final response = await http.get(Uri.parse(apiUrl),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        });

    if (response.statusCode == 200) {
      provider.orgList.clear();
      debugPrint("ORG---------------yes-->${response.body}");
      List<dynamic> data = jsonDecode(response.body);
      provider.setSearchedOrg(data);
    } else {
      debugPrint("---------------No-->${response.body}");
    }
  }
  static searchDepartment({context, orgId}) async {
    final provider = Provider.of<SearchDepartmentProvider>(context,listen: false);
    String apiUrl = "$baseUrl/api/Departments/ByOrgId?org_Id=$orgId";
    SharedPreferences pref = await SharedPreferences.getInstance();
    String? token = pref.getString(CustomString.accessToken);
    final response = await http.get(Uri.parse(apiUrl),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        });

    if (response.statusCode == 200) {
      provider.departmentList.clear();
      debugPrint("Department---------------yes-->${response.body}");
      List<dynamic> data = jsonDecode(response.body);
      provider.setSearchedDepartment(data);
    } else {
      debugPrint("---------------No-->${response.body}");
    }
  }
  static joinOrgRequest({context,orgID, dpID, dpName}) async {
    debugPrint("organizationId---->$orgID");
    debugPrint("departmentId---->$dpID");
    debugPrint("departmentName---->$dpName");
    Map<String, dynamic> parameter = {
      "Org_Id":orgID,
      "Dept_Id":dpID,
      "Dept_Req":dpName
    };
    const String apiUrl = "$baseUrl/api/OrgPersons/Create";
    SharedPreferences pref = await SharedPreferences.getInstance();
    String? token = pref.getString(CustomString.accessToken);
    final response = await http.post(Uri.parse(apiUrl),body: jsonEncode(parameter),headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        });
    if (response.statusCode == 200) {
      debugPrint("CreateORG---------------yes-->${response.body}");
      //Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>const ManageOrganization()));
      ApiConfig.getManageOrgData(context: context, tabIndex: 0);
      Navigator.pop(context);
    } else {
      debugPrint("---------------No-->${response.body}");
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Try again data will not added..")));
    }
  }
  static deleteOrgRequest({context, orgID, personID}) async {
    String apiUrl = "$baseUrl/api/OrgPersons/Delete?org_Id=$orgID&person_Id=$personID";
    SharedPreferences pref = await SharedPreferences.getInstance();
    String? token = pref.getString(CustomString.accessToken);
    final response = await http.delete(Uri.parse(apiUrl),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        });
    if (response.statusCode == 200) {
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>const ManageOrganization()));
      debugPrint("Delete ORG Request Success-------------yes-->${response.body}");
    } else {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Try again data not delete...")));
      debugPrint("Data not Delete Try again----------No-->${response.body}");
    }
  }
}