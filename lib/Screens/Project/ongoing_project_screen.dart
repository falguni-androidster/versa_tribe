import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:versa_tribe/Screens/Project/project_details_screen.dart';

import 'package:versa_tribe/extension.dart';

class OnGoingProjectScreen extends StatefulWidget {
  const OnGoingProjectScreen({super.key});

  @override
  State<OnGoingProjectScreen> createState() => _OnGoingProjectScreenState();
}

class _OnGoingProjectScreenState extends State<OnGoingProjectScreen> {

  // Call this when the user pull down the screen
  Future<void> _loadData() async {
    try {
      ApiConfig.getProjectData(context);
    } catch (err) {
      rethrow;
    }
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Scaffold(
      body: RefreshIndicator(
        onRefresh: _loadData,
        child: FutureBuilder(
          future: ApiConfig.getProjectData(context),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return SizedBox(
                height: size.height * 0.21,
                child: const Center(
                  child: CircularProgressIndicator(),
                ),
              );
            } else if (snapshot.connectionState == ConnectionState.done) {
              return Consumer<ProjectListProvider>(
                  builder: (context, val, child) {
                    return val.getProjectList.isNotEmpty ? ListView.builder(
                      shrinkWrap: true,
                      itemCount: val.getProjectList.length,
                      itemBuilder: (context, index) {
                        return InkWell(
                          child: Card(
                            color: CustomColors.kWhiteColor,
                            elevation: 3,
                            shape: const RoundedRectangleBorder(
                                borderRadius: BorderRadius.all(
                                    Radius.circular(6))),
                            margin: EdgeInsets.all(size.width * 0.01),
                            child: Padding(
                                padding: const EdgeInsets.all(10.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                        '${val.getProjectList[index].projectName}',
                                        style: const TextStyle(color: CustomColors.kBlackColor, fontSize: 14, fontFamily: 'Poppins', fontWeight: FontWeight.w600)),
                                    SizedBox(height: size.height * 0.01 / 2),
                                    const Text(
                                        'Project Manager : Falguni Maheta',
                                        style: TextStyle(color: CustomColors.kLightGrayColor, fontSize: 12, fontFamily: 'Poppins')),
                                    SizedBox(height: size.height * 0.01 / 2),
                                    val.getProjectList[index].startDate != null && val.getProjectList[index].endDate != null ? Text(
                                        'Duration : ${DateUtil().formattedDate(DateTime.parse(val.getProjectList[index].startDate!).toLocal())} - ${DateUtil().formattedDate(DateTime.parse(val.getProjectList[index].endDate!).toLocal())}',
                                        style: const TextStyle(color: CustomColors.kBlackColor, fontSize: 12, fontFamily: 'Poppins')) :
                                    const Text('Duration : 00/00/0000 - 00/00/0000', style: TextStyle(color: CustomColors.kBlackColor, fontSize: 12, fontFamily: 'Poppins')),
                                  ],
                                )),
                          ),
                          onTap: () {
                            Navigator.of(context).push(MaterialPageRoute(builder: (context) => ProjectDetailsScreen(projectResponseModel: val.getProjectList[index])));
                          },
                        );
                      },
                    ) : SizedBox(
                        width: size.width,
                        height: defaultTargetPlatform == TargetPlatform.iOS ? size.height * 0.21 : size.height * 0.25,
                        child: Center(
                          child: Column(crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Image.asset(ImagePath.noData, fit: BoxFit.fill),
                                const Text(CustomString.noProjectFound, style: TextStyle(color: CustomColors.kLightGrayColor, fontFamily: 'Poppins'))
                              ]),
                        ));
                  });
            } else {
              debugPrint("-----Project print future builder------");
            }
            return Container();
          },
        ),
      ),
    );
  }
}
