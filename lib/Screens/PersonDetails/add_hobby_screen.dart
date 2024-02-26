import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:versa_tribe/extension.dart';

class AddHobbyScreen extends StatefulWidget {
  const AddHobbyScreen({super.key});

  @override
  State<AddHobbyScreen> createState() => _AddHobbyScreenState();
}

class _AddHobbyScreenState extends State<AddHobbyScreen> {

  final _formKey = GlobalKey<FormState>();
  TextEditingController hobbyController = TextEditingController();
  dynamic providerHobby;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    providerHobby = Provider.of<SearchHobbyProvider>(context,listen: false);
    providerHobby.hobbyList.clear();
  }
  @override
  Widget build(BuildContext context) {
    final providerHobby = Provider.of<SearchHobbyProvider>(context, listen: false);
    var size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: CustomColors.kGrayColor,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(Icons.arrow_back_ios, color: CustomColors.kBlackColor),
        ),
        centerTitle: true,
        title: const Text(CustomString.createHobby,
            style: TextStyle(color: CustomColors.kBlueColor,fontSize:16,fontFamily: 'Poppins')),
      ),
      body: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Padding(
            padding: EdgeInsets.symmetric(
                horizontal: size.width * 0.04, vertical: size.height * 0.02),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                /// Hobby name
                SizedBox(
                  height: size.height*0.09,
                  child: TextFormField(
                      controller: hobbyController,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return CustomString.hobbyRequired;
                        } else {
                          return null;
                        }
                      },
                      onChanged: (value) {
                        if (value != "") {
                          apiConfig.searchHobby(context: context, hobbyString: value);
                          providerHobby.hobbyList.clear();
                          providerHobby.setVisible(true);
                        }else{
                          providerHobby.setVisible(false);
                        }
                        providerHobby.hobbyList.clear();
                      },
                      cursorColor: CustomColors.kBlueColor,
                      decoration: const InputDecoration(
                          labelText: CustomString.searchHobby,
                          labelStyle: TextStyle(
                              color: CustomColors.kLightGrayColor, fontSize: 14,fontFamily: 'Poppins')),
                      style: const TextStyle(color: CustomColors.kBlackColor, fontSize: 14, fontFamily: 'Poppins')),
                ),
                Consumer<SearchHobbyProvider>(builder: (context, val, child) {
                  return val.visible == true ? ListView.builder(
                      shrinkWrap: true,
                      itemCount: val.hobbyList.length,
                      itemBuilder: (context, index) {
                        debugPrint("hobby search--------->${val.hobbyList[index].name}");
                        return InkWell(
                          child: Card(
                            shadowColor: CustomColors.kBlueColor,
                            elevation: 3,
                            color: CustomColors.kGrayColor,
                            child: Container(
                                padding:
                                EdgeInsets.only(left: size.width * 0.02),
                                height: size.height * 0.05,
                                alignment: Alignment.centerLeft,
                                child: Text('${val.hobbyList[index].name}',
                                    style: const TextStyle(color: CustomColors.kLightGrayColor,fontFamily: 'Poppins'))),
                          ),
                          onTap: () async {
                            hobbyController.text = val.hobbyList[index].name ?? hobbyController.text;
                            val.setVisible(false);
                          },
                        );
                      }): Container();
                }),
                SizedBox(height: size.height * 0.03),
                /// Submit Button
                SizedBox(
                    width: double.infinity,
                    height: size.height * 0.06,
                    child: ElevatedButton(
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          apiConfig.addHobbyData(
                              context: context,
                              hobbyName: hobbyController.text);
                        } else {
                          return;
                        }
                      },
                      style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all(CustomColors.kBlueColor),
                          shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                                  RoundedRectangleBorder(borderRadius: BorderRadius.circular(10), side: const BorderSide(color: Colors.transparent)))),
                      child: const Text(CustomString.buttonContinue,
                          style: TextStyle(
                            color: CustomColors.kWhiteColor,
                            fontSize: 20,
                            fontFamily: 'Poppins',
                            fontWeight: FontWeight.w600,
                          )),
                    )),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
