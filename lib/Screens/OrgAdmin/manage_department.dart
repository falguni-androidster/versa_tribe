import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:versa_tribe/Providers/person_details_provider.dart';
import 'package:versa_tribe/Screens/OrgAdmin/add_new_department.dart';
import 'package:versa_tribe/Screens/OrgAdmin/edit_department.dart';
import 'package:versa_tribe/Utils/api_config.dart';
import 'package:versa_tribe/Utils/image_path.dart';
import '../../Utils/custom_colors.dart';
import '../../Utils/custom_string.dart';

class ManageDepartment extends StatefulWidget {

  final int orgId;

  ManageDepartment({super.key, required this.orgId});

  @override
  State<ManageDepartment> createState() => _ManageDepartmentState();
}


class _ManageDepartmentState extends State<ManageDepartment> {

  final Future<String> _calculation = Future<String>.delayed(
    const Duration(seconds: 2),
        () => 'Data Loaded',
  );
  @override
  void initState() {
    super.initState();
    ApiConfig.getDepartment(context: context,orgId: widget.orgId);
  }
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: CustomColors.kWhiteColor,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: CustomColors.kGrayColor,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(Icons.arrow_back_ios, color: CustomColors.kBlackColor) //replace with our own icon data.
        ),
        centerTitle: true,
        title: const Text(CustomString.manageDepartment,
            style: TextStyle(color: CustomColors.kBlueColor, fontFamily: 'Poppins')),
        actions: [IconButton(onPressed: (){
          Navigator.push(context, MaterialPageRoute(builder: (context)=> AddNewDepartment(orgId: widget.orgId,)));
        }, icon: const Icon(Icons.add,color: CustomColors.kBlackColor,))],
      ),
      // body: FutureBuilder(
      //   future: ApiConfig.getDepartment(oderId: 16),
      //   builder: (context,snapshot) {
      //     if(snapshot.connectionState==ConnectionState.waiting){
      //       return CircularProgressIndicator(color: Colors.redAccent,);
      //     }else if(snapshot.hasError){
      //       return Image.asset(ImagePath.search);
      //     }else if(snapshot.connectionState==ConnectionState.done){
      //       print("-=->${snapshot.data.}");
      //       return ListView.builder(
      //           itemCount: 10,
      //           itemBuilder: (context,index){
      //             return Card(
      //               margin: EdgeInsets.symmetric(horizontal: mWidth*0.01,vertical: mHeight*0.005),
      //               elevation: 4,
      //               child: Row(
      //                 children: [
      //                   CircleAvatar(radius: 30,child: Image.asset(ImagePath.noData,fit: BoxFit.cover,)),
      //                   Column(
      //                     crossAxisAlignment: CrossAxisAlignment.start,
      //                     mainAxisAlignment: MainAxisAlignment.start,
      //                     children: [
      //                       Text("Admin"),
      //                       Row(
      //                         children: [
      //                           Text("PD : "),
      //                           Text("UI/UX",style: TextStyle(color: CustomColors.kBlueColor),),
      //                         ],
      //                       ),
      //                     ],
      //                   ),
      //                   Spacer(),
      //                   IconButton(onPressed: (){}, icon: Icon(Icons.more_vert))
      //                 ],
      //               ),
      //             );
      //           }
      //       );
      //     }
      //     else{
      //       return Image.asset(ImagePath.noData);
      //     }
      //   }
      // ),

      body: Consumer<DepartmentProvider>(
          builder: (context,val,child) {
          return val.department.isNotEmpty?
          Padding(
            padding: EdgeInsets.only(top: size.height * 0.018),
            child: ListView.builder(
                itemCount: val.department.length,
                itemBuilder: (context,index){
                  return Container(
                    decoration: const BoxDecoration(
                        color: CustomColors.kGrayColor,
                        borderRadius: BorderRadius.all(Radius.circular(5))
                    ),
                    margin: EdgeInsets.only(left: size.width * 0.025,right: size.width * 0.03, top: size.height * 0.01,bottom: size.height * 0.005),
                    child: Row(
                      children: [
                        Padding(
                          padding: EdgeInsets.all(size.height*0.01+size.width*0.01),
                          child: Container(
                              clipBehavior: Clip.hardEdge,
                              decoration: BoxDecoration(borderRadius: BorderRadius.circular(10)),
                              child: Image.asset("assets/images/5.jpeg",height: size.height*0.05,fit: BoxFit.cover,)),
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Text(val.department[index].deptName!,style: const TextStyle(fontFamily: 'Poppins')), val.department[index].parentDeptName!=null ?
                            Row(
                              children: [
                                const Text("PD : ", style: TextStyle(fontFamily: 'Poppins')),
                                Text(val.department[index].parentDeptName!,style: const TextStyle(color: CustomColors.kBlueColor, fontFamily: 'Poppins')),
                              ],
                            ) : Container(),
                          ],
                        ),
                        const Spacer(),
                        PopupMenuButton(
                            child:
                            CircleAvatar(
                                radius:10,backgroundColor: Colors.transparent,
                                child: SvgPicture.asset(ImagePath.more,width: size.width*0.1,height: size.height*0.5,colorFilter: const ColorFilter.mode(CustomColors.kBlueColor, BlendMode.srcIn))),
                            onSelected: (item) {
                                int? parentDepID = val.department[index].parentDeptId;
                                String? parentDepName = val.department[index].parentDeptName;
                                int? depID = val.department[index].deptId;
                                String? depName = val.department[index].deptName;
                              switch (item) {
                                case 0:
                                 Navigator.push(context, MaterialPageRoute(builder: (context) => EditDepartment(orgId: widget.orgId,parentDepId: parentDepID, parentDepName: parentDepName, depId: depID, depName: depName,)));
                                case 1:
                                  _showDeleteConfirmation(context,val.department[index].deptId);
                              }
                            },
                            itemBuilder: (_) => [
                              const PopupMenuItem(
                                  value: 0,
                                  child: Text(CustomString.edit, style: TextStyle(fontFamily: 'Poppins'))),
                              const PopupMenuItem(
                                  value: 1,
                                  child: Text(CustomString.delete, style: TextStyle(fontFamily: 'Poppins')))
                            ]),
                        SizedBox(width: size.width * 0.03,)
                      ],
                    ),
                  );
                }),
          ):
          Center(
            child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
            SizedBox(height: size.height*0.02,),
            SizedBox(height: size.height*0.2,width: size.width/1.5,child: Image.asset(ImagePath.noData,fit: BoxFit.fill,)),
            SizedBox(height: size.height*0.2,),
            const Text(CustomString.noDataFound,style: TextStyle(color: CustomColors.kLightGrayColor),)
            ],),
            );
        }
      ),
      // body: FutureBuilder(
      //   future: ApiConfig.getDepartment(orgId: widget.orgId), // a previously-obtained Future<String> or null
      //   //future: _calculation, // a previously-obtained Future<String> or null
      //   builder: (BuildContext context,snapshot) {
      //     print("------------->${snapshot.data}");
      //     if(snapshot.connectionState==ConnectionState.waiting){
      //       return const Column(
      //         children: [
      //           CircularProgressIndicator(),
      //           Padding(
      //             padding: EdgeInsets.only(top: 16),
      //             child: Text('Awaiting result...',style: TextStyle(fontFamily: 'Poppins')),
      //           ),
      //         ],
      //       );
      //     }
      //     else if(snapshot.connectionState==ConnectionState.done){
      //      return Consumer<DepartmentProvider>(
      //             builder: (context,val,child) {
      //               print(val.department.length);
      //          return Expanded(
      //            child: val.department.isNotEmpty? Padding(
      //              padding: EdgeInsets.only(top: size.height * 0.018),
      //              child: ListView.builder(
      //                       itemCount: val.department.length,
      //                       itemBuilder: (context,index){
      //                         return Container(
      //                           decoration: const BoxDecoration(
      //                             color: CustomColors.kGrayColor,
      //                             borderRadius: BorderRadius.all(Radius.circular(5))
      //                           ),
      //                           margin: EdgeInsets.only(left: size.width * 0.025,right: size.width * 0.03, top: size.height * 0.01,bottom: size.height * 0.005),
      //                           child: Row(
      //                             children: [
      //                               Padding(
      //                                 padding: EdgeInsets.all(size.height*0.01+size.width*0.01),
      //                                 child: Container(
      //                                   clipBehavior: Clip.hardEdge,
      //                                     decoration: BoxDecoration(borderRadius: BorderRadius.circular(10)),
      //                                     child: Image.asset("assets/images/5.jpeg",height: size.height*0.05,fit: BoxFit.cover,)),
      //                               ),
      //                               Column(
      //                                 crossAxisAlignment: CrossAxisAlignment.start,
      //                                 mainAxisAlignment: MainAxisAlignment.start,
      //                                 children: [
      //                                   Text(val.department[index].deptName!,style: const TextStyle(fontFamily: 'Poppins')), val.department[index].parentDeptName!=null ?
      //                                   Row(
      //                                     children: [
      //                                       const Text("PD : ", style: TextStyle(fontFamily: 'Poppins')),
      //                                       Text(val.department[index].parentDeptName!,style: const TextStyle(color: CustomColors.kBlueColor, fontFamily: 'Poppins')),
      //                                     ],
      //                                   ) : Container(),
      //                                 ],
      //                               ),
      //                               const Spacer(),
      //                               PopupMenuButton(
      //                                   child:
      //                                   CircleAvatar(
      //                                       radius:10,backgroundColor: Colors.transparent,
      //                                       child: SvgPicture.asset(ImagePath.more,width: size.width*0.1,height: size.height*0.5,colorFilter: const ColorFilter.mode(CustomColors.kBlueColor, BlendMode.srcIn))),
      //                                   onSelected: (item) {
      //                                     //  int perSKID = val.personSkill[index].perSkId!;
      //                                     //  String skillName = val.personSkill[index].skillName!;
      //                                     // int month = val.personSkill[index].experience!;
      //                                     switch (item) {
      //                                       case 0:
      //                                       // Navigator.push(context, MaterialPageRoute(builder: (context) => EditSkillScreen(skillName: skillName, months: month, perSkillId: perSKID)));
      //                                       case 1:
      //                                         _showDeleteConfirmation(context,val.department[index].deptId);
      //                                     }
      //                                   },
      //                                   itemBuilder: (_) => [
      //                                     const PopupMenuItem(
      //                                         value: 0,
      //                                         child: Text(CustomString.edit, style: TextStyle(fontFamily: 'Poppins'))),
      //                                     const PopupMenuItem(
      //                                         value: 1,
      //                                         child: Text(CustomString.delete, style: TextStyle(fontFamily: 'Poppins')))
      //                                   ]),
      //                             ],
      //                           ),
      //                         );
      //                       }),
      //            ):Center(
      //     child: Column(
      //     crossAxisAlignment: CrossAxisAlignment.center,
      //     children: [
      //     SizedBox(height: size.height*0.02,),
      //     SizedBox(height: size.height*0.2,width: size.width/1.5,child: Image.asset(ImagePath.noData,fit: BoxFit.fill,)),
      //     SizedBox(height: size.height*0.2,),
      //     const Text(CustomString.noDataFound,style: TextStyle(color: CustomColors.kLightGrayColor),)
      //     ],),
      //     ),
      //             );
      //        }
      //      );
      //     }
      //     else {
      //       print("**----------->else in future builder department");
      //     }
      //     return Container();
      //   },
      // ),
    );
  }

  void _showDeleteConfirmation(context, int? deptId) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text(CustomString.deleteTitle, style: TextStyle(fontFamily: 'Poppins')),
          content: const Text(CustomString.deleteContent, style: TextStyle(fontFamily: 'Poppins')),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the confirmation dialog
              },
              child: const Text(CustomString.cancel, style: TextStyle(fontFamily: 'Poppins')),
            ),
            TextButton(
              onPressed: () async {
                ApiConfig.deleteDepartment(context: context,departmentID: deptId,orgId: widget.orgId);
              },
              child: const Text(CustomString.delete, style: TextStyle(fontFamily: 'Poppins')),
            ),
          ],
        );
      },
    );
  }
}



