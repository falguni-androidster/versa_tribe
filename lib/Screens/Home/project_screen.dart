import 'package:flutter/material.dart';
import 'package:versa_tribe/extension.dart';

class ProjectScreen extends StatefulWidget {
  const ProjectScreen({super.key});

  @override
  State<ProjectScreen> createState() => _ProjectScreenState();
}

class _ProjectScreenState extends State<ProjectScreen> with SingleTickerProviderStateMixin {
  late final TabController _tabController;
  @override
  void initState() {
    _tabController = TabController(length: 3, vsync: this);
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children:[
          Padding(
            padding: EdgeInsets.only(top: size.height * 0.02, left: size.width * 0.02, right: size.height * 0.02),
            child: TabBar(
              onTap: (value){},dividerColor: Colors.transparent,
              controller: _tabController,
              tabAlignment: TabAlignment.start,
              isScrollable: true,
              labelPadding: const EdgeInsets.symmetric(horizontal: 5),
              labelColor: CustomColors.kBlueColor,
              indicatorColor: Colors.transparent,
              unselectedLabelColor: CustomColors.kBlackColor,
              unselectedLabelStyle: const TextStyle(fontSize: 16, color: CustomColors.kBlackColor, fontWeight: FontWeight.w400, fontFamily: 'Poppins'),
              labelStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.w400, fontFamily: 'Poppins'),
              tabs: <Widget>[
                Container(
                    padding: const EdgeInsets.all(10),
                    decoration: const BoxDecoration(
                        borderRadius:
                        BorderRadius.all(Radius.circular(5)),
                        color: CustomColors.kGrayColor),
                    child: const Text(CustomString.requested,style: TextStyle(fontFamily: 'Poppins'))),
                Container(
                    padding: const EdgeInsets.all(10),
                    decoration: const BoxDecoration(
                        borderRadius:
                        BorderRadius.all(Radius.circular(5)),
                        color: CustomColors.kGrayColor),
                    child: const Text(CustomString.approved, style: TextStyle(fontFamily: 'Poppins'))),
                Container(
                    padding: const EdgeInsets.all(10),
                    decoration: const BoxDecoration(
                        borderRadius:
                        BorderRadius.all(Radius.circular(5)),
                        color: CustomColors.kGrayColor),
                    child: const Text(CustomString.approved, style: TextStyle(fontFamily: 'Poppins'))),
              ],
            ),
          ),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: const [
                ProjectDisplay(),Center(child: Text("two")),Center(child: Text("three"))
              ],
            ),
          )
        ],
      ),
    );
  }
}




class ProjectDisplay extends StatefulWidget {
  const ProjectDisplay({super.key});

  @override
  State<ProjectDisplay> createState() => _ProjectDisplayState();
}

class _ProjectDisplayState extends State<ProjectDisplay> {
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      body: ListView.builder(
           itemCount: 4,
          itemBuilder: (context,index){
             return Card(
               margin: EdgeInsets.only(left: size.width*0.03, right: size.width*0.03,top: size.height*0.01),
               child: Padding(
                 padding: const EdgeInsets.all(15),
                 child: Column(
                   crossAxisAlignment: CrossAxisAlignment.start,
                   children: [
                     const Text("Flood Forcasting System",style: TextStyle(color: CustomColors.kBlueColor),),
                     const Text("Project Manager: data"),
                     const Text("Duration: data"),
                     Row(
                       mainAxisAlignment: MainAxisAlignment.start,
                       children: [
                         ElevatedButton(
                             style: ElevatedButton.styleFrom(
                               shape: RoundedRectangleBorder(
                                   borderRadius: BorderRadius.circular(15)),
                               backgroundColor: Colors.green
                             ),
                             onPressed: (){},
                             child: const Text("You Are Eligible",style: TextStyle(color: CustomColors.kWhiteColor),)),
                         SizedBox(width: size.width*0.01,),
                         Padding(
                           padding: const EdgeInsets.all(8.0),
                           child: ElevatedButton(
                               style: ElevatedButton.styleFrom(
                                   shape: RoundedRectangleBorder(
                                       borderRadius: BorderRadius.circular(15)),
                                   backgroundColor: CustomColors.kLightGrayColor
                               ),
                               onPressed: (){},
                               child: const Text("Already Applied!",style: TextStyle(color: CustomColors.kWhiteColor))),
                         )
                       ],
                     )
                   ],
                 ),
               ),
             );
          }),
    );
  }
}

