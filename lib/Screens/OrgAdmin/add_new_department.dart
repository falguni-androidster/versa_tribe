import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:versa_tribe/Utils/api_config.dart';
import '../../Providers/person_details_provider.dart';
import '../../Utils/custom_colors.dart';
import '../../Utils/custom_string.dart';

class AddNewDepartment extends StatefulWidget {
  int? orgId;
  AddNewDepartment({super.key, required this.orgId});
  @override
  State<AddNewDepartment> createState() => _AddNewDepartmentState();
}
class _AddNewDepartmentState extends State<AddNewDepartment> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController searchParentDController = TextEditingController();
  TextEditingController newDController = TextEditingController();
  late int pDepId;

  @override
  Widget build(BuildContext context) {
    final mHeight = MediaQuery.of(context).size.height;
    final mWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: CustomColors.kWhiteColor,
        leading: Consumer<SearchParentDPProvider>(
            builder: (context, val, child) {
            return IconButton(
              onPressed: () {
                Navigator.pop(context);
                val.setVisibilitySearchList(false);
                val.notify();
              },
              icon: const Icon(Icons.arrow_back_ios, color: CustomColors.kBlackColor),
              //replace with our own icon data.
            );
          }
        ),
        centerTitle: true,
        title: const Text(CustomString.addNewDP,
            style: TextStyle(color: CustomColors.kBlueColor)),
      ),
      body:  Form(
        key: _formKey,
        child: Container(
          margin: EdgeInsets.symmetric(horizontal: mWidth*0.04),
          child: SingleChildScrollView(
            child: Column(
              children: [
                SizedBox(height: mHeight*0.05,),
                TextFormField(
                  controller: newDController,
                    decoration: const InputDecoration(
                        labelText: CustomString.newDpLabel,
                        labelStyle: TextStyle(
                            color: CustomColors.kLightGrayColor,
                            fontSize: 14)),
                    style:
                    const TextStyle(color: CustomColors.kBlackColor)
                ),
                SizedBox(height: mHeight*0.01,),

                Consumer<SearchParentDPProvider>(
                    builder: (context, val, child) {
                      return Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Checkbox(value: val.visible,
                              onChanged: (value){
                            val.setVisible(value);
                            if(value==false){
                              searchParentDController.clear();
                            }else{
                              val.setVisibilitySearchList(true);
                              ApiConfig.searchPDepartment(context: context,oderId: 16);
                            }
                          }),
                          const Text("Choose parent department"),
                        ],
                      );
                    }),

                Consumer<SearchParentDPProvider>(builder: (context, val, child) {
                    return val.visible == true? TextFormField(
                      controller: searchParentDController,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return CustomString.parentDP;
                        } else {
                          return null;
                        }
                      },
                        onTap: (){
                          val.setVisibilitySearchList(true);
                          val.notifyListeners();
                          ApiConfig.searchPDepartment(context: context,oderId: 16);
                        },
                      decoration: const InputDecoration(
                          hintText: "Parent department",
                          hintStyle: TextStyle(color: CustomColors.kLightGrayColor, fontSize: 14)),
                          style: const TextStyle(color: CustomColors.kBlackColor)
                    ):const SizedBox();
                  }
                ),

                Consumer<SearchParentDPProvider>(builder: (context, val, child) {
                  return val.visibilitySearch==true
                      ? ListView.builder(
                      shrinkWrap: true,
                      itemCount: val.dpList.length,
                      itemBuilder: (context, index) {
                        return InkWell(
                          child: val.dpList[index].parentDeptName!=null?Card(
                            shadowColor: CustomColors.kBlueColor,
                            elevation: 3,
                            color: CustomColors.kGrayColor,
                            child: Container(
                                padding:
                                EdgeInsets.only(left: mWidth * 0.02),
                                height: mHeight * 0.05,
                                alignment: Alignment.centerLeft,
                                child: Text(
                                    '${val.dpList[index].parentDeptName}',
                                    style: const TextStyle(
                                        color: CustomColors
                                            .kLightGrayColor))),
                          ):Container(),
                          onTap: () async {
                            searchParentDController.text = val.dpList[index].parentDeptName ?? searchParentDController.text;
                            pDepId = val.dpList[index].parentDeptId!;
                            val.setVisibilitySearchList(false);
                            val.notifyListeners();
                          },
                        );
                      }): Container();
                }),
                SizedBox(
                  width: mWidth,
                    child: ElevatedButton(onPressed: (){
                      print("parent Dep ID--=-=----->$pDepId");
                      ApiConfig.addNewDepartment(context: context,departmentName: newDController.text,parentDepId: pDepId,orgID: widget.orgId);
                    }, child: const Text("Continue")))
              ],
            ),
          ),
        ),
      ),
    );
  }
}
