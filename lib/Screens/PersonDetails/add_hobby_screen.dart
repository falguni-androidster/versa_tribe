import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:versa_tribe/Utils/api_config.dart';
import 'package:versa_tribe/Utils/custom_colors.dart';
import 'package:versa_tribe/Utils/custom_string.dart';

import '../../Providers/person_details_provider.dart';

class AddHobbyScreen extends StatefulWidget {
  const AddHobbyScreen({super.key});

  @override
  State<AddHobbyScreen> createState() => _AddHobbyScreenState();
}

class _AddHobbyScreenState extends State<AddHobbyScreen> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController hobbyController = TextEditingController();
  dynamic providerHobby;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    providerHobby = Provider.of<SearchHobbyProvider>(context,listen: false);
    providerHobby.hobbyList.clear();
  }
  @override
  Widget build(BuildContext context) {
    final providerHobby = Provider.of<SearchHobbyProvider>(context, listen: false);
    var mHeight = MediaQuery.of(context).size.height;
    var mWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: CustomColors.kWhiteColor,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon:
              const Icon(Icons.arrow_back_ios, color: CustomColors.kBlackColor),
          //replace with our own icon data.
        ),
        centerTitle: true,
        title: const Text(CustomString.createHobby,
            style: TextStyle(color: CustomColors.kBlueColor)),
      ),
      body: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Padding(
            padding: EdgeInsets.symmetric(
                horizontal: mWidth * 0.04, vertical: mHeight * 0.02),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                /// Hobby name
                TextFormField(
                    controller: hobbyController,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return CustomString.hobbyRequired;
                      } else {
                        return null;
                      }
                    },
                    onChanged: (value) {
                      if (value != "") {
                        ApiConfig.searchHobby(context: context, hobbyString: value);
                        providerHobby.hobbyList.clear();
                      }
                      providerHobby.hobbyList.clear();
                      providerHobby.setVisible(true);
                    },
                    cursorColor: CustomColors.kBlueColor,
                    decoration: const InputDecoration(
                        labelText: CustomString.searchHobby,
                        labelStyle: TextStyle(
                            color: CustomColors.kLightGrayColor, fontSize: 14)),
                    style: const TextStyle(color: CustomColors.kBlackColor)),
                Consumer<SearchHobbyProvider>(builder: (context, val, child) {
                  return ListView.builder(
                      shrinkWrap: true,
                      itemCount: val.hobbyList.length,
                      itemBuilder: (context, index) {
                        debugPrint("INSTITUTE--------->${val.hobbyList[index].name}");
                        return val.visible == true
                            ? InkWell(
                          child: Card(
                            shadowColor: CustomColors.kBlueColor,
                            elevation: 3,
                            color: CustomColors.kGrayColor,
                            child: Container(
                                padding:
                                EdgeInsets.only(left: mWidth * 0.02),
                                height: mHeight * 0.05,
                                alignment: Alignment.centerLeft,
                                child: Text(
                                    '${val.hobbyList[index].name}',
                                    style: const TextStyle(
                                        color: CustomColors
                                            .kLightGrayColor))),
                          ),
                          onTap: () async {
                            hobbyController.text =
                                val.hobbyList[index].name ??
                                    hobbyController.text;
                            val.setVisible(false);
                          },
                        )
                            : Container();
                      });
                }),

                SizedBox(height: mHeight * 0.03),

                /// Submit Button
                SizedBox(
                    width: double.infinity,
                    height: mHeight * 0.06,
                    child: ElevatedButton(
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          ApiConfig.addHobbyData(
                              context: context,
                              hobbyName: hobbyController.text);
                        } else {
                          return;
                        }
                      },
                      style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all(
                              CustomColors.kBlueColor),
                          shape:
                              MaterialStateProperty.all<RoundedRectangleBorder>(
                                  RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10),
                                      side: const BorderSide(
                                          color: Colors.transparent)))),
                      child: const Text(CustomString.buttonContinue,
                          style: TextStyle(
                            color: CustomColors.kWhiteColor,
                            fontSize: 20,
                            fontWeight: FontWeight.w600,
                          )),
                    )),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
