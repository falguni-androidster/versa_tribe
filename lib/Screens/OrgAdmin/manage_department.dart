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
          icon: const Icon(Icons.arrow_back_ios, color: CustomColors.kBlackColor) //replace with our own icon data.
        ),
        centerTitle: true,
        title: const Text(CustomString.manageDepartment,
            style: TextStyle(color: CustomColors.kBlueColor, fontFamily: 'Poppins')),
        actions: [
          IconButton(
              onPressed: (){
                Navigator.push(context, MaterialPageRoute(builder: (context) => const AddNewDepartment()));
                },
              icon: const Icon(Icons.add,color: CustomColors.kBlackColor,)
          )
        ],
      ),

      body: FutureBuilder(
        future: ApiConfig.getDepartment(orgId: 16), // a previously-obtained Future<String> or null
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
                          margin: EdgeInsets.symmetric(horizontal: size.width * 0.01, vertical: size.height * 0.005),
                          elevation: 4,
                          child: Row(
                            children: [
                              CircleAvatar(radius: 30,child: Image.asset(ImagePath.noData,fit: BoxFit.cover)),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Text(snapshot.data![index].deptName!,style: const TextStyle(fontFamily: 'Poppins')), snapshot.data![index].parentDeptName!=null ?
                                  Row(
                                    children: [
                                      const Text("PD : ", style: TextStyle(fontFamily: 'Poppins')),
                                      Text(snapshot.data![index].parentDeptName!,style: const TextStyle(color: CustomColors.kBlueColor, fontFamily: 'Poppins')),
                                    ],
                                  ) : Container(),
                                ],
                              ),
                              const Spacer(),
                              IconButton(onPressed: (){}, icon: const Icon(Icons.more_vert))
                            ],
                          ),
                        );
                      }),
              )
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
                child: Text('Error: ${snapshot.error}',style: const TextStyle(fontFamily: 'Poppins')),
              ),
            ];
          } else {
            children = const <Widget>[
              SizedBox(
                width: 60,
                height: 60,
                child: CircularProgressIndicator(color: Colors.cyanAccent),
              ),
              Padding(
                padding: EdgeInsets.only(top: 16),
                child: Text('Awaiting result...',style: TextStyle(fontFamily: 'Poppins')),
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
