import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:versa_tribe/Model/training_response.dart';
import 'package:versa_tribe/Utils/custom_toast.dart';

import '../../Utils/custom_colors.dart';
import '../../Utils/custom_string.dart';
import '../../Utils/helper.dart';
import '../../Utils/image_path.dart';

class TrainingItemScreen extends StatefulWidget {

  final TrainingResponse trainingResponse;

  const TrainingItemScreen({super.key,required this.trainingResponse});

  @override
  State<TrainingItemScreen> createState() => _TrainingItemScreenState();
}

class _TrainingItemScreenState extends State<TrainingItemScreen> {

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Scaffold(
        appBar: AppBar(
          backgroundColor: CustomColors.kWhiteColor,
          leading: InkWell(
            child: const Icon(Icons.arrow_back_ios,
                color: CustomColors.kBlackColor),
            onTap: () {
              Navigator.pop(context);
            },
          ),
          title: const Text(CustomString.manageTraining,
              style: TextStyle(
                  color: CustomColors.kBlueColor, fontFamily: 'Poppins')),
          centerTitle: true,
        ),
        backgroundColor: CustomColors.kWhiteColor,
        body: Form(
            key: _formKey,
            child: SingleChildScrollView(
                child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Text(widget.trainingResponse.trainingName!,
                                  style: const TextStyle(color: CustomColors.kBlueColor, fontSize: 20, fontFamily: 'Poppins', fontWeight: FontWeight.w500)),
                              const Spacer(),
                              InkWell(
                                child: SvgPicture.asset(ImagePath.editProfileIcon, height: 20, width: 20, colorFilter: const ColorFilter.mode(CustomColors.kBlackColor, BlendMode.srcIn)),
                                onTap: () {
                                },
                              ),
                            ],
                          ),
                          SizedBox(height: size.height * 0.01),
                          Text('Organization : ${widget.trainingResponse.orgName!}',
                              style: const TextStyle(color: CustomColors.kBlackColor, fontSize: 14, fontFamily: 'Poppins')),
                          SizedBox(height: size.height * 0.01),
                          Text('Duration : ${DateUtil().formattedDate(DateTime.parse(widget.trainingResponse.startDate!).toLocal())} - ${DateUtil().formattedDate(DateTime.parse(widget.trainingResponse.endDate!).toLocal())}',
                              style: const TextStyle(color: CustomColors.kBlackColor, fontSize: 14, fontFamily: 'Poppins')),
                          SizedBox(height: size.height * 0.01),
                          Text('Person Limit : ${widget.trainingResponse.personLimit!}',
                              style: const TextStyle(color: CustomColors.kBlackColor, fontSize: 14, fontFamily: 'Poppins')),
                          SizedBox(height: size.height * 0.01),
                          const Text('Description',
                              style: TextStyle(color: CustomColors.kBlackColor, fontSize: 16, fontFamily: 'Poppins')),
                          SizedBox(height: size.height * 0.01 / 2),
                          Text(widget.trainingResponse.description!,
                              style: const TextStyle(color: CustomColors.kLightGrayColor, fontSize: 14, fontFamily: 'Poppins', overflow: TextOverflow.fade)),
                          SizedBox(height: size.height * 0.01),
                          const Text(CustomString.manageCriteria,
                              style: TextStyle(color: CustomColors.kBlackColor, fontSize: 16, fontFamily: 'Poppins')),
                          SizedBox(height: size.height * 0.01),
                          Row(children: [
                            const Text(CustomString.experience,
                                style: TextStyle(color: CustomColors.kBlackColor, fontWeight: FontWeight.normal, fontSize: 14, fontFamily: 'Poppins')),
                            const Spacer(),
                            InkWell(
                              child: SvgPicture.asset(ImagePath.addIcon, height: 16, width: 16,  colorFilter: const ColorFilter.mode(CustomColors.kBlueColor, BlendMode.srcIn)),
                              onTap: () {
                                showToast(context, 'Experience Click');
                              },
                            ),
                          ]),
                          SizedBox(height: size.height * 0.01),
                          Row(children: [
                            const Text(CustomString.qualification,
                                style: TextStyle(color: CustomColors.kBlackColor, fontWeight: FontWeight.normal, fontSize: 14, fontFamily: 'Poppins')),
                            const Spacer(),
                            InkWell(
                              child: SvgPicture.asset(ImagePath.addIcon, height: 16, width: 16,  colorFilter: const ColorFilter.mode(CustomColors.kBlueColor, BlendMode.srcIn)),
                              onTap: () {
                                showToast(context, 'Qualification Click');
                              },
                            ),
                          ]),
                          SizedBox(height: size.height * 0.01),
                          Row(children: [
                            const Text(CustomString.skill,
                                style: TextStyle(color: CustomColors.kBlackColor, fontWeight: FontWeight.normal, fontSize: 14, fontFamily: 'Poppins')),
                            const Spacer(),
                            InkWell(
                              child: SvgPicture.asset(ImagePath.addIcon, height: 16, width: 16,  colorFilter: const ColorFilter.mode(CustomColors.kBlueColor, BlendMode.srcIn)),
                              onTap: () {
                                showToast(context, 'Skill Click');
                              },
                            ),
                          ]),
                          SizedBox(height: size.height * 0.01),
                          Row(children: [
                            const Text(CustomString.hobby,
                                style: TextStyle(color: CustomColors.kBlackColor, fontWeight: FontWeight.normal, fontSize: 14, fontFamily: 'Poppins')),
                            const Spacer(),
                            InkWell(
                              child: SvgPicture.asset(ImagePath.addIcon, height: 16, width: 16,  colorFilter: const ColorFilter.mode(CustomColors.kBlueColor, BlendMode.srcIn)),
                              onTap: () {
                                showToast(context, 'Hobby Click');
                              },
                            ),
                          ]),
                        ]
                    )
                )
            )
        )
    );
  }
}
