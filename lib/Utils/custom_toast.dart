import 'package:flutter/material.dart';
import 'package:versa_tribe/Utils/custom_colors.dart';
import 'image_path.dart';

void showToast(BuildContext context,String message) {
  final overlay = OverlayEntry(
    builder: (context) =>
        Positioned(
          bottom: 50.0,
          left: 8.0,
          right: 8.0,
          child: Material(
            color: Colors.transparent,
            child: Container(
              padding: const EdgeInsets.symmetric(
                  horizontal: 24.0, vertical: 12.0),
              decoration: BoxDecoration(
                color: CustomColors.kBlackColor,
                borderRadius: BorderRadius.circular(8.0),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(ImagePath.androidPath,height: 30,width: 30),
                  const SizedBox(width: 10),
                  Text(
                    message,
                    style: const TextStyle(color: CustomColors.kWhiteColor, fontSize: 12, fontFamily: 'Poppins',overflow: TextOverflow.ellipsis,),
                  ),
                ],
              ),
            ),
          ),
        ),
  );

  Overlay.of(context).insert(overlay);

  // Remove the overlay after 3 seconds
  Future.delayed(const Duration(seconds: 3), () {
    overlay.remove();
  });
}
