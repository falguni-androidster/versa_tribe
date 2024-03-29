import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:versa_tribe/extension.dart';

class RequestedProjectScreen extends StatefulWidget {
  final int? orgID;
  const RequestedProjectScreen({super.key, required this.orgID});

  @override
  State<RequestedProjectScreen> createState() => _RequestedProjectScreenState();
}

class _RequestedProjectScreenState extends State<RequestedProjectScreen> {

  // Call this when the user pull down the screen
  Future<void> _loadData() async {
    try {
      apiConfig.getRequestedProject(context: context, isApproved: false, orgId:widget.orgID);
    } catch (err) {
      rethrow;
    }
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: CustomColors.kWhiteColor,
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

            }
            else if (snapshot.connectionState == ConnectionState.done) {
              return Consumer<ProjectRequestProvider>(
                  builder: (context, val, child) {
                    return val.projectRequest.isNotEmpty ? ListView.builder(
                      shrinkWrap: true,
                      itemCount: val.projectRequest.length,
                      itemBuilder: (context, index) {
                        return InkWell(
                          child: Card(
                            color: CustomColors.kWhiteColor,
                            shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(6))),
                            margin: EdgeInsets.symmetric(horizontal: size.width*0.03,vertical: size.height*0.005),
                            child: Padding(
                                padding:EdgeInsets.symmetric(horizontal: size.width*0.04,vertical: size.height*0.01),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        Expanded(
                                          child: RichText(
                                            text: TextSpan(
                                              style: const TextStyle(color: CustomColors.kBlackColor, fontSize: 14, fontFamily: 'Poppins'),
                                              children: [
                                                const TextSpan(text: 'You requested to join ',),
                                                TextSpan(text: val.projectRequest[index].projectName, style: const TextStyle(color: Colors.blue,fontSize: 14, fontFamily: 'Poppins'),),
                                                const TextSpan(text: ' Project'),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    SizedBox(
                                      width: double.infinity,
                                      child: ElevatedButton(
                                        onPressed: () {
                                          apiConfig.cancelProjectJoinedRequest(context: context, id: val.projectRequest[index].id, projectId: val.projectRequest[index].projectId, orgId: widget.orgID);
                                        },
                                        style: ElevatedButton.styleFrom(
                                            backgroundColor: CustomColors.kGrayColor,
                                            shape: RoundedRectangleBorder(
                                              borderRadius: BorderRadius.circular(6),
                                            )),
                                        child: const Text(
                                          CustomString.cancel,
                                          style: TextStyle(fontSize: 14, color: CustomColors.kBlackColor, fontFamily: 'Poppins'),
                                        ),
                                      ),
                                    ),
                                  ],
                                )),
                          ),
                        );
                      },
                    ) :
                    SizedBox(
                        width: size.width,
                        height: defaultTargetPlatform == TargetPlatform.iOS ? size.height * 0.21 : size.height * 0.25,
                        child: Center(
                          child: Column(crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Image.asset(ImagePath.noData, fit: BoxFit.fill),
                                const Text(CustomString.noDataFound, style: TextStyle(color: CustomColors.kLightGrayColor, fontFamily: 'Poppins'))
                              ]),
                        ));
                  });
            }
            else {
              debugPrint("-----Requested Training print future builder------");
            }
            return Container();
          },
        ),
      ),
    );
  }
}
