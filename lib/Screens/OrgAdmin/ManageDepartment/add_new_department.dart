import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:versa_tribe/extension.dart';

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

  int? pDepId;
  @override
  void initState() {
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
                          debugPrint("cheque---parent department Id------>$pDepId");
                          ApiConfig.addNewDepartment(context: context,departmentName: newDController.text, depId: pDepId, orgID: widget.orgId );
                          },
                        style: ElevatedButton.styleFrom(shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6))),
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
