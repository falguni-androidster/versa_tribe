import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:versa_tribe/Utils/api_config.dart';
import '../../Providers/person_details_provider.dart';
import '../../Utils/custom_colors.dart';
import '../../Utils/custom_string.dart';

class AddNewDepartment extends StatefulWidget {
  const AddNewDepartment({super.key});
  @override
  State<AddNewDepartment> createState() => _AddNewDepartmentState();
}
class _AddNewDepartmentState extends State<AddNewDepartment> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController searchParentDController = TextEditingController();
  TextEditingController newDController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: CustomColors.kWhiteColor,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(Icons.arrow_back_ios, color: CustomColors.kBlackColor),
          //replace with our own icon data.
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
                TextFormField(
                  enabled: false,
                  controller: searchParentDController,
                  validator: (value) {
                    if (value!.isEmpty) {
                      return CustomString.parentDP;
                    } else {
                      return null;
                    }
                  },
                  decoration: const InputDecoration(
                      hintText: CustomString.parentDepartment,
                      hintStyle: TextStyle(color: CustomColors.kLightGrayColor, fontSize: 14, fontFamily: 'Poppins')),
                      style: const TextStyle(color: CustomColors.kBlackColor, fontSize: 14, fontFamily: 'Poppins')
                ),
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
                              ApiConfig.searchPDepartment(context: context, orderId: 16);
                            }
                          }),
                          const Text(CustomString.chooseParentDepartment, style: TextStyle(fontSize: 14, fontFamily: 'Poppins')),
                        ],
                      );
                    }),
                Consumer<SearchParentDPProvider>(builder: (context, val, child) {
                  return ListView.builder(
                      shrinkWrap: true,
                      itemCount: val.dpList.length,
                      itemBuilder: (context, index) {
                        return val.visible == true ? InkWell(
                          child: val.dpList[index].parentDeptName != null ? Card(
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
                                    style: const TextStyle(
                                        color: CustomColors
                                            .kLightGrayColor))),
                          ) : Container(),
                          onTap: () async {
                            searchParentDController.text = val.dpList[index].parentDeptName ?? searchParentDController.text;
                            val.setVisible(false);
                          },
                        )
                            : Container();
                      });
                }),
                SizedBox(height: size.height * 0.1),
                SizedBox(
                  width: size.width,
                    child: ElevatedButton(
                        onPressed: () {
                          ApiConfig.addNewDepartment(context: context,departmentName: newDController.text);
                          },
                        child: const Text(CustomString.buttonContinue)
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
