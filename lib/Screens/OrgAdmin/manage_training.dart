import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:versa_tribe/extension.dart';
import 'ManageTraining/orgadmin_manage_training_detail_screen.dart';

class ManageTrainingScreen extends StatefulWidget {
  final int? orgId;
  const ManageTrainingScreen({super.key, required this.orgId});
  @override
  State<ManageTrainingScreen> createState() => _ManageTrainingScreenState();
}

class _ManageTrainingScreenState extends State<ManageTrainingScreen>{
  // Call this when the user pull down the screen
  Future<void> _loadData() async {
    try {
      ApiConfig.getTakeTrainingData(context: context, orgId: widget.orgId);
    } catch (err) {
      rethrow;
    }
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: CustomColors.kWhiteColor,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: CustomColors.kGrayColor,
        leading: IconButton(
            onPressed: () {Navigator.pop(context);},
            icon: const Icon(Icons.arrow_back_ios, color: CustomColors.kBlackColor) //replace with our own icon data.
        ),
        centerTitle: true,
        title: const Text(CustomString.manageTraining,
            style: TextStyle(color: CustomColors.kBlueColor,fontSize: 16, fontFamily: 'Poppins')),
      ),
      body: RefreshIndicator(
        onRefresh: _loadData,
        child: FutureBuilder(
          future: _loadData(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return SizedBox(
                height: size.height * 0.21,
                child: const Center(
                  child: CircularProgressIndicator(),
                ),
              );
            } else if (snapshot.connectionState == ConnectionState.done) {
              return Consumer<TakeTrainingListProvider>(
                  builder: (context, val, child) {
                    return val.getTakeTrainingList.isNotEmpty ? ListView.builder(
                      shrinkWrap: true,
                      itemCount: val.getTakeTrainingList.length,
                      itemBuilder: (context, index) {
                        return InkWell(
                          child: Card(
                            color: CustomColors.kGrayColor,
                            elevation: 0.5,
                            shape: const RoundedRectangleBorder(
                                borderRadius: BorderRadius.all(
                                    Radius.circular(6))),
                            margin: EdgeInsets.symmetric(horizontal: size.width*0.03,vertical: size.height*0.005),
                            child: Padding(
                                padding:EdgeInsets.symmetric(horizontal: size.width*0.04,vertical: size.height*0.01),
                                child: Column(
                                  crossAxisAlignment:
                                  CrossAxisAlignment.start,
                                  children: [
                                    Text('${val.getTakeTrainingList[index].trainingName}',
                                        style: const TextStyle(color: CustomColors.kBlackColor, fontSize: 14, fontFamily: 'Poppins', fontWeight: FontWeight.normal)),
                                    //SizedBox(height: size.height * 0.01 / 2),
                                    // Text(
                                    //     'Organization : ${val.getTakeTrainingList[index].orgName}',
                                    //     style: const TextStyle(color: CustomColors.kLightGrayColor, fontSize: 12, fontFamily: 'Poppins')),
                                    SizedBox(height: size.height * 0.01 / 2),
                                    Text(
                                        'Duration : ${DateUtil().formattedDate(DateTime.parse(val.getTakeTrainingList[index].startDate!).toLocal())} - ${DateUtil().formattedDate(DateTime.parse(val.getTakeTrainingList[index].endDate!).toLocal())}',
                                        style: const TextStyle(color: CustomColors.kBlackColor, fontSize: 12, fontFamily: 'Poppins')),
                                    SizedBox(height: size.height * 0.01 / 2),
                                    Text(
                                        'Trainer : ${val.getTakeTrainingList[index].firstName} ${val.getTakeTrainingList[index].lastName}',
                                        style: const TextStyle(color: CustomColors.kBlackColor, fontSize: 12, fontFamily: 'Poppins')),
                                    SizedBox(height: size.height * 0.01 / 2),
                                    Container(
                                      decoration: BoxDecoration(
                                        color: CustomColors.kWhiteColor,
                                          border: Border.all(width: 2, color: CustomColors.kBlueColor),
                                          borderRadius: const BorderRadius.all(Radius.circular(10))),
                                      padding: const EdgeInsets.all(6.0),
                                      child: Text(
                                          'PersonLimit: ${val.getTakeTrainingList[index].personLimit}',
                                          style: const TextStyle(color: CustomColors.kBlackColor, fontSize: 12, fontFamily: 'Poppins')),
                                    ),
                                  ],
                                )),
                          ),
                          onTap: () {
                            Navigator.of(context).push(MaterialPageRoute(builder: (context) => OrgManageTrainingDetailScreen(trainingResponse: val.getTakeTrainingList[index])));
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
                                const Text(CustomString.noTrainingFound, style: TextStyle(color: CustomColors.kLightGrayColor, fontFamily: 'Poppins'))
                              ]),
                        ));
                  });
            } else {
              debugPrint("-----Manage Training print future builder------");
            }
            return Container();
          },
        ),
      ),
    );
  }
}
