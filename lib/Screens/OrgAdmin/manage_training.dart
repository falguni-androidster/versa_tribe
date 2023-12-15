import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import 'package:versa_tribe/Screens/Training/give_training_item_screen.dart';
import 'package:versa_tribe/extension.dart';


class ManageTrainingScreen extends StatefulWidget {

  final int? orgId;

  const ManageTrainingScreen({super.key, required this.orgId});

  @override
  State<ManageTrainingScreen> createState() => _ManageTrainingScreenState();
}

class _ManageTrainingScreenState extends State<ManageTrainingScreen>{

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
            style: TextStyle(color: CustomColors.kBlueColor, fontFamily: 'Poppins')),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          FutureBuilder(
            future: ApiConfig.getGiveTrainingData(context),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return SizedBox(
                  height: size.height * 0.21,
                  child: const Center(
                    child: CircularProgressIndicator(),
                  ),
                );
              } else if (snapshot.connectionState == ConnectionState.done) {
                return Consumer<GiveTrainingListProvider>(
                    builder: (context, val, child) {
                      return val.getGiveTrainingList.isNotEmpty ? ListView.builder(
                        shrinkWrap: true,
                        itemCount: val.getGiveTrainingList.length,
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
                                    crossAxisAlignment:
                                    CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                          '${val.getGiveTrainingList[index].trainingName}',
                                          style: const TextStyle(color: CustomColors.kBlackColor, fontSize: 14, fontFamily: 'Poppins', fontWeight: FontWeight.w600)),
                                      SizedBox(height: size.height * 0.01 / 2),
                                      Text(
                                          'Organization : ${val.getGiveTrainingList[index].orgName}',
                                          style: const TextStyle(color: CustomColors.kLightGrayColor, fontSize: 12, fontFamily: 'Poppins')),
                                      SizedBox(height: size.height * 0.01 / 2),
                                      Text(
                                          'Duration : ${DateUtil().formattedDate(DateTime.parse(val.getGiveTrainingList[index].startDate!).toLocal())} - ${DateUtil().formattedDate(DateTime.parse(val.getGiveTrainingList[index].endDate!).toLocal())}',
                                          style: const TextStyle(color: CustomColors.kBlackColor, fontSize: 12, fontFamily: 'Poppins')),
                                      SizedBox(height: size.height * 0.01 / 2),
                                      Container(
                                        decoration: BoxDecoration(
                                            border: Border.all(width: 2, color: CustomColors.kBlueColor),
                                            borderRadius: const BorderRadius.all(Radius.circular(10))),
                                        padding: const EdgeInsets.all(6.0),
                                        child: Text(
                                            'PersonLimit - ${val.getGiveTrainingList[index].personLimit}',
                                            style: const TextStyle(color: CustomColors.kBlackColor, fontSize: 12, fontFamily: 'Poppins')),
                                      ),
                                    ],
                                  )),
                            ),
                            onTap: () {
                              Navigator.of(context).push(MaterialPageRoute(builder: (context) => GiveTrainingItemScreen(trainingResponse: val.getGiveTrainingList[index])));
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
                debugPrint("-----Give Training print future builder------");
              }
              return Container();
            },
          ),
        ],
      ),
    );
  }
}
