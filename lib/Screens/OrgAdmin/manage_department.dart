import 'package:flutter/material.dart';
import 'package:versa_tribe/Screens/OrgAdmin/add_new_department.dart';
import 'package:versa_tribe/Utils/api_config.dart';
import 'package:versa_tribe/Utils/image_path.dart';
import '../../Utils/custom_colors.dart';
import '../../Utils/custom_string.dart';

class ManageDepartment extends StatefulWidget {
  const ManageDepartment({super.key});
  @override
  State<ManageDepartment> createState() => _ManageDepartmentState();
}
class _ManageDepartmentState extends State<ManageDepartment> {
  final Future<String> _calculation = Future<String>.delayed(
    const Duration(seconds: 2),
        () => 'Data Loaded',
  );
  @override
  Widget build(BuildContext context) {
    final mHeight = MediaQuery.of(context).size.height;
    final mWidth = MediaQuery.of(context).size.width;
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
        title: const Text(CustomString.manageDepartment,
            style: TextStyle(color: CustomColors.kBlueColor)),
        actions: [IconButton(onPressed: (){
          Navigator.push(context, MaterialPageRoute(builder: (context)=>const AddNewDepartment()));
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

      body: FutureBuilder(
        future: ApiConfig.getDepartment(orgId: 16), // a previously-obtained Future<String> or null
        //future: _calculation, // a previously-obtained Future<String> or null
        builder: (BuildContext context,snapshot) {
          print(snapshot.runtimeType);
          List<Widget> children;
          if (snapshot.hasData) {
            children = <Widget>[
           Expanded(
             child: ListView.builder(
                      itemCount: snapshot.data!.length,
                      itemBuilder: (context,index){
                        return Card(
                          margin: EdgeInsets.symmetric(horizontal: mWidth*0.01,vertical: mHeight*0.005),
                          elevation: 4,
                          child: Row(
                            children: [
                              CircleAvatar(radius: 30,child: Image.asset(ImagePath.noData,fit: BoxFit.cover,)),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Text(snapshot.data![index].deptName!),
                                  snapshot.data![index].parentDeptName!=null? Row(
                                    children: [
                                      const Text("PD : "),
                                      Text(snapshot.data![index].parentDeptName!,style: TextStyle(color: CustomColors.kBlueColor),),
                                    ],
                                  ):Container(),
                                ],
                              ),
                              Spacer(),
                              IconButton(onPressed: (){}, icon: Icon(Icons.more_vert))
                            ],
                          ),
                        );}),
           )
            /*  const Icon(
                Icons.check_circle_outline,
                color: Colors.green,
                size: 60,
              ),
              Padding(
                padding: const EdgeInsets.only(top: 16),
                child: Text('Result: ${snapshot.data}'),
              ),*/
            ];
          } else if (snapshot.hasError) {
            children = <Widget>[
              const Icon(
                Icons.error_outline,
                color: Colors.red,
                size: 60,
              ),
              Padding(
                padding: const EdgeInsets.only(top: 16),
                child: Text('Error: ${snapshot.error}'),
              ),
            ];
          } else {
            children = const <Widget>[
              SizedBox(
                width: 60,
                height: 60,
                child: CircularProgressIndicator(color: Colors.cyanAccent,),
              ),
              Padding(
                padding: EdgeInsets.only(top: 16),
                child: Text('Awaiting result...'),
              ),
            ];
          }
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: children,
            ),
          );
        },
      ),
    );
  }
}
