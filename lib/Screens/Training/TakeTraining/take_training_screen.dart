import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:versa_tribe/Screens/Training/TakeTraining/take_training_detailed_screen.dart';
import 'package:versa_tribe/extension.dart';

class TakeTrainingScreen extends StatefulWidget {

  final int? orgId;

  const TakeTrainingScreen({super.key, required this.orgId});

  @override
  State<TakeTrainingScreen> createState() => _TakeTrainingScreenState();
}

class _TakeTrainingScreenState extends State<TakeTrainingScreen> {

  late int personId;

  Future<int> isPersonId() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    personId = int.parse(pref.getSharedPrefStringValue(key: CustomString.personId)!);
    return personId;
}

  @override
  void initState() {
    super.initState();
    isPersonId();
    //broadcastUpdate(); we are used sharedPreference + Provider for pass orgId so it can be neglect it.
  }
      /*broadcastUpdate() async {
        FBroadcast.instance().register("Key_Message", (value, callback) {
          var orgID = value;
          ApiConfig.getProjectDataByOrgID(context, orgID);
        });
      }*/

  // Call this when the user pull down the screen
  Future<void> loadData() async {
    try {
      ApiConfig.getTakeTrainingData(context: context ,orgId: widget.orgId);
    } catch (err) {
      rethrow;
    }
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: CustomColors.kWhiteColor,
      body: RefreshIndicator(triggerMode: RefreshIndicatorTriggerMode.anywhere,
        onRefresh: loadData,
        child: FutureBuilder(
          future:ApiConfig.getTakeTrainingData(context: context ,orgId: widget.orgId),
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
                    final filteredList = val.getTakeTrainingList.where((item) => item.trainerId != personId).toList();
                    return filteredList.isNotEmpty ? ListView.builder(
                     // return val.getTakeTrainingList.isNotEmpty ? ListView.builder(
                      shrinkWrap: true,
                      itemCount: filteredList.length,
                      itemBuilder: (context, index) {
                        return InkWell(
                          child: Card(
                            color: CustomColors.kWhiteColor,
                            elevation: 3,
                            shape: const RoundedRectangleBorder(
                                borderRadius: BorderRadius.all(Radius.circular(6))),
                            margin: EdgeInsets.symmetric(horizontal:size.width * 0.03,vertical: size.height*0.005),
                            child: Padding(
                                padding: const EdgeInsets.all(10.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                        '${filteredList[index].trainingName}',
                                        style: const TextStyle(color: CustomColors.kBlackColor, fontSize: 14, fontFamily: 'Poppins', fontWeight: FontWeight.normal)),
                                    SizedBox(height: size.height * 0.01 / 2),
                                    Text(
                                        'Duration : ${DateUtil().formattedDate(DateTime.parse(filteredList[index].startDate!).toLocal())} - ${DateUtil().formattedDate(DateTime.parse(val.getTakeTrainingList[index].endDate!).toLocal())}',
                                        style: const TextStyle(color: CustomColors.kBlackColor, fontSize: 12, fontFamily: 'Poppins')),
                                    SizedBox(height: size.height * 0.01 / 2),
                                    Text(
                                        'Trainer : ${filteredList[index].firstName} ${filteredList[index].lastName}',
                                        style: const TextStyle(color: CustomColors.kBlackColor, fontSize: 12, fontFamily: 'Poppins')),
                                    SizedBox(height: size.height * 0.01 / 2),
                                    Container(
                                      decoration: BoxDecoration(border: Border.all(width: 2, color: CustomColors.kBlueColor),
                                          borderRadius: const BorderRadius.all(Radius.circular(10))),
                                      padding: EdgeInsets.symmetric(horizontal: size.width*0.01,vertical: size.height*0.005),
                                      child: Text(
                                          'PersonLimit - ${filteredList[index].personLimit}',
                                          style: const TextStyle(color: CustomColors.kBlackColor, fontSize: 12, fontFamily: 'Poppins')),
                                    ),
                                    filteredList[index].isJoin==true?Card(

                                      elevation: 3,
                                      shape: OutlineInputBorder(borderRadius: BorderRadius.circular(10),borderSide: BorderSide.none),
                                      child:Padding(
                                        padding: EdgeInsets.symmetric(horizontal: size.width*0.01,vertical: size.height*0.005),
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.start,
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            const Text("Already Joined",style: TextStyle(fontFamily: 'Poppins'),),
                                            SvgPicture.asset(ImagePath.danderIcon,height: size.height*0.02,),
                                          ],
                                        ),
                                      ),
                                    ):filteredList[index].isJoin==false?
                                    Card(
                                      elevation: 3,
                                      shape: OutlineInputBorder(borderRadius: BorderRadius.circular(10),borderSide: BorderSide.none),
                                      child:Padding(
                                        padding: EdgeInsets.symmetric(horizontal: size.width*0.01,vertical: size.height*0.005),
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.start,
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            const Text("Already Applied",style: TextStyle(fontFamily: 'Poppins'),),
                                            SvgPicture.asset(ImagePath.danderIcon,height: size.height*0.02,),
                                          ],
                                        ),
                                      ),
                                    ):const SizedBox.shrink(),
                                  ],
                                )),
                          ),
                          onTap: () {
                            Navigator.of(context).push(MaterialPageRoute(builder: (context) => TakeTrainingDetailScreen(trainingResponse: filteredList[index], orgID: widget.orgId!)));
                          },
                        );
                      },
                    ) : SizedBox(
                        width: size.width,
                        height: defaultTargetPlatform == TargetPlatform.iOS ? size.height * 0.21 : size.height * 0.25,
                        child: Center(
                          child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Image.asset(ImagePath.noData, fit: BoxFit.fill),
                                const Text(CustomString.noTrainingFound, style: TextStyle(fontFamily: 'Poppins', color: CustomColors.kLightGrayColor))
                              ]),
                        ),
                    );
                  });
            } else {
              debugPrint("-----Take Training print future builder------");
            }
            return Container();
          },
        ),
      ),
    );
  }
}
