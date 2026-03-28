// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Hindi (`hi`).
class AppLocalizationsHi extends AppLocalizations {
  AppLocalizationsHi([String locale = 'hi']) : super(locale);

  @override
  String get appTitle => 'हीलसिंक';

  @override
  String get welcome => 'स्वागत है';

  @override
  String get upload => 'मेडिकल रिकॉर्ड अपलोड करें';

  @override
  String get language => 'भाषा';

  @override
  String get english => 'अंग्रेज़ी';

  @override
  String get hindi => 'हिंदी';

  @override
  String get tamil => 'तमिल';

  @override
  String get telugu => 'तेलुगु';

  @override
  String get malayalam => 'मलयालम';

  @override
  String get createCareWorkspace => 'अपना देखभाल कार्यक्षेत्र बनाएं';

  @override
  String get welcomeBack => 'फिर से स्वागत है';

  @override
  String get signupSubtitle =>
      'अपना खाता सेट करें और चुनें कि आप हीलसिंक का उपयोग कैसे करते हैं।';

  @override
  String get loginSubtitle =>
      'परामर्श, रिकॉर्ड और सत्यापित स्वास्थ्य डेटा प्रबंधित करने के लिए साइन इन करें।';

  @override
  String get fullName => 'पूरा नाम';

  @override
  String get email => 'ईमेल';

  @override
  String get password => 'पासवर्ड';

  @override
  String get patient => 'रोगी';

  @override
  String get doctor => 'डॉक्टर';

  @override
  String get createAccount => 'खाता बनाएं';

  @override
  String get loginAction => 'लॉगिन';

  @override
  String get alreadyHaveAccount => 'क्या आपका पहले से खाता है? लॉगिन करें';

  @override
  String get needAccount => 'खाता चाहिए? साइन अप करें';

  @override
  String get careHeroHeadline =>
      'ऐसी देखभाल जो जुड़ी हुई, सत्यापित और खूबसूरती से सरल लगे।';

  @override
  String get careHeroBody =>
      'हीलसिंक टेलीमेडिसिन, रीयलटाइम रिकॉर्ड और सुंदर स्वास्थ्य कार्यक्षेत्र को एक शांत अनुभव में लाता है।';

  @override
  String get realtimeRecords => 'रीयलटाइम रिकॉर्ड';

  @override
  String get verifiedReports => 'सत्यापित रिपोर्ट';

  @override
  String get secureConsultations => 'सुरक्षित परामर्श';

  @override
  String get logout => 'लॉगआउट';

  @override
  String get patientDashboardTitle => 'रोगी डैशबोर्ड';

  @override
  String get doctorDashboardTitle => 'डॉक्टर डैशबोर्ड';

  @override
  String welcomeBackUser(Object name) {
    return 'फिर से स्वागत है, $name';
  }

  @override
  String get patientHeroSubtitle =>
      'बुकिंग से लेकर सत्यापित मेडिकल रिकॉर्ड तक सब कुछ अब एक शांत स्वास्थ्य कमांड सेंटर में है।';

  @override
  String get verifiedRecordsLabel => 'सत्यापित रिकॉर्ड';

  @override
  String get appointmentsLabel => 'अपॉइंटमेंट';

  @override
  String get bookAppointment => 'अपॉइंटमेंट बुक करें';

  @override
  String get uploadRecord => 'रिकॉर्ड अपलोड करें';

  @override
  String get nextConsultation => 'अगला परामर्श';

  @override
  String consultationWithDoctor(Object doctorName) {
    return '$doctorName के साथ परामर्श';
  }

  @override
  String get join => 'जुड़ें';

  @override
  String get trackBookingsStatuses => 'बुकिंग और स्थिति ट्रैक करें';

  @override
  String get medicalHistory => 'मेडिकल हिस्ट्री';

  @override
  String get reportsVerificationAudit => 'रिपोर्ट, सत्यापन और ऑडिट';

  @override
  String get prescriptionsTitle => 'प्रिस्क्रिप्शन';

  @override
  String get doctorMedicationsNotes => 'डॉक्टर की दवाइयाँ और नोट्स';

  @override
  String get healthPassport => 'हेल्थ पासपोर्ट';

  @override
  String get portableVerifiedProfile => 'आपकी पोर्टेबल सत्यापित प्रोफ़ाइल';

  @override
  String get recentRecords => 'हाल के रिकॉर्ड';

  @override
  String referenceCode(Object code) {
    return 'संदर्भ: $code';
  }

  @override
  String get verified => 'सत्यापित';

  @override
  String get notVerified => 'सत्यापित नहीं';

  @override
  String get myAppointments => 'मेरे अपॉइंटमेंट';

  @override
  String get noAppointmentsYet => 'अभी तक कोई अपॉइंटमेंट नहीं';

  @override
  String get bookConsultationPrompt =>
      'अपने विज़िट यहाँ रीयलटाइम में देखने के लिए डैशबोर्ड से परामर्श बुक करें।';

  @override
  String get confirmBooking => 'बुकिंग की पुष्टि करें';

  @override
  String get selectDoctor => 'डॉक्टर चुनें';

  @override
  String telemedicineSuffix(Object name) {
    return '$name - टेलीमेडिसिन';
  }

  @override
  String get consultationDateTime => 'परामर्श दिनांक और समय';

  @override
  String get appointmentConfirmed => 'अपॉइंटमेंट पुष्टि हो गई';

  @override
  String get noDoctorAccountAvailable =>
      'बैकएंड में अभी कोई डॉक्टर खाता उपलब्ध नहीं है। पहले डॉक्टर से HealSync में साइन अप करने के लिए कहें, फिर दोबारा कोशिश करें।';

  @override
  String get payment => 'भुगतान';

  @override
  String get consultationPayment => 'परामर्श भुगतान';

  @override
  String get doctorLabel => 'डॉक्टर';

  @override
  String get appointmentTime => 'अपॉइंटमेंट समय';

  @override
  String get amount => 'राशि';

  @override
  String get processingPayment => 'भुगतान प्रोसेस हो रहा है...';

  @override
  String get processing => 'प्रोसेस हो रहा है...';

  @override
  String get payNow => 'अभी भुगतान करें';

  @override
  String get paymentFailedTryAgain => 'भुगतान असफल रहा। फिर से कोशिश करें';

  @override
  String get paymentSuccessful => 'भुगतान सफल';

  @override
  String get appointmentConfirmedMessage => 'आपका अपॉइंटमेंट पुष्टि हो गया है';

  @override
  String get ok => 'ठीक है';

  @override
  String doctorGreeting(Object name) {
    return 'नमस्ते डॉ. $name';
  }

  @override
  String get doctorHeroSubtitle =>
      'शांत क्लिनिकल वर्कफ़्लो के साथ परामर्श चलाएँ, प्रिस्क्रिप्शन जारी करें और रोगी रिपोर्ट सत्यापित करें।';

  @override
  String get quickActions => 'त्वरित कार्य';

  @override
  String get patientList => 'रोगी सूची';

  @override
  String get recordsHub => 'रिकॉर्ड हब';

  @override
  String get upcomingConsultations => 'आगामी परामर्श';

  @override
  String get start => 'शुरू करें';

  @override
  String get patientsLabel => 'रोगी';

  @override
  String get searchByDoctorName => 'डॉक्टर के नाम से खोजें';

  @override
  String get noDoctorsFound => 'कोई डॉक्टर नहीं मिला';

  @override
  String get all => 'सभी';

  @override
  String get cardiology => 'कार्डियोलॉजी';

  @override
  String get dermatology => 'त्वचा रोग';

  @override
  String get general => 'सामान्य';

  @override
  String get pediatrics => 'बाल रोग';

  @override
  String experienceValue(Object value) {
    return 'अनुभव: $value';
  }

  @override
  String get records => 'रिकॉर्ड';

  @override
  String historyTitle(Object name) {
    return '$name का इतिहास';
  }

  @override
  String get grantAccess => 'एक्सेस दें';

  @override
  String get revokeAccess => 'एक्सेस हटाएँ';

  @override
  String get doctorAccessRevoked => 'डॉक्टर एक्सेस सफलतापूर्वक हटाया गया।';

  @override
  String get doctorAccessGranted => 'डॉक्टर एक्सेस सफलतापूर्वक दिया गया।';

  @override
  String get updateAccessPermissionsError =>
      'अभी एक्सेस परमिशन अपडेट नहीं हो सकी।';

  @override
  String get liveConsultationRoom => 'लाइव परामर्श कक्ष';

  @override
  String channelLabel(Object channelId) {
    return 'चैनल: $channelId';
  }

  @override
  String get recording => 'रिकॉर्डिंग';

  @override
  String liveDuration(Object duration) {
    return 'लाइव अवधि: $duration';
  }

  @override
  String get viewHistory => 'इतिहास देखें';

  @override
  String get addRecord => 'रिकॉर्ड जोड़ें';

  @override
  String get mute => 'म्यूट';

  @override
  String get unmute => 'अनम्यूट';

  @override
  String get camera => 'कैमरा';

  @override
  String get turnCameraOn => 'कैमरा चालू करें';

  @override
  String get rearCamera => 'रियर कैमरा';

  @override
  String get frontCamera => 'फ्रंट कैमरा';

  @override
  String get end => 'समाप्त करें';

  @override
  String get you => 'आप';

  @override
  String get remoteParticipant => 'दूसरा प्रतिभागी';

  @override
  String get cameraOff => 'कैमरा बंद';

  @override
  String get localCamera => 'लोकल कैमरा';

  @override
  String get waitingSecondPerson => 'दूसरे व्यक्ति के जुड़ने की प्रतीक्षा है';

  @override
  String get connectedLive => 'लाइव जुड़ा हुआ';

  @override
  String get diagnosis => 'निदान';

  @override
  String get prescription => 'प्रिस्क्रिप्शन';

  @override
  String get saveNotes => 'नोट्स सहेजें';

  @override
  String get consultationNotesSaved => 'परामर्श नोट्स सहेजे गए।';

  @override
  String get saveNotesError => 'अभी परामर्श नोट्स सहेज नहीं सके।';

  @override
  String get patientHistoryUnavailable => 'रोगी का इतिहास अभी उपलब्ध नहीं है।';

  @override
  String get noMedicalHistoryFound => 'अभी तक कोई मेडिकल हिस्ट्री नहीं मिली।';

  @override
  String get onlyDoctorsCanAddRecords => 'केवल डॉक्टर रिकॉर्ड जोड़ सकते हैं।';

  @override
  String get patientDetailsUnavailable => 'रोगी विवरण अभी उपलब्ध नहीं हैं।';

  @override
  String get medicalRecordSaved => 'मेडिकल रिकॉर्ड सफलतापूर्वक सहेजा गया।';

  @override
  String get cameraMicAccessRequired => 'कैमरा और माइक एक्सेस आवश्यक है';

  @override
  String get openSettings => 'सेटिंग्स खोलें';

  @override
  String get readyToJoinConsultationRoom =>
      'परामर्श कक्ष में जुड़ने के लिए तैयार।';

  @override
  String get agoraNotConfigured =>
      'Agora अभी कॉन्फ़िगर नहीं है। लाइव परामर्श में जुड़ने से पहले AGORA_APP_ID और यदि आवश्यक हो तो AGORA_TEMP_TOKEN जोड़ें।';

  @override
  String get preparingSecureVideoConsultation =>
      'सुरक्षित वीडियो परामर्श तैयार किया जा रहा है...';

  @override
  String get youAreLiveInRoom => 'आप परामर्श कक्ष में लाइव हैं।';

  @override
  String get doctorPatientConnected => 'डॉक्टर और रोगी अब जुड़ चुके हैं।';

  @override
  String get otherParticipantLeft =>
      'दूसरा प्रतिभागी कक्ष छोड़ गया। जुड़े रहें या परामर्श समाप्त करें।';

  @override
  String get connectingSecureConsultation =>
      'सुरक्षित परामर्श जोड़ा जा रहा है...';

  @override
  String get connectionDroppedReconnect =>
      'कनेक्शन टूट गया। परामर्श को फिर से जोड़ने की कोशिश हो रही है...';

  @override
  String get consultationConnectionFailedTokenless =>
      'परामर्श कनेक्शन असफल हुआ। इसका मतलब आमतौर पर Agora प्रोजेक्ट को टोकन चाहिए। परीक्षण के लिए App Certificate बंद करें या AGORA_TEMP_TOKEN दें।';

  @override
  String get consultationConnectionFailedRetry =>
      'परामर्श कनेक्शन असफल हुआ। कृपया फिर से कमरे में जुड़ें।';

  @override
  String get joinCancelledUntilPermissions =>
      'परमिशन मिलने तक जुड़ना रद्द किया गया।';

  @override
  String get joinCancelledUntilEnabled =>
      'परमिशन चालू होने तक जुड़ना रद्द किया गया।';

  @override
  String get joiningConsultationRoom => 'परामर्श कक्ष में जुड़ रहा है...';

  @override
  String get liveVideoSetupWaiting =>
      'लाइव वीडियो सेटअप Agora प्रमाणीकरण की प्रतीक्षा कर रहा है।';

  @override
  String get unableToJoinConsultationRoom => 'परामर्श कक्ष में जुड़ नहीं सके।';

  @override
  String get consultationEnded => 'परामर्श समाप्त हुआ।';

  @override
  String get cameraMicPermissionsRequired =>
      'परामर्श में जुड़ने से पहले कैमरा और माइक्रोफ़ोन परमिशन आवश्यक हैं।';

  @override
  String get cameraMicPermanentlyDenied =>
      'कैमरा और माइक्रोफ़ोन एक्सेस स्थायी रूप से अस्वीकृत है। जारी रखने के लिए सेटिंग्स खोलें।';

  @override
  String get healsyncNeedsPermissions =>
      'लाइव परामर्श शुरू होने से पहले HealSync को कैमरा और माइक्रोफ़ोन परमिशन चाहिए।';

  @override
  String get agoraRejectingTokenless =>
      'यह Agora प्रोजेक्ट बिना टोकन के एक्सेस अस्वीकार कर रहा है। परीक्षण के लिए Agora Console में App Certificate बंद करें या मान्य AGORA_TEMP_TOKEN दें।';

  @override
  String get agoraTokenMissingExpired =>
      'आपका Agora टोकन गुम है या समाप्त हो गया है। नया टोकन बनाकर फिर से कोशिश करें।';

  @override
  String get networkUnstable =>
      'नेटवर्क अस्थिर होने के कारण वीडियो सत्र कनेक्ट नहीं हो सका। कृपया फिर से कोशिश करें।';

  @override
  String get unableStartLiveConsultation =>
      'अभी लाइव परामर्श शुरू नहीं हो सका। कृपया अपना Agora सेटअप जाँचें और फिर से कोशिश करें।';

  @override
  String get recordingFailed => 'रिकॉर्डिंग असफल रही';

  @override
  String get readyForPreview => 'प्रीव्यू के लिए तैयार';

  @override
  String get cameraIsOff => 'कैमरा बंद है';

  @override
  String get waitingForOtherParticipant => 'दूसरे प्रतिभागी की प्रतीक्षा है';

  @override
  String get agoraSetupRequired => 'Agora सेटअप आवश्यक';

  @override
  String get agoraSetupRequiredBody =>
      'आपका प्रोजेक्ट बिना टोकन वाले एक्सेस को अस्वीकार कर रहा है। परीक्षण के लिए Agora Console में App Certificate बंद करें या इस चैनल के लिए AGORA_TEMP_TOKEN बनाकर ऐप फिर चलाएँ।';

  @override
  String get noFileAttached => 'कोई फ़ाइल संलग्न नहीं है';

  @override
  String get pdfFileAttached => 'PDF फ़ाइल संलग्न है';

  @override
  String get fileAttached => 'फ़ाइल संलग्न है';

  @override
  String dateLabel(Object date) {
    return 'दिनांक: $date';
  }

  @override
  String prescriptionLabel(Object value) {
    return 'प्रिस्क्रिप्शन: $value';
  }

  @override
  String get addRecordTitle => 'रिकॉर्ड जोड़ें';

  @override
  String patientLabel(Object name) {
    return 'रोगी: $name';
  }

  @override
  String get condition => 'स्थिति';

  @override
  String get uploadFileOptional => 'फ़ाइल अपलोड करें (वैकल्पिक)';

  @override
  String get saveRecord => 'रिकॉर्ड सहेजें';

  @override
  String get saving => 'सहेजा जा रहा है...';

  @override
  String get conditionPrescriptionRequired =>
      'स्थिति और प्रिस्क्रिप्शन आवश्यक हैं।';
}
