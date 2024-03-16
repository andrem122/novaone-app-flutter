import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:novaone/constants.dart';
import 'package:novaone/novaOneTableHelper.dart';
import 'package:novaone/palette.dart';
import 'package:novaone/screens/screens.dart';
import 'package:provider/provider.dart';
import 'controllers/controller.dart';
import 'localizations.dart';
import 'package:sqflite/sqflite.dart';
import 'widgets/widgets.dart';
import 'package:path/path.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  /// Set the orientation to be portrait up
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);

  /// Initialize firebase
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  /// Write SQL needed to create local database tables
  final String leadsSql = """
  CREATE TABLE ${NovaOneTableHelper.instance.leads} 
      (id INTEGER PRIMARY KEY,
      ${NovaOneTableColumns.instance.localLeadName} TEXT, 
      ${NovaOneTableColumns.instance.localLeadPhone} TEXT, 
      ${NovaOneTableColumns.instance.localLeadEmail} TEXT, 
      ${NovaOneTableColumns.instance.localLeadDateOfInquiry} TEXT, 
      ${NovaOneTableColumns.instance.localLeadRenterBrand} TEXT, 
      ${NovaOneTableColumns.instance.localLeadCompanyId} INTEGER, 
      ${NovaOneTableColumns.instance.localLeadSentTextDate} TEXT, 
      ${NovaOneTableColumns.instance.localLeadSentEmailDate} TEXT, 
      ${NovaOneTableColumns.instance.localLeadFilledOutForm} INTEGER, 
      ${NovaOneTableColumns.instance.localLeadMadeAppointment} INTEGER, 
      ${NovaOneTableColumns.instance.localLeadCompanyName} TEXT)""";

  final String appointmentsSql = """
  CREATE TABLE ${NovaOneTableHelper.instance.appointmentsBase} 
      (id INTEGER PRIMARY KEY,
      ${NovaOneTableColumns.instance.localAppointmentName} TEXT, 
      ${NovaOneTableColumns.instance.localAppointmentPhone} TEXT, 
      ${NovaOneTableColumns.instance.localAppointmentTime} TEXT, 
      ${NovaOneTableColumns.instance.localAppointmentCreated} TEXT, 
      ${NovaOneTableColumns.instance.localAppointmentTimeZone} TEXT, 
      ${NovaOneTableColumns.instance.localAppointmentConfirmed} INTEGER, 
      ${NovaOneTableColumns.instance.localAppointmentCompanyId} INTEGER, 
      ${NovaOneTableColumns.instance.localAppointmentUnitType} TEXT, 
      ${NovaOneTableColumns.instance.localAppointmentEmail} TEXT, 
      ${NovaOneTableColumns.instance.localAppointmentDateOfBirth} TEXT, 
      ${NovaOneTableColumns.instance.localAppointmentTestType} TEXT, 
      ${NovaOneTableColumns.instance.localAppointmentGender} TEXT, 
      ${NovaOneTableColumns.instance.localAppointmentAddress} TEXT, 
      ${NovaOneTableColumns.instance.localAppointmentCity} TEXT, 
      ${NovaOneTableColumns.instance.localAppointmentZip} TEXT)""";

  final String companiesSql = """
  CREATE TABLE ${NovaOneTableHelper.instance.company} 
      (id INTEGER PRIMARY KEY,
      ${NovaOneTableColumns.instance.localCompanyName} TEXT, 
      ${NovaOneTableColumns.instance.localCompanyAddress} TEXT, 
      ${NovaOneTableColumns.instance.localCompanyPhone} TEXT, 
      ${NovaOneTableColumns.instance.localCompanyAutoRespondNumber} TEXT, 
      ${NovaOneTableColumns.instance.localCompanyAutoRespondText} TEXT, 
      ${NovaOneTableColumns.instance.localCompanyEmail} TEXT, 
      ${NovaOneTableColumns.instance.localCompanyCreated} TEXT, 
      ${NovaOneTableColumns.instance.localCompanyAllowSameDayAppointments} INTEGER, 
      ${NovaOneTableColumns.instance.localCompanyDaysOfTheWeekEnabled} TEXT, 
      ${NovaOneTableColumns.instance.localCompanyHoursOfTheDayEnabled} TEXT, 
      ${NovaOneTableColumns.instance.localCompanyCity} TEXT,
      ${NovaOneTableColumns.instance.localCompanyCustomerUserId} INTEGER,
      ${NovaOneTableColumns.instance.localCompanyState} TEXT,
      ${NovaOneTableColumns.instance.localCompanyZip} TEXT)""";

  final _database =
      await openDatabase(join(await getDatabasesPath(), 'novaone_database.db'),
          onCreate: (Database db, int version) async {
    final batch = db.batch();
    await db.execute(leadsSql);
    await db.execute(appointmentsSql);
    await db.execute(companiesSql);
    await batch.commit();
  }, version: 1);

  runApp(
    RootWidget(
      database: _database,
      child: App(),
    ),
  );
}

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    /// Dismiss the keyboard whenever something other than the keyboard
    /// is tapped
    return GestureDetector(
      onTap: () {
        final FocusScopeNode currentFocus = FocusScope.of(context);
        if (!currentFocus.hasPrimaryFocus &&
            currentFocus.focusedChild != null) {
          FocusManager.instance.primaryFocus?.unfocus();
        }
      },
      child: MaterialApp(
        scaffoldMessengerKey: rootScaffoldMessengerKey,
        routes: {
          '/settings': (context) => NavScreen(
                controller: context.read<NavScreenController>(),
              ),
        },
        debugShowCheckedModeBanner: false,
        localizationsDelegates: [
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: [
          Locale('en', ''), // English, no country code
          Locale('es', ''), // Spanish, no country code
        ],
        title: NovaOneLocalizations.appName,
        // locale: DevicePreview.locale(context),
        // builder: DevicePreview.appBuilder,
        theme: ThemeData(
          primarySwatch: Colors.blue,
          // This makes the visual density adapt to the platform that you run
          // the app on. For desktop platforms, the controls will be smaller and
          // closer together (more dense) than on mobile platforms.
          visualDensity: VisualDensity.adaptivePlatformDensity,
          scaffoldBackgroundColor: Colors.grey[200],
          primaryColor: Palette.primaryColor,
        ),
        home: SplashScreenLayout(),
      ),
    );
  }
}
