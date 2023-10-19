import 'package:flutter/material.dart';
import 'package:versa_tribe/Utils/custom_colors.dart';

import '../create_training_screen.dart';

class TrainingScreen extends StatefulWidget {
  const TrainingScreen({super.key});

  @override
  State<TrainingScreen> createState() => _TrainingScreenState();
}

class _TrainingScreenState extends State<TrainingScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(right: 20.0),
        child: FloatingActionButton(
          onPressed: (){
            _navigateToNextScreen(context);
          },
          backgroundColor: CustomColors.kBlueColor,
          child: const Icon(Icons.add,color: CustomColors.kWhiteColor),
        ),
      )
    );
  }

  void _navigateToNextScreen(BuildContext context) {
    Navigator.of(context)
        .push(MaterialPageRoute(builder: (context) => const CreateTrainingScreen()));
  }
}
