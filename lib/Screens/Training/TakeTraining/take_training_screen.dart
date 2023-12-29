import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:versa_tribe/Screens/Training/TakeTraining/take_training_item_screen.dart';
import 'package:versa_tribe/extension.dart';

class TakeTrainingScreen extends StatefulWidget {

  final int? orgId;

  const TakeTrainingScreen({super.key, required this.orgId});

  @override
  State<TakeTrainingScreen> createState() => _TakeTrainingScreenState();
}

class _TakeTrainingScreenState extends State<TakeTrainingScreen> {

  String? personId;

  Future<void> isPersonId() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    personId = pref.getString('PersonId');
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    isPersonId();
  }


  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: CustomColors.kWhiteColor,
      body: FutureBuilder(
        future: ApiConfig.getTakeTrainingData(context: context ,orgId: widget.orgId),
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
                      return val.getTakeTrainingList[index].trainerId != int.parse(personId!) ? InkWell(
                        child: Card(
                          color: CustomColors.kWhiteColor,
                          elevation: 3,
                          shape: const RoundedRectangleBorder(
                              borderRadius: BorderRadius.all(Radius.circular(6))),
                          margin: EdgeInsets.all(size.width * 0.01),
                          child: Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                      '${val.getTakeTrainingList[index].trainingName}',
                                      style: const TextStyle(color: CustomColors.kBlackColor, fontSize: 14, fontFamily: 'Poppins', fontWeight: FontWeight.w600)),
                                  SizedBox(height: size.height * 0.01 / 2),
                                  Text(
                                      'Organization : ${val.getTakeTrainingList[index].orgName}',
                                      style: const TextStyle(color: CustomColors.kLightGrayColor, fontSize: 12, fontFamily: 'Poppins')),
                                  SizedBox(height: size.height * 0.01 / 2),
                                  Text(
                                      'Duration : ${DateUtil().formattedDate(DateTime.parse(val.getTakeTrainingList[index].startDate!).toLocal())} - ${DateUtil().formattedDate(DateTime.parse(val.getTakeTrainingList[index].endDate!).toLocal())}',
                                      style: const TextStyle(color: CustomColors.kBlackColor, fontSize: 12, fontFamily: 'Poppins')),
                                  SizedBox(height: size.height * 0.01 / 2),
                                  const Text(
                                      'Trainer : Falguni Maheta',
                                      style: TextStyle(color: CustomColors.kBlackColor, fontSize: 12, fontFamily: 'Poppins')),
                                  SizedBox(height: size.height * 0.01 / 2),
                                  Container(
                                    decoration: BoxDecoration(border: Border.all(width: 2, color: CustomColors.kBlueColor),
                                        borderRadius: const BorderRadius.all(Radius.circular(10))),
                                    padding: const EdgeInsets.all(6.0),
                                    child: Text(
                                        'PersonLimit - ${val.getTakeTrainingList[index].personLimit}',
                                        style: const TextStyle(color: CustomColors.kBlackColor, fontSize: 12, fontFamily: 'Poppins')),
                                  )
                                ],
                              )),
                        ),
                        onTap: () {
                          Navigator.of(context).push(MaterialPageRoute(builder: (context) => TakeTrainingItemScreen(trainingResponse: val.getTakeTrainingList[index])));
                        },
                      ) : Container();
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
                      ));
                });
          } else {
            debugPrint("-----Take Training print future builder------");
          }
          return Container();
        },
      ),
    );
  }
}
