import 'dart:convert';
import 'dart:io';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:versa_tribe/Screens/home_screen.dart';
import 'package:versa_tribe/Screens/Profile/create_profile_screen.dart';
import 'package:versa_tribe/Screens/sign_up_screen.dart';
import 'package:http/http.dart' as http;
import 'forgot_password_screen.dart';
import 'package:versa_tribe/extension.dart';

class SignInScreen extends StatefulWidget {

  const SignInScreen({super.key});

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  ConnectivityResult connectivityResult = ConnectivityResult.none;

  //GoogleSignIn googleSignIn = GoogleSignIn(clientId: '801650424679-gfhm5fbk06pbqugfdp8cr1854bo6t46c.apps.googleusercontent.com');

/*  GoogleSignIn googleSignIn = defaultTargetPlatform==TargetPlatform.android?
       GoogleSignIn(clientId: '924555205284-uo6blsjm998el16rjamv0gnpm9eop1si.apps.googleusercontent.com')
      :defaultTargetPlatform==TargetPlatform.iOS?GoogleSignIn(clientId: '924555205284-iembjogplf12k21veub6b8a2uqjicbs9.apps.googleusercontent.com'):
      //:defaultTargetPlatform==TargetPlatform.iOS?GoogleSignIn(clientId: 'com.googleusercontent.apps.924555205284-iembjogplf12k21veub6b8a2uqjicbs9'):
  GoogleSignIn(clientId: '924555205284-mp8ndh82982lq9h5ak2j5vc81o9to1mi.apps.googleusercontent.com');*/


  @override
  void initState() {
    super.initState();
    // Listen for connectivity changes and update the UI accordingly.
    connection(context);
   // checkSignInStatus();
  }

  // void checkSignInStatus() async {
  //   bool isSignedIn = await googleSignIn.isSignedIn();
  //   if (isSignedIn) {
  //     debugPrint("User Signed In");
  //   } else {
  //     debugPrint("User Signed Out");
  //   }
  // }

  void _handleSignIn(context) async {
    //Default definition
    GoogleSignIn googleSignIn = GoogleSignIn(
      scopes: [
        'email',
      ],
    );

//If current device is Web or Android, do not use any parameters except from scopes.
    if (kIsWeb || Platform.isAndroid ) {
      googleSignIn = GoogleSignIn(
        scopes: [
          'email',
        ],
      );
    }

//If current device IOS or MacOS, We have to declare clientID
//Please, look STEP 2 for how to get Client ID for IOS
    if (Platform.isIOS || Platform.isMacOS) {
      googleSignIn = GoogleSignIn(
        clientId:
        "924555205284-iembjogplf12k21veub6b8a2uqjicbs9.apps.googleusercontent.com",
        scopes: [
          'email',
        ],
      );
    }

    try {
      googleSignIn.signOut();
      final GoogleSignInAccount? googleSignInAccount = await googleSignIn.signIn();
      // Process the signed-in user if the sign-in was successful
      if (googleSignInAccount != null) {
        String id = googleSignInAccount.id;
        String email = googleSignInAccount.email;
        String? serverAuthCode = googleSignInAccount.serverAuthCode;
        String? profilePhoto = googleSignInAccount.photoUrl;
        String? displayName = googleSignInAccount.displayName;
        debugPrint("------>id: $id");
        debugPrint("------>email: $email");
        debugPrint("------>serverAuthCode: $serverAuthCode");
        debugPrint("------>profilePhoto: $profilePhoto");
        debugPrint("------>displayName: $displayName");


        GoogleSignInAuthentication googleAuth = await googleSignInAccount.authentication;
        // Access the Access Token
        String accessToken = googleAuth.accessToken!;
        String? idToken = googleAuth.idToken;
        var runtimeType = googleAuth.runtimeType;
        int hashCode = googleAuth.hashCode;
        debugPrint("------>Access Token: $accessToken");
        debugPrint("------>id Token: $idToken");
        debugPrint("------>runtimeType: $runtimeType");
        debugPrint("------>hashCode: $hashCode");

        showToast(context, "Google Login Success...");
      } else {
        // User cancelled the sign-in process
        showToast(context, "Google Login Cancel...");
      }
    } catch (error) {
      // Handle the sign-in error
      debugPrint("Error signing in with Google------*>: $error");
    }
   }


  // void _handleSignIn(context) async {
  //   await googleSignIn.signOut();
  //   googleSignIn = GoogleSignIn(scopes: ['email']);
  //   try {
  //     final GoogleSignInAccount? googleSignInAccount = await googleSignIn.signIn();
  //     // Process the signed-in user if the sign-in was successful
  //     if (googleSignInAccount != null) {
  //       String id = googleSignInAccount.id;
  //       String email = googleSignInAccount.email;
  //       String? serverAuthCode = googleSignInAccount.serverAuthCode;
  //       String? profilePhoto = googleSignInAccount.photoUrl;
  //       String? displayName = googleSignInAccount.displayName;
  //       debugPrint("------>id: $id");
  //       debugPrint("------>email: $email");
  //       debugPrint("------>serverAuthCode: $serverAuthCode");
  //       debugPrint("------>profilePhoto: $profilePhoto");
  //       debugPrint("------>displayName: $displayName");
  //
  //
  //       GoogleSignInAuthentication googleAuth = await googleSignInAccount.authentication;
  //       // Access the Access Token
  //       String accessToken = googleAuth.accessToken!;
  //       String? idToken = googleAuth.idToken;
  //       var runtimeType = googleAuth.runtimeType;
  //       int hashCode = googleAuth.hashCode;
  //       debugPrint("------>Access Token: $accessToken");
  //       debugPrint("------>id Token: $idToken");
  //       debugPrint("------>runtimeType: $runtimeType");
  //       debugPrint("------>hashCode: $hashCode");
  //
  //       showToast(context, "Google Login Success...");
  //     } else {
  //       // User cancelled the sign-in process
  //       showToast(context, "Google Login Cancel...");
  //     }
  //   } catch (error) {
  //     // Handle the sign-in error
  //     debugPrint("Error signing in with Google------*>: $error");
  //   }
  // }

  Future<void> _loginWithFacebook() async {
    try {
      final LoginResult result = await FacebookAuth.instance.login();

      if (result.status == LoginStatus.success) {
        // Access token obtained
        final AccessToken accessToken = result.accessToken!;
        debugPrint('Access Token: ${accessToken.token}');
        // Use the access token for further operations
      } else {
        // Login failed or was canceled by the user
        debugPrint('Facebook login failed');
      }
    } catch (e) {
      // Handle exceptions
      debugPrint('Error logging in with Facebook: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        backgroundColor: CustomColors.kWhiteColor,
        body: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [

                    SizedBox(height: size.height * 0.05),

                    const Text(
                      CustomString.hello,
                      style: TextStyle(
                          fontSize: 50,
                          color: CustomColors.kBlueColor,
                          fontFamily: 'Poppins'),
                    ),

                    const Text(
                      CustomString.again,
                      style: TextStyle(
                          fontSize: 50,
                          color: CustomColors.kBlueColor,
                          fontWeight: FontWeight.w600,
                          fontFamily: 'Poppins',
                          decoration: TextDecoration.underline,
                          decorationColor: CustomColors.kBlueColor),
                    ),

                    SizedBox(height: size.height * 0.02),

                    const Text(
                      CustomString.welcomeBack,
                      style: TextStyle(
                          fontSize: 20,
                          color: CustomColors.kLightGrayColor,
                          fontFamily: 'Poppins',
                          fontWeight: FontWeight.w400),
                    ),

                    SizedBox(height: size.height * 0.02),

                    /// Email Address Field
                    TextFormField(
                      controller: emailController,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return CustomString.emailRequired;
                        } // using regular expression
                        else if (!Validator().regEmail.hasMatch(value)) {
                          return CustomString.validEmailAddress;
                        } else {
                          return null;
                        }
                      },
                      decoration: const InputDecoration(
                          labelText: CustomString.emailAddress,
                          labelStyle: TextStyle(
                              color: CustomColors.kLightGrayColor,
                              fontSize: 14,
                              fontFamily: 'Poppins')),
                      style: const TextStyle(
                          fontSize: 14,
                          color: CustomColors.kBlackColor,
                          fontFamily: 'Poppins'),
                    ),

                    SizedBox(height: size.height * 0.02),

                    /// Password Field
                    Consumer<SignInPwdProvider>(builder: (context, val, child) {
                      return TextFormField(
                        controller: passwordController,
                        obscureText: val.visible,
                        validator: (value) {
                          if (value!.isEmpty) {
                            return CustomString.passwordRequired;
                          } // using regular expression
                          else if (!Validator().regPassword.hasMatch(value)) {
                            return CustomString.validPassword;
                          } else {
                            return null;
                          }
                        },
                        style: const TextStyle(
                            fontSize: 14,
                            color: CustomColors.kBlackColor,
                            fontFamily: 'Poppins'),
                        decoration: InputDecoration(
                            suffixIcon: InkWell(
                              child: Icon(
                                  val.visible == true
                                      ? Icons.visibility
                                      : Icons.visibility_off,
                                  color: CustomColors.kLightGrayColor),
                              onTap: () {
                                val.setVisible();
                              },
                            ),
                            labelText: CustomString.password,
                            labelStyle: const TextStyle(
                                color: CustomColors.kLightGrayColor,
                                fontSize: 14,
                                fontFamily: 'Poppins')
                        ),
                      );
                    }),

                    SizedBox(height: size.height * 0.02),

                    /// Forgot Password
                    Align(
                      alignment: Alignment.centerLeft,
                      child: InkWell(
                        onTap: () {
                          _navigateToNextScreen(
                              context: context, screenName: 'forgotScreen');
                        },
                        child: const Text(
                          CustomString.forgotPassword,
                          style: TextStyle(
                              color: CustomColors.kBlueColor,
                              fontSize: 14,
                              fontFamily: 'Poppins'),
                        ),
                      ),
                    ),

                    SizedBox(height: size.height * 0.02),

                    /// SignIn Button
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            signInClick(context);
                          } else {
                            return;
                          }
                        },
                        style: ElevatedButton.styleFrom(
                            backgroundColor: CustomColors.kBlueColor,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(6),
                            ),
                            padding: const EdgeInsets.all(16)),
                        child: const Text(
                          CustomString.signIn,
                          style: TextStyle(
                              fontSize: 14,
                              color: Colors.white,
                              letterSpacing: 1,
                              fontWeight: FontWeight.w600,
                              fontFamily: 'Poppins'),
                        ),
                      ),
                    ),

                    SizedBox(height: size.height * 0.02),

                    const Align(
                      alignment: Alignment.center,
                      child: Text(
                        CustomString.continueWith,
                        style: TextStyle(
                            color: CustomColors.kLightGrayColor,
                            fontSize: 14,
                            fontFamily: 'Poppins'),
                      ),
                    ),

                    SizedBox(height: size.height * 0.01),

                    /// Social Buttons
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: ElevatedButton.icon(
                              onPressed: () {
                                _handleSignIn(context);
                              },
                              icon: Image.asset(ImagePath.googlePath),
                              label: const Text(CustomString.google,
                                  style: TextStyle(
                                      fontFamily: 'Poppins', fontSize: 12)),
                              style: ElevatedButton.styleFrom(
                                  foregroundColor: CustomColors.kLightGrayColor,
                                  backgroundColor: CustomColors.kGrayColor,
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
                                  padding: const EdgeInsets.all(12)),
                            ),
                          ),
                        ),
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: ElevatedButton.icon(
                              onPressed: _loginWithFacebook,
                              icon: Image.asset(ImagePath.facebookPath),
                              label: const Text(CustomString.facebook,
                                  style: TextStyle(
                                      fontFamily: 'Poppins', fontSize: 12)),
                              style: ElevatedButton.styleFrom(
                                  foregroundColor: CustomColors.kLightGrayColor,
                                  backgroundColor: CustomColors.kGrayColor,
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
                                  padding: const EdgeInsets.all(12)),
                            ),
                          ),
                        ),
                      ],
                    ),

                    SizedBox(height: size.height * 0.01),

                    /// SignIn Text
                    InkWell(
                      onTap: () {
                        _navigateToNextScreen(
                            context: context, screenName: 'signupScreen');
                      },
                      highlightColor: CustomColors.kWhiteColor,
                      child: const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            CustomString.donTHaveAccount,
                            style: TextStyle(
                                color: CustomColors.kLightGrayColor,
                                fontSize: 12,
                                fontFamily: 'Poppins',
                                fontWeight: FontWeight.w600),
                          ),
                          Text(
                            CustomString.signUp,
                            style: TextStyle(
                                color: CustomColors.kLightGrayColor,
                                fontSize: 14,
                                fontFamily: 'Poppins',
                                decoration: TextDecoration.underline,
                                fontWeight: FontWeight.w600),
                          ),
                        ],
                      ),
                    ),
                  ]),
            ),
          ),
        ),
      ),
    );
  }

  // Navigate to Next Screen
  Future<void> _navigateToNextScreen({context, screenName, loginData}) async {
    if (screenName == 'signupScreen') {
      Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => const SignUpScreen()));
    } else if (screenName == 'forgotScreen') {
      Navigator.of(context).push(
          MaterialPageRoute(
              builder: (context) => const ForgotPasswordScreen()));
    } else if (screenName == 'profileScreen') {
      Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => const CreateProfileScreen()));
    } else if (screenName == 'mainScreen') {
      Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => const HomeScreen()));
    }
  }

  Future<void> signInClick(context) async {
    final provider = Provider.of<CheckInternet>(context,listen:false);
    debugPrint("status-internet------>${provider.status}");
    LoginResponseModel loginResponseModelData;
    if (provider.status == "Connected") {
      Map signInParameter = {
        "username": emailController.text.toString(),
        "password": passwordController.text.toString(),
        "grant_type": "password"
      };
      const String loginUrl = '${ApiConfig.baseUrl}/token';
      var response = await http.post(Uri.parse(loginUrl), body: signInParameter);
      Map<String, dynamic> jsonData = jsonDecode(response.body); // Return Single Object
      loginResponseModelData = LoginResponseModel.fromJson(jsonData);
      if (response.body.isNotEmpty) {
        debugPrint("------->${loginResponseModelData.accessToken}");
        if (loginResponseModelData.accessToken != null) {
          final SharedPreferences pref = await SharedPreferences.getInstance();
          pref.setString(CustomString.accessToken,
              loginResponseModelData.accessToken.toString());
          showToast(context, CustomString.accountLoginSuccess);
          pref.setBool(CustomString.isLoggedIn, true);
          if (loginResponseModelData.profileExist != "True") {
            if (!mounted) return;
            _navigateToNextScreen(context: context, screenName: 'profileScreen');
          } else {
            if (!mounted) return;
            _navigateToNextScreen(context: context, screenName: "mainScreen", loginData: loginResponseModelData);
          }
        } else {
          showToast(context, CustomString.checkYourEmail);
        }
      } else {
        const CircularProgressIndicator();
        showToast(context, CustomString.loginFailed);
      }
    }
    else{
    showToast(context, CustomString.checkNetworkConnection);
    }

  }
}
