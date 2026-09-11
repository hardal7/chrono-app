import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_ar.dart';
import 'app_localizations_en.dart';
import 'app_localizations_es.dart';
import 'app_localizations_fr.dart';
import 'app_localizations_hi.dart';
import 'app_localizations_pt.dart';
import 'app_localizations_ru.dart';
import 'app_localizations_tr.dart';
import 'app_localizations_zh.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('ar'),
    Locale('en'),
    Locale('es'),
    Locale('fr'),
    Locale('hi'),
    Locale('pt'),
    Locale('ru'),
    Locale('tr'),
    Locale('zh'),
  ];

  /// Text appended to today's time.
  ///
  /// In en, this message translates to:
  /// **'today'**
  String get today;

  /// Text displayed on the onboarding page.
  ///
  /// In en, this message translates to:
  /// **'Welcome to Chrono'**
  String get welcome;

  /// Text displayed on the onboarding page describing the app.
  ///
  /// In en, this message translates to:
  /// **'Start tracking your study habits for a more mindful studying experience.'**
  String get appDescription;

  /// Text displayed for the login action.
  ///
  /// In en, this message translates to:
  /// **'Login'**
  String get login;

  /// Text displayed for the account sign-up action.
  ///
  /// In en, this message translates to:
  /// **'Sign Up'**
  String get signup;

  /// Text displayed for the privacy policy.
  ///
  /// In en, this message translates to:
  /// **'Privacy Policy'**
  String get privacyPolicy;

  /// Text displayed in the agreement notice.
  ///
  /// In en, this message translates to:
  /// **'By continuing you agree to the'**
  String get userNotice;

  /// Conjunction displayed in the agreement notice.
  ///
  /// In en, this message translates to:
  /// **'and'**
  String get and;

  /// Text displayed for the user terms.
  ///
  /// In en, this message translates to:
  /// **'User Terms'**
  String get userTerms;

  /// Navigation item displayed for the tracker page.
  ///
  /// In en, this message translates to:
  /// **'Tracker'**
  String get tracker;

  /// Navigation item displayed for the sessions page.
  ///
  /// In en, this message translates to:
  /// **'Sessions'**
  String get sessions;

  /// Navigation item displayed for the users page.
  ///
  /// In en, this message translates to:
  /// **'Users'**
  String get users;

  /// Navigation item displayed for the profile page.
  ///
  /// In en, this message translates to:
  /// **'Profile'**
  String get profile;

  /// Navigation item displayed for the settings page.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settings;

  /// Title displayed on the login page.
  ///
  /// In en, this message translates to:
  /// **'Login to your account'**
  String get loginToYourAccount;

  /// Label displayed for the username input field.
  ///
  /// In en, this message translates to:
  /// **'Username'**
  String get username;

  /// Label displayed for the password input field.
  ///
  /// In en, this message translates to:
  /// **'Password'**
  String get password;

  /// Text displayed for the forgot password action.
  ///
  /// In en, this message translates to:
  /// **'Forgot password?'**
  String get forgotPassword;

  /// Error message displayed when the user cannot be found with the provided credentials.
  ///
  /// In en, this message translates to:
  /// **'User with credentials not found'**
  String get userWithCredentialsNotFound;

  /// Error message displayed when the provided credentials are incorrect.
  ///
  /// In en, this message translates to:
  /// **'Incorrect credentials'**
  String get incorrectCredentials;

  /// Error message displayed when the server is unavailable.
  ///
  /// In en, this message translates to:
  /// **'Server is currently down, please try again later.'**
  String get serverCurrentlyDown;

  /// Error message displayed when an unexpected error occurs.
  ///
  /// In en, this message translates to:
  /// **'An unexpected error occurred'**
  String get unexpectedError;

  /// Text displayed above the third-party login options.
  ///
  /// In en, this message translates to:
  /// **'Or login with'**
  String get orLoginWith;

  /// Text displayed before the registration action.
  ///
  /// In en, this message translates to:
  /// **'Don\'t have an account? '**
  String get dontHaveAnAccount;

  /// Text displayed for the registration action and registration page title.
  ///
  /// In en, this message translates to:
  /// **'Register an account'**
  String get registerAnAccount;

  /// Label displayed for the email input field.
  ///
  /// In en, this message translates to:
  /// **'Email'**
  String get email;

  /// Text displayed for the register action.
  ///
  /// In en, this message translates to:
  /// **'Register'**
  String get register;

  /// Error message displayed when a user with the provided credentials already exists.
  ///
  /// In en, this message translates to:
  /// **'User with credentials already exists'**
  String get userWithCredentialsAlreadyExists;

  /// Error message displayed when the user cannot be created.
  ///
  /// In en, this message translates to:
  /// **'Failed to create user'**
  String get failedToCreateUser;

  /// Text displayed before the login action.
  ///
  /// In en, this message translates to:
  /// **'Already have an account? '**
  String get alreadyHaveAnAccount;

  /// Text displayed for the login action.
  ///
  /// In en, this message translates to:
  /// **'Login to account'**
  String get loginToAccount;

  /// Text displayed for the reset password action.
  ///
  /// In en, this message translates to:
  /// **'Reset Password'**
  String get resetPassword;

  /// Title displayed in the leaderboard settings popup.
  ///
  /// In en, this message translates to:
  /// **'Leaderboard Settings'**
  String get leaderboardSettings;

  /// Hint text displayed in the username search field.
  ///
  /// In en, this message translates to:
  /// **'Search username'**
  String get searchUsername;

  /// Text displayed for the friends search scope.
  ///
  /// In en, this message translates to:
  /// **'Friend'**
  String get friend;

  /// Text displayed for the local search scope.
  ///
  /// In en, this message translates to:
  /// **'Local'**
  String get local;

  /// Text displayed for the global search scope.
  ///
  /// In en, this message translates to:
  /// **'Global'**
  String get global;

  /// Column header displayed for the user rank.
  ///
  /// In en, this message translates to:
  /// **'Rank'**
  String get rank;

  /// Column header displayed for the username.
  ///
  /// In en, this message translates to:
  /// **'User'**
  String get user;

  /// Column header displayed for the tracked time.
  ///
  /// In en, this message translates to:
  /// **'Time'**
  String get time;

  /// Label displayed for the language setting.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get language;

  /// Label displayed for the dark mode setting.
  ///
  /// In en, this message translates to:
  /// **'Dark Mode'**
  String get darkMode;

  /// Label displayed for the notifications setting.
  ///
  /// In en, this message translates to:
  /// **'Notifications'**
  String get notifications;

  /// Label displayed for the hide account setting.
  ///
  /// In en, this message translates to:
  /// **'Hide Account'**
  String get hideAccount;

  /// Label displayed for the hide location setting.
  ///
  /// In en, this message translates to:
  /// **'Hide Location'**
  String get hideLocation;

  /// Label displayed for the report a problem action.
  ///
  /// In en, this message translates to:
  /// **'Report a Problem'**
  String get reportAProblem;

  /// Label displayed for the request a feature action.
  ///
  /// In en, this message translates to:
  /// **'Request a Feature'**
  String get requestAFeature;

  /// Text displayed after the overall tracked time.
  ///
  /// In en, this message translates to:
  /// **'overall'**
  String get overall;

  /// Text displayed for the start timer action.
  ///
  /// In en, this message translates to:
  /// **'Start'**
  String get start;

  /// Text displayed for the pause timer action.
  ///
  /// In en, this message translates to:
  /// **'Pause'**
  String get pause;

  /// Text displayed for the create topic action and popup title.
  ///
  /// In en, this message translates to:
  /// **'Create Topic'**
  String get createTopic;

  /// Label displayed for the topic name input field.
  ///
  /// In en, this message translates to:
  /// **'Topic Name'**
  String get topicName;

  /// Text displayed for the create action.
  ///
  /// In en, this message translates to:
  /// **'Create'**
  String get create;

  /// Title displayed in the timer settings popup.
  ///
  /// In en, this message translates to:
  /// **'Set Timer'**
  String get setTimer;

  /// Label displayed for the hours input field.
  ///
  /// In en, this message translates to:
  /// **'Hours'**
  String get hours;

  /// Label displayed for the minutes input field.
  ///
  /// In en, this message translates to:
  /// **'Minutes'**
  String get minutes;

  /// Label displayed for the seconds input field.
  ///
  /// In en, this message translates to:
  /// **'Seconds'**
  String get seconds;

  /// Label displayed for showing it is break time.
  ///
  /// In en, this message translates to:
  /// **'Break Time'**
  String get breakTime;

  /// Text displayed for the save action.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get save;

  /// Short name displayed for Monday.
  ///
  /// In en, this message translates to:
  /// **'Mon'**
  String get mondayShort;

  /// Short name displayed for Tuesday.
  ///
  /// In en, this message translates to:
  /// **'Tue'**
  String get tuesdayShort;

  /// Short name displayed for Wednesday.
  ///
  /// In en, this message translates to:
  /// **'Wed'**
  String get wednesdayShort;

  /// Short name displayed for Thursday.
  ///
  /// In en, this message translates to:
  /// **'Thu'**
  String get thursdayShort;

  /// Short name displayed for Friday.
  ///
  /// In en, this message translates to:
  /// **'Fri'**
  String get fridayShort;

  /// Short name displayed for Saturday.
  ///
  /// In en, this message translates to:
  /// **'Sat'**
  String get saturdayShort;

  /// Short name displayed for Sunday.
  ///
  /// In en, this message translates to:
  /// **'Sun'**
  String get sundayShort;

  /// Label displaying the user's total tracked time.
  ///
  /// In en, this message translates to:
  /// **'Total Time'**
  String get totalTime;

  /// Label identifying the topic the user has spent the most time studying.
  ///
  /// In en, this message translates to:
  /// **'Best Topic'**
  String get bestTopic;

  /// Button label for sending a friend request to the user.
  ///
  /// In en, this message translates to:
  /// **'Add Friend'**
  String get addFriend;

  /// Button label indicating that a friend request has already been sent to the user.
  ///
  /// In en, this message translates to:
  /// **'Sent Request'**
  String get sentRequest;

  /// Button label indicating that the current user and the profile user are already friends.
  ///
  /// In en, this message translates to:
  /// **'Friends'**
  String get friends;

  /// Button label for inviting the user to a session.
  ///
  /// In en, this message translates to:
  /// **'Invite'**
  String get invite;

  /// Title displayed at the top of the profile settings dialog.
  ///
  /// In en, this message translates to:
  /// **'Profile Settings'**
  String get profileSettings;

  /// Button label for deleting the user avatar.
  ///
  /// In en, this message translates to:
  /// **'Delete Avatar'**
  String get deleteAvatar;

  /// Label displaying the number of participants in the session.
  ///
  /// In en, this message translates to:
  /// **'Members'**
  String get members;

  /// Label indicating how much time remains before the session expires.
  ///
  /// In en, this message translates to:
  /// **'Expires In'**
  String get expiresIn;

  /// Unit label for a duration measured in days.
  ///
  /// In en, this message translates to:
  /// **'days'**
  String get days;

  /// Status label indicating that a session participant is currently online.
  ///
  /// In en, this message translates to:
  /// **'online'**
  String get online;

  /// Status label indicating that a session participant is currently offline.
  ///
  /// In en, this message translates to:
  /// **'offline'**
  String get offline;

  /// Title displayed at the top of the session settings dialog.
  ///
  /// In en, this message translates to:
  /// **'Session Settings'**
  String get sessionSettings;

  /// Button label for leaving the current session.
  ///
  /// In en, this message translates to:
  /// **'Leave'**
  String get leave;

  /// Message displayed when no sessions are available.
  ///
  /// In en, this message translates to:
  /// **'No session found'**
  String get noSessionFound;

  /// Button label for opening a session the user has already joined.
  ///
  /// In en, this message translates to:
  /// **'View'**
  String get view;

  /// Button label for joining a session.
  ///
  /// In en, this message translates to:
  /// **'Join'**
  String get join;

  /// Title displayed at the top of the create session dialog.
  ///
  /// In en, this message translates to:
  /// **'Create Session'**
  String get createSession;

  /// Label for the input field used to enter the session name.
  ///
  /// In en, this message translates to:
  /// **'Session Name'**
  String get sessionName;

  /// Label introducing optional settings when creating a session.
  ///
  /// In en, this message translates to:
  /// **'Optional Settings'**
  String get optionalSettings;

  /// Label for the input field used to specify the session topic.
  ///
  /// In en, this message translates to:
  /// **'Topic'**
  String get topic;

  /// Label for the input field used to set the maximum number of session participants.
  ///
  /// In en, this message translates to:
  /// **'Max Participants'**
  String get maxParticipants;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) => <String>[
    'ar',
    'en',
    'es',
    'fr',
    'hi',
    'pt',
    'ru',
    'tr',
    'zh',
  ].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'ar':
      return AppLocalizationsAr();
    case 'en':
      return AppLocalizationsEn();
    case 'es':
      return AppLocalizationsEs();
    case 'fr':
      return AppLocalizationsFr();
    case 'hi':
      return AppLocalizationsHi();
    case 'pt':
      return AppLocalizationsPt();
    case 'ru':
      return AppLocalizationsRu();
    case 'tr':
      return AppLocalizationsTr();
    case 'zh':
      return AppLocalizationsZh();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
