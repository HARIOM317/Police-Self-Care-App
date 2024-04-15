import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'dart:convert';
import 'dart:io';

import 'package:intl/intl.dart';
import 'package:mp_police/utils/constants.dart';
import 'package:mp_police/widget/widget.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:path/path.dart' as path;

class ChatPage extends StatefulWidget {
  const ChatPage({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _ChatPageState createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final TextEditingController _textController = TextEditingController();
  final List<Map<String, dynamic>> _messages = [];

  // bool isAllMessagesFetched = false;
  final List<String> _messagesTimestamps = [];
  DateFormat dateFormat = DateFormat.jm();

  int userId = -1;
  String userName = '';
  String userImg = '';

  bool _isUploading = false;

  // to get current user id
  Future<void> getUserID() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      userId = prefs.getInt('userId') ?? -1;
      userName = prefs.getString('adminName') ?? '';
      userImg = prefs.getString('userImg') ?? '';
    });
  }

  // to fetch all messages
  Future<void> fetchMessages() async {
    try {
      final String url = dotenv.env['GET_ALL_MESSAGES_API']!;

      final request = http.Request('OPTIONS', Uri.parse(url));
      request.headers['Content-Type'] = 'application/json';

      final streamedResponse = await http.Client().send(request);
      final response = await http.Response.fromStream(streamedResponse);

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = jsonDecode(response.body);
        final List<dynamic> messages = data['newmessage'];
        setState(() {
          _messages.addAll(messages.reversed.map((message) {
            return {
              'id': message['id'],
              'message': message['message'].toString(),
              'send_by': message['send_by'],
              'created_on': message['created_on'].toString(),
              'messager_name': message['messager_name'].toString(),
              'messager_img': message['messager_img'],
              'images': message['images'].toString()
            };
          }).toList());
        });
      } else {
        if (kDebugMode) {
          print('Failed to fetch messages: ${response.body}');
        }
      }
    } catch (error) {
      if (kDebugMode) {
        print('Error fetching messages: $error');
      }
    }
  }

  // to send message
  Future<void> sendMessage(String message, int userId, String userName) async {
    try {
      final String url = dotenv.env['CREATE_NEW_MSG_WITHOUT_IMAGE_API']!;

      final request = http.Request('OPTIONS', Uri.parse(url))
        ..headers['Content-Type'] = 'application/json'
        ..body = jsonEncode({
          'message': message,
          'send_by': userId,
          'images': '',
          'messager_name': userName,
          'messager_img': userImg,
          'created_on': DateFormat('hh:mm a').format(DateTime.now()).toString()
        });

      final streamedResponse = await http.Client().send(request);
      final response = await http.Response.fromStream(streamedResponse);

      if (response.statusCode == 200) {
        // Message sent successfully
        if (kDebugMode) {
          print('Message sent successfully');
        }
      } else {
        // Failed to send message
        if (kDebugMode) {
          print('Failed to send message: ${response.body}');
        }
      }
    } catch (error) {
      if (kDebugMode) {
        print('Error sending message: $error');
      }
    }
  }

  // send chat image
  Future<void> sendChatImage(
      int userId, String userName, File? file, String extension) async {
    try {
      if (kDebugMode) {
        print('Trying to send image...');
      }
      // final ext = file.path.split('.').last;
      String? base64Image;
      if (file != null) {
        final List<int> imageBytes = await file.readAsBytes();
        base64Image = base64Encode(imageBytes);
        if (kDebugMode) {
          print("Base 64 Image =  $base64Image");
        }
      }

      final String url = dotenv.env['CREATE_NEW_MSG_WITH_IMAGE_API']!;

      final request = http.Request('OPTIONS', Uri.parse(url))
        ..headers['Content-Type'] = 'application/json'
        ..body = jsonEncode({
          'message': '',
          'send_by': userId,
          'images': base64Image,
          'messager_name': userName,
          'messager_img': userImg,
          'image_ext': extension,
          'created_on': DateFormat('hh:mm a').format(DateTime.now()).toString()
        });

      final streamedResponse = await http.Client().send(request);
      final response = await http.Response.fromStream(streamedResponse);

      if (response.statusCode == 200) {
        // Image sent successfully
        if (kDebugMode) {
          print('Image sent successfully');
          setState(() {
            fetchMessages();
          });
        }
      } else {
        // Failed to send image
        if (kDebugMode) {
          print('Failed to send image: ${response.body}');
        }
      }
    } catch (error) {
      if (kDebugMode) {
        print('Error sending image: $error');
      }
    }
  }

  // for user's message
  Widget _buildSendMessage(Map<String, dynamic> message) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Padding(
                padding: const EdgeInsets.only(right: 6.0),
                child: Text(
                  "You",
                  style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: primaryColor),
                ),
              ),
              userImg == ''
                  ? CircleAvatar(
                      backgroundColor: primaryColor,
                      radius: 14,
                      child: const Icon(
                        CupertinoIcons.person_fill,
                        size: 20,
                        color: Colors.white,
                      ),
                    )
                  : CircleAvatar(
                      backgroundColor: primaryColor,
                      radius: 14,
                      backgroundImage: NetworkImage(userImg),
                    )
            ],
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // message time
            Row(
              children: [
                // for adding some space
                const SizedBox(
                  width: 12,
                ),

                // double tick icon for message read/unread
                const Icon(
                  Icons.done_all_rounded,
                  color: Colors.grey,
                  size: 20,
                ),

                // for adding some space
                const SizedBox(
                  width: 5,
                ),

                // sent time
                Text(
                  message['created_on'],
                  style: const TextStyle(fontSize: 12, color: Colors.black54),
                ),
              ],
            ),

            // message content
            Flexible(
              child: Container(
                  padding: EdgeInsets.symmetric(
                      horizontal: (message['message'] == '' ||
                                  message['message'] == 'null' ||
                                  message['message'] == null) &&
                              (message['images'] != '' ||
                                  message['images'] != null)
                          ? 3.3
                          : 15.0,
                      vertical: (message['message'] == '' || message['message'] == 'null' || message['message'] == null) &&
                              (message['images'] != '' ||
                                  message['images'] != null)
                          ? 10.0
                          : 5.0),
                  margin: const EdgeInsets.only(
                      left: 12, right: 38, top: 0, bottom: 4),
                  decoration: const BoxDecoration(
                      color: Color(0xff455323),
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(25),
                          bottomRight: Radius.circular(25),
                          bottomLeft: Radius.circular(25))),
                  child: (message['message'] == '' || message['message'] == null ||  message['message'] == 'null') &&
                          (message['images'] != '' || message['images'] != null)
                      ? ClipRRect(
                          borderRadius: BorderRadius.circular(23),
                          child: CachedNetworkImage(
                            fit: BoxFit.cover,
                            imageUrl: message['images'].toString(),
                            placeholder: (context, url) => const Padding(
                              padding: EdgeInsets.all(8.0),
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                              ),
                            ),
                            errorWidget: (context, url, error) => const Icon(
                              Icons.image,
                              size: 70,
                            ),
                          ),
                        )
                      : Text(
                          message['message'].toString(),
                          style: const TextStyle(
                              fontSize: 16, color: Colors.white),
                        )),
            ),
          ],
        ),
      ],
    );
  }

  // for other's message
  Widget _buildReceiveMessage(Map<String, dynamic> message) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              message['messager_img'] == "" || message['messager_img'] == null
                  ? const CircleAvatar(
                      backgroundColor: Color(0xff5b5b5b),
                      radius: 14,
                      child: Icon(
                        CupertinoIcons.person_fill,
                        size: 20,
                        color: Colors.white,
                      ),
                    )
                  : CircleAvatar(
                      backgroundColor: const Color(0xff5b5b5b),
                      radius: 14,
                      backgroundImage:
                          NetworkImage(message['messager_img'] ?? ""),
                    ),
              Padding(
                padding: const EdgeInsets.only(left: 6.0),
                child: Text(
                  message['messager_name'] ?? "",
                  style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: Color(0xff5b5b5b)),
                ),
              ),
            ],
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // message content
            Flexible(
              child: Container(
                  padding: EdgeInsets.symmetric(
                      horizontal: (message['message'] == 'null' ||
                                  message['message'] == null ||
                                  message['message'] == '') &&
                              (message['images'] != 'null' ||
                                  message['images'] != null ||
                                  message['images'] != '')
                          ? 3.3
                          : 15.0,
                      vertical: (message['message'] == 'null' ||
                                  message['message'] == null ||
                                  message['message'] == '') &&
                              (message['images'] != 'null' ||
                                  message['images'] != '' ||
                                  message['images'] != null)
                          ? 10.0
                          : 5.0),
                  margin: const EdgeInsets.only(
                      left: 38, right: 12, top: 0, bottom: 4),
                  decoration: const BoxDecoration(
                      color: Color(0xff353535),
                      borderRadius: BorderRadius.only(
                          topRight: Radius.circular(25),
                          bottomLeft: Radius.circular(25),
                          bottomRight: Radius.circular(25))),
                  child: (message['message'] == 'null' || message['message'] == null || message['message'] == '') && (message['images'] != 'null' || message['images'] != '' || message['images'] != null)
                      ? ClipRRect(
                          borderRadius: BorderRadius.circular(23),
                          child: CachedNetworkImage(
                            fit: BoxFit.cover,
                            imageUrl: message['images'].toString(),
                            placeholder: (context, url) => const Padding(
                              padding: EdgeInsets.all(8.0),
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                              ),
                            ),
                            errorWidget: (context, url, error) => const Icon(
                              Icons.image,
                              size: 70,
                            ),
                          ),
                        )
                      : Text(
                          message['message'].toString(),
                          style: const TextStyle(
                              fontSize: 16, color: Colors.white),
                        )),
            ),

            // message time
            Padding(
              padding: const EdgeInsets.only(right: 12.0),
              child: Text(
                message['created_on'],
                style: const TextStyle(fontSize: 12, color: Colors.black54),
              ),
            )
          ],
        ),
      ],
    );
  }

  // bottom sheet to show attach media options
  void _showBottomSheet(bool isMe, int index) {
    showModalBottomSheet(
        context: context,
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20), topRight: Radius.circular(20))),
        builder: (_) {
          return ListView(
            shrinkWrap: true,
            children: [
              Container(
                height: 4,
                margin: EdgeInsets.symmetric(
                    vertical: MediaQuery.of(context).size.height * 0.015,
                    horizontal: MediaQuery.of(context).size.width * 0.4),
                decoration: BoxDecoration(
                    color: Colors.grey, borderRadius: BorderRadius.circular(8)),
              ),
              // Copy text option
              _OptionItem(
                  icon: const Icon(Icons.copy, color: Colors.deepPurple),
                  name: "Copy Text",
                  onTap: () async {
                    try {
                      await Clipboard.setData(ClipboardData(
                              text: _messages[index]['message'].toString()))
                          .then((value) {
                        // for hiding bottom sheet
                        Navigator.pop(context);
                        showSnackbar(context, "Message Copied!");
                      });
                    } catch (e) {
                      Navigator.pop(context);
                      showSnackbar(context, "Something went wrong!");
                    }
                  }),

              if (isMe)
                Divider(
                  color: Colors.black54,
                  endIndent: MediaQuery.of(context).size.width * 0.04,
                  indent: MediaQuery.of(context).size.width * 0.04,
                ),

              Divider(
                color: Colors.black54,
                endIndent: MediaQuery.of(context).size.width * 0.04,
                indent: MediaQuery.of(context).size.width * 0.04,
              ),

              // sent time
              _OptionItem(
                  icon: const Icon(Icons.remove_red_eye,
                      color: Colors.deepPurple),
                  name: "Sent At: ${_messages[index]['created_on'].toString()}",
                  onTap: () {}),
            ],
          );
        });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    setState(() {
      fetchMessages();
      getUserID();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              reverse: true,
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                bool isMe =
                    _messages[index]['send_by'].toString() == userId.toString();
                return isMe
                    ? InkWell(
                        onLongPress: () {
                          _showBottomSheet(isMe, index);
                        },
                        child: _buildSendMessage(_messages[index]))
                    : InkWell(
                        onLongPress: () {
                          _showBottomSheet(isMe, index);
                        },
                        child: _buildReceiveMessage(_messages[index]),
                      );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 5.0, right: 5.0, bottom: 8.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Expanded(
                  child: Card(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30)),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        // message text field to type message
                        ConstrainedBox(
                          constraints: BoxConstraints(
                            minWidth: MediaQuery.of(context).size.width * 0.45,
                            maxWidth: MediaQuery.of(context).size.width * 0.55,
                            minHeight:
                                MediaQuery.of(context).size.height * 0.05,
                            maxHeight:
                                MediaQuery.of(context).size.height * 0.10,
                          ),
                          child: SingleChildScrollView(
                            scrollDirection: Axis.vertical,
                            child: TextField(
                              controller: _textController,
                              keyboardType: TextInputType.multiline,
                              maxLines:
                                  null, // it will automatically adjust input line

                              onTap: () {},

                              style: const TextStyle(
                                height: 1.25,
                              ),
                              decoration: const InputDecoration(
                                contentPadding: EdgeInsets.zero,
                                hintText: "Message",
                                hintStyle: TextStyle(color: Colors.blueGrey),
                                border: InputBorder.none,
                              ),
                            ),
                          ),
                        ),

                        // document attach button
                        IconButton(
                            alignment: Alignment.bottomRight,
                            onPressed: () {
                              showModalBottomSheet(
                                  backgroundColor: Colors.transparent,
                                  context: context,
                                  builder: (context) => bottomSheet());
                            },
                            icon: const Icon(Icons.attachment_outlined)),
                      ],
                    ),
                  ),
                ),

                // send button
                MaterialButton(
                  onPressed: () {
                    String message = _textController.text.trim();
                    if (message.isNotEmpty) {
                      setState(() {
                        _messages.insert(
                          0,
                          {
                            'message': message,
                            'send_by': userId,
                            'created_on': DateFormat('hh:mm a')
                                .format(DateTime.now()),
                          },
                        );

                        String timestamp = dateFormat.format(DateTime.now());
                        _messagesTimestamps.insert(0, timestamp);
                        _textController.clear();
                      });
                      sendMessage(message, userId, userName);
                      // Replace 'userId' with actual user ID
                    }
                    if (kDebugMode) {
                      print(UserSingleton().getUserId());
                    }
                  },
                  padding: const EdgeInsets.only(
                      top: 10, bottom: 10, left: 10, right: 5),
                  shape: const CircleBorder(),
                  minWidth: 0,
                  color: primaryColor,
                  child: const Icon(
                    Icons.send_rounded,
                    size: 28,
                    color: Colors.white,
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Bottom sheet to show attach media options
  bottomSheet() {
    return SizedBox(
      height: 170,
      width: double.infinity,
      child: Card(
        margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            // take image from camera
            attachIcon(Icons.camera_alt, "Camera", () async {
              Navigator.pop(context);
              final ImagePicker picker = ImagePicker();

              // Pick an image
              final XFile? image = await picker.pickImage(
                  source: ImageSource.camera, imageQuality: 50);

              if (image != null) {
                setState(() => _isUploading = true);
                String extension = path.extension(image.path);
                await sendChatImage(
                    userId, userName, File(image.path), extension);
                setState(() => _isUploading = false);
                Fluttertoast.showToast(msg: "Image selected successfully!");
              }
            }, Colors.pink),

            // pick image from gallery button
            attachIcon(Icons.image, "Gallery", () async {
              Navigator.pop(context);
              final ImagePicker picker = ImagePicker();

              final XFile? image = await picker.pickImage(
                  source: ImageSource.gallery, imageQuality: 50);

              if (image != null) {
                setState(() => _isUploading = true);
                String extension = path.extension(image.path);
                await sendChatImage(
                    userId, userName, File(image.path), extension);
                setState(() => _isUploading = false);
                Fluttertoast.showToast(msg: "Image selected successfully!");
              }
            }, Colors.green),
          ],
        ),
      ),
    );
  }

  attachIcon(IconData icon, String name, VoidCallback onTap, Color bgColor) {
    return InkWell(
      onTap: onTap,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: CircleAvatar(
              radius: 30,
              backgroundColor: bgColor,
              child: Icon(
                icon,
                color: Colors.white,
                size: 28,
              ),
            ),
          ),
          Text(name)
        ],
      ),
    );
  }
}

// class to show message options
class _OptionItem extends StatelessWidget {
  final Icon icon;
  final String name;
  final VoidCallback onTap;

  const _OptionItem(
      {required this.icon, required this.name, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => onTap(),
      child: Padding(
        padding: EdgeInsets.only(
            left: MediaQuery.of(context).size.width * 0.06,
            top: MediaQuery.of(context).size.height * 0.02,
            bottom: MediaQuery.of(context).size.height * 0.02),
        child: Row(
          children: [
            icon,
            Flexible(
                child: Text(
              '    $name',
              style: const TextStyle(
                  fontSize: 16, color: Color(0xff36464e), letterSpacing: 0.5),
            )),
          ],
        ),
      ),
    );
  }
}
