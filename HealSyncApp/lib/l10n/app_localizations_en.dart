// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'HealSync';

  @override
  String get welcome => 'Welcome';

  @override
  String get upload => 'Upload Medical Record';

  @override
  String get language => 'Language';

  @override
  String get english => 'English';

  @override
  String get hindi => 'Hindi';

  @override
  String get tamil => 'Tamil';

  @override
  String get telugu => 'Telugu';

  @override
  String get malayalam => 'Malayalam';

  @override
  String get createCareWorkspace => 'Create your care workspace';

  @override
  String get welcomeBack => 'Welcome back';

  @override
  String get signupSubtitle =>
      'Set up your account and choose how you use HealSync.';

  @override
  String get loginSubtitle =>
      'Sign in to manage consultations, records, and verified health data.';

  @override
  String get fullName => 'Full name';

  @override
  String get email => 'Email';

  @override
  String get password => 'Password';

  @override
  String get patient => 'Patient';

  @override
  String get doctor => 'Doctor';

  @override
  String get createAccount => 'Create account';

  @override
  String get loginAction => 'Login';

  @override
  String get alreadyHaveAccount => 'Already have an account? Login';

  @override
  String get needAccount => 'Need an account? Sign up';

  @override
  String get careHeroHeadline =>
      'Care that feels connected, verified, and beautifully simple.';

  @override
  String get careHeroBody =>
      'HealSync brings telemedicine, realtime records, and a beautifully structured healthcare workspace into one calm experience.';

  @override
  String get realtimeRecords => 'Realtime Records';

  @override
  String get verifiedReports => 'Verified Reports';

  @override
  String get secureConsultations => 'Secure Consultations';

  @override
  String get logout => 'Logout';

  @override
  String get patientDashboardTitle => 'Patient Dashboard';

  @override
  String get doctorDashboardTitle => 'Doctor Dashboard';

  @override
  String welcomeBackUser(Object name) {
    return 'Welcome back, $name';
  }

  @override
  String get patientHeroSubtitle =>
      'Everything from bookings to verified medical records now lives in one serene healthcare command center.';

  @override
  String get verifiedRecordsLabel => 'Verified Records';

  @override
  String get appointmentsLabel => 'Appointments';

  @override
  String get bookAppointment => 'Book Appointment';

  @override
  String get uploadRecord => 'Upload Record';

  @override
  String get nextConsultation => 'Next Consultation';

  @override
  String consultationWithDoctor(Object doctorName) {
    return 'Consultation with $doctorName';
  }

  @override
  String get join => 'Join';

  @override
  String get trackBookingsStatuses => 'Track bookings and statuses';

  @override
  String get medicalHistory => 'Medical History';

  @override
  String get reportsVerificationAudit => 'Reports, verification, and audit';

  @override
  String get prescriptionsTitle => 'Prescriptions';

  @override
  String get doctorMedicationsNotes => 'Doctor medications and notes';

  @override
  String get healthPassport => 'Health Passport';

  @override
  String get portableVerifiedProfile => 'Your portable verified profile';

  @override
  String get recentRecords => 'Recent Records';

  @override
  String referenceCode(Object code) {
    return 'Ref: $code';
  }

  @override
  String get verified => 'Verified';

  @override
  String get notVerified => 'Not Verified';

  @override
  String get myAppointments => 'My Appointments';

  @override
  String get noAppointmentsYet => 'No appointments yet';

  @override
  String get bookConsultationPrompt =>
      'Book a consultation from the dashboard to see your visits here in real time.';

  @override
  String get confirmBooking => 'Confirm Booking';

  @override
  String get selectDoctor => 'Select doctor';

  @override
  String telemedicineSuffix(Object name) {
    return '$name - Telemedicine';
  }

  @override
  String get consultationDateTime => 'Consultation Date & Time';

  @override
  String get appointmentConfirmed => 'Appointment Confirmed';

  @override
  String get noDoctorAccountAvailable =>
      'No doctor account is available in the backend yet. Ask the doctor to sign up in HealSync first, then try booking again.';

  @override
  String get payment => 'Payment';

  @override
  String get consultationPayment => 'Consultation Payment';

  @override
  String get doctorLabel => 'Doctor';

  @override
  String get appointmentTime => 'Appointment Time';

  @override
  String get amount => 'Amount';

  @override
  String get processingPayment => 'Processing payment...';

  @override
  String get processing => 'Processing...';

  @override
  String get payNow => 'Pay Now';

  @override
  String get paymentFailedTryAgain => 'Payment Failed. Try again';

  @override
  String get paymentSuccessful => 'Payment Successful';

  @override
  String get appointmentConfirmedMessage =>
      'Your appointment has been confirmed';

  @override
  String get ok => 'OK';

  @override
  String doctorGreeting(Object name) {
    return 'Hello Dr. $name';
  }

  @override
  String get doctorHeroSubtitle =>
      'Run consultations, issue prescriptions, and validate patient reports with a calm clinical workflow.';

  @override
  String get quickActions => 'Quick Actions';

  @override
  String get patientList => 'Patient List';

  @override
  String get recordsHub => 'Records Hub';

  @override
  String get upcomingConsultations => 'Upcoming Consultations';

  @override
  String get start => 'Start';

  @override
  String get patientsLabel => 'Patients';

  @override
  String get searchByDoctorName => 'Search by doctor name';

  @override
  String get noDoctorsFound => 'No doctors found';

  @override
  String get all => 'All';

  @override
  String get cardiology => 'Cardiology';

  @override
  String get dermatology => 'Dermatology';

  @override
  String get general => 'General';

  @override
  String get pediatrics => 'Pediatrics';

  @override
  String experienceValue(Object value) {
    return 'Experience: $value';
  }

  @override
  String get records => 'Records';

  @override
  String historyTitle(Object name) {
    return '$name History';
  }

  @override
  String get grantAccess => 'Grant Access';

  @override
  String get revokeAccess => 'Revoke Access';

  @override
  String get doctorAccessRevoked => 'Doctor access revoked successfully.';

  @override
  String get doctorAccessGranted => 'Doctor access granted successfully.';

  @override
  String get updateAccessPermissionsError =>
      'We could not update access permissions right now.';

  @override
  String get liveConsultationRoom => 'Live Consultation Room';

  @override
  String channelLabel(Object channelId) {
    return 'Channel: $channelId';
  }

  @override
  String get recording => 'Recording';

  @override
  String liveDuration(Object duration) {
    return 'Live duration: $duration';
  }

  @override
  String get viewHistory => 'View History';

  @override
  String get addRecord => 'Add Record';

  @override
  String get mute => 'Mute';

  @override
  String get unmute => 'Unmute';

  @override
  String get camera => 'Camera';

  @override
  String get turnCameraOn => 'Turn Camera On';

  @override
  String get rearCamera => 'Rear Camera';

  @override
  String get frontCamera => 'Front Camera';

  @override
  String get end => 'End';

  @override
  String get you => 'You';

  @override
  String get remoteParticipant => 'Remote participant';

  @override
  String get cameraOff => 'Camera off';

  @override
  String get localCamera => 'Local camera';

  @override
  String get waitingSecondPerson => 'Waiting for the second person to join';

  @override
  String get connectedLive => 'Connected live';

  @override
  String get diagnosis => 'Diagnosis';

  @override
  String get prescription => 'Prescription';

  @override
  String get saveNotes => 'Save Notes';

  @override
  String get consultationNotesSaved => 'Consultation notes saved.';

  @override
  String get saveNotesError =>
      'We could not save the consultation notes right now.';

  @override
  String get patientHistoryUnavailable =>
      'Patient history is not available right now.';

  @override
  String get noMedicalHistoryFound => 'No medical history found yet.';

  @override
  String get onlyDoctorsCanAddRecords => 'Only doctors can add records.';

  @override
  String get patientDetailsUnavailable =>
      'Patient details not available right now.';

  @override
  String get medicalRecordSaved => 'Medical record saved successfully.';

  @override
  String get cameraMicAccessRequired => 'Camera & Mic access required';

  @override
  String get openSettings => 'Open Settings';

  @override
  String get readyToJoinConsultationRoom =>
      'Ready to join the consultation room.';

  @override
  String get agoraNotConfigured =>
      'Agora is not configured yet. Add AGORA_APP_ID and, if your Agora project uses tokens, AGORA_TEMP_TOKEN before joining a live consultation.';

  @override
  String get preparingSecureVideoConsultation =>
      'Preparing secure video consultation...';

  @override
  String get youAreLiveInRoom => 'You are live in the consultation room.';

  @override
  String get doctorPatientConnected => 'Doctor and patient are now connected.';

  @override
  String get otherParticipantLeft =>
      'The other participant left the room. Stay connected or end the consultation.';

  @override
  String get connectingSecureConsultation =>
      'Connecting secure consultation...';

  @override
  String get connectionDroppedReconnect =>
      'Connection dropped. Trying to reconnect the consultation...';

  @override
  String get consultationConnectionFailedTokenless =>
      'The consultation connection failed. This usually means the Agora project requires a token. Disable App Certificate for testing, or provide AGORA_TEMP_TOKEN.';

  @override
  String get consultationConnectionFailedRetry =>
      'The consultation connection failed. Please rejoin the room.';

  @override
  String get joinCancelledUntilPermissions =>
      'Join cancelled until permissions are granted.';

  @override
  String get joinCancelledUntilEnabled =>
      'Join cancelled until permissions are enabled.';

  @override
  String get joiningConsultationRoom => 'Joining consultation room...';

  @override
  String get liveVideoSetupWaiting =>
      'Live video setup is waiting for Agora authentication.';

  @override
  String get unableToJoinConsultationRoom =>
      'Unable to join the consultation room.';

  @override
  String get consultationEnded => 'Consultation ended.';

  @override
  String get cameraMicPermissionsRequired =>
      'Camera and microphone permissions are required before joining the consultation.';

  @override
  String get cameraMicPermanentlyDenied =>
      'Camera and microphone access is permanently denied. Open settings to continue.';

  @override
  String get healsyncNeedsPermissions =>
      'HealSync needs camera and microphone permission before the live consultation can start.';

  @override
  String get agoraRejectingTokenless =>
      'This Agora project is rejecting tokenless access. Disable App Certificate in the Agora console for testing, or provide a valid AGORA_TEMP_TOKEN.';

  @override
  String get agoraTokenMissingExpired =>
      'Your Agora token is missing or expired. Generate a fresh token and try again.';

  @override
  String get networkUnstable =>
      'The video session could not connect because the network is unstable. Please try again.';

  @override
  String get unableStartLiveConsultation =>
      'We could not start the live consultation right now. Please verify your Agora setup and try again.';

  @override
  String get recordingFailed => 'Recording failed';

  @override
  String get readyForPreview => 'Ready for preview';

  @override
  String get cameraIsOff => 'Camera is off';

  @override
  String get waitingForOtherParticipant => 'Waiting for the other participant';

  @override
  String get agoraSetupRequired => 'Agora setup required';

  @override
  String get agoraSetupRequiredBody =>
      'Your project is rejecting no-token access. Disable App Certificate in Agora Console for testing, or generate an AGORA_TEMP_TOKEN for this channel and run the app again.';

  @override
  String get noFileAttached => 'No file attached';

  @override
  String get pdfFileAttached => 'PDF file attached';

  @override
  String get fileAttached => 'File attached';

  @override
  String dateLabel(Object date) {
    return 'Date: $date';
  }

  @override
  String prescriptionLabel(Object value) {
    return 'Prescription: $value';
  }

  @override
  String get addRecordTitle => 'Add Record';

  @override
  String patientLabel(Object name) {
    return 'Patient: $name';
  }

  @override
  String get condition => 'Condition';

  @override
  String get uploadFileOptional => 'Upload File (Optional)';

  @override
  String get saveRecord => 'Save Record';

  @override
  String get saving => 'Saving...';

  @override
  String get conditionPrescriptionRequired =>
      'Condition and prescription are required.';
}
