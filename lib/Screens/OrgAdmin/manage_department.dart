import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import 'package:versa_tribe/Screens/OrgAdmin/ManageDepartment/add_new_department.dart';
import 'package:versa_tribe/Screens/OrgAdmin/ManageDepartment/edit_department.dart';
import 'package:versa_tribe/extension.dart';

class ManageDepartment extends StatefulWidget {
  final int orgId;
  const ManageDepartment({super.key, required this.orgId});
  @override
  State<ManageDepartment> createState() => _ManageDepartmentState();
}

class _ManageDepartmentState extends State<ManageDepartment> {
  // Call this when the user pull down the screen
  Future<void> _loadData() async {
    try {
      ApiConfig.getDepartment(context: context,orgId: widget.orgId);
    } catch (err) {
      rethrow;
    }
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
            style: TextStyle(color: CustomColors.kBlueColor,fontSize: 16, fontFamily: 'Poppins')),
        actions: [IconButton(onPressed: (){
          Navigator.push(context, MaterialPageRoute(builder: (context)=> AddNewDepartment(orgId: widget.orgId,)));
        }, icon: const Icon(Icons.add,color: CustomColors.kBlackColor,))],
      ),
      body: RefreshIndicator(
        onRefresh: _loadData,
        child: FutureBuilder(
          future:ApiConfig.getDepartment(context: context,orgId: widget.orgId),
          builder: (context,snapshot) {
            if(snapshot.connectionState==ConnectionState.waiting){
              return SizedBox(
                height: size.height*0.21,
                child: const Center(
                  child: CircularProgressIndicator(),
                ),
              );
            }
            else if(snapshot.connectionState==ConnectionState.done){
             return Consumer<DepartmentProvider>(
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
                                  // const Spacer(),
                                  // PopupMenuButton(
                                  //     child:
                                  //     CircleAvatar(
                                  //         radius:10,backgroundColor: Colors.transparent,
                                  //         child: SvgPicture.asset(ImagePath.more,width: size.width*0.1,height: size.height*0.5,colorFilter: const ColorFilter.mode(CustomColors.kBlueColor, BlendMode.srcIn))),
                                  //     onSelected: (item) {
                                  //       int? parentDepID = val.department[index].parentDeptId;
                                  //       String? parentDepName = val.department[index].parentDeptName;
                                  //       int? depID = val.department[index].deptId;
                                  //       String? depName = val.department[index].deptName;
                                  //       switch (item) {
                                  //         case 0:
                                  //           Navigator.push(context, MaterialPageRoute(builder: (context) => EditDepartment(orgId: widget.orgId,parentDepId: parentDepID, parentDepName: parentDepName, depId: depID, depName: depName,)));
                                  //         case 1:
                                  //           _showDeleteConfirmation(context,val.department[index].deptId);
                                  //       }
                                  //     },
                                  //     itemBuilder: (_) => [
                                  //       const PopupMenuItem(
                                  //           value: 0,
                                  //           child: Text(CustomString.edit, style: TextStyle(fontFamily: 'Poppins'))),
                                  //       const PopupMenuItem(
                                  //           value: 1,
                                  //           child: Text(CustomString.delete, style: TextStyle(fontFamily: 'Poppins')))
                                  //     ]),
                                  // SizedBox(width: size.width * 0.03,)
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
              );
            }
            return Container();
          }
        ),
      ),
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



