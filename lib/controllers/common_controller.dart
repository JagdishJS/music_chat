import "../library.dart";
import 'package:intl/intl.dart';

class CommonController extends GetxController {
  // Define user variables
  var userName = ''.obs;
  var userEmail = ''.obs;
  var userUid = ''.obs;
  var lastSeenTime = ''.obs;
  var partnerName = ''.obs;
  var partnerEmail = ''.obs;
  var partnerLastSeen = ''.obs;
  var partnerUid = ''.obs;

  var appId = 479352876;
  var appSign =
      'f52dbbb0997b9aeaa388d0729f0722be155c1df4f3652e7457a371bde67af089';
  var callerId = "Isai_Janan";

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseMessaging _fcm = FirebaseMessaging.instance;

  @override
  void onInit() {
    super.onInit();
    loadLocalData();
  }

  loadLocalData() {
    User? user = _auth.currentUser;
    userUid.value = user?.uid ?? "";
    userName.value = user?.email == null
        ? "-"
        : user?.email == "jagadeeswaran.s3@gmail.com"
            ? "Janan"
            : "Isai";
    partnerName.value = user?.email == null
        ? "-"
        : user?.email == "jagadeeswaran.s3@gmail.com"
            ? "Isai"
            : "Janan";
    userEmail.value = user?.email ?? "";
    updateLastOpenedTime();
    fetchLastOpenedTime();
    // DateTime? lastSignInDateTime = user?.metadata.lastSignInTime;
    // lastSeenTime.value = lastSignInDateTime != null
    //     ? DateFormat("MMM, dd yyyy hh:mm a").format(lastSignInDateTime)
    //     : "No last seen time";
  }

  void updateLastOpenedTime() async {
    User? user = _auth.currentUser;
    String? token = await _fcm.getToken();
    print('token: $token');
    if (user != null) {
      DocumentSnapshot userDoc =
          await _firestore.collection('users').doc(userName.value).get();

      if (userDoc.exists) {
        await _firestore.collection('users').doc(userName.value).update({
          'lastOpened': FieldValue.serverTimestamp(),
          'fcm_token': token,
        });
      } else {
        await _firestore.collection('users').doc(userName.value).set({
          'email': user.email,
          'name': userName.value,
          'uid': user.uid,
          'fcm_token': token,
          'lastOpened': FieldValue.serverTimestamp(),
        });
      }
    }
  }

  void fetchLastOpenedTime() async {
    User? user = _auth.currentUser;
    if (user != null) {
      DocumentSnapshot userDoc =
          await _firestore.collection('users').doc(partnerName.value).get();
      if (userDoc.exists) {
        Timestamp lastOpenedTimestamp =
            userDoc['lastOpened'] ?? Timestamp.now();
        partnerLastSeen.value = DateFormat('MMM dd, yyyy hh:mm a')
            .format(lastOpenedTimestamp.toDate());
        partnerName.value = userDoc['name'];
        partnerEmail.value = userDoc['email'];
        partnerUid.value = userDoc['uid'];
      }
      update();
    }
  }

  void signOut() async {
    LocalStorageService.clearAllData();
    await _auth.signOut();
    Get.offAllNamed("splashScreen");
  }
}
