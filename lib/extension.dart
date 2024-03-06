import 'package:flutter/material.dart';
import 'Utils/custom_colors.dart';

export 'main.dart';
export 'Utils/api_config.dart';
export 'Utils/custom_colors.dart';
export 'Utils/custom_string.dart';
export 'Utils/custom_toast.dart';
export 'Utils/image_path.dart';
export 'Utils/validator.dart';
export 'Utils/helper.dart';
export 'Utils/shared_preference.dart';

export 'Model/approve_member.dart';
export 'Model/approve_organization.dart';
export 'Model/department.dart';
export 'Model/login_response.dart';
export 'Model/org_admin_profile.dart';
export 'Model/org_name_id.dart';
export 'Model/pending_request_members.dart';
export 'Model/person_experience.dart';
export 'Model/person_hobby.dart';
export 'Model/person_qualification.dart';
export 'Model/person_skill.dart';
export 'Model/profile_data_Model.dart';
export 'Model/request_organization.dart';
export 'Model/search_company.dart';
export 'Model/search_course.dart';
export 'Model/search_dp.dart';
export 'Model/search_hobby.dart';
export 'Model/search_industry.dart';
export 'Model/search_institute.dart';
export 'Model/search_organization.dart';
export 'Model/search_skill.dart';
export 'Model/switch_data.dart';
export 'Model/give_training_data_model.dart';
export 'Model/take_training_data_model.dart';
export 'Model/training_experience.dart';
export 'Model/training_qualification.dart';
export 'Model/training_hobby.dart';
export 'Model/training_skill.dart';
export 'Model/training_join_members.dart';
export 'Model/training_pending_requests.dart';
export 'Model/project_experience.dart';
export 'Model/project_hobby.dart';
export 'Model/project_qualification.dart';
export 'Model/project_skill.dart';
export 'Model/project_response.dart';
export 'Model/project_list_by_org_id.dart';
export 'Model/project_manage_user.dart';

export 'Providers/calling_providers.dart';
export 'Providers/dropmenu_provider.dart';
export 'Providers/visibility_join_training_btn_provider.dart';
export 'Providers/bottom_tab_provider.dart';
export 'Providers/password_provider.dart';
export 'Providers/date_provider.dart';
export 'Providers/manage_org_index_provider.dart';
export 'Providers/manage_visibility_btn.dart';
export 'Providers/onboarding_provider.dart';
export 'Providers/organization_provider.dart';
export 'Providers/person_details_provider.dart';
export 'Providers/profile_provider.dart';
export 'Providers/switch_provider.dart';
export 'Providers/training_provider.dart';
export 'Providers/check_connection_provider.dart';
export 'Providers/project_provider.dart';

///SizedBox
//Way->1----->access: SizedBoxExtension.spacing(context,h:01,w:01).
extension SizedBoxExtension on SizedBox {
  static SizedBox spacing(BuildContext context, {h, w}) {
    final size = MediaQuery.of(context).size;
    return SizedBox(height: size.height * h,width: size.width * w,);
  }
}
//Way->2----->access: spacing(context,h:01,w:01)
SizedBox spacing(BuildContext context,{h, w}) {
  final size = MediaQuery.of(context).size;
  return SizedBox(height: size.height * h, width: size.width * w,);
}
//Way->3----->access: 01.0.h
extension SizeFactors on double {
  SizedBox get h {
    return SizedBox(height: this);
  }

  SizedBox get w {
    return SizedBox(width: this);
  }
}

///ElevatedButton for detailed project adn training.
extension ElevatedButtonExtension on ElevatedButton {
  static ElevatedButton elevatedButton({
    required BuildContext context,
    required Function onPressed,
    required String text,
    required double width,
    required double height,
  }) {
    return ElevatedButton(
      onPressed: () => onPressed(),
      style: ElevatedButton.styleFrom(
        backgroundColor: CustomColors.kBlueColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(5),
        ),
        padding: EdgeInsets.symmetric(
          horizontal: width * 0.02,
          vertical: height * 0.015,
        ),
      ),
      child: Text(
        text,
        style: const TextStyle(
          fontSize: 14,
          color: Colors.white,
          fontWeight: FontWeight.normal,
          fontFamily: 'Poppins',
        ),
      ),
    );
  }
}
