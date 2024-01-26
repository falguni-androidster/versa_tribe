import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;
import '../Providers/check_connection_provider.dart';
import 'api_config.dart';
import 'custom_string.dart';
import 'custom_toast.dart';

class AuthOP{
  //Google Authentication
  googleSignInMethod({context}) async {
    GoogleSignIn googleSignIn =
    GoogleSignIn(serverClientId: "801650424679-d8c0r27qe22lgkdbv0hjk1g8vdgkqfil.apps.googleusercontent.com"); // Harshil Web ClientID
    debugPrint("------------->GoogleLogin Method Call<------------");
    final provider = Provider.of<CheckInternet>(context,listen:false);
    if(provider.status == "Connected"){
      try {
        /// Marks current user as being in the signed out state.
        await googleSignIn.signOut();
        debugPrint("Status of Google LogOut------>${await googleSignIn.signOut()}");
        final GoogleSignInAccount? googleLoginAcResult = await googleSignIn.signIn();
        debugPrint("Status of Google Login------>${googleLoginAcResult?.email}");
        // Process the signed-in user if the sign-in was successful
        if (googleLoginAcResult == null) {
          // User abort the sign-in process
          showToast(context, "Google Login Cancel......");
        } else {
          GoogleSignInAuthentication googleAuth = await googleLoginAcResult.authentication;
          if (googleAuth.idToken!.isEmpty) {
            debugPrint("ID Token is null or empty");
            showDialog(
              context: context,
              builder: (context) => AlertDialog(
                title: const Text('Sign-in Error'),
                content: const Text('There was an issue signing in. Please try again later.'),
                actions: <Widget>[
                  TextButton(
                    onPressed: () {
                      Navigator.pop(context); // Dismiss the dialog
                    },
                    child: const Text('OK'),
                  ),
                ],
              ),
            );
            // Perform further checks or error handling specific to this case
          } else {
            debugPrint("Google Access Token------>${googleAuth.accessToken}");
            ApiConfig.externalAuthentication(context: context, authToken: googleAuth.idToken, provider: "Google",email:googleLoginAcResult.email);
            //showToast(context, "Google Login Success...");
          }
        }
      } catch (error) {
        // Handle the sign-in error
        debugPrint("Google Login Error----------*>: $error");
      }
    }else{
      showToast(context, CustomString.checkNetworkConnection);
    }
  }

  //Facebook Authentication
  facebookAuth({context}) async {
    try{
      FacebookAuth.i.logOut();
      debugPrint("---LogOut FB------>${FacebookAuth.i.logOut().hashCode}");
      final LoginResult result = await FacebookAuth.instance.login(permissions: [
        'email',
        'public_profile'
      ]); // by default we request the email and the public profile
      debugPrint("login Status --)--)--L: ${result.status}");
      // or FacebookAuth.i.login()
      // switch (result.status){
      //   case LoginStatus.cancelled: return showToast(context, "login cancel by user...");
      //   break;
      //   case LoginStatus.failed: return showToast(context, "login failed try again...");
      //   break;
      //   case LoginStatus.operationInProgress: return const SizedBox(child: CircularProgressIndicator(color: Colors.green,));
      //   break;
      //   case LoginStatus.success: {
      //     // you are logged
      //     final String accessToken = result.accessToken!.token;
      //
      //   }
      //   break;
      // }
      if (result.status == LoginStatus.success) {
        // you are logged
        final String accessToken = result.accessToken!.token;
              String userId = result.accessToken!.userId;
          // Use the userID and accessToken to make a Graph API request to get the email
          final graphResponse = await http.get(Uri.parse('https://graph.facebook.com/v14.0/$userId?fields=email&access_token=$accessToken'));
          if (graphResponse.statusCode == 200) {
            final Map<String, dynamic> data = json.decode(graphResponse.body);
            final String email = data['email'];
            debugPrint("Facebook user email: $email");

            // Now you can use the email in your application logic
            await ApiConfig.externalAuthentication(
              context: context,
              authToken: accessToken,
              provider: "Facebook",
              email: email,
            );
          } else {
            debugPrint("Failed to get user email from Facebook Graph API");
          }

        //final String accessToken = result.accessToken!.token;
        debugPrint("facebook accessToken------>$accessToken");
        debugPrint("facebook status-------------->${result.status}");
        //await ApiConfig.externalAuthentication(context: context, authToken: accessToken, provider: "Facebook",email: result.accessToken?.graphDomain);
        //return showToast(context, "facebook login success...");
      } else if (result.status == LoginStatus.operationInProgress) {
        debugPrint("facebook status inProgress-------------->${LoginStatus.operationInProgress}");
        return const SizedBox(child: CircularProgressIndicator(color: Colors.green));
      } else if (result.status == LoginStatus.failed) {
        debugPrint("facebook status failed-------------->${LoginStatus.failed}");
        return showToast(context, "login failed try again...");
      } else if (result.status == LoginStatus.cancelled) {
        debugPrint("facebook status cancelled-------------->${LoginStatus.cancelled}");
        return ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("login cancel by user...")));
      } else {
        debugPrint("facebook----->Error-->${result.status}");
      }
    }catch(e){
      debugPrint("exception error: ==-->$e");
    }
  }
}
