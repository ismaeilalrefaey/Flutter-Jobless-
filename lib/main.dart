// @dart=2.9

import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import '../Screens/jobs_posted_by_company.dart';
import '../Screens/add_details_screens/add_new_company_job.dart';
import '../Screens/change_home_page.dart';
import '../Screens/company_profile_screen.dart';
import '../Screens/guest_screen.dart';
import 'package:provider/provider.dart';
import 'package:connectivity/connectivity.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

import 'config.dart';
import './providers/auth.dart';
import '../providers/email.dart';
import './providers/details.dart';
import './widget/app_drawer.dart';
import '../providers/accounts.dart';
import './Screens/job_details.dart';
import './Screens/login_screen.dart';
import './profiles/user_profile.dart';
import '../Screens/admin_screen.dart';
import '../Screens/job_applicant.dart';
import '../Screens/favorite_user.dart';
import './providers/job_business.dart';
import '../providers/notification.dart';
import '../providers/previous_work.dart';
// import 'Screens/listed_jobs_screen.dart';
import './profiles/company_profile.dart';
import '../providers/admin_provider.dart';
import './providers/freelance_offer.dart';
import './Screens/favorite_freelancer.dart';
import './Screens/notification_screen.dart';
import '../Screens/wait_company_screen.dart';
import './providers/employment_details.dart';
import './Screens/jobs_overview_screen.dart';
import './Screens/chosen_account_screen.dart';
import '../Screens/all_freelancers_screen.dart';
import '../Screens/freelancer_offer_detail.dart';
import './profiles/freelancer_profile.dart.dart';
import './Screens/employment_details_screen.dart';
import './Screens/email_screens/emails_screen.dart';
import './Screens/requests_screen/user_requests.dart';
import './Screens/sign_up_screens/sign_up_screen.dart';
import 'Screens/jobs_posted_by_user.dart';
import './editing_screens/edit_basic_details_screen.dart';
import './Screens/email_screens/sending_email_screen.dart';
import './Screens/requests_screen/freelancer_requests.dart';
import './editing_screens/edit_company_details_screen.dart';
import './editing_screens/edit_additional_details_screen.dart';
import './Screens/sign_up_screens/sign_up_company_screen.dart';
import './editing_screens/edit_educational_details_screen.dart';
import '../Screens/add_details_screens/add_new_freelance_offer_screen.dart';
import '../Screens/add_details_screens/add_new_emplyment_details_screen.dart';

AndroidNotificationChannel channel;
FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  await FirebaseMessaging.instance.requestPermission(
    criticalAlert: true,
    announcement: true,
    carPlay: true,
  );

  channel = const AndroidNotificationChannel(
    'high_importance_channel', // id
    'High Importance Notifications', // name
    'This channel is used for important notifications.', // description
    importance: Importance.high,
  );

  flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
  await flutterLocalNotificationsPlugin
      .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin>()
      .createNotificationChannel(channel);

  var token = await FirebaseMessaging.instance.getToken();
  print(token);

  // SystemChrome.setSystemUIOverlayStyle(currentTheme.currentTheme() == ThemeMode.dark ? SystemUiOverlayStyle.dark : SystemUiOverlayStyle.light);

  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String _connectionStatus = 'Unknown';
  final Connectivity _connectivity = Connectivity();
  StreamSubscription<ConnectivityResult> _connectivitySubscription;

  @override
  void dispose() {
    _connectivitySubscription.cancel();
    super.dispose();
  }

  Future<void> _updateConnectionStatus(ConnectivityResult result) async {
    switch (result) {
      case ConnectivityResult.wifi:
      case ConnectivityResult.mobile:
      case ConnectivityResult.none:
        setState(() => _connectionStatus = result.toString());
        break;
      default:
        setState(() => _connectionStatus = 'Failed to get connectivity.');
        break;
    }
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> initConnectivity() async {
    ConnectivityResult result = ConnectivityResult.none;
    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      result = await _connectivity.checkConnectivity();
    } catch (e) {
      print(e.toString());
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) {
      return Future.value(null);
    }

    return _updateConnectionStatus(result);
  }

  @override
  void initState() {
    initConnectivity();
    _connectivitySubscription =
        _connectivity.onConnectivityChanged.listen(_updateConnectionStatus);

    FirebaseMessaging.instance
        .getInitialMessage()
        .then((RemoteMessage message) {
      if (message != null) {
        Navigator.of(context).pushReplacementNamed(
          NotificationsScreen.routeName,
          arguments: message.data['id'],
        );
      }
    });

    currentTheme.addListener(() {
      print('changes');
      setState(() {});
    });

    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      RemoteNotification notification = message.notification;
      AndroidNotification android = message.notification.android;
      if (notification != null && android != null /*&& !kIsWeb*/) {
        flutterLocalNotificationsPlugin.show(
          notification.hashCode,
          notification.title,
          notification.body,
          NotificationDetails(
            android: AndroidNotificationDetails(
              channel.id,
              channel.name,
              channel.description,
              icon: 'launch_background',
            ),
          ),
        );
      }
    });

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      print('A new onMessageOpenedApp event was published!');
      Navigator.of(context).pushReplacementNamed(
        NotificationsScreen.routeName,
        arguments: message.data['id'],
      );
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (ctx) => JobBusiness()),
        ChangeNotifierProvider(create: (ctx) => EmailBusiness()),
        ChangeNotifierProvider(create: (ctx) => AdminProvider()),
        ChangeNotifierProvider(create: (ctx) => Authentication()),
        ChangeNotifierProvider(create: (ctx) => NotificationProvider()),
        ChangeNotifierProvider(create: (ctx) => PreviousWorkProvider()),
        ChangeNotifierProvider(create: (ctx) => BasicDetailsProvider()),
        ChangeNotifierProvider(create: (ctx) => FreelanceOfferBusiness()),
        ChangeNotifierProvider(create: (ctx) => CompanyDetailsProvider()),
        ChangeNotifierProvider(create: (ctx) => AdditionalDetailsProvider()),
        ChangeNotifierProvider(create: (ctx) => EmploymentDetailsProvider()),
        ChangeNotifierProvider(create: (ctx) => EducationalDetailsProvider()),
        ChangeNotifierProxyProvider<Authentication, AppDrawer>(
          create: null,
          update: (ctx, authenticationObject, _) => AppDrawer(
              authenticationObject.object), //authenticationObject.response
        ),
        ChangeNotifierProxyProvider<Authentication, CompanyAccount>(
          create: null,
          update: (ctx, auth, _) =>
              CompanyAccount(json.encode((auth.response))),
        ),
        ChangeNotifierProxyProvider<Authentication, UserAccount>(
          create: null,
          update: (ctx, auth, _) => UserAccount(json.encode((auth.response))),
        ),
        ChangeNotifierProxyProvider<Authentication, FreelancerAccount>(
          create: null,
          update: (ctx, auth, _) =>
              FreelancerAccount(json.encode((auth.response))),
        ),
      ],
      child: Consumer<Authentication>(
        builder: (ctx, authData, _) => MaterialApp(
          title: 'Project 1',
          home: authData.isAuthenticated
              ? authData.type == AccountType.Admin
                  ? AdminScreen()
                  : authData.type == AccountType.Company
                      ? authData.object != null
                          ? JobsPostedByCompany(authData.authenticatedAccount)
                          : WaitComapanyScreen()
                      : authData.type == AccountType.User
                          ? HomePage(
                              account: authData.authenticatedAccount,
                            )
                          : JobOverviewScreen(authData.authenticatedAccount)
              : LoginScreen(),
          // JobOverviewScreen(userAccount(true)),
          theme: ThemeData.light(),
          darkTheme: ThemeData.dark(),
          themeMode: currentTheme.currentTheme(),
          debugShowCheckedModeBanner: false,
          routes: {
            SignUp.routeName: (ctx) => SignUp(),
            JobDetails.routeName: (ctx) => JobDetails(),
            LoginScreen.routeName: (ctx) => LoginScreen(),
            UserRequest.routeName: (ctx) => UserRequest(),
            UserProfile.routeName: (ctx) => UserProfile(),
            AdminScreen.routeName: (ctx) => AdminScreen(),
            GuestScreen.routeName: (ctx) => GuestScreen(),
            EmailsScreen.routeName: (ctx) => EmailsScreen(),
            JobApplicant.routeName: (ctx) => JobApplicant(),
            UserFavorite.routeName: (ctx) => UserFavorite(),
            SignUpCompany.routeName: (ctx) => SignUpCompany(),
            ChosenAccount.routeName: (ctx) => ChosenAccount(),
            CompanyProfile.routeName: (ctx) => CompanyProfile(),
            HomePage.routeName: (ctx) => HomePage(account: authData.object),
            // AddNewCompanyJob.routeName: (ctx) => AddNewCompanyJob(),
            JobOverviewScreen.routeName: (ctx) =>
                JobOverviewScreen(authData.authenticatedAccount),
            FreelancerProfile.routeName: (ctx) => FreelancerProfile(),
            WaitComapanyScreen.routeName: (ctx) => WaitComapanyScreen(),
            FreelancerRequests.routeName: (ctx) => FreelancerRequests(),
            FreelancerFavorite.routeName: (ctx) => FreelancerFavorite(),
            SendingEmailScreen.routeName: (ctx) => SendingEmailScreen(),
            JobsPostedByCompany.routeName: (ctx) =>
                JobsPostedByCompany(authData.object),
            NotificationsScreen.routeName: (ctx) => NotificationsScreen(),
            CompanyProfileScreen.routeName: (ctx) => CompanyProfileScreen(),
            EditBasicDetailsScreen.routeName: (ctx) => EditBasicDetailsScreen(),
            // AddNewCompanyJob.routeName: (ctx) => AddNewCompanyJob(),
            AllFreelancers.routeName: (ctx) => AllFreelancers(),
            EmploymentDetailsScreen.routeName: (ctx) =>
                EmploymentDetailsScreen(),
            AddFreelanceOfferScreen.routeName: (ctx) =>
                AddFreelanceOfferScreen(authData.object),
            AddNewCompanyJob.routeName: (ctx) =>
                AddNewCompanyJob(authData.object),
            EditCompanyDetailsScreen.routeName: (ctx) =>
                EditCompanyDetailsScreen(),
            FreelancerOfferDetail.routeName: (ctx) => FreelancerOfferDetail(),
            JobsPostedByUser.routeName: (ctx) => JobsPostedByUser(),
            EditAdditionalDetailsScreen.routeName: (ctx) =>
                EditAdditionalDetailsScreen(),
            EditEducationalDetailsScreen.routeName: (ctx) =>
                EditEducationalDetailsScreen(),
            AddNewEmploymentDetailsScreen.routeName: (ctx) =>
                AddNewEmploymentDetailsScreen(),
            // ApplicantsForAJob.routeName: (ctx) => ApplicantsForAJob(),
          },
        ),
      ),
    );
  }
}

// import 'dart:convert';
// import 'dart:developer';
// import 'dart:io';
// import 'dart:typed_data';
// import 'package:file_picker/file_picker.dart';
// import 'package:flutter/material.dart';
// import '../services/random_object_generator.dart';
// import 'package:path_provider/path_provider.dart';
// import '../PDF_bussiness/PDFApi.dart';
// import '../temp.dart';
// import 'package:razorpay_flutter/razorpay_flutter.dart';
// import 'package:toast/toast.dart';
// import 'PDF_bussiness/PDF_view.dart';
// import 'global_stuff.dart';
// import 'package:http/http.dart' as http;

// void main() async {
//   WidgetsFlutterBinding.ensureInitialized();
//   // String salary = 'Less than 100\$';
//   // String yearsOfExperience = 'More than 10 years';
//   // Range salaryRange = salary.contains('-')
//   //     ? Range(
//   //         num.parse(salary.substring(0, salary.indexOf('\$'))),
//   //         num.parse(
//   //             salary.substring(salary.indexOf('-') + 2, salary.length - 1)))
//   //     : salary.contains('Less')
//   //         ? Range(0, num.parse(salary.substring(10, salary.length - 1)))
//   //         : salary.contains('More')
//   //             ? Range(
//   //                 num.parse(salary.substring(10, salary.length - 1)), 100000)
//   //             : null;
//   // Range yearsRange = yearsOfExperience.contains('-')
//   //     ? Range(
//   //         num.parse(yearsOfExperience.substring(
//   //             0, yearsOfExperience.indexOf('-') - 1)),
//   //         num.parse(yearsOfExperience.substring(
//   //             yearsOfExperience.indexOf('-') + 2,
//   //             yearsOfExperience.indexOf('y') - 1)))
//   //     : yearsOfExperience.contains('Less')
//   //         ? Range(
//   //             0,
//   //             num.parse(yearsOfExperience.substring(
//   //                 10, yearsOfExperience.indexOf('y') - 1)))
//   //         : yearsOfExperience.contains('More')
//   //             ? Range(
//   //                 num.parse(yearsOfExperience.substring(
//   //                     10, yearsOfExperience.indexOf('y') - 1)),
//   //                 100000)
//   //             : null;
//   // print(salaryRange);
//   // print(yearsRange);

//   // await initDict();

//   // print(randomListOfInts(150));

//   // print('${(await getTemporaryDirectory()).path}');

//   runApp(RazorpayApp());
// }

// class RazorpayApp extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'Flutter Demo',
//       theme: ThemeData(
//         primarySwatch: Colors.blue,
//       ),
//       home: MyHomePage(),
//     );
//   }
// }

// class MyHomePage extends StatefulWidget {
//   @override
//   _MyHomePageState createState() => _MyHomePageState();
// }

// class _MyHomePageState extends State<MyHomePage> {
//   Razorpay razorpay;
//   double amount = 0.0;
//   @override
//   void initState() {
//     super.initState();
//     razorpay = Razorpay();
//     razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, handlerPaymentSuccess);
//     razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, handlerPaymentError);
//     razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, handlerExternalWallet);

//     (() async {
//       f = File((await FilePicker.platform.pickFiles(type: FileType.image))
//           .paths
//           .first);
//       _base64 = base64.encode((await f.readAsBytes()));
//       http.Response response = await http.post(
//         Uri.parse('$ipAddress/hat/sora'),
//         headers: <String, String>{'Content-Type': 'application/json'},
//         body: json.encode({'string': _base64}),
//       );
//       var responseBody = json.decode(response.body);
//       log(responseBody['string']);
//       var list8 = base64.decode(responseBody['string']);
//       f.writeAsBytes(list8.toList());
//       setState(() {});
//     })();
//   }

//   @override
//   void dispose() {
//     super.dispose();
//     razorpay.clear();
//   }

//   void handlerPaymentSuccess(PaymentSuccessResponse response) {
//     Toast.show(
//         'Payment Succeeded !! Payment ID: ${response.paymentId}', context,
//         duration: 5,
//         gravity: Toast.BOTTOM,
//         backgroundColor: Theme.of(context).primaryColor,
//         backgroundRadius: 20);
//   }

//   void handlerPaymentError(PaymentFailureResponse response) {
//     Toast.show('Payment Failed :(\nError Message: ${response.message}', context,
//         duration: 5,
//         gravity: Toast.BOTTOM,
//         backgroundColor: Theme.of(context).errorColor,
//         backgroundRadius: 10);
//   }

//   void handlerExternalWallet(ExternalWalletResponse response) {
//     Toast.show(response.walletName, context,
//         duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
//   }

//   void openCheckout() {
//     var options = {
//       'key':
//           'rzp_test_w4aZd3UXQ2gjZC', // Randomly generated from dashboard.razorpay.com
//       'amount': amount * 100.0, // Wage
//       'name': 'MiDzz', // User's name
//       'description': 'Razorpay App', // Dummy data
//       'external': {
//         'wallets': ['paytm'] // DK -.-
//       },
//       'prefill': {
//         'contact': '0932450315', // Freelancer's phone number
//         'email': 'milad.khnefes.16@gmail.com', // Freelancer's email
//       }
//     };

//     try {
//       razorpay.open(options);
//     } catch (e) {
//       print(e.toString());
//     }
//   }

//   String _base64;
//   File f;
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text(_base64 == null ? 'Empty' : _base64.length.toString()),
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(28.0),
//         child: Column(
//           children: [
//             CircleAvatar(
//               child: f == null
//                   ? Icon(Icons.person)
//                   : Image.file(
//                       f,
//                       fit: BoxFit.fitWidth,
//                     ),
//               // _base64 == null ? null : Image.memory(base64.decode(_base64)),
//             ),
//             TextField(
//               decoration: InputDecoration(hintText: 'Amount to pay'),
//               onChanged: (value) {
//                 amount = double.parse(value);
//               },
//             ),
//             SizedBox(height: 12),
//             ElevatedButton(
//               child: Text('Pay now !!'),
//               onPressed: // openCheckout,
//                   () async {
//                 // File f = File(
//                 //     (await FilePicker.platform.pickFiles(type: FileType.image))
//                 //         .paths
//                 //         .first);
//                 // print(await f.exists());
//                 // String S = fileToString(f);
//                 // print('fileToString');
//                 // File s = stringToFile(S, 'jpg');
//                 // print('stringToFile');
//                 // print(await s.exists());

//                 // File f = await PDFApi.pickFile();
//                 // Navigator.of(context).push(MaterialPageRoute(
//                 //     builder: (context) => PDFViewer(file: f)));
//                 // print(stringToFile(f.readAsBytes().toString(), 'jpg'));

//                 // if (_base64 == null) return new Container();
//                 // Uint8List bytes = base64.decode(_base64);
//                 // return new Scaffold(
//                 //   appBar: new AppBar(title: new Text('Example App')),
//                 //   body: new ListTile(
//                 //     leading: new Image.memory(bytes),
//                 //     title: new Text(_base64),
//                 //   ),
//                 // );
//               },
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
