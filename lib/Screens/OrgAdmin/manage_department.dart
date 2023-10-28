import 'package:flutter/material.dart';

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
      ),
      body: ListView.builder(
        itemCount: 10,
        itemBuilder: (context,index){
          return Card(
            child: Text("Continue UI"),
          );
        }
      ),
    );
  }
}
