import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:versa_tribe/Screens/home_screen.dart';
import 'package:http/http.dart' as http;
import 'package:versa_tribe/extension.dart';

class UpdateAdminProfile extends StatefulWidget {

  final String orgName;
  final int orgId;

  const UpdateAdminProfile({super.key, required this.orgName, required this.orgId});

  @override
  State<UpdateAdminProfile> createState() => _UpdateAdminProfileState();
}

class _UpdateAdminProfileState extends State<UpdateAdminProfile> {

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final TextEditingController orgNameController = TextEditingController();
  final TextEditingController aboutOrgController = TextEditingController();
  final TextEditingController mobileController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController cityController = TextEditingController();
  final TextEditingController countryController = TextEditingController();

  dynamic providerBtn;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    orgNameController.dispose();
    aboutOrgController.dispose();
    mobileController.dispose();
    emailController.dispose();
    cityController.dispose();
    countryController.dispose();
    super.dispose();
  }

  Future<OrgAdminProfile> getAdminProfileOldData({orgId}) async {
    OrgAdminProfile orgAdminProfile = OrgAdminProfile();
    SharedPreferences pref = await SharedPreferences.getInstance();
    String? token = pref.getString(CustomString.accessToken);

    String profileUrl = '${ApiConfig.baseUrl}/api/OrgInfo/ById?id=$orgId';
    final response = await http.get(Uri.parse(profileUrl), headers: {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    });
    debugPrint("get OrgPerson data Response------->>  ${response.body}");
    if (response.statusCode == 200) {
      debugPrint("get OrgPerson data Response------->O>->  ${response.body}");
      dynamic data = jsonDecode(response.body);
      orgAdminProfile = OrgAdminProfile.fromJson(data);
    } else {
      orgAdminProfile = OrgAdminProfile();
    }
    return orgAdminProfile;
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Scaffold(
        backgroundColor: CustomColors.kWhiteColor,
        appBar: AppBar(
          backgroundColor: CustomColors.kWhiteColor,
          leading: InkWell(
            child: const Icon(Icons.arrow_back_ios,
                color: CustomColors.kBlackColor),
            onTap: () {
              Navigator.pop(context);
            },
          ),
          centerTitle: true,
          title: const Text(CustomString.orgDetail,
              style: TextStyle(
                  fontFamily: 'Poppins', color: CustomColors.kBlueColor)),
        ),
        body: Form(
          key: _formKey,
          child: SingleChildScrollView(
              child: FutureBuilder(
                  future: getAdminProfileOldData(orgId: widget.orgId).then((value) {
                    providerBtn = Provider.of<OrgProfileBtnVisibility>(context, listen: false);
                    value.orgId == null ? providerBtn.setVisibility(false) : null;
                    orgNameController.text = widget.orgName;
                    aboutOrgController.text = value.aboutOrg!;
                    cityController.text = value.city!;
                    mobileController.text = value.contactNumber!;
                    emailController.text = value.contactEmail!;
                    countryController.text = value.country!;
                  }),
                  builder: (context, val) {
                    if (val.connectionState == ConnectionState.waiting) {
                      return SizedBox(
                        height: size.height * 0.21,
                        child: const Center(
                          child: CircularProgressIndicator(),
                        ),
                      );
                    } else if (val.connectionState == ConnectionState.done) {
                      return containerAdminProfile(size);
                    } else {
                      debugPrint("------error when load data in update admin profile-----");
                    }
                    return Container();
                  }
                  )
          ),
        )
    );
  }

  Future<void> updateProfileClick(context) async {
    if (_formKey.currentState!.validate()) {
      SharedPreferences pref = await SharedPreferences.getInstance();
      String? token = pref.getString(CustomString.accessToken);

      Map data = {
        'FirstName': orgNameController.text.toString(),
        'City': cityController.text.toString(),
        'Country': countryController.text.toString(),
      };

      const String profileUrl = '${ApiConfig.baseUrl}/api/Person/Update';
      final response =
          await http.put(Uri.parse(profileUrl), body: data, headers: {
        'Authorization': 'Bearer $token',
      });
      const CircularProgressIndicator();
      if (response.statusCode == 200) {
        showToast(context, CustomString.profileSuccessUpdated);
        if (!mounted) return;
        _navigateToNextScreen(context);
      } else {
        showToast(context, CustomString.somethingWrongMessage);
      }
    }
  }

  void _navigateToNextScreen(BuildContext context) {
    Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => const HomeScreen()));
  }

  Widget containerAdminProfile(Size size) {
    return Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            SizedBox(height: size.height * 0.02),

            /// Profile Pic
            const Center(
              child: CircleAvatar(
                radius: 50.0,
                backgroundImage: AssetImage(ImagePath.profilePath),
              ),
            ),

            SizedBox(height: size.height * 0.02),

            /// organization Name Field
            TextFormField(
              readOnly: true,
              controller: orgNameController,
              validator: (value) {
                if (value!.isEmpty) {
                  return CustomString.orgNameRequired;
                } // using regular expression
                else {
                  return null;
                }
              },
              decoration: const InputDecoration(
                  labelText: CustomString.orgName,
                  labelStyle: TextStyle(color: CustomColors.kLightGrayColor, fontSize: 14, fontFamily: 'Poppins')),
              style: const TextStyle(color: CustomColors.kBlackColor, fontFamily: 'Poppins'),
            ),

            SizedBox(height: size.height * 0.01),

            /// About Organization Field
            const Text(CustomString.aboutOrgName, style: TextStyle(color: CustomColors.kBlueColor, fontSize: 16)),

            SizedBox(height: size.height * 0.02),

            TextFormField(
              maxLines: 3,
              controller: aboutOrgController,
              validator: (value) {
                if (value!.isEmpty) {
                  return CustomString.aboutOrgRequired;
                } // using regular expression
                else {
                  return null;
                }
              },
              decoration: const InputDecoration(
                  labelText: CustomString.aboutOrgName,
                  labelStyle: TextStyle(color: CustomColors.kLightGrayColor, fontFamily: 'Poppins', fontSize: 14)),
              style: const TextStyle(color: CustomColors.kBlackColor, fontFamily: 'Poppins'),
            ),

            SizedBox(height: size.height * 0.01),

            /// mobile number Field
            const Text(CustomString.contactInfo, style: TextStyle(color: CustomColors.kBlueColor, fontSize: 16)),

            SizedBox(height: size.height * 0.02),

            TextFormField(
              controller: mobileController,
              validator: (value) {
                if (value!.isEmpty) {
                  return CustomString.mobileRequired;
                } // using regular expression
                else {
                  return null;
                }
              },
              decoration: const InputDecoration(
                  labelText: CustomString.mobileLabel,
                  labelStyle: TextStyle(color: CustomColors.kLightGrayColor, fontFamily: 'Poppins', fontSize: 14)),
              style: const TextStyle(color: CustomColors.kBlackColor, fontFamily: 'Poppins'),
            ),
            SizedBox(height: size.height * 0.02),

            TextFormField(
              controller: emailController,
              validator: (value) {
                if (value!.isEmpty) {
                  return CustomString.emailRequired;
                } // using regular expression
                else {
                  return null;
                }
              },
              decoration: const InputDecoration(
                  labelText: CustomString.emailLabel,
                  labelStyle: TextStyle(color: CustomColors.kLightGrayColor, fontFamily: 'Poppins', fontSize: 14)),
              style: const TextStyle(color: CustomColors.kBlackColor, fontFamily: 'Poppins'),
            ),

            SizedBox(height: size.height * 0.01),

            /// Contact Fields
            const Text(CustomString.addressInfo, style: TextStyle(color: CustomColors.kBlueColor, fontSize: 16)),

            SizedBox(height: size.height * 0.02),

            TextFormField(
              controller: cityController,
              validator: (value) {
                if (value!.isEmpty) {
                  return CustomString.cityRequired;
                } // using regular expression
                else {
                  return null;
                }
              },
              decoration: const InputDecoration(
                  labelText: CustomString.city,
                  labelStyle: TextStyle(color: CustomColors.kLightGrayColor, fontFamily: 'Poppins', fontSize: 14)),
              style: const TextStyle(color: CustomColors.kBlackColor, fontFamily: 'Poppins'),
            ),

            SizedBox(height: size.height * 0.02),

            /// Country Field
            TextFormField(
              controller: countryController,
              validator: (value) {
                if (value!.isEmpty) {
                  return CustomString.countryRequired;
                } // using regular expression
                else {
                  return null;
                }
              },
              decoration: const InputDecoration(
                  labelText: CustomString.country,
                  labelStyle: TextStyle(color: CustomColors.kLightGrayColor, fontSize: 14, fontFamily: 'Poppins')),
              style: const TextStyle(color: CustomColors.kBlackColor, fontFamily: 'Poppins'),
            ),

            SizedBox(height: size.height * 0.02),

            /// Update/Create Profile Button
            SizedBox(
              width: double.infinity,
              child: Consumer<OrgProfileBtnVisibility>(
                  builder: (context, val, child) {
                    return ElevatedButton(
                      onPressed: () {
                        val.updateBtnVisible == true ?
                        ApiConfig.editOrgAdminProfile(context: context, orgId: widget.orgId, aboutOrg: aboutOrgController.text, city: cityController.text, country: countryController.text, email: emailController.text, number: mobileController.text) :
                        ApiConfig.addOrgPersonData(context: context, orgId: widget.orgId, aboutORG: aboutOrgController.text, city: cityController.text, country: countryController.text, email: emailController.text, mobileNo: mobileController.text, orgName: widget.orgName);
                      },
                      style: ElevatedButton.styleFrom(
                          backgroundColor: CustomColors.kBlueColor,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
                          padding: const EdgeInsets.all(14)),
                      child: val.updateBtnVisible == true ?
                      const Text(
                          CustomString.updateOrgDetail,
                          style: TextStyle(fontSize: 14, color: Colors.white, fontFamily: 'Poppins', fontWeight: FontWeight.w600))
                          : const Text(
                          CustomString.createOrgDetail,
                          style: TextStyle(fontSize: 14, color: Colors.white, fontFamily: 'Poppins', fontWeight: FontWeight.w600)),
                    );
                  }),
            ),
          ],
        )
    );
  }

}
