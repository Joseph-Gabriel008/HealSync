// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Malayalam (`ml`).
class AppLocalizationsMl extends AppLocalizations {
  AppLocalizationsMl([String locale = 'ml']) : super(locale);

  @override
  String get appTitle => 'ഹീൽസിങ്ക്';

  @override
  String get welcome => 'സ്വാഗതം';

  @override
  String get upload => 'മെഡിക്കൽ റെക്കോർഡ് അപ്‌ലോഡ് ചെയ്യുക';

  @override
  String get language => 'ഭാഷ';

  @override
  String get english => 'ഇംഗ്ലീഷ്';

  @override
  String get hindi => 'ഹിന്ദി';

  @override
  String get tamil => 'തമിഴ്';

  @override
  String get telugu => 'തെലുങ്ക്';

  @override
  String get malayalam => 'മലയാളം';

  @override
  String get createCareWorkspace => 'നിങ്ങളുടെ കെയർ വർക്ക്‌സ്‌പേസ് സൃഷ്ടിക്കുക';

  @override
  String get welcomeBack => 'വീണ്ടും സ്വാഗതം';

  @override
  String get signupSubtitle =>
      'നിങ്ങളുടെ അക്കൗണ്ട് സജ്ജമാക്കി HealSync എങ്ങനെ ഉപയോഗിക്കണമെന്ന് തിരഞ്ഞെടുക്കുക.';

  @override
  String get loginSubtitle =>
      'കൺസൾട്ടേഷനുകൾ, റെക്കോർഡുകൾ, സ്ഥിരീകരിച്ച ആരോഗ്യ ഡാറ്റ എന്നിവ നിയന്ത്രിക്കാൻ സൈൻ ഇൻ ചെയ്യുക.';

  @override
  String get fullName => 'പൂർണ്ണ പേര്';

  @override
  String get email => 'ഇമെയിൽ';

  @override
  String get password => 'പാസ്‌വേഡ്';

  @override
  String get patient => 'രോഗി';

  @override
  String get doctor => 'ഡോക്ടർ';

  @override
  String get createAccount => 'അക്കൗണ്ട് സൃഷ്ടിക്കുക';

  @override
  String get loginAction => 'ലോഗിൻ';

  @override
  String get alreadyHaveAccount => 'ഇതിനകം അക്കൗണ്ട് ഉണ്ടോ? ലോഗിൻ ചെയ്യുക';

  @override
  String get needAccount => 'അക്കൗണ്ട് വേണോ? സൈൻ അപ്പ് ചെയ്യുക';

  @override
  String get careHeroHeadline =>
      'ബന്ധിപ്പിച്ച, സ്ഥിരീകരിച്ച, ലളിതമായ ചികിത്സാനുഭവം.';

  @override
  String get careHeroBody =>
      'HealSync ടെലിമെഡിസിൻ, റിയൽടൈം റെക്കോർഡുകൾ, മനോഹരമായ ഹെൽത്ത്‌ക്കെയർ വർക്ക്‌സ്‌പേസ് എന്നിവയെ ഒരു ശാന്തമായ അനുഭവമായി ഒന്നിക്കുന്നു.';

  @override
  String get realtimeRecords => 'റിയൽടൈം റെക്കോർഡുകൾ';

  @override
  String get verifiedReports => 'സ്ഥിരീകരിച്ച റിപ്പോർട്ടുകൾ';

  @override
  String get secureConsultations => 'സുരക്ഷിത കൺസൾട്ടേഷനുകൾ';

  @override
  String get logout => 'ലോഗ്ഔട്ട്';

  @override
  String get patientDashboardTitle => 'രോഗി ഡാഷ്ബോർഡ്';

  @override
  String get doctorDashboardTitle => 'ഡോക്ടർ ഡാഷ്ബോർഡ്';

  @override
  String welcomeBackUser(Object name) {
    return 'വീണ്ടും സ്വാഗതം, $name';
  }

  @override
  String get patientHeroSubtitle =>
      'ബുക്കിംഗുകളിൽ നിന്ന് സ്ഥിരീകരിച്ച മെഡിക്കൽ റെക്കോർഡുകൾ വരെ എല്ലാം ഇപ്പോൾ ഒരൊറ്റ ശാന്തമായ ഹെൽത്ത് കമാൻഡ് സെന്ററിലാണ്.';

  @override
  String get verifiedRecordsLabel => 'സ്ഥിരീകരിച്ച റെക്കോർഡുകൾ';

  @override
  String get appointmentsLabel => 'അപ്പോയിന്റ്മെന്റുകൾ';

  @override
  String get bookAppointment => 'അപ്പോയിന്റ്മെന്റ് ബുക്ക് ചെയ്യുക';

  @override
  String get uploadRecord => 'റെക്കോർഡ് അപ്‌ലോഡ് ചെയ്യുക';

  @override
  String get nextConsultation => 'അടുത്ത കൺസൾട്ടേഷൻ';

  @override
  String consultationWithDoctor(Object doctorName) {
    return '$doctorName യോടുള്ള കൺസൾട്ടേഷൻ';
  }

  @override
  String get join => 'ചേരുക';

  @override
  String get trackBookingsStatuses => 'ബുക്കിംഗുകളും നിലകളും നിരീക്ഷിക്കുക';

  @override
  String get medicalHistory => 'മെഡിക്കൽ ചരിത്രം';

  @override
  String get reportsVerificationAudit => 'റിപ്പോർട്ടുകൾ, പരിശോധന, ഓഡിറ്റ്';

  @override
  String get prescriptionsTitle => 'പ്രിസ്ക്രിപ്ഷനുകൾ';

  @override
  String get doctorMedicationsNotes => 'ഡോക്ടർ മരുന്നുകളും കുറിപ്പുകളും';

  @override
  String get healthPassport => 'ഹെൽത്ത് പാസ്‌പോർട്ട്';

  @override
  String get portableVerifiedProfile =>
      'നിങ്ങളുടെ കൈയിൽ കൊണ്ടുപോകാവുന്ന സ്ഥിരീകരിച്ച പ്രൊഫൈൽ';

  @override
  String get recentRecords => 'സമീപകാല റെക്കോർഡുകൾ';

  @override
  String referenceCode(Object code) {
    return 'റഫറൻസ്: $code';
  }

  @override
  String get verified => 'സ്ഥിരീകരിച്ചു';

  @override
  String get notVerified => 'സ്ഥിരീകരിച്ചിട്ടില്ല';

  @override
  String get myAppointments => 'എന്റെ അപ്പോയിന്റ്മെന്റുകൾ';

  @override
  String get noAppointmentsYet => 'ഇനിയും അപ്പോയിന്റ്മെന്റുകളില്ല';

  @override
  String get bookConsultationPrompt =>
      'നിങ്ങളുടെ സന്ദർശനങ്ങൾ ഇവിടെ കാണാൻ ഡാഷ്ബോർഡിൽ നിന്ന് ഒരു കൺസൾട്ടേഷൻ ബുക്ക് ചെയ്യുക.';

  @override
  String get confirmBooking => 'ബുക്കിംഗ് സ്ഥിരീകരിക്കുക';

  @override
  String get selectDoctor => 'ഡോക്ടറെ തിരഞ്ഞെടുക്കുക';

  @override
  String telemedicineSuffix(Object name) {
    return '$name - ടെലിമെഡിസിൻ';
  }

  @override
  String get consultationDateTime => 'കൺസൾട്ടേഷൻ തീയതിയും സമയവും';

  @override
  String get appointmentConfirmed => 'അപ്പോയിന്റ്മെന്റ് സ്ഥിരീകരിച്ചു';

  @override
  String get noDoctorAccountAvailable =>
      'ബാക്ക്‌എൻഡിൽ ഇതുവരെ ഡോക്ടർ അക്കൗണ്ട് ലഭ്യമല്ല. ആദ്യം ഡോക്ടറോട് HealSync ൽ സൈൻ അപ്പ് ചെയ്യാൻ പറഞ്ഞ ശേഷം വീണ്ടും ശ്രമിക്കുക.';

  @override
  String get payment => 'പേയ്മെന്റ്';

  @override
  String get consultationPayment => 'കൺസൾട്ടേഷൻ പേയ്മെന്റ്';

  @override
  String get doctorLabel => 'ഡോക്ടർ';

  @override
  String get appointmentTime => 'അപ്പോയിന്റ്മെന്റ് സമയം';

  @override
  String get amount => 'തുക';

  @override
  String get processingPayment => 'പേയ്മെന്റ് പ്രോസസ്സ് ചെയ്യുന്നു...';

  @override
  String get processing => 'പ്രോസസ്സ് ചെയ്യുന്നു...';

  @override
  String get payNow => 'ഇപ്പോൾ പണമടയ്ക്കുക';

  @override
  String get paymentFailedTryAgain =>
      'പേയ്മെന്റ് പരാജയപ്പെട്ടു. വീണ്ടും ശ്രമിക്കുക';

  @override
  String get paymentSuccessful => 'പേയ്മെന്റ് വിജയിച്ചു';

  @override
  String get appointmentConfirmedMessage =>
      'നിങ്ങളുടെ അപ്പോയിന്റ്മെന്റ് സ്ഥിരീകരിച്ചു';

  @override
  String get ok => 'ശരി';

  @override
  String doctorGreeting(Object name) {
    return 'ഹലോ ഡോ. $name';
  }

  @override
  String get doctorHeroSubtitle =>
      'ശാന്തമായ ക്ലിനിക്കൽ പ്രവാഹത്തോടെ കൺസൾട്ടേഷനുകൾ നടത്തുക, പ്രിസ്ക്രിപ്ഷനുകൾ നൽകുക, രോഗികളുടെ റിപ്പോർട്ടുകൾ സ്ഥിരീകരിക്കുക.';

  @override
  String get quickActions => 'വേഗ പ്രവർത്തനങ്ങൾ';

  @override
  String get patientList => 'രോഗി പട്ടിക';

  @override
  String get recordsHub => 'റെക്കോർഡ്സ് ഹബ്';

  @override
  String get upcomingConsultations => 'വരാനിരിക്കുന്ന കൺസൾട്ടേഷനുകൾ';

  @override
  String get start => 'ആരംഭിക്കുക';

  @override
  String get patientsLabel => 'രോഗികൾ';

  @override
  String get searchByDoctorName => 'ഡോക്ടർ പേരിൽ തിരയുക';

  @override
  String get noDoctorsFound => 'ഡോക്ടർമാരെ കണ്ടെത്താനായില്ല';

  @override
  String get all => 'എല്ലാം';

  @override
  String get cardiology => 'കാർഡിയോളജി';

  @override
  String get dermatology => 'ഡെർമറ്റോളജി';

  @override
  String get general => 'ജനറൽ';

  @override
  String get pediatrics => 'പീഡിയാട്രിക്സ്';

  @override
  String experienceValue(Object value) {
    return 'അനുഭവം: $value';
  }

  @override
  String get records => 'റെക്കോർഡുകൾ';

  @override
  String historyTitle(Object name) {
    return '$name യുടെ ചരിത്രം';
  }

  @override
  String get grantAccess => 'ആക്സസ് അനുവദിക്കുക';

  @override
  String get revokeAccess => 'ആക്സസ് പിൻവലിക്കുക';

  @override
  String get doctorAccessRevoked => 'ഡോക്ടർ ആക്സസ് വിജയകരമായി പിൻവലിച്ചു.';

  @override
  String get doctorAccessGranted => 'ഡോക്ടർ ആക്സസ് വിജയകരമായി അനുവദിച്ചു.';

  @override
  String get updateAccessPermissionsError =>
      'ഇപ്പോൾ ആക്സസ് അനുമതികൾ പുതുക്കാനായില്ല.';

  @override
  String get liveConsultationRoom => 'ലൈവ് കൺസൾട്ടേഷൻ റൂം';

  @override
  String channelLabel(Object channelId) {
    return 'ചാനൽ: $channelId';
  }

  @override
  String get recording => 'റെക്കോർഡിംഗ്';

  @override
  String liveDuration(Object duration) {
    return 'ലൈവ് ദൈർഘ്യം: $duration';
  }

  @override
  String get viewHistory => 'ചരിത്രം കാണുക';

  @override
  String get addRecord => 'റെക്കോർഡ് ചേർക്കുക';

  @override
  String get mute => 'മ്യൂട്ട്';

  @override
  String get unmute => 'അൺമ്യൂട്ട്';

  @override
  String get camera => 'ക്യാമറ';

  @override
  String get turnCameraOn => 'ക്യാമറ ഓൺ ചെയ്യുക';

  @override
  String get rearCamera => 'പിൻ ക്യാമറ';

  @override
  String get frontCamera => 'മുൻ ക്യാമറ';

  @override
  String get end => 'അവസാനിപ്പിക്കുക';

  @override
  String get you => 'നിങ്ങൾ';

  @override
  String get remoteParticipant => 'മറ്റ് പങ്കാളി';

  @override
  String get cameraOff => 'ക്യാമറ ഓഫ്';

  @override
  String get localCamera => 'ലോക്കൽ ക്യാമറ';

  @override
  String get waitingSecondPerson => 'രണ്ടാമത്തെ ആളെ കാത്തിരിക്കുന്നു';

  @override
  String get connectedLive => 'ലൈവായി കണക്റ്റ് ചെയ്തു';

  @override
  String get diagnosis => 'രോഗനിർണ്ണയം';

  @override
  String get prescription => 'പ്രിസ്ക്രിപ്ഷൻ';

  @override
  String get saveNotes => 'കുറിപ്പുകൾ സംരക്ഷിക്കുക';

  @override
  String get consultationNotesSaved => 'കൺസൾട്ടേഷൻ കുറിപ്പുകൾ സംരക്ഷിച്ചു.';

  @override
  String get saveNotesError =>
      'ഇപ്പോൾ കൺസൾട്ടേഷൻ കുറിപ്പുകൾ സംരക്ഷിക്കാനായില്ല.';

  @override
  String get patientHistoryUnavailable => 'രോഗിയുടെ ചരിത്രം ഇപ്പോൾ ലഭ്യമല്ല.';

  @override
  String get noMedicalHistoryFound =>
      'ഇതുവരെ മെഡിക്കൽ ചരിത്രം കണ്ടെത്തിയിട്ടില്ല.';

  @override
  String get onlyDoctorsCanAddRecords =>
      'ഡോക്ടർമാർക്ക് മാത്രമേ റെക്കോർഡുകൾ ചേർക്കാൻ കഴിയൂ.';

  @override
  String get patientDetailsUnavailable => 'രോഗിയുടെ വിവരങ്ങൾ ഇപ്പോൾ ലഭ്യമല്ല.';

  @override
  String get medicalRecordSaved => 'മെഡിക്കൽ റെക്കോർഡ് വിജയകരമായി സംരക്ഷിച്ചു.';

  @override
  String get cameraMicAccessRequired => 'ക്യാമറയും മൈക്കും ആക്സസ് ആവശ്യമാണ്';

  @override
  String get openSettings => 'സെറ്റിംഗ്സ് തുറക്കുക';

  @override
  String get readyToJoinConsultationRoom => 'കൺസൾട്ടേഷൻ റൂമിൽ ചേരാൻ തയ്യാറാണ്.';

  @override
  String get agoraNotConfigured =>
      'Agora ഇനിയും ക്രമീകരിച്ചിട്ടില്ല. ലൈവ് കൺസൾട്ടേഷനിൽ ചേരുന്നതിന് മുമ്പ് AGORA_APP_IDയും ആവശ്യമെങ്കിൽ AGORA_TEMP_TOKENഉം ചേർക്കുക.';

  @override
  String get preparingSecureVideoConsultation =>
      'സുരക്ഷിത വീഡിയോ കൺസൾട്ടേഷൻ തയ്യാറാക്കുന്നു...';

  @override
  String get youAreLiveInRoom => 'നിങ്ങൾ കൺസൾട്ടേഷൻ റൂമിൽ ലൈവിലാണ്.';

  @override
  String get doctorPatientConnected => 'ഡോക്ടറും രോഗിയും ഇപ്പോൾ ബന്ധപ്പെട്ടു.';

  @override
  String get otherParticipantLeft =>
      'മറ്റ് പങ്കാളി റൂം വിട്ടു. കണക്റ്റ് ആയി തുടരുക അല്ലെങ്കിൽ കൺസൾട്ടേഷൻ അവസാനിപ്പിക്കുക.';

  @override
  String get connectingSecureConsultation =>
      'സുരക്ഷിത കൺസൾട്ടേഷൻ കണക്റ്റ് ചെയ്യുന്നു...';

  @override
  String get connectionDroppedReconnect =>
      'കണക്ഷൻ നഷ്ടപ്പെട്ടു. കൺസൾട്ടേഷൻ വീണ്ടും ബന്ധിപ്പിക്കാൻ ശ്രമിക്കുന്നു...';

  @override
  String get consultationConnectionFailedTokenless =>
      'കൺസൾട്ടേഷൻ കണക്ഷൻ പരാജയപ്പെട്ടു. സാധാരണയായി ഇതിന്റെ അർത്ഥം Agora പ്രോജക്റ്റിന് ടോക്കൺ ആവശ്യമാണ്. ടെസ്റ്റിംഗിനായി App Certificate ഓഫ് ചെയ്യുക അല്ലെങ്കിൽ AGORA_TEMP_TOKEN നൽകുക.';

  @override
  String get consultationConnectionFailedRetry =>
      'കൺസൾട്ടേഷൻ കണക്ഷൻ പരാജയപ്പെട്ടു. ദയവായി റൂമിൽ വീണ്ടും ചേരുക.';

  @override
  String get joinCancelledUntilPermissions =>
      'അനുമതികൾ ലഭിക്കും വരെ ചേരൽ റദ്ദാക്കി.';

  @override
  String get joinCancelledUntilEnabled =>
      'അനുമതികൾ പ്രവർത്തനക്ഷമമാകുന്നത് വരെ ചേരൽ റദ്ദാക്കി.';

  @override
  String get joiningConsultationRoom => 'കൺസൾട്ടേഷൻ റൂമിൽ ചേരുന്നു...';

  @override
  String get liveVideoSetupWaiting =>
      'ലൈവ് വീഡിയോ ക്രമീകരണം Agora ഓത് സ്ഥിരീകരണത്തിനായി കാത്തിരിക്കുന്നു.';

  @override
  String get unableToJoinConsultationRoom => 'കൺസൾട്ടേഷൻ റൂമിൽ ചേരാനായില്ല.';

  @override
  String get consultationEnded => 'കൺസൾട്ടേഷൻ അവസാനിച്ചു.';

  @override
  String get cameraMicPermissionsRequired =>
      'കൺസൾട്ടേഷനിൽ ചേരുന്നതിന് മുമ്പ് ക്യാമറയും മൈക്രോഫോണും അനുമതികൾ ആവശ്യമാണ്.';

  @override
  String get cameraMicPermanentlyDenied =>
      'ക്യാമറയും മൈക്രോഫോണും ആക്സസ് സ്ഥിരമായി നിരസിച്ചിരിക്കുന്നു. തുടരാൻ സെറ്റിംഗ്സ് തുറക്കുക.';

  @override
  String get healsyncNeedsPermissions =>
      'ലൈവ് കൺസൾട്ടേഷൻ ആരംഭിക്കുന്നതിന് മുമ്പ് HealSync ന് ക്യാമറയും മൈക്രോഫോണും അനുമതി വേണം.';

  @override
  String get agoraRejectingTokenless =>
      'ഈ Agora പ്രോജക്റ്റ് ടോക്കൺ ഇല്ലാത്ത ആക്സസ് നിരസിക്കുന്നു. ടെസ്റ്റിംഗിനായി Agora Console ൽ App Certificate ഓഫ് ചെയ്യുക അല്ലെങ്കിൽ സാധുവായ AGORA_TEMP_TOKEN നൽകുക.';

  @override
  String get agoraTokenMissingExpired =>
      'നിങ്ങളുടെ Agora ടോക്കൺ കാണാനില്ല അല്ലെങ്കിൽ കാലഹരണപ്പെട്ടു. പുതിയ ടോക്കൺ സൃഷ്ടിച്ച് വീണ്ടും ശ്രമിക്കുക.';

  @override
  String get networkUnstable =>
      'നെറ്റ്‌വർക്ക് സ്ഥിരതയില്ലാത്തതിനാൽ വീഡിയോ സെഷൻ കണക്റ്റ് ചെയ്യാനായില്ല. ദയവായി വീണ്ടും ശ്രമിക്കുക.';

  @override
  String get unableStartLiveConsultation =>
      'ഇപ്പോൾ ലൈവ് കൺസൾട്ടേഷൻ ആരംഭിക്കാനായില്ല. നിങ്ങളുടെ Agora ക്രമീകരണം പരിശോധിച്ച് വീണ്ടും ശ്രമിക്കുക.';

  @override
  String get recordingFailed => 'റെക്കോർഡിംഗ് പരാജയപ്പെട്ടു';

  @override
  String get readyForPreview => 'പ്രീവ്യൂക്കായി തയ്യാറാണ്';

  @override
  String get cameraIsOff => 'ക്യാമറ ഓഫാണ്';

  @override
  String get waitingForOtherParticipant => 'മറ്റ് പങ്കാളിയെ കാത്തിരിക്കുന്നു';

  @override
  String get agoraSetupRequired => 'Agora ക്രമീകരണം ആവശ്യമാണ്';

  @override
  String get agoraSetupRequiredBody =>
      'നിങ്ങളുടെ പ്രോജക്റ്റ് ടോക്കൺ ഇല്ലാത്ത ആക്സസ് നിരസിക്കുന്നു. ടെസ്റ്റിംഗിനായി Agora Console ൽ App Certificate ഓഫ് ചെയ്യുക അല്ലെങ്കിൽ ഈ ചാനലിന് AGORA_TEMP_TOKEN സൃഷ്ടിച്ച് ആപ്പ് വീണ്ടും പ്രവർത്തിപ്പിക്കുക.';

  @override
  String get noFileAttached => 'ഫയൽ ചേർത്തിട്ടില്ല';

  @override
  String get pdfFileAttached => 'PDF ഫയൽ ചേർത്തിരിക്കുന്നു';

  @override
  String get fileAttached => 'ഫയൽ ചേർത്തിരിക്കുന്നു';

  @override
  String dateLabel(Object date) {
    return 'തീയതി: $date';
  }

  @override
  String prescriptionLabel(Object value) {
    return 'പ്രിസ്ക്രിപ്ഷൻ: $value';
  }

  @override
  String get addRecordTitle => 'റെക്കോർഡ് ചേർക്കുക';

  @override
  String patientLabel(Object name) {
    return 'രോഗി: $name';
  }

  @override
  String get condition => 'സ്ഥിതി';

  @override
  String get uploadFileOptional => 'ഫയൽ അപ്‌ലോഡ് ചെയ്യുക (ഐച്ഛികം)';

  @override
  String get saveRecord => 'റെക്കോർഡ് സംരക്ഷിക്കുക';

  @override
  String get saving => 'സംരക്ഷിക്കുന്നു...';

  @override
  String get conditionPrescriptionRequired =>
      'സ്ഥിതിയും പ്രിസ്ക്രിപ്ഷനും ആവശ്യമാണ്.';
}
