// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Tamil (`ta`).
class AppLocalizationsTa extends AppLocalizations {
  AppLocalizationsTa([String locale = 'ta']) : super(locale);

  @override
  String get appTitle => 'ஹீல்சிங்';

  @override
  String get welcome => 'வரவேற்கிறோம்';

  @override
  String get upload => 'மருத்துவ பதிவை பதிவேற்றவும்';

  @override
  String get language => 'மொழி';

  @override
  String get english => 'ஆங்கிலம்';

  @override
  String get hindi => 'ஹிந்தி';

  @override
  String get tamil => 'தமிழ்';

  @override
  String get telugu => 'தெலுங்கு';

  @override
  String get malayalam => 'மலையாளம்';

  @override
  String get createCareWorkspace => 'உங்கள் சிகிச்சை பணிமனையை உருவாக்குங்கள்';

  @override
  String get welcomeBack => 'மீண்டும் வரவேற்கிறோம்';

  @override
  String get signupSubtitle =>
      'உங்கள் கணக்கை அமைத்து ஹீல்சிங்கை எப்படி பயன்படுத்த விரும்புகிறீர்கள் என்பதைத் தேர்வு செய்யுங்கள்.';

  @override
  String get loginSubtitle =>
      'ஆலோசனைகள், பதிவுகள் மற்றும் சரிபார்க்கப்பட்ட சுகாதாரத் தரவை நிர்வகிக்க உள்நுழையுங்கள்.';

  @override
  String get fullName => 'முழு பெயர்';

  @override
  String get email => 'மின்னஞ்சல்';

  @override
  String get password => 'கடவுச்சொல்';

  @override
  String get patient => 'நோயாளர்';

  @override
  String get doctor => 'மருத்துவர்';

  @override
  String get createAccount => 'கணக்கை உருவாக்கவும்';

  @override
  String get loginAction => 'உள்நுழை';

  @override
  String get alreadyHaveAccount => 'ஏற்கனவே கணக்கு உள்ளதா? உள்நுழையுங்கள்';

  @override
  String get needAccount => 'கணக்கு வேண்டுமா? பதிவு செய்யுங்கள்';

  @override
  String get careHeroHeadline =>
      'இணைந்த, சரிபார்க்கப்பட்ட மற்றும் அழகாக எளிமையான சிகிச்சை அனுபவம்.';

  @override
  String get careHeroBody =>
      'ஹீல்சிங் தொலைமருத்துவம், நேரடி பதிவுகள் மற்றும் அழகாக அமைந்த சுகாதார பணிமனையை ஒரே அமைதியான அனுபவமாக வழங்குகிறது.';

  @override
  String get realtimeRecords => 'நேரடி பதிவுகள்';

  @override
  String get verifiedReports => 'சரிபார்க்கப்பட்ட அறிக்கைகள்';

  @override
  String get secureConsultations => 'பாதுகாப்பான ஆலோசனைகள்';

  @override
  String get logout => 'வெளியேறு';

  @override
  String get patientDashboardTitle => 'நோயாளர் டாஷ்போர்டு';

  @override
  String get doctorDashboardTitle => 'மருத்துவர் டாஷ்போர்டு';

  @override
  String welcomeBackUser(Object name) {
    return 'மீண்டும் வரவேற்கிறோம், $name';
  }

  @override
  String get patientHeroSubtitle =>
      'பதிவுப்பதிவு முதல் சரிபார்க்கப்பட்ட மருத்துவ பதிவுகள் வரை அனைத்தும் இப்போது ஒரே அமைதியான சுகாதார மையத்தில் உள்ளது.';

  @override
  String get verifiedRecordsLabel => 'சரிபார்க்கப்பட்ட பதிவுகள்';

  @override
  String get appointmentsLabel => 'நியமனங்கள்';

  @override
  String get bookAppointment => 'நியமனம் பதிவு செய்யவும்';

  @override
  String get uploadRecord => 'பதிவை பதிவேற்றவும்';

  @override
  String get nextConsultation => 'அடுத்த ஆலோசனை';

  @override
  String consultationWithDoctor(Object doctorName) {
    return '$doctorName உடன் ஆலோசனை';
  }

  @override
  String get join => 'சேரவும்';

  @override
  String get trackBookingsStatuses => 'பதிவுகள் மற்றும் நிலைகளை கண்காணிக்கவும்';

  @override
  String get medicalHistory => 'மருத்துவ வரலாறு';

  @override
  String get reportsVerificationAudit =>
      'அறிக்கைகள், சரிபார்ப்பு மற்றும் ஆய்வு';

  @override
  String get prescriptionsTitle => 'மருந்து சீட்டுகள்';

  @override
  String get doctorMedicationsNotes =>
      'மருத்துவர் மருந்துகள் மற்றும் குறிப்புகள்';

  @override
  String get healthPassport => 'சுகாதார அடையாளம்';

  @override
  String get portableVerifiedProfile =>
      'உங்கள் எடுத்துச்செல்லக்கூடிய சரிபார்க்கப்பட்ட சுயவிவரம்';

  @override
  String get recentRecords => 'சமீபத்திய பதிவுகள்';

  @override
  String referenceCode(Object code) {
    return 'குறிப்பு: $code';
  }

  @override
  String get verified => 'சரிபார்க்கப்பட்டது';

  @override
  String get notVerified => 'சரிபார்க்கப்படவில்லை';

  @override
  String get myAppointments => 'என் நியமனங்கள்';

  @override
  String get noAppointmentsYet => 'இன்னும் நியமனங்கள் இல்லை';

  @override
  String get bookConsultationPrompt =>
      'உங்கள் வருகைகளை இங்கே நேரடியாக காண டாஷ்போர்டில் இருந்து ஒரு ஆலோசனையை பதிவு செய்யுங்கள்.';

  @override
  String get confirmBooking => 'பதிவை உறுதிப்படுத்தவும்';

  @override
  String get selectDoctor => 'மருத்துவரை தேர்ந்தெடுக்கவும்';

  @override
  String telemedicineSuffix(Object name) {
    return '$name - தொலைமருத்துவம்';
  }

  @override
  String get consultationDateTime => 'ஆலோசனை தேதி மற்றும் நேரம்';

  @override
  String get appointmentConfirmed => 'நியமனம் உறுதிப்படுத்தப்பட்டது';

  @override
  String get noDoctorAccountAvailable =>
      'பின்தளத்தில் இன்னும் மருத்துவர் கணக்கு இல்லை. முதலில் மருத்துவரை HealSync-ல் பதிவு செய்யச் சொல்லி பிறகு மீண்டும் முயற்சிக்கவும்.';

  @override
  String get payment => 'கட்டணம்';

  @override
  String get consultationPayment => 'ஆலோசனை கட்டணம்';

  @override
  String get doctorLabel => 'மருத்துவர்';

  @override
  String get appointmentTime => 'நியமன நேரம்';

  @override
  String get amount => 'தொகை';

  @override
  String get processingPayment => 'கட்டணம் செயலாக்கப்படுகிறது...';

  @override
  String get processing => 'செயலாக்கப்படுகிறது...';

  @override
  String get payNow => 'இப்போது கட்டணம் செலுத்தவும்';

  @override
  String get paymentFailedTryAgain =>
      'கட்டணம் தோல்வியடைந்தது. மீண்டும் முயற்சிக்கவும்';

  @override
  String get paymentSuccessful => 'கட்டணம் வெற்றி';

  @override
  String get appointmentConfirmedMessage =>
      'உங்கள் நியமனம் உறுதிப்படுத்தப்பட்டது';

  @override
  String get ok => 'சரி';

  @override
  String doctorGreeting(Object name) {
    return 'வணக்கம் டாக்டர் $name';
  }

  @override
  String get doctorHeroSubtitle =>
      'அமைதியான மருத்துவ பணிச்சூழலில் ஆலோசனைகளை நடத்தி, மருந்து சீட்டுகளை வழங்கி, நோயாளி அறிக்கைகளை சரிபார்க்கவும்.';

  @override
  String get quickActions => 'விரைவு செயல்கள்';

  @override
  String get patientList => 'நோயாளர் பட்டியல்';

  @override
  String get recordsHub => 'பதிவுகள் மையம்';

  @override
  String get upcomingConsultations => 'வரவிருக்கும் ஆலோசனைகள்';

  @override
  String get start => 'தொடங்கு';

  @override
  String get patientsLabel => 'நோயாளர்கள்';

  @override
  String get searchByDoctorName => 'மருத்துவர் பெயரால் தேடுங்கள்';

  @override
  String get noDoctorsFound => 'மருத்துவர்கள் இல்லை';

  @override
  String get all => 'அனைத்தும்';

  @override
  String get cardiology => 'இதயவியல்';

  @override
  String get dermatology => 'தோல் மருத்துவம்';

  @override
  String get general => 'பொது';

  @override
  String get pediatrics => 'குழந்தை மருத்துவம்';

  @override
  String experienceValue(Object value) {
    return 'அனுபவம்: $value';
  }

  @override
  String get records => 'பதிவுகள்';

  @override
  String historyTitle(Object name) {
    return '$name வரலாறு';
  }

  @override
  String get grantAccess => 'அணுகலை வழங்கவும்';

  @override
  String get revokeAccess => 'அணுகலை ரத்து செய்யவும்';

  @override
  String get doctorAccessRevoked =>
      'மருத்துவர் அணுகல் வெற்றிகரமாக ரத்து செய்யப்பட்டது.';

  @override
  String get doctorAccessGranted =>
      'மருத்துவர் அணுகல் வெற்றிகரமாக வழங்கப்பட்டது.';

  @override
  String get updateAccessPermissionsError =>
      'இப்போது அணுகல் அனுமதிகளை புதுப்பிக்க முடியவில்லை.';

  @override
  String get liveConsultationRoom => 'நேரடி ஆலோசனை அறை';

  @override
  String channelLabel(Object channelId) {
    return 'சேனல்: $channelId';
  }

  @override
  String get recording => 'பதிவாகிறது';

  @override
  String liveDuration(Object duration) {
    return 'நேரடி நீளம்: $duration';
  }

  @override
  String get viewHistory => 'வரலாற்றைப் பார்க்கவும்';

  @override
  String get addRecord => 'பதிவு சேர்க்கவும்';

  @override
  String get mute => 'ஒலியை அணைக்கவும்';

  @override
  String get unmute => 'ஒலியை இயக்கவும்';

  @override
  String get camera => 'கேமரா';

  @override
  String get turnCameraOn => 'கேமராவை இயக்கு';

  @override
  String get rearCamera => 'பின்புற கேமரா';

  @override
  String get frontCamera => 'முன் கேமரா';

  @override
  String get end => 'முடி';

  @override
  String get you => 'நீங்கள்';

  @override
  String get remoteParticipant => 'மற்ற பங்கேற்பாளர்';

  @override
  String get cameraOff => 'கேமரா அணைப்பு';

  @override
  String get localCamera => 'உள்ளூர் கேமரா';

  @override
  String get waitingSecondPerson => 'இரண்டாவது நபர் சேர காத்திருக்கிறது';

  @override
  String get connectedLive => 'நேரடியாக இணைந்தது';

  @override
  String get diagnosis => 'நோயறிதல்';

  @override
  String get prescription => 'மருந்து சீட்டு';

  @override
  String get saveNotes => 'குறிப்புகளை சேமிக்கவும்';

  @override
  String get consultationNotesSaved => 'ஆலோசனை குறிப்புகள் சேமிக்கப்பட்டன.';

  @override
  String get saveNotesError =>
      'ஆலோசனை குறிப்புகளை இப்போது சேமிக்க முடியவில்லை.';

  @override
  String get patientHistoryUnavailable =>
      'நோயாளியின் வரலாறு இப்போது கிடைக்கவில்லை.';

  @override
  String get noMedicalHistoryFound => 'இதுவரை மருத்துவ வரலாறு இல்லை.';

  @override
  String get onlyDoctorsCanAddRecords =>
      'மருத்துவர்கள் மட்டும் பதிவுகளைச் சேர்க்க முடியும்.';

  @override
  String get patientDetailsUnavailable =>
      'நோயாளர் விவரங்கள் இப்போது கிடைக்கவில்லை.';

  @override
  String get medicalRecordSaved =>
      'மருத்துவ பதிவு வெற்றிகரமாக சேமிக்கப்பட்டது.';

  @override
  String get cameraMicAccessRequired => 'கேமரா மற்றும் மைக் அணுகல் தேவை';

  @override
  String get openSettings => 'அமைப்புகளைத் திறக்கவும்';

  @override
  String get readyToJoinConsultationRoom => 'ஆலோசனை அறையில் சேர தயாராக உள்ளது.';

  @override
  String get agoraNotConfigured =>
      'Agora இன்னும் அமைக்கப்படவில்லை. நேரடி ஆலோசனையில் சேருவதற்கு முன் AGORA_APP_ID மற்றும் தேவைப்பட்டால் AGORA_TEMP_TOKEN சேர்க்கவும்.';

  @override
  String get preparingSecureVideoConsultation =>
      'பாதுகாப்பான வீடியோ ஆலோசனை தயாராகிறது...';

  @override
  String get youAreLiveInRoom =>
      'நீங்கள் ஆலோசனை அறையில் நேரடியாக இருக்கிறீர்கள்.';

  @override
  String get doctorPatientConnected =>
      'மருத்துவரும் நோயாளியும் இப்போது இணைந்துள்ளனர்.';

  @override
  String get otherParticipantLeft =>
      'மற்ற பங்கேற்பாளர் அறையை விட்டு வெளியேறினார். இணைந்தே இருங்கள் அல்லது ஆலோசனையை முடிக்கவும்.';

  @override
  String get connectingSecureConsultation =>
      'பாதுகாப்பான ஆலோசனை இணைக்கப்படுகிறது...';

  @override
  String get connectionDroppedReconnect =>
      'இணைப்பு துண்டிக்கப்பட்டது. ஆலோசனையை மீண்டும் இணைக்க முயற்சிக்கிறது...';

  @override
  String get consultationConnectionFailedTokenless =>
      'ஆலோசனை இணைப்பு தோல்வியடைந்தது. இது பொதுவாக Agora திட்டத்திற்கு டோக்கன் தேவை என்பதைக் குறிக்கிறது. சோதனைக்காக App Certificate-ஐ முடக்கவும் அல்லது AGORA_TEMP_TOKEN வழங்கவும்.';

  @override
  String get consultationConnectionFailedRetry =>
      'ஆலோசனை இணைப்பு தோல்வியடைந்தது. மீண்டும் அறையில் சேரவும்.';

  @override
  String get joinCancelledUntilPermissions =>
      'அனுமதிகள் வழங்கப்படும் வரை சேருதல் ரத்து செய்யப்பட்டது.';

  @override
  String get joinCancelledUntilEnabled =>
      'அனுமதிகள் செயல்படுத்தப்படும் வரை சேருதல் ரத்து செய்யப்பட்டது.';

  @override
  String get joiningConsultationRoom => 'ஆலோசனை அறையில் சேருகிறது...';

  @override
  String get liveVideoSetupWaiting =>
      'Agora அங்கீகாரத்திற்காக நேரடி வீடியோ அமைப்பு காத்திருக்கிறது.';

  @override
  String get unableToJoinConsultationRoom => 'ஆலோசனை அறையில் சேர முடியவில்லை.';

  @override
  String get consultationEnded => 'ஆலோசனை முடிந்தது.';

  @override
  String get cameraMicPermissionsRequired =>
      'ஆலோசனையில் சேருவதற்கு முன் கேமரா மற்றும் மைக்ரோஃபோன் அனுமதிகள் தேவை.';

  @override
  String get cameraMicPermanentlyDenied =>
      'கேமரா மற்றும் மைக்ரோஃபோன் அணுகல் நிரந்தரமாக மறுக்கப்பட்டுள்ளது. தொடர அமைப்புகளைத் திறக்கவும்.';

  @override
  String get healsyncNeedsPermissions =>
      'நேரடி ஆலோசனை தொடங்குவதற்கு முன் HealSync-க்கு கேமரா மற்றும் மைக்ரோஃபோன் அனுமதி தேவை.';

  @override
  String get agoraRejectingTokenless =>
      'இந்த Agora திட்டம் டோக்கன் இல்லா அணுகலை நிராகரிக்கிறது. சோதனைக்காக Agora Console-ல் App Certificate-ஐ முடக்கவும் அல்லது செல்லுபடியாகும் AGORA_TEMP_TOKEN வழங்கவும்.';

  @override
  String get agoraTokenMissingExpired =>
      'உங்கள் Agora டோக்கன் இல்லை அல்லது காலாவதியானது. புதிய டோக்கன் உருவாக்கி மீண்டும் முயற்சிக்கவும்.';

  @override
  String get networkUnstable =>
      'நெட்வொர்க் நிலையற்றதால் வீடியோ அமர்வு இணைக்க முடியவில்லை. மீண்டும் முயற்சிக்கவும்.';

  @override
  String get unableStartLiveConsultation =>
      'இப்போது நேரடி ஆலோசனையை தொடங்க முடியவில்லை. உங்கள் Agora அமைப்பைச் சரிபார்த்து மீண்டும் முயற்சிக்கவும்.';

  @override
  String get recordingFailed => 'பதிவு தோல்வியடைந்தது';

  @override
  String get readyForPreview => 'முன்னோட்டத்துக்கு தயார்';

  @override
  String get cameraIsOff => 'கேமரா அணைந்துள்ளது';

  @override
  String get waitingForOtherParticipant =>
      'மற்ற பங்கேற்பாளருக்காக காத்திருக்கிறது';

  @override
  String get agoraSetupRequired => 'Agora அமைப்பு தேவை';

  @override
  String get agoraSetupRequiredBody =>
      'உங்கள் திட்டம் டோக்கன் இல்லா அணுகலை நிராகரிக்கிறது. சோதனைக்காக Agora Console-ல் App Certificate-ஐ முடக்கவும் அல்லது இந்த சேனலுக்கான AGORA_TEMP_TOKEN உருவாக்கி பயன்பாட்டை மீண்டும் இயக்கவும்.';

  @override
  String get noFileAttached => 'கோப்பு இணைக்கப்படவில்லை';

  @override
  String get pdfFileAttached => 'PDF கோப்பு இணைக்கப்பட்டுள்ளது';

  @override
  String get fileAttached => 'கோப்பு இணைக்கப்பட்டுள்ளது';

  @override
  String dateLabel(Object date) {
    return 'தேதி: $date';
  }

  @override
  String prescriptionLabel(Object value) {
    return 'மருந்து சீட்டு: $value';
  }

  @override
  String get addRecordTitle => 'பதிவு சேர்க்கவும்';

  @override
  String patientLabel(Object name) {
    return 'நோயாளர்: $name';
  }

  @override
  String get condition => 'நிலை';

  @override
  String get uploadFileOptional => 'கோப்பை பதிவேற்றவும் (விருப்பம்)';

  @override
  String get saveRecord => 'பதிவை சேமிக்கவும்';

  @override
  String get saving => 'சேமிக்கப்படுகிறது...';

  @override
  String get conditionPrescriptionRequired =>
      'நிலையும் மருந்து சீட்டும் அவசியம்.';
}
