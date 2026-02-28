import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_ar.dart';
import 'app_localizations_en.dart';
import 'app_localizations_fr.dart';

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
  AppLocalizations(String locale) : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate = _AppLocalizationsDelegate();

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
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates = <LocalizationsDelegate<dynamic>>[
    delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
  ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('ar'),
    Locale('en'),
    Locale('fr')
  ];

  /// No description provided for @appName.
  ///
  /// In en, this message translates to:
  /// **'My Awesome App'**
  String get appName;

  /// No description provided for @settings.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settings;

  /// No description provided for @theme.
  ///
  /// In en, this message translates to:
  /// **'Theme'**
  String get theme;

  /// No description provided for @language.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get language;

  /// No description provided for @chooseTheme.
  ///
  /// In en, this message translates to:
  /// **'Choose Theme'**
  String get chooseTheme;

  /// No description provided for @chooseLanguage.
  ///
  /// In en, this message translates to:
  /// **'Choose Language'**
  String get chooseLanguage;

  /// No description provided for @systemDefault.
  ///
  /// In en, this message translates to:
  /// **'System Default'**
  String get systemDefault;

  /// No description provided for @lightMode.
  ///
  /// In en, this message translates to:
  /// **'Light Mode'**
  String get lightMode;

  /// No description provided for @darkMode.
  ///
  /// In en, this message translates to:
  /// **'Dark Mode'**
  String get darkMode;

  /// No description provided for @english.
  ///
  /// In en, this message translates to:
  /// **'English'**
  String get english;

  /// No description provided for @french.
  ///
  /// In en, this message translates to:
  /// **'Français'**
  String get french;

  /// No description provided for @arabic.
  ///
  /// In en, this message translates to:
  /// **'العربية'**
  String get arabic;

  /// No description provided for @followSystem.
  ///
  /// In en, this message translates to:
  /// **'Follow System'**
  String get followSystem;

  /// No description provided for @ok.
  ///
  /// In en, this message translates to:
  /// **'OK'**
  String get ok;

  /// No description provided for @cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// No description provided for @save.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get save;

  /// No description provided for @delete.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get delete;

  /// No description provided for @edit.
  ///
  /// In en, this message translates to:
  /// **'Edit'**
  String get edit;

  /// No description provided for @profile.
  ///
  /// In en, this message translates to:
  /// **'Profile'**
  String get profile;

  /// No description provided for @logout.
  ///
  /// In en, this message translates to:
  /// **'Log Out'**
  String get logout;

  /// No description provided for @login.
  ///
  /// In en, this message translates to:
  /// **'Login'**
  String get login;

  /// No description provided for @signup.
  ///
  /// In en, this message translates to:
  /// **'Sign Up'**
  String get signup;

  /// No description provided for @home.
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get home;

  /// No description provided for @appointment.
  ///
  /// In en, this message translates to:
  /// **'Appointment'**
  String get appointment;

  /// No description provided for @order.
  ///
  /// In en, this message translates to:
  /// **'Order'**
  String get order;

  /// No description provided for @explore.
  ///
  /// In en, this message translates to:
  /// **'Explore'**
  String get explore;

  /// No description provided for @chat.
  ///
  /// In en, this message translates to:
  /// **'Chat'**
  String get chat;

  /// No description provided for @search.
  ///
  /// In en, this message translates to:
  /// **'Search'**
  String get search;

  /// No description provided for @favorites.
  ///
  /// In en, this message translates to:
  /// **'Favorites'**
  String get favorites;

  /// No description provided for @notifications.
  ///
  /// In en, this message translates to:
  /// **'Notifications'**
  String get notifications;

  /// No description provided for @promotions.
  ///
  /// In en, this message translates to:
  /// **'promotions'**
  String get promotions;

  /// No description provided for @myAccount.
  ///
  /// In en, this message translates to:
  /// **'My account'**
  String get myAccount;

  /// No description provided for @personalInformation.
  ///
  /// In en, this message translates to:
  /// **'Personal information'**
  String get personalInformation;

  /// No description provided for @paymentMethods.
  ///
  /// In en, this message translates to:
  /// **'Payment methods'**
  String get paymentMethods;

  /// No description provided for @activity.
  ///
  /// In en, this message translates to:
  /// **'Activity'**
  String get activity;

  /// No description provided for @savedAddresses.
  ///
  /// In en, this message translates to:
  /// **'Saved addresses'**
  String get savedAddresses;

  /// No description provided for @support.
  ///
  /// In en, this message translates to:
  /// **'Support'**
  String get support;

  /// No description provided for @additional.
  ///
  /// In en, this message translates to:
  /// **'Additional'**
  String get additional;

  /// No description provided for @dataAndPrivacy.
  ///
  /// In en, this message translates to:
  /// **'Data & Privacy'**
  String get dataAndPrivacy;

  /// No description provided for @completeYourProfile.
  ///
  /// In en, this message translates to:
  /// **'Complete your profile'**
  String get completeYourProfile;

  /// No description provided for @noInternet.
  ///
  /// In en, this message translates to:
  /// **'No internet connection'**
  String get noInternet;

  /// No description provided for @loading.
  ///
  /// In en, this message translates to:
  /// **'Loading...'**
  String get loading;

  /// No description provided for @onboarding1title.
  ///
  /// In en, this message translates to:
  /// **'Transform Your Space'**
  String get onboarding1title;

  /// No description provided for @onboarding2title.
  ///
  /// In en, this message translates to:
  /// **'Complete Furnishing Solutions'**
  String get onboarding2title;

  /// No description provided for @onboarding3title.
  ///
  /// In en, this message translates to:
  /// **'Reliable & Professional Service'**
  String get onboarding3title;

  /// No description provided for @onboarding1.
  ///
  /// In en, this message translates to:
  /// **'We design and decorate homes and businesses with modern, elegant, and personalized styles.'**
  String get onboarding1;

  /// No description provided for @onboarding2.
  ///
  /// In en, this message translates to:
  /// **'From furniture to final details, we fully equip and prepare your space for living or work.'**
  String get onboarding2;

  /// No description provided for @onboarding3.
  ///
  /// In en, this message translates to:
  /// **'Our expert team delivers quality, comfort, and on-time results you can trust.'**
  String get onboarding3;

  /// No description provided for @skip.
  ///
  /// In en, this message translates to:
  /// **'Skip'**
  String get skip;

  /// No description provided for @welcomeBack.
  ///
  /// In en, this message translates to:
  /// **'Welcome back,'**
  String get welcomeBack;

  /// No description provided for @welcomeSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Discover limitless choices and unmatched convenience.'**
  String get welcomeSubtitle;

  /// No description provided for @email.
  ///
  /// In en, this message translates to:
  /// **'E-mail'**
  String get email;

  /// No description provided for @password.
  ///
  /// In en, this message translates to:
  /// **'Password'**
  String get password;

  /// No description provided for @rememberMe.
  ///
  /// In en, this message translates to:
  /// **'Remember Me'**
  String get rememberMe;

  /// No description provided for @forgetPassword.
  ///
  /// In en, this message translates to:
  /// **'Forget password?'**
  String get forgetPassword;

  /// No description provided for @signIn.
  ///
  /// In en, this message translates to:
  /// **'Sign In'**
  String get signIn;

  /// No description provided for @signUp.
  ///
  /// In en, this message translates to:
  /// **'create account'**
  String get signUp;

  /// No description provided for @orSignInWith.
  ///
  /// In en, this message translates to:
  /// **'Or sign in with'**
  String get orSignInWith;

  /// No description provided for @letsCreateYourAccount.
  ///
  /// In en, this message translates to:
  /// **'Let\'s create your account'**
  String get letsCreateYourAccount;

  /// No description provided for @firstName.
  ///
  /// In en, this message translates to:
  /// **'First Name'**
  String get firstName;

  /// No description provided for @lastName.
  ///
  /// In en, this message translates to:
  /// **'Last Name'**
  String get lastName;

  /// No description provided for @userName.
  ///
  /// In en, this message translates to:
  /// **'User name'**
  String get userName;

  /// No description provided for @phoneNumber.
  ///
  /// In en, this message translates to:
  /// **'Phone number'**
  String get phoneNumber;

  /// No description provided for @orSignUpWith.
  ///
  /// In en, this message translates to:
  /// **'Or sign Up with'**
  String get orSignUpWith;

  /// No description provided for @iAgreeTo.
  ///
  /// In en, this message translates to:
  /// **'I agree to'**
  String get iAgreeTo;

  /// No description provided for @privacyPolicy.
  ///
  /// In en, this message translates to:
  /// **'Privacy Policy'**
  String get privacyPolicy;

  /// No description provided for @termsAndConditions.
  ///
  /// In en, this message translates to:
  /// **'Terms and conditions'**
  String get termsAndConditions;

  /// No description provided for @and.
  ///
  /// In en, this message translates to:
  /// **'and'**
  String get and;

  /// No description provided for @confirmEmail.
  ///
  /// In en, this message translates to:
  /// **'Confirm your email'**
  String get confirmEmail;

  /// No description provided for @confirmEmailSubTitle.
  ///
  /// In en, this message translates to:
  /// **'Please check your inbox and confirm your email address to continue.'**
  String get confirmEmailSubTitle;

  /// No description provided for @continueButton.
  ///
  /// In en, this message translates to:
  /// **'Continue'**
  String get continueButton;

  /// No description provided for @resendEmail.
  ///
  /// In en, this message translates to:
  /// **'Resend email'**
  String get resendEmail;

  /// No description provided for @yourAccountCreatedTitle.
  ///
  /// In en, this message translates to:
  /// **'Your account has been created'**
  String get yourAccountCreatedTitle;

  /// No description provided for @yourAccountCreatedSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Your account has been created successfully.'**
  String get yourAccountCreatedSubtitle;

  /// No description provided for @forgetPasswordTitle.
  ///
  /// In en, this message translates to:
  /// **'Forgot password?'**
  String get forgetPasswordTitle;

  /// No description provided for @forgetPasswordSubTitle.
  ///
  /// In en, this message translates to:
  /// **'Enter your email address and we’ll send you a link to reset your password.'**
  String get forgetPasswordSubTitle;

  /// No description provided for @submit.
  ///
  /// In en, this message translates to:
  /// **'Submit'**
  String get submit;

  /// No description provided for @changeYourPasswordTitle.
  ///
  /// In en, this message translates to:
  /// **'Change your password'**
  String get changeYourPasswordTitle;

  /// No description provided for @changeYourPasswordSubTitle.
  ///
  /// In en, this message translates to:
  /// **'We’ve sent you a secure link to change your password.'**
  String get changeYourPasswordSubTitle;

  /// No description provided for @done.
  ///
  /// In en, this message translates to:
  /// **'Done'**
  String get done;

  /// No description provided for @servicesWeOffer.
  ///
  /// In en, this message translates to:
  /// **'Services We Offer'**
  String get servicesWeOffer;

  /// No description provided for @featuredProjects.
  ///
  /// In en, this message translates to:
  /// **'Featured Projects'**
  String get featuredProjects;

  /// No description provided for @activeProjects.
  ///
  /// In en, this message translates to:
  /// **'Active Projects'**
  String get activeProjects;

  /// No description provided for @viewAll.
  ///
  /// In en, this message translates to:
  /// **'View All'**
  String get viewAll;

  /// No description provided for @requestAService.
  ///
  /// In en, this message translates to:
  /// **'Request a Service'**
  String get requestAService;

  /// No description provided for @noFeaturedProjects.
  ///
  /// In en, this message translates to:
  /// **'No featured projects yet.'**
  String get noFeaturedProjects;

  /// No description provided for @noServicesFound.
  ///
  /// In en, this message translates to:
  /// **'No services found.'**
  String get noServicesFound;

  /// No description provided for @gallery.
  ///
  /// In en, this message translates to:
  /// **'Gallery'**
  String get gallery;

  /// No description provided for @chat_tab.
  ///
  /// In en, this message translates to:
  /// **'Chat'**
  String get chat_tab;

  /// No description provided for @requestNow.
  ///
  /// In en, this message translates to:
  /// **'Request Now'**
  String get requestNow;

  /// No description provided for @projectBasics.
  ///
  /// In en, this message translates to:
  /// **'Project Basics'**
  String get projectBasics;

  /// No description provided for @serviceType.
  ///
  /// In en, this message translates to:
  /// **'Service Type'**
  String get serviceType;

  /// No description provided for @spaceType.
  ///
  /// In en, this message translates to:
  /// **'Space Type'**
  String get spaceType;

  /// No description provided for @selectServiceType.
  ///
  /// In en, this message translates to:
  /// **'Select Service Type'**
  String get selectServiceType;

  /// No description provided for @selectSpaceType.
  ///
  /// In en, this message translates to:
  /// **'Select Space Type'**
  String get selectSpaceType;

  /// No description provided for @locationAndDimensions.
  ///
  /// In en, this message translates to:
  /// **'Location & Dimensions'**
  String get locationAndDimensions;

  /// No description provided for @location.
  ///
  /// In en, this message translates to:
  /// **'Location'**
  String get location;

  /// No description provided for @enterLocation.
  ///
  /// In en, this message translates to:
  /// **'Enter project location...'**
  String get enterLocation;

  /// No description provided for @width.
  ///
  /// In en, this message translates to:
  /// **'Width (m)'**
  String get width;

  /// No description provided for @height.
  ///
  /// In en, this message translates to:
  /// **'Height (m)'**
  String get height;

  /// No description provided for @requestDetails.
  ///
  /// In en, this message translates to:
  /// **'Request Details'**
  String get requestDetails;

  /// No description provided for @descriptionRequirements.
  ///
  /// In en, this message translates to:
  /// **'Description / Special Requirements'**
  String get descriptionRequirements;

  /// No description provided for @describeRequirements.
  ///
  /// In en, this message translates to:
  /// **'Describe your requirements...'**
  String get describeRequirements;

  /// No description provided for @requestedDuration.
  ///
  /// In en, this message translates to:
  /// **'Requested Duration (Days)'**
  String get requestedDuration;

  /// No description provided for @optionalDays.
  ///
  /// In en, this message translates to:
  /// **'Optional: estimated days'**
  String get optionalDays;

  /// No description provided for @attachments.
  ///
  /// In en, this message translates to:
  /// **'Attachments'**
  String get attachments;

  /// No description provided for @noFilesAttached.
  ///
  /// In en, this message translates to:
  /// **'No files attached'**
  String get noFilesAttached;

  /// No description provided for @submitRequest.
  ///
  /// In en, this message translates to:
  /// **'Submit Service Request'**
  String get submitRequest;

  /// No description provided for @myServiceRequests.
  ///
  /// In en, this message translates to:
  /// **'My Service Requests'**
  String get myServiceRequests;

  /// No description provided for @noRequestsYet.
  ///
  /// In en, this message translates to:
  /// **'No requests yet'**
  String get noRequestsYet;

  /// No description provided for @createFirstRequest.
  ///
  /// In en, this message translates to:
  /// **'Create your first service request!'**
  String get createFirstRequest;

  /// No description provided for @openChat.
  ///
  /// In en, this message translates to:
  /// **'Open Chat'**
  String get openChat;

  /// No description provided for @confirmCancelTitle.
  ///
  /// In en, this message translates to:
  /// **'Cancel Request'**
  String get confirmCancelTitle;

  /// No description provided for @confirmCancelMessage.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to cancel this request?'**
  String get confirmCancelMessage;

  /// No description provided for @interiorGallery.
  ///
  /// In en, this message translates to:
  /// **'Interior Gallery'**
  String get interiorGallery;

  /// No description provided for @noGalleryItems.
  ///
  /// In en, this message translates to:
  /// **'No gallery items yet'**
  String get noGalleryItems;

  /// No description provided for @uploadPortfolioItem.
  ///
  /// In en, this message translates to:
  /// **'Upload Portfolio Item'**
  String get uploadPortfolioItem;

  /// No description provided for @title.
  ///
  /// In en, this message translates to:
  /// **'Title'**
  String get title;

  /// No description provided for @description.
  ///
  /// In en, this message translates to:
  /// **'Description'**
  String get description;

  /// No description provided for @required.
  ///
  /// In en, this message translates to:
  /// **'Required'**
  String get required;

  /// No description provided for @tapToSelectMedia.
  ///
  /// In en, this message translates to:
  /// **'Tap to select Image or Video'**
  String get tapToSelectMedia;

  /// No description provided for @uploadItem.
  ///
  /// In en, this message translates to:
  /// **'Upload Item'**
  String get uploadItem;

  /// No description provided for @itemUploadedSuccess.
  ///
  /// In en, this message translates to:
  /// **'Item uploaded successfully'**
  String get itemUploadedSuccess;

  /// No description provided for @uploadFailed.
  ///
  /// In en, this message translates to:
  /// **'Upload failed'**
  String get uploadFailed;

  /// No description provided for @pleaseSelectFile.
  ///
  /// In en, this message translates to:
  /// **'Please select a file'**
  String get pleaseSelectFile;

  /// No description provided for @messages.
  ///
  /// In en, this message translates to:
  /// **'Messages'**
  String get messages;

  /// No description provided for @noConversationsFound.
  ///
  /// In en, this message translates to:
  /// **'No conversations found'**
  String get noConversationsFound;

  /// No description provided for @createRequestToStartChat.
  ///
  /// In en, this message translates to:
  /// **'Create a service request to start a chat.'**
  String get createRequestToStartChat;

  /// No description provided for @online.
  ///
  /// In en, this message translates to:
  /// **'Online'**
  String get online;

  /// No description provided for @sendMessage.
  ///
  /// In en, this message translates to:
  /// **'Send message...'**
  String get sendMessage;

  /// No description provided for @cancelRecording.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancelRecording;

  /// No description provided for @error.
  ///
  /// In en, this message translates to:
  /// **'Error'**
  String get error;

  /// No description provided for @noPicturesForProject.
  ///
  /// In en, this message translates to:
  /// **'No pictures for this project'**
  String get noPicturesForProject;

  /// No description provided for @supportAndContact.
  ///
  /// In en, this message translates to:
  /// **'Support & Contact'**
  String get supportAndContact;

  /// No description provided for @howCanWeHelp.
  ///
  /// In en, this message translates to:
  /// **'How can we help you today?'**
  String get howCanWeHelp;

  /// No description provided for @followUs.
  ///
  /// In en, this message translates to:
  /// **'Follow Us'**
  String get followUs;

  /// No description provided for @logoutConfirmation.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to log out?'**
  String get logoutConfirmation;

  /// No description provided for @dontHaveAccount.
  ///
  /// In en, this message translates to:
  /// **'Don\'t have an account?'**
  String get dontHaveAccount;

  /// No description provided for @phoneNumberHint.
  ///
  /// In en, this message translates to:
  /// **'+213 5XX XX XX XX'**
  String get phoneNumberHint;

  /// No description provided for @continueAsGuest.
  ///
  /// In en, this message translates to:
  /// **'Continue as Guest'**
  String get continueAsGuest;

  /// No description provided for @loginToViewHome.
  ///
  /// In en, this message translates to:
  /// **'Login to View Home'**
  String get loginToViewHome;

  /// No description provided for @loginToViewHomeSubtitle.
  ///
  /// In en, this message translates to:
  /// **'You need to be logged in to access the personalized dashboard.'**
  String get loginToViewHomeSubtitle;

  /// No description provided for @loginToOrder.
  ///
  /// In en, this message translates to:
  /// **'Login to Order'**
  String get loginToOrder;

  /// No description provided for @loginToOrderSubtitle.
  ///
  /// In en, this message translates to:
  /// **'You need to be logged in to submit service requests.'**
  String get loginToOrderSubtitle;

  /// No description provided for @loginToChat.
  ///
  /// In en, this message translates to:
  /// **'Login to Chat'**
  String get loginToChat;

  /// No description provided for @loginToChatSubtitle.
  ///
  /// In en, this message translates to:
  /// **'You need to be logged in to chat with our designers.'**
  String get loginToChatSubtitle;

  /// No description provided for @loginToSettings.
  ///
  /// In en, this message translates to:
  /// **'Login to Settings'**
  String get loginToSettings;

  /// No description provided for @loginToSettingsSubtitle.
  ///
  /// In en, this message translates to:
  /// **'You need to be logged in to view and change settings.'**
  String get loginToSettingsSubtitle;

  /// No description provided for @loginWithOtp.
  ///
  /// In en, this message translates to:
  /// **'Login with OTP'**
  String get loginWithOtp;
}

class _AppLocalizationsDelegate extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) => <String>['ar', 'en', 'fr'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {


  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'ar': return AppLocalizationsAr();
    case 'en': return AppLocalizationsEn();
    case 'fr': return AppLocalizationsFr();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.'
  );
}
