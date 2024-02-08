import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:versa_tribe/Providers/dropmenu_provider.dart';
import 'package:versa_tribe/extension.dart';

import '../Training/GiveTraining/give_training_screen.dart';
import '../Training/TakeTraining/take_training_screen.dart';

class TrainingScreen extends StatefulWidget {

  final int? orgId;

  const TrainingScreen({super.key, required this.orgId});

  @override
  State<TrainingScreen> createState() => _TrainingScreenState();
}

class _TrainingScreenState extends State<TrainingScreen>{

  // List of items in our dropdown menu
  var menuItems = [
    'All',
    'Requested',
    'Joined',
    'Not joined',
  ];

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    dynamic dropMenuPro = Provider.of<DropMenuProvider>(context,listen: false);
    dropMenuPro.setDropMenu("All");
  }

  @override
  Widget build(BuildContext context) {
    final dropMenuPro = Provider.of<DropMenuProvider>(context,listen: false);
    var size = MediaQuery.of(context).size;
    return Scaffold(
      /*floatingActionButton: Padding(
        padding: const EdgeInsets.only(right: 20.0),
        child: FloatingActionButton(
          onPressed: (){
            Navigator.of(context).push(MaterialPageRoute(builder: (context) => CreateTrainingScreen(orgId: widget.orgId)));
          },
          backgroundColor: CustomColors.kBlueColor,
          child: const Icon(Icons.add,color: CustomColors.kWhiteColor),
        ),
      ),*/
      body: DefaultTabController(
        length: 2,//4,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Padding(
              padding: EdgeInsets.only(
                  top: size.height * 0.02,
                  left: size.width * 0.02,
                  right: size.height * 0.02),
              child: TabBar(
                isScrollable: true,
                labelPadding: const EdgeInsets.symmetric(horizontal: 5),
                indicator: BoxDecoration(
                  borderRadius: BorderRadius.circular(5),
                  color: CustomColors.kBlueColor, // Change the color of the selected tab here
                ),
                indicatorSize: TabBarIndicatorSize.label,
                unselectedLabelStyle: const TextStyle(fontSize: 14, color: CustomColors.kBlackColor, fontWeight: FontWeight.w400, fontFamily: 'Poppins'),
                tabAlignment: TabAlignment.start,
                labelStyle: const TextStyle(fontSize: 14, color : CustomColors.kWhiteColor,fontWeight: FontWeight.w400, fontFamily: 'Poppins'),
                tabs: <Widget>[
                  Container(
                      padding: const EdgeInsets.all(8.0),
                      child: const Text(CustomString.takeTraining)),
                  Container(
                      padding: const EdgeInsets.all(8.0),
                      child: const Text(CustomString.giveTraining)),
                  // Container(
                  //     padding: const EdgeInsets.all(8.0),
                  //     child: const Text(CustomString.requested)),
                  // Container(
                  //     padding: const EdgeInsets.all(8.0),
                  //     child: const Text(CustomString.accepted)),
                ],onTap: (tabIndex){
                  if(tabIndex==0){
                    dropMenuPro.setDropMenuVisibility(0);
                  }else if(tabIndex==1){
                    dropMenuPro.setDropMenuVisibility(1);
                  }
              },
              ),
            ),
            Consumer<DropMenuProvider>(
              builder: (context,val,child) {
                return val.dropMenu ==0? Container(
                  alignment: Alignment.centerRight,
                  child: DropdownButton(
                    dropdownColor: Colors.white,
                    //padding: EdgeInsets.symmetric(vertical: size.height*0.02,horizontal: size.width*0.02),
                    borderRadius: const BorderRadius.all(Radius.circular(5)),
                    alignment: Alignment.topRight,
                    // Initial Value
                    value: val.takeTrainingMenuItems,
                    // Down Arrow Icon
                    icon: const Icon(Icons.keyboard_arrow_down),
                    // Array list of items
                    items: menuItems.map((String items) {
                      return DropdownMenuItem(
                        value: items,
                        child: Text(items),
                      );
                    }).toList(),
                    // After selecting the desired option,it will change button value to selected value
                    onChanged: (String? newValue) {
                      val.setDropMenu(newValue);
                      val.notify();
                    },
                  ),
                ):const SizedBox.shrink();
              }
            ),
            Expanded(
              child: TabBarView(
                physics: const NeverScrollableScrollPhysics(),
                children: <Widget>[

                  /// Take Training
                  /*TakeTrainingScreen(orgId: widget.orgId),*/
                  TakeTrainingScreen(orgId: widget.orgId),

                  /// Give Training
                  GiveTrainingScreen(orgId: widget.orgId),

                  // /// Requested
                  // RequestedTrainingScreen(orgId: widget.orgId),
                  //
                  // /// Accepted
                  // AcceptedTrainingScreen(orgId: widget.orgId)

                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
