import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:versa_tribe/Utils/api_config.dart';
import '../../Providers/person_details_provider.dart';
import '../../Utils/custom_colors.dart';
import '../../Utils/custom_string.dart';

class EditDepartment extends StatefulWidget {

  final int? orgId;
  final int? parentDepId;
  final String? parentDepName;
  final int? depId;
  final String? depName;

  const EditDepartment({super.key, required this.orgId, this.depId, this.depName, this.parentDepId, this.parentDepName});

  @override
  State<EditDepartment> createState() => _EditDepartmentState();
}
class _EditDepartmentState extends State<EditDepartment> {

  final _formKey = GlobalKey<FormState>();
  TextEditingController searchParentDController = TextEditingController();
  TextEditingController newDController = TextEditingController();

  int? pDepId=0;
  @override
  void initState() {
    print("--{{{---->${widget.parentDepId}");
    print("--{{{---->${widget.depId}");
    print("--{{{---->${widget.depName}");
    print("--{{{---->${widget.parentDepName}");
    newDController.text = widget.depName.toString();
    searchParentDController.text = widget.parentDepName??"";
    super.initState();
  }

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
                },
                icon: const Icon(Icons.arrow_back_ios, color: CustomColors.kBlackColor),
                //replace with our own icon data.
              );
            }
        ),
        centerTitle: true,
        title: const Text(CustomString.updateDP, style: TextStyle(color: CustomColors.kBlueColor, fontFamily: 'Poppins')),
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

                Consumer<DepartmentProvider>(
                    builder: (context, val, child) {
                      return Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Checkbox(value: val.visible,
                              onChanged: (value){
                                val.setVisible(value);
                                if(value == false){
                                  searchParentDController.clear();
                                }else{
                                  //val.setVisibilitySearchList(true);
                                  //ApiConfig.searchPDepartment(context: context,orderId: widget.orgId);
                                }
                              }),
                          const Text(CustomString.chooseParentDepartment, style: TextStyle(fontSize: 14, fontFamily: 'Poppins')),
                        ],
                      );
                    }),

                Consumer<DepartmentProvider>(builder: (context, val, child) {
                  return searchParentDController.text != "" ? TextFormField(
                      controller: searchParentDController,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return CustomString.parentDP;
                        } else {
                          return null;
                        }
                      },
                      onTap: (){
                        //val.setVisibilitySearchList(true);
                        //val.notify();
                        //ApiConfig.searchPDepartment(context: context,orderId: widget.orgId);
                      },
                      enabled: false,
                      decoration: const InputDecoration(
                          hintText: "Parent department",
                          hintStyle: TextStyle(color: CustomColors.kLightGrayColor, fontSize: 14, fontFamily: 'Poppins')),
                      style: const TextStyle(color: CustomColors.kBlackColor, fontSize: 14, fontFamily: 'Poppins')
                  ) : const SizedBox();
                }
                ),

                Consumer<DepartmentProvider>(
                    builder: (context,val,child) {
                      return val.visible == true ?ListView.builder(
                          shrinkWrap: true,
                          itemCount: val.department.length,
                          itemBuilder: (context, index) {
                            return InkWell(
                              child:Card(
                                shadowColor: CustomColors.kBlueColor,
                                elevation: 3,
                                color: CustomColors.kGrayColor,
                                child: Container(
                                    padding:
                                    EdgeInsets.only(left: size.width * 0.02),
                                    height: size.height * 0.05,
                                    alignment: Alignment.centerLeft,
                                    child: Text(
                                        '${val.department[index].deptName}',
                                        style: const TextStyle(color: CustomColors.kLightGrayColor, fontFamily: 'Poppins'))),
                              ),
                              onTap: () async {
                                searchParentDController.text = val.department[index].deptName ?? searchParentDController.text;
                                pDepId = val.department[index].deptId;
                                val.setVisibilitySearchList(true);
                                val.setVisible(false);
                              },
                            );
                          }): const SizedBox();
                    }
                ),

                SizedBox(
                    width: size.width,
                    child: ElevatedButton(
                        onPressed: () {
                          print("cheque---parent department Id------>$pDepId------>${widget.parentDepId}");
                          ApiConfig.editDepartment(context: context,departmentName: newDController.text, depId: widget.depId, parentDepId:pDepId==0?widget.parentDepId==0||widget.parentDepId==null?pDepId:widget.parentDepId:pDepId, orgID: widget.orgId );
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
