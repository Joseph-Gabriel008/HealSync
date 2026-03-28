import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_hi.dart';
import 'app_localizations_ml.dart';
import 'app_localizations_ta.dart';
import 'app_localizations_te.dart';

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
    Locale('en'),
    Locale('hi'),
    Locale('ml'),
    Locale('ta'),
    Locale('te'),
  ];

  /// No description provided for @appTitle.
  ///
  /// In en, this message translates to:
  /// **'HealSync'**
  String get appTitle;

  /// No description provided for @welcome.
  ///
  /// In en, this message translates to:
  /// **'Welcome'**
  String get welcome;

  /// No description provided for @upload.
  ///
  /// In en, this message translates to:
  /// **'Upload Medical Record'**
  String get upload;

  /// No description provided for @language.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get language;

  /// No description provided for @english.
  ///
  /// In en, this message translates to:
  /// **'English'**
  String get english;

  /// No description provided for @hindi.
  ///
  /// In en, this message translates to:
  /// **'Hindi'**
  String get hindi;

  /// No description provided for @tamil.
  ///
  /// In en, this message translates to:
  /// **'Tamil'**
  String get tamil;

  /// No description provided for @telugu.
  ///
  /// In en, this message translates to:
  /// **'Telugu'**
  String get telugu;

  /// No description provided for @malayalam.
  ///
  /// In en, this message translates to:
  /// **'Malayalam'**
  String get malayalam;

  /// No description provided for @createCareWorkspace.
  ///
  /// In en, this message translates to:
  /// **'Create your care workspace'**
  String get createCareWorkspace;

  /// No description provided for @welcomeBack.
  ///
  /// In en, this message translates to:
  /// **'Welcome back'**
  String get welcomeBack;

  /// No description provided for @signupSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Set up your account and choose how you use HealSync.'**
  String get signupSubtitle;

  /// No description provided for @loginSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Sign in to manage consultations, records, and verified health data.'**
  String get loginSubtitle;

  /// No description provided for @fullName.
  ///
  /// In en, this message translates to:
  /// **'Full name'**
  String get fullName;

  /// No description provided for @email.
  ///
  /// In en, this message translates to:
  /// **'Email'**
  String get email;

  /// No description provided for @password.
  ///
  /// In en, this message translates to:
  /// **'Password'**
  String get password;

  /// No description provided for @patient.
  ///
  /// In en, this message translates to:
  /// **'Patient'**
  String get patient;

  /// No description provided for @doctor.
  ///
  /// In en, this message translates to:
  /// **'Doctor'**
  String get doctor;

  /// No description provided for @createAccount.
  ///
  /// In en, this message translates to:
  /// **'Create account'**
  String get createAccount;

  /// No description provided for @loginAction.
  ///
  /// In en, this message translates to:
  /// **'Login'**
  String get loginAction;

  /// No description provided for @alreadyHaveAccount.
  ///
  /// In en, this message translates to:
  /// **'Already have an account? Login'**
  String get alreadyHaveAccount;

  /// No description provided for @needAccount.
  ///
  /// In en, this message translates to:
  /// **'Need an account? Sign up'**
  String get needAccount;

  /// No description provided for @careHeroHeadline.
  ///
  /// In en, this message translates to:
  /// **'Care that feels connected, verified, and beautifully simple.'**
  String get careHeroHeadline;

  /// No description provided for @careHeroBody.
  ///
  /// In en, this message translates to:
  /// **'HealSync brings telemedicine, realtime records, and a beautifully structured healthcare workspace into one calm experience.'**
  String get careHeroBody;

  /// No description provided for @realtimeRecords.
  ///
  /// In en, this message translates to:
  /// **'Realtime Records'**
  String get realtimeRecords;

  /// No description provided for @verifiedReports.
  ///
  /// In en, this message translates to:
  /// **'Verified Reports'**
  String get verifiedReports;

  /// No description provided for @secureConsultations.
  ///
  /// In en, this message translates to:
  /// **'Secure Consultations'**
  String get secureConsultations;

  /// No description provided for @logout.
  ///
  /// In en, this message translates to:
  /// **'Logout'**
  String get logout;

  /// No description provided for @patientDashboardTitle.
  ///
  /// In en, this message translates to:
  /// **'Patient Dashboard'**
  String get patientDashboardTitle;

  /// No description provided for @doctorDashboardTitle.
  ///
  /// In en, this message translates to:
  /// **'Doctor Dashboard'**
  String get doctorDashboardTitle;

  /// No description provided for @welcomeBackUser.
  ///
  /// In en, this message translates to:
  /// **'Welcome back, {name}'**
  String welcomeBackUser(Object name);

  /// No description provided for @patientHeroSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Everything from bookings to verified medical records now lives in one serene healthcare command center.'**
  String get patientHeroSubtitle;

  /// No description provided for @verifiedRecordsLabel.
  ///
  /// In en, this message translates to:
  /// **'Verified Records'**
  String get verifiedRecordsLabel;

  /// No description provided for @appointmentsLabel.
  ///
  /// In en, this message translates to:
  /// **'Appointments'**
  String get appointmentsLabel;

  /// No description provided for @bookAppointment.
  ///
  /// In en, this message translates to:
  /// **'Book Appointment'**
  String get bookAppointment;

  /// No description provided for @uploadRecord.
  ///
  /// In en, this message translates to:
  /// **'Upload Record'**
  String get uploadRecord;

  /// No description provided for @nextConsultation.
  ///
  /// In en, this message translates to:
  /// **'Next Consultation'**
  String get nextConsultation;

  /// No description provided for @consultationWithDoctor.
  ///
  /// In en, this message translates to:
  /// **'Consultation with {doctorName}'**
  String consultationWithDoctor(Object doctorName);

  /// No description provided for @join.
  ///
  /// In en, this message translates to:
  /// **'Join'**
  String get join;

  /// No description provided for @trackBookingsStatuses.
  ///
  /// In en, this message translates to:
  /// **'Track bookings and statuses'**
  String get trackBookingsStatuses;

  /// No description provided for @medicalHistory.
  ///
  /// In en, this message translates to:
  /// **'Medical History'**
  String get medicalHistory;

  /// No description provided for @reportsVerificationAudit.
  ///
  /// In en, this message translates to:
  /// **'Reports, verification, and audit'**
  String get reportsVerificationAudit;

  /// No description provided for @prescriptionsTitle.
  ///
  /// In en, this message translates to:
  /// **'Prescriptions'**
  String get prescriptionsTitle;

  /// No description provided for @doctorMedicationsNotes.
  ///
  /// In en, this message translates to:
  /// **'Doctor medications and notes'**
  String get doctorMedicationsNotes;

  /// No description provided for @healthPassport.
  ///
  /// In en, this message translates to:
  /// **'Health Passport'**
  String get healthPassport;

  /// No description provided for @portableVerifiedProfile.
  ///
  /// In en, this message translates to:
  /// **'Your portable verified profile'**
  String get portableVerifiedProfile;

  /// No description provided for @recentRecords.
  ///
  /// In en, this message translates to:
  /// **'Recent Records'**
  String get recentRecords;

  /// No description provided for @referenceCode.
  ///
  /// In en, this message translates to:
  /// **'Ref: {code}'**
  String referenceCode(Object code);

  /// No description provided for @verified.
  ///
  /// In en, this message translates to:
  /// **'Verified'**
  String get verified;

  /// No description provided for @notVerified.
  ///
  /// In en, this message translates to:
  /// **'Not Verified'**
  String get notVerified;

  /// No description provided for @myAppointments.
  ///
  /// In en, this message translates to:
  /// **'My Appointments'**
  String get myAppointments;

  /// No description provided for @noAppointmentsYet.
  ///
  /// In en, this message translates to:
  /// **'No appointments yet'**
  String get noAppointmentsYet;

  /// No description provided for @bookConsultationPrompt.
  ///
  /// In en, this message translates to:
  /// **'Book a consultation from the dashboard to see your visits here in real time.'**
  String get bookConsultationPrompt;

  /// No description provided for @confirmBooking.
  ///
  /// In en, this message translates to:
  /// **'Confirm Booking'**
  String get confirmBooking;

  /// No description provided for @selectDoctor.
  ///
  /// In en, this message translates to:
  /// **'Select doctor'**
  String get selectDoctor;

  /// No description provided for @telemedicineSuffix.
  ///
  /// In en, this message translates to:
  /// **'{name} - Telemedicine'**
  String telemedicineSuffix(Object name);

  /// No description provided for @consultationDateTime.
  ///
  /// In en, this message translates to:
  /// **'Consultation Date & Time'**
  String get consultationDateTime;

  /// No description provided for @appointmentConfirmed.
  ///
  /// In en, this message translates to:
  /// **'Appointment Confirmed'**
  String get appointmentConfirmed;

  /// No description provided for @noDoctorAccountAvailable.
  ///
  /// In en, this message translates to:
  /// **'No doctor account is available in the backend yet. Ask the doctor to sign up in HealSync first, then try booking again.'**
  String get noDoctorAccountAvailable;

  /// No description provided for @payment.
  ///
  /// In en, this message translates to:
  /// **'Payment'**
  String get payment;

  /// No description provided for @consultationPayment.
  ///
  /// In en, this message translates to:
  /// **'Consultation Payment'**
  String get consultationPayment;

  /// No description provided for @doctorLabel.
  ///
  /// In en, this message translates to:
  /// **'Doctor'**
  String get doctorLabel;

  /// No description provided for @appointmentTime.
  ///
  /// In en, this message translates to:
  /// **'Appointment Time'**
  String get appointmentTime;

  /// No description provided for @amount.
  ///
  /// In en, this message translates to:
  /// **'Amount'**
  String get amount;

  /// No description provided for @processingPayment.
  ///
  /// In en, this message translates to:
  /// **'Processing payment...'**
  String get processingPayment;

  /// No description provided for @processing.
  ///
  /// In en, this message translates to:
  /// **'Processing...'**
  String get processing;

  /// No description provided for @payNow.
  ///
  /// In en, this message translates to:
  /// **'Pay Now'**
  String get payNow;

  /// No description provided for @paymentFailedTryAgain.
  ///
  /// In en, this message translates to:
  /// **'Payment Failed. Try again'**
  String get paymentFailedTryAgain;

  /// No description provided for @paymentSuccessful.
  ///
  /// In en, this message translates to:
  /// **'Payment Successful'**
  String get paymentSuccessful;

  /// No description provided for @appointmentConfirmedMessage.
  ///
  /// In en, this message translates to:
  /// **'Your appointment has been confirmed'**
  String get appointmentConfirmedMessage;

  /// No description provided for @ok.
  ///
  /// In en, this message translates to:
  /// **'OK'**
  String get ok;

  /// No description provided for @doctorGreeting.
  ///
  /// In en, this message translates to:
  /// **'Hello Dr. {name}'**
  String doctorGreeting(Object name);

  /// No description provided for @doctorHeroSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Run consultations, issue prescriptions, and validate patient reports with a calm clinical workflow.'**
  String get doctorHeroSubtitle;

  /// No description provided for @quickActions.
  ///
  /// In en, this message translates to:
  /// **'Quick Actions'**
  String get quickActions;

  /// No description provided for @patientList.
  ///
  /// In en, this message translates to:
  /// **'Patient List'**
  String get patientList;

  /// No description provided for @recordsHub.
  ///
  /// In en, this message translates to:
  /// **'Records Hub'**
  String get recordsHub;

  /// No description provided for @upcomingConsultations.
  ///
  /// In en, this message translates to:
  /// **'Upcoming Consultations'**
  String get upcomingConsultations;

  /// No description provided for @start.
  ///
  /// In en, this message translates to:
  /// **'Start'**
  String get start;

  /// No description provided for @patientsLabel.
  ///
  /// In en, this message translates to:
  /// **'Patients'**
  String get patientsLabel;

  /// No description provided for @searchByDoctorName.
  ///
  /// In en, this message translates to:
  /// **'Search by doctor name'**
  String get searchByDoctorName;

  /// No description provided for @noDoctorsFound.
  ///
  /// In en, this message translates to:
  /// **'No doctors found'**
  String get noDoctorsFound;

  /// No description provided for @all.
  ///
  /// In en, this message translates to:
  /// **'All'**
  String get all;

  /// No description provided for @cardiology.
  ///
  /// In en, this message translates to:
  /// **'Cardiology'**
  String get cardiology;

  /// No description provided for @dermatology.
  ///
  /// In en, this message translates to:
  /// **'Dermatology'**
  String get dermatology;

  /// No description provided for @general.
  ///
  /// In en, this message translates to:
  /// **'General'**
  String get general;

  /// No description provided for @pediatrics.
  ///
  /// In en, this message translates to:
  /// **'Pediatrics'**
  String get pediatrics;

  /// No description provided for @experienceValue.
  ///
  /// In en, this message translates to:
  /// **'Experience: {value}'**
  String experienceValue(Object value);

  /// No description provided for @records.
  ///
  /// In en, this message translates to:
  /// **'Records'**
  String get records;

  /// No description provided for @historyTitle.
  ///
  /// In en, this message translates to:
  /// **'{name} History'**
  String historyTitle(Object name);

  /// No description provided for @grantAccess.
  ///
  /// In en, this message translates to:
  /// **'Grant Access'**
  String get grantAccess;

  /// No description provided for @revokeAccess.
  ///
  /// In en, this message translates to:
  /// **'Revoke Access'**
  String get revokeAccess;

  /// No description provided for @doctorAccessRevoked.
  ///
  /// In en, this message translates to:
  /// **'Doctor access revoked successfully.'**
  String get doctorAccessRevoked;

  /// No description provided for @doctorAccessGranted.
  ///
  /// In en, this message translates to:
  /// **'Doctor access granted successfully.'**
  String get doctorAccessGranted;

  /// No description provided for @updateAccessPermissionsError.
  ///
  /// In en, this message translates to:
  /// **'We could not update access permissions right now.'**
  String get updateAccessPermissionsError;

  /// No description provided for @liveConsultationRoom.
  ///
  /// In en, this message translates to:
  /// **'Live Consultation Room'**
  String get liveConsultationRoom;

  /// No description provided for @channelLabel.
  ///
  /// In en, this message translates to:
  /// **'Channel: {channelId}'**
  String channelLabel(Object channelId);

  /// No description provided for @recording.
  ///
  /// In en, this message translates to:
  /// **'Recording'**
  String get recording;

  /// No description provided for @liveDuration.
  ///
  /// In en, this message translates to:
  /// **'Live duration: {duration}'**
  String liveDuration(Object duration);

  /// No description provided for @viewHistory.
  ///
  /// In en, this message translates to:
  /// **'View History'**
  String get viewHistory;

  /// No description provided for @addRecord.
  ///
  /// In en, this message translates to:
  /// **'Add Record'**
  String get addRecord;

  /// No description provided for @mute.
  ///
  /// In en, this message translates to:
  /// **'Mute'**
  String get mute;

  /// No description provided for @unmute.
  ///
  /// In en, this message translates to:
  /// **'Unmute'**
  String get unmute;

  /// No description provided for @camera.
  ///
  /// In en, this message translates to:
  /// **'Camera'**
  String get camera;

  /// No description provided for @turnCameraOn.
  ///
  /// In en, this message translates to:
  /// **'Turn Camera On'**
  String get turnCameraOn;

  /// No description provided for @rearCamera.
  ///
  /// In en, this message translates to:
  /// **'Rear Camera'**
  String get rearCamera;

  /// No description provided for @frontCamera.
  ///
  /// In en, this message translates to:
  /// **'Front Camera'**
  String get frontCamera;

  /// No description provided for @end.
  ///
  /// In en, this message translates to:
  /// **'End'**
  String get end;

  /// No description provided for @you.
  ///
  /// In en, this message translates to:
  /// **'You'**
  String get you;

  /// No description provided for @remoteParticipant.
  ///
  /// In en, this message translates to:
  /// **'Remote participant'**
  String get remoteParticipant;

  /// No description provided for @cameraOff.
  ///
  /// In en, this message translates to:
  /// **'Camera off'**
  String get cameraOff;

  /// No description provided for @localCamera.
  ///
  /// In en, this message translates to:
  /// **'Local camera'**
  String get localCamera;

  /// No description provided for @waitingSecondPerson.
  ///
  /// In en, this message translates to:
  /// **'Waiting for the second person to join'**
  String get waitingSecondPerson;

  /// No description provided for @connectedLive.
  ///
  /// In en, this message translates to:
  /// **'Connected live'**
  String get connectedLive;

  /// No description provided for @diagnosis.
  ///
  /// In en, this message translates to:
  /// **'Diagnosis'**
  String get diagnosis;

  /// No description provided for @prescription.
  ///
  /// In en, this message translates to:
  /// **'Prescription'**
  String get prescription;

  /// No description provided for @saveNotes.
  ///
  /// In en, this message translates to:
  /// **'Save Notes'**
  String get saveNotes;

  /// No description provided for @consultationNotesSaved.
  ///
  /// In en, this message translates to:
  /// **'Consultation notes saved.'**
  String get consultationNotesSaved;

  /// No description provided for @saveNotesError.
  ///
  /// In en, this message translates to:
  /// **'We could not save the consultation notes right now.'**
  String get saveNotesError;

  /// No description provided for @patientHistoryUnavailable.
  ///
  /// In en, this message translates to:
  /// **'Patient history is not available right now.'**
  String get patientHistoryUnavailable;

  /// No description provided for @noMedicalHistoryFound.
  ///
  /// In en, this message translates to:
  /// **'No medical history found yet.'**
  String get noMedicalHistoryFound;

  /// No description provided for @onlyDoctorsCanAddRecords.
  ///
  /// In en, this message translates to:
  /// **'Only doctors can add records.'**
  String get onlyDoctorsCanAddRecords;

  /// No description provided for @patientDetailsUnavailable.
  ///
  /// In en, this message translates to:
  /// **'Patient details not available right now.'**
  String get patientDetailsUnavailable;

  /// No description provided for @medicalRecordSaved.
  ///
  /// In en, this message translates to:
  /// **'Medical record saved successfully.'**
  String get medicalRecordSaved;

  /// No description provided for @cameraMicAccessRequired.
  ///
  /// In en, this message translates to:
  /// **'Camera & Mic access required'**
  String get cameraMicAccessRequired;

  /// No description provided for @openSettings.
  ///
  /// In en, this message translates to:
  /// **'Open Settings'**
  String get openSettings;

  /// No description provided for @readyToJoinConsultationRoom.
  ///
  /// In en, this message translates to:
  /// **'Ready to join the consultation room.'**
  String get readyToJoinConsultationRoom;

  /// No description provided for @agoraNotConfigured.
  ///
  /// In en, this message translates to:
  /// **'Agora is not configured yet. Add AGORA_APP_ID and, if your Agora project uses tokens, AGORA_TEMP_TOKEN before joining a live consultation.'**
  String get agoraNotConfigured;

  /// No description provided for @preparingSecureVideoConsultation.
  ///
  /// In en, this message translates to:
  /// **'Preparing secure video consultation...'**
  String get preparingSecureVideoConsultation;

  /// No description provided for @youAreLiveInRoom.
  ///
  /// In en, this message translates to:
  /// **'You are live in the consultation room.'**
  String get youAreLiveInRoom;

  /// No description provided for @doctorPatientConnected.
  ///
  /// In en, this message translates to:
  /// **'Doctor and patient are now connected.'**
  String get doctorPatientConnected;

  /// No description provided for @otherParticipantLeft.
  ///
  /// In en, this message translates to:
  /// **'The other participant left the room. Stay connected or end the consultation.'**
  String get otherParticipantLeft;

  /// No description provided for @connectingSecureConsultation.
  ///
  /// In en, this message translates to:
  /// **'Connecting secure consultation...'**
  String get connectingSecureConsultation;

  /// No description provided for @connectionDroppedReconnect.
  ///
  /// In en, this message translates to:
  /// **'Connection dropped. Trying to reconnect the consultation...'**
  String get connectionDroppedReconnect;

  /// No description provided for @consultationConnectionFailedTokenless.
  ///
  /// In en, this message translates to:
  /// **'The consultation connection failed. This usually means the Agora project requires a token. Disable App Certificate for testing, or provide AGORA_TEMP_TOKEN.'**
  String get consultationConnectionFailedTokenless;

  /// No description provided for @consultationConnectionFailedRetry.
  ///
  /// In en, this message translates to:
  /// **'The consultation connection failed. Please rejoin the room.'**
  String get consultationConnectionFailedRetry;

  /// No description provided for @joinCancelledUntilPermissions.
  ///
  /// In en, this message translates to:
  /// **'Join cancelled until permissions are granted.'**
  String get joinCancelledUntilPermissions;

  /// No description provided for @joinCancelledUntilEnabled.
  ///
  /// In en, this message translates to:
  /// **'Join cancelled until permissions are enabled.'**
  String get joinCancelledUntilEnabled;

  /// No description provided for @joiningConsultationRoom.
  ///
  /// In en, this message translates to:
  /// **'Joining consultation room...'**
  String get joiningConsultationRoom;

  /// No description provided for @liveVideoSetupWaiting.
  ///
  /// In en, this message translates to:
  /// **'Live video setup is waiting for Agora authentication.'**
  String get liveVideoSetupWaiting;

  /// No description provided for @unableToJoinConsultationRoom.
  ///
  /// In en, this message translates to:
  /// **'Unable to join the consultation room.'**
  String get unableToJoinConsultationRoom;

  /// No description provided for @consultationEnded.
  ///
  /// In en, this message translates to:
  /// **'Consultation ended.'**
  String get consultationEnded;

  /// No description provided for @cameraMicPermissionsRequired.
  ///
  /// In en, this message translates to:
  /// **'Camera and microphone permissions are required before joining the consultation.'**
  String get cameraMicPermissionsRequired;

  /// No description provided for @cameraMicPermanentlyDenied.
  ///
  /// In en, this message translates to:
  /// **'Camera and microphone access is permanently denied. Open settings to continue.'**
  String get cameraMicPermanentlyDenied;

  /// No description provided for @healsyncNeedsPermissions.
  ///
  /// In en, this message translates to:
  /// **'HealSync needs camera and microphone permission before the live consultation can start.'**
  String get healsyncNeedsPermissions;

  /// No description provided for @agoraRejectingTokenless.
  ///
  /// In en, this message translates to:
  /// **'This Agora project is rejecting tokenless access. Disable App Certificate in the Agora console for testing, or provide a valid AGORA_TEMP_TOKEN.'**
  String get agoraRejectingTokenless;

  /// No description provided for @agoraTokenMissingExpired.
  ///
  /// In en, this message translates to:
  /// **'Your Agora token is missing or expired. Generate a fresh token and try again.'**
  String get agoraTokenMissingExpired;

  /// No description provided for @networkUnstable.
  ///
  /// In en, this message translates to:
  /// **'The video session could not connect because the network is unstable. Please try again.'**
  String get networkUnstable;

  /// No description provided for @unableStartLiveConsultation.
  ///
  /// In en, this message translates to:
  /// **'We could not start the live consultation right now. Please verify your Agora setup and try again.'**
  String get unableStartLiveConsultation;

  /// No description provided for @recordingFailed.
  ///
  /// In en, this message translates to:
  /// **'Recording failed'**
  String get recordingFailed;

  /// No description provided for @readyForPreview.
  ///
  /// In en, this message translates to:
  /// **'Ready for preview'**
  String get readyForPreview;

  /// No description provided for @cameraIsOff.
  ///
  /// In en, this message translates to:
  /// **'Camera is off'**
  String get cameraIsOff;

  /// No description provided for @waitingForOtherParticipant.
  ///
  /// In en, this message translates to:
  /// **'Waiting for the other participant'**
  String get waitingForOtherParticipant;

  /// No description provided for @agoraSetupRequired.
  ///
  /// In en, this message translates to:
  /// **'Agora setup required'**
  String get agoraSetupRequired;

  /// No description provided for @agoraSetupRequiredBody.
  ///
  /// In en, this message translates to:
  /// **'Your project is rejecting no-token access. Disable App Certificate in Agora Console for testing, or generate an AGORA_TEMP_TOKEN for this channel and run the app again.'**
  String get agoraSetupRequiredBody;

  /// No description provided for @noFileAttached.
  ///
  /// In en, this message translates to:
  /// **'No file attached'**
  String get noFileAttached;

  /// No description provided for @pdfFileAttached.
  ///
  /// In en, this message translates to:
  /// **'PDF file attached'**
  String get pdfFileAttached;

  /// No description provided for @fileAttached.
  ///
  /// In en, this message translates to:
  /// **'File attached'**
  String get fileAttached;

  /// No description provided for @dateLabel.
  ///
  /// In en, this message translates to:
  /// **'Date: {date}'**
  String dateLabel(Object date);

  /// No description provided for @prescriptionLabel.
  ///
  /// In en, this message translates to:
  /// **'Prescription: {value}'**
  String prescriptionLabel(Object value);

  /// No description provided for @addRecordTitle.
  ///
  /// In en, this message translates to:
  /// **'Add Record'**
  String get addRecordTitle;

  /// No description provided for @patientLabel.
  ///
  /// In en, this message translates to:
  /// **'Patient: {name}'**
  String patientLabel(Object name);

  /// No description provided for @condition.
  ///
  /// In en, this message translates to:
  /// **'Condition'**
  String get condition;

  /// No description provided for @uploadFileOptional.
  ///
  /// In en, this message translates to:
  /// **'Upload File (Optional)'**
  String get uploadFileOptional;

  /// No description provided for @saveRecord.
  ///
  /// In en, this message translates to:
  /// **'Save Record'**
  String get saveRecord;

  /// No description provided for @saving.
  ///
  /// In en, this message translates to:
  /// **'Saving...'**
  String get saving;

  /// No description provided for @conditionPrescriptionRequired.
  ///
  /// In en, this message translates to:
  /// **'Condition and prescription are required.'**
  String get conditionPrescriptionRequired;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'hi', 'ml', 'ta', 'te'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'hi':
      return AppLocalizationsHi();
    case 'ml':
      return AppLocalizationsMl();
    case 'ta':
      return AppLocalizationsTa();
    case 'te':
      return AppLocalizationsTe();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
