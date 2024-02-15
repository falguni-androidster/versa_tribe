import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
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
  TextEditingController orgNameController = TextEditingController();
  TextEditingController aboutOrgController = TextEditingController();
  TextEditingController mobileController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController cityController = TextEditingController();
  TextEditingController countryController = TextEditingController();

  int? orgID;
  dynamic providerBtn;
  dynamic boolProvider;

  @override
  void initState() {
    orgID = widget.orgId;
    providerBtn = Provider.of<OrgProfileBtnVisibility>(context,listen:false);
    boolProvider = Provider.of<CirculerIndicationProvider>(context,listen:false);
    getAdminProfileOldData(orgId: widget.orgId);
    _loadData();
    super.initState();
  }

  _loadData() async {
    // Replace this with your actual data loading logic
    await Future.delayed(const Duration(seconds: 1));
    boolProvider.setLoading(false);
  }

  getAdminProfileOldData({orgId}) async {
    ApiConfig apiConfig =ApiConfig();
    bool isValidToken = await apiConfig.isTokenValid();
    if (isValidToken) {
      SharedPreferences pref = await SharedPreferences.getInstance();
      String? token = pref.getSharedPrefStringValue(key: CustomString.accessToken);
      String profileUrl = '${ApiConfig.baseUrl}/api/OrgInfo/ById?id=$orgId';
      final response = await http.get(Uri.parse(profileUrl), headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      });
      if (response.statusCode == 200) {
        debugPrint("getOrgAdminData Response------->->  ${response.body}");
        OrgAdminProfile orgAdminProfile = OrgAdminProfile.fromJson(jsonDecode(response.body));
        orgAdminProfile.orgId==null?providerBtn.setVisibility(false):null;
        orgNameController.text = widget.orgName;
        aboutOrgController.text = orgAdminProfile.aboutOrg!;
        cityController.text = orgAdminProfile.city!;
        mobileController.text = orgAdminProfile.contactNumber!;
        emailController.text = orgAdminProfile.contactEmail!;
        countryController.text = orgAdminProfile.country!;
      } else {
        debugPrint("Have Error in getORG ADMIN DATA------------<");
      }
    } else {
      print("refresh----isValidToken-------false-----");
      throw Exception('|-------------Cheque Refresh Token Function it has error---------|');
    }
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Scaffold(
        backgroundColor: CustomColors.kWhiteColor,
        appBar: AppBar(
          backgroundColor: CustomColors.kGrayColor,
          leading: InkWell(
            child: const Icon(Icons.arrow_back_ios, color: CustomColors.kBlackColor),
            onTap: () {
              boolProvider.setLoading(true);
              Navigator.pop(context);
            },
          ),
          centerTitle: true,
          title: const Text(CustomString.orgDetail,style: TextStyle(
              fontFamily: 'Poppins',fontSize: 16,
              color: CustomColors.kBlueColor)),
        ),
        body:
        Consumer<CirculerIndicationProvider>(
          builder: (context, val, child) {
            return val.loading == true ?
            SizedBox(
              height: size.height*0.21,
              child: const Center(
                child: CircularProgressIndicator(),
              ),
            ): SingleChildScrollView(
              child: Form(
                key: _formKey,
                child: Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            SizedBox(height: size.height * 0.02),

                            /// Profile Pic
                            const Center(
                              child: CircleAvatar(
                                radius: 50.0,
                                backgroundImage:
                                AssetImage(ImagePath.profilePath),
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
                              style: const TextStyle(color: CustomColors.kBlackColor,fontFamily: 'Poppins'),
                            ),

                            SizedBox(height: size.height * 0.01),

                            /// About Organization Field
                            const Text(CustomString.aboutOrgName,
                                style: TextStyle(color: CustomColors.kBlueColor, fontSize: 16)),
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
                            const Text(CustomString.contactInfo,
                                style: TextStyle(color: CustomColors.kBlueColor, fontSize: 16)),
                            SizedBox(height: size.height * 0.02),
                            TextFormField(
                              keyboardType: TextInputType.number,
                              maxLength: 10,
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
                            const Text(CustomString.addressInfo,
                                style: TextStyle(color: CustomColors.kBlueColor, fontSize: 16)),
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
                                  labelStyle: TextStyle(color: CustomColors.kLightGrayColor, fontSize: 14,fontFamily: 'Poppins')),
                              style: const TextStyle(
                                  color: CustomColors.kBlackColor,fontFamily: 'Poppins'),
                            ),

                            SizedBox(height: size.height * 0.02),

                            /// Update/Create Profile Button
                            SizedBox(
                              width: double.infinity,
                              child: Consumer<OrgProfileBtnVisibility>(
                                  builder: (context,val,child) {
                                    return ElevatedButton(
                                      onPressed:orgID!=null? (){
                                        val.updateBtnVisible==true?
                                        apiConfig.updateOrgAdminProfile(context: context,orgId: orgID,aboutOrg: aboutOrgController.text,city: cityController.text,country: countryController.text,email: emailController.text,number: mobileController.text):
                                        apiConfig.addOrgPersonData(context: context,orgId: orgID,aboutORG: aboutOrgController.text,city: cityController.text,country: countryController.text,email: emailController.text,mobileNo: mobileController.text, orgName: widget.orgName);
                                      }:(){},
                                      style: ElevatedButton.styleFrom(
                                          backgroundColor: CustomColors.kBlueColor,
                                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6),),
                                          padding: const EdgeInsets.all(14)),
                                      child: val.updateBtnVisible==true?const Text(CustomString.updateOrgDetail,
                                        style: TextStyle(fontSize: 14, color: Colors.white, fontFamily: 'Poppins', fontWeight: FontWeight.w600),
                                      ):const Text(CustomString.createOrgDetail,
                                        style: TextStyle(fontSize: 14, color: Colors.white, fontFamily: 'Poppins', fontWeight: FontWeight.w600),
                                      ),
                                    );
                                  }
                              ),
                            ),
                          ],
                        ),
                      )

                /*child: FutureBuilder(
                  future:
                  getAdminProfileOldData(orgId: widget.orgId),
                    builder: (context,val) {
                    if(val.connectionState==ConnectionState.waiting){
                      return SizedBox(
                        height: size.height*0.21,
                        child: const Center(
                          child: CircularProgressIndicator(),
                        ),
                      );
                    }else if(val.connectionState==ConnectionState.done){
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
                                backgroundImage:
                                AssetImage(ImagePath.profilePath),
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
                              style: const TextStyle(color: CustomColors.kBlackColor,fontFamily: 'Poppins'),
                            ),

                            SizedBox(height: size.height * 0.01),

                            /// About Organization Field
                            const Text(CustomString.aboutOrgName,
                                style: TextStyle(color: CustomColors.kBlueColor, fontSize: 16)),
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
                            const Text(CustomString.contactInfo,
                                style: TextStyle(color: CustomColors.kBlueColor, fontSize: 16)),
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
                            const Text(CustomString.addressInfo,
                                style: TextStyle(color: CustomColors.kBlueColor, fontSize: 16)),
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
                                  labelStyle: TextStyle(color: CustomColors.kLightGrayColor, fontSize: 14,fontFamily: 'Poppins')),
                              style: const TextStyle(
                                  color: CustomColors.kBlackColor,fontFamily: 'Poppins'),
                            ),

                            SizedBox(height: size.height * 0.02),

                            /// Update/Create Profile Button
                            SizedBox(
                              width: double.infinity,
                              child: Consumer<OrgProfileBtnVisibility>(
                                  builder: (context,val,child) {
                                    return ElevatedButton(
                                      onPressed:orgID!=null? (){
                                        val.updateBtnVisible==true? ApiConfig.editOrgAdminProfile(context: context,orgId: orgID,aboutOrg: aboutOrgController.text,city: cityController.text,country: countryController.text,email: emailController.text,number: mobileController.text):
                                        ApiConfig.addOrgPersonData(context: context,orgId: orgID,aboutORG: aboutOrgController.text,city: cityController.text,country: countryController.text,email: emailController.text,mobileNo: mobileController.text, orgName: widget.orgName);
                                      }:(){},
                                      style: ElevatedButton.styleFrom(
                                          backgroundColor: CustomColors.kBlueColor,
                                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6),),
                                          padding: const EdgeInsets.all(14)),
                                      child: val.updateBtnVisible==true?const Text(CustomString.updateOrgDetail,
                                        style: TextStyle(fontSize: 14, color: Colors.white, fontFamily: 'Poppins', fontWeight: FontWeight.w600),
                                      ):const Text(CustomString.createOrgDetail,
                                        style: TextStyle(fontSize: 14, color: Colors.white, fontFamily: 'Poppins', fontWeight: FontWeight.w600),
                                      ),
                                    );
                                  }
                              ),
                            ),
                          ],
                        ),
                      );
                    }else{
                      debugPrint("------error when load data in update admin profile-----");
                    }
                    return Container();
                  }
                ),*/
              ),
            );
          }
        ));
  }
 }
