import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:versa_tribe/Utils/api_config.dart';
import '../../Providers/person_details_provider.dart';
import '../../Utils/custom_colors.dart';
import '../../Utils/custom_string.dart';

class AddNewDepartment extends StatefulWidget {

  final int? orgId;

  const AddNewDepartment({super.key, required this.orgId});

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
    final size = MediaQuery.of(context).size;
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
        title: const Text(CustomString.addNewDP, style: TextStyle(color: CustomColors.kBlueColor, fontFamily: 'Poppins')),
      ),
      body:  Form(
        key: _formKey,
        child: Container(
          margin: EdgeInsets.symmetric(horizontal: size.width * 0.04),
          child: SingleChildScrollView(
            child: Column(
              children: [
                SizedBox(height: size.height * 0.05),
                TextFormField(
                  controller: newDController,
                    decoration: const InputDecoration(
                        labelText: CustomString.newDpLabel,
                        labelStyle: TextStyle(
                            color: CustomColors.kLightGrayColor,
                            fontSize: 14, fontFamily: 'Poppins')),
                    style:
                    const TextStyle(color: CustomColors.kBlackColor, fontSize: 14, fontFamily: 'Poppins')
                ),

                SizedBox(height: size.height * 0.01),

                Consumer<SearchParentDPProvider>(
                    builder: (context, val, child) {
                      return Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Checkbox(value: val.visible, onChanged: (value){
                            val.setVisible(value);
                            if(value == false){
                              searchParentDController.clear();
                            }else{
                              val.setVisibilitySearchList(true);
                              ApiConfig.searchPDepartment(context: context,orderId: widget.orgId);
                            }
                          }),
                          const Text(CustomString.chooseParentDepartment, style: TextStyle(fontSize: 14, fontFamily: 'Poppins')),
                        ],
                      );
                    }),

                Consumer<SearchParentDPProvider>(builder: (context, val, child) {
                    return val.visible == true ? TextFormField(
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
                          val.notify();
                          ApiConfig.searchPDepartment(context: context,orderId: widget.orgId);
                        },
                      decoration: const InputDecoration(
                          hintText: "Parent department",
                          hintStyle: TextStyle(color: CustomColors.kLightGrayColor, fontSize: 14, fontFamily: 'Poppins')),
                          style: const TextStyle(color: CustomColors.kBlackColor, fontSize: 14, fontFamily: 'Poppins')
                    ) : const SizedBox();
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
                                EdgeInsets.only(left: size.width * 0.02),
                                height: size.height * 0.05,
                                alignment: Alignment.centerLeft,
                                child: Text(
                                    '${val.dpList[index].parentDeptName}',
                                    style: const TextStyle(color: CustomColors.kLightGrayColor, fontFamily: 'Poppins'))),
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
                  width: size.width,
                    child: ElevatedButton(
                        onPressed: () {
                          ApiConfig.addNewDepartment(context: context,departmentName: newDController.text);
                          },
                        child: const Text(CustomString.buttonContinue, style: TextStyle(fontFamily: 'Poppins'))
                    )
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
