import '../library.dart';

class CallPage extends StatelessWidget {
  const CallPage({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<CommonController>(
        init: CommonController(),
        builder: (commonController) {
          return PopScope(
              canPop: true,
              onPopInvokedWithResult: (bool didPop, Object? result) async {
                if (didPop) {
                  Get.back();
                }
                return;
              },
              child: ZegoUIKitPrebuiltCall(
                  appID: commonController.appId,
                  appSign: commonController.appSign,
                  userID: commonController.userUid.value,
                  userName: commonController.userName.value,
                  callID: commonController.callerId,
                  config: ZegoUIKitPrebuiltCallConfig.oneOnOneVoiceCall()
                    ..bottomMenuBar = ZegoCallBottomMenuBarConfig(
                        buttons: [
                          ZegoCallMenuBarButtonName.toggleMicrophoneButton,
                          ZegoCallMenuBarButtonName.chatButton,
                          ZegoCallMenuBarButtonName.hangUpButton,
                          ZegoCallMenuBarButtonName.soundEffectButton,
                          ZegoCallMenuBarButtonName.switchAudioOutputButton,
                        ],
                        hideAutomatically: false,
                        backgroundColor: blackColor,
                        style: ZegoCallMenuBarStyle.dark)));
        });
  }
}

class VideoCallPage extends StatelessWidget {
  const VideoCallPage({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<CommonController>(
        init: CommonController(),
        builder: (commonController) {
          return PopScope(
              canPop: true,
              onPopInvokedWithResult: (bool didPop, Object? result) async {
                if (didPop) {
                  Get.back();
                }
                return;
              },
              child: ZegoUIKitPrebuiltCall(
                  appID: commonController.appId,
                  appSign: commonController.appSign,
                  userID: commonController.userUid.value,
                  userName: commonController.userName.value,
                  callID: commonController.callerId,
                  config: ZegoUIKitPrebuiltCallConfig.oneOnOneVideoCall()
                    ..bottomMenuBar = ZegoCallBottomMenuBarConfig(
                        buttons: [
                          ZegoCallMenuBarButtonName.toggleCameraButton,
                          ZegoCallMenuBarButtonName.toggleMicrophoneButton,
                          ZegoCallMenuBarButtonName.hangUpButton,
                          ZegoCallMenuBarButtonName.switchCameraButton,
                          ZegoCallMenuBarButtonName.switchAudioOutputButton,
                        ],
                        hideAutomatically: false,
                        backgroundColor: blackColor,
                        style: ZegoCallMenuBarStyle.dark)));
        });
  }
}
