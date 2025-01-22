import 'package:intl/intl.dart';
import '../library.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final _messageController = TextEditingController();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  User? user;
  ScrollController scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    user = _auth.currentUser;
  }

  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }

  void scrollToBottom() {
    scrollController.animateTo(
      scrollController.position.maxScrollExtent,
      duration: Duration(milliseconds: 300),
      curve: Curves.easeOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    double dh = MediaQuery.of(context).size.height;
    double dw = MediaQuery.of(context).size.width;
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
              child: Scaffold(
                  appBar: AppBar(
                    leading: IconButton(
                      icon: Icon(
                        Icons.arrow_circle_left_outlined,
                        color: whiteColor,
                        size: dh * 0.04,
                      ),
                      onPressed: () {
                        Get.back();
                      },
                    ),
                    title: Padding(
                      padding: const EdgeInsets.only(top: 0.0),
                      child: Row(
                        children: [
                          // Container(
                          //   width: dw * 0.1,
                          //   height: dh * 0.05,
                          //   decoration: BoxDecoration(
                          //     border: Border.all(
                          //       color: whiteColor,
                          //       width: 3.0,
                          //     ),
                          //     boxShadow: [
                          //       BoxShadow(
                          //         color: green,
                          //         spreadRadius: 2,
                          //         blurRadius: 3,
                          //         offset: Offset(0, 0),
                          //       ),
                          //     ],
                          //     shape: BoxShape.circle,
                          //   ),
                          //   child: ClipOval(
                          //     child: Image.asset(
                          //       'assets/app_logo/isai_janan.jpg',
                          //       width: dw * 0.22,
                          //       height: dh * 0.1,
                          //       fit: BoxFit.cover,
                          //     ),
                          //   ),
                          // ),
                          SizedBox(width: dw * 0.04),
                          Text(
                            '🎵✨',
                            style: Theme.of(context)
                                .textTheme
                                .titleLarge!
                                .copyWith(fontSize: dh * 0.03),
                          ),
                        ],
                      ),
                    ),
                    backgroundColor: blackColor,
                    actions: [
                      IconButton(
                        icon: Icon(Icons.call, color: whiteColor),
                        onPressed: () {
                          Get.toNamed("voice_call");
                        },
                      ),
                      IconButton(
                        icon: Icon(Icons.videocam, color: whiteColor),
                        onPressed: () {
                          Get.toNamed("video_call");
                        },
                      ),
                      IconButton(
                        icon: Icon(Icons.more_vert, color: whiteColor),
                        onPressed: () => _showMenu(context),
                      ),
                    ],
                  ),
                  body: GestureDetector(
                    onTap: () {
                      FocusScope.of(context).unfocus();
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        color: blackColor,
                        image: DecorationImage(
                          opacity: 0.5,
                          filterQuality: FilterQuality.high,
                          image: AssetImage('assets/app_logo/empty.jpg'),
                          fit: BoxFit.cover,
                        ),
                      ),
                      child: Column(
                        children: [
                          SizedBox(height: dh * 0.02),
                          Expanded(
                            child: StreamBuilder<QuerySnapshot>(
                              stream: _getMessages(),
                              builder: (context, snapshot) {
                                if (!snapshot.hasData) {
                                  return Center(
                                      child: CircularProgressIndicator());
                                }

                                WidgetsBinding.instance
                                    .addPostFrameCallback((_) {
                                  scrollToBottom();
                                });

                                final messages = snapshot.data!.docs;
                                return ListView.builder(
                                  itemCount: messages.length,
                                  controller: scrollController,
                                  itemBuilder: (context, index) {
                                    final message = messages[index];
                                    Timestamp lastOpenedTimestamp =
                                        message['timestamp'] ?? Timestamp.now();
                                    final timeStamp = DateFormat(
                                            'MMM dd, yyyy hh:mm a')
                                        .format(lastOpenedTimestamp.toDate());
                                    final bool isSentByCurrentUser =
                                        message['sender'] ==
                                            commonController.userName.value;

                                    return Align(
                                      alignment: isSentByCurrentUser
                                          ? Alignment.centerRight
                                          : Alignment.centerLeft,
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 5.0, horizontal: 10.0),
                                        child: Container(
                                          padding: EdgeInsets.all(12.0),
                                          decoration: BoxDecoration(
                                            color: isSentByCurrentUser
                                                ? blackColor
                                                : blackColor,
                                            borderRadius:
                                                BorderRadius.circular(12.0),
                                            boxShadow: [
                                              BoxShadow(
                                                color: Colors.black26,
                                                blurRadius: 6.0,
                                                offset: Offset(2, 2),
                                              ),
                                            ],
                                          ),
                                          child: Column(
                                            crossAxisAlignment:
                                                isSentByCurrentUser
                                                    ? CrossAxisAlignment.end
                                                    : CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                message['sender'] == "Janan"
                                                    ? "Janan ✨"
                                                    : "Isai 🎵",
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .labelSmall,
                                              ),
                                              SizedBox(height: 4.0),
                                              Text(
                                                message['message'],
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .labelLarge,
                                              ),
                                              Text(
                                                "$timeStamp 🕒",
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .labelSmall,
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    );
                                  },
                                );
                              },
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                              children: [
                                Expanded(
                                  child: TextField(
                                    controller: _messageController,
                                    style:
                                        Theme.of(context).textTheme.titleMedium,
                                    textCapitalization:
                                        TextCapitalization.sentences,
                                    decoration: InputDecoration(
                                      contentPadding: EdgeInsets.symmetric(
                                          vertical: 0, horizontal: dw * 0.01),
                                      hintText: 'Type a message',
                                      hintStyle: TextStyle(color: whiteColor),
                                      focusedBorder: OutlineInputBorder(
                                        borderRadius:
                                            BorderRadius.circular(30.0),
                                        borderSide:
                                            BorderSide(color: whiteColor),
                                      ),
                                      border: OutlineInputBorder(
                                        borderRadius:
                                            BorderRadius.circular(30.0),
                                        borderSide:
                                            BorderSide(color: whiteColor),
                                      ),
                                      enabledBorder: OutlineInputBorder(
                                        borderRadius:
                                            BorderRadius.circular(30.0),
                                        borderSide:
                                            BorderSide(color: whiteColor),
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(width: 8.0),
                                Container(
                                  decoration: BoxDecoration(
                                    color: green,
                                    shape: BoxShape.circle,
                                  ),
                                  child: Center(
                                    child: IconButton(
                                      icon: Icon(Icons.send,
                                          color: Colors.white, size: dh * 0.03),
                                      onPressed: () {
                                        FocusScope.of(context).unfocus();
                                        _sendMessage(
                                            commonController.userName.value);
                                      },
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  )));
        });
  }

  void _showMenu(BuildContext context) async {
    final RenderBox overlay =
        Overlay.of(context).context.findRenderObject() as RenderBox;
    final RenderBox button = context.findRenderObject() as RenderBox;
    final position = button.localToGlobal(Offset.zero, ancestor: overlay);
    final size = button.size;

    await showMenu(
      context: context,
      menuPadding: EdgeInsets.zero,
      position: RelativeRect.fromLTRB(position.dx + size.width, position.dy,
          position.dx + size.width, position.dy + size.height),
      items: [
        PopupMenuItem(
          value: 'edit',
          // padding: EdgeInsets.zero,
          child: Text(
            "Edit Chat",
            style: Theme.of(context).textTheme.labelLarge,
          ),
        ),
        PopupMenuItem(
          value: 'viewProfile',
          // padding: EdgeInsets.zero,
          child: Text(
            "View Profile",
            style: Theme.of(context).textTheme.labelLarge,
          ),
        ),
        PopupMenuItem(
          value: 'clear',
          // padding: EdgeInsets.zero,
          child: Text(
            "Clear Chat",
            style: Theme.of(context).textTheme.labelLarge,
          ),
        ),
      ],
      elevation: 3.0,
      color: charcoal,
    ).then((value) {
      if (value != null) {
        switch (value) {
          case 'edit':
            print('Edit Chat');
            break;
          case 'viewProfile':
            print('View Profile');
            break;
          case 'clear':
            _clearChat();
            break;
        }
      }
    });
  }

  Future<void> _sendMessage(String senderName) async {
    if (_messageController.text.isNotEmpty) {
      String message = _messageController.text;
      _messageController.clear();
      await _firestore.collection('chats').add({
        'message': message,
        'sender': senderName,
        'timestamp': FieldValue.serverTimestamp(),
      });
    }
  }

  Stream<QuerySnapshot> _getMessages() {
    return _firestore.collection('chats').orderBy('timestamp').snapshots();
  }

  Future<void> _clearChat() async {
    try {
      QuerySnapshot querySnapshot = await _firestore.collection('chats').get();
      for (var doc in querySnapshot.docs) {
        await _firestore.collection('chats').doc(doc.id).delete();
      }
    } catch (e) {
      print('Error clearing chat: $e');
    }
  }
}
