import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mp_police/admin/pages/required_widgets/admin_user_previouswork.dart';
import 'package:mp_police/widget/widget.dart';

class AdminHomePage extends StatefulWidget {
  const AdminHomePage({Key? key}) : super(key: key);

  @override
  State<AdminHomePage> createState() => _AdminHomePageState();
}

class _AdminHomePageState extends State<AdminHomePage> {
  int _currentIndex = 0;
  int index = 0;
  bool isHindi = true;
  bool isEditModeOn = false;

  // Variable to change Slider Image
  String? sliderImage;
  bool isSliderImgSelect = false;
  late File sliderFile;

  // Variable to change Work Option Image 1
  String? workOption1Image;
  bool isWorkOption1Select = false;
  late File workOption1File;

  // Variable to change Work Option Image 2
  String? workOption2Image;
  bool isWorkOption2Select = false;
  late File workOption2File;

  // Variable to change File Image 1
  String? file1Image;
  bool file1Select = false;
  late File image1File;

  // Variable to change File Image 2
  String? file2Image;
  bool file2Select = false;
  late File image2File;

  // Variable to change File Image 3
  String? file3Image;
  bool file3Select = false;
  late File image3File;

  // Variable to change File Image 4
  String? file4Image;
  bool file4Select = false;
  late File image4File;

  void changeLanguage() {
    setState(() {
      isHindi = !isHindi;
    });
  }

  final List<String> textList = [
    'Latest Information 1',
    'Latest Information 2',
    'Latest Information 3',
    'Latest Information 4',
  ];
  void viewAllPreviousWork() {
    // Navigate to previous work page
    // Example:
    Navigator.push(context,
        MaterialPageRoute(builder: (context) => const AdminUserPreviousWork()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Align(
              alignment: Alignment.topRight,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: ElevatedButton(
                    onPressed: () {
                      setState(() {
                        isEditModeOn = !isEditModeOn;
                      });
                    },
                    child:
                        isEditModeOn ? const Text("Save") : const Text("Edit")),
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Text(
                  isHindi ? "NOTICE" : "अनुस्मारक ",
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                      fontSize: 20, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            const SizedBox(
              height: 20,
            ),
            CustomCard(
                isEditable: isEditModeOn), // Pass isEditable flag to CustomCard
            const SizedBox(
              height: 20,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  isHindi ? "Previous Work" : "पिछला कार्य विकल्प",
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 20,
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 20,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Stack(
                  children: [
                    // Work Option Image 1
                    workOption1Image == null
                        ? Card(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Container(
                                height: 90.0,
                                width: 150.0,
                                decoration: BoxDecoration(
                                  color: Colors.grey[300],
                                  border: Border.all(
                                      width: 1.0, color: Colors.black45),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: ClipRRect(
                                    borderRadius: BorderRadius.circular(7.0),
                                    child: Image.asset(
                                      "assets/images/latest.png",
                                      fit: BoxFit.cover,
                                    ))),
                          )
                        : Card(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Container(
                              height: 90.0,
                              width: 150.0,
                              decoration: BoxDecoration(
                                color: Colors.grey[300],
                                border: Border.all(
                                    width: 1.0, color: Colors.black45),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(7.0),
                                child: Image.file(
                                  workOption1File,
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                          ),
                    // Edit button for Work Option Image 1
                    isEditModeOn
                        ? Positioned(
                            right: 8,
                            bottom: 8,
                            child: GestureDetector(
                              onTap: () async {
                                isWorkOption1Select = true;
                                final XFile? pickImage = await ImagePicker()
                                    .pickImage(
                                        source: ImageSource.gallery,
                                        imageQuality: 100);

                                if (pickImage != null) {
                                  setState(() {
                                    workOption1Image = pickImage.path;
                                    workOption1File = File(workOption1Image!);
                                  });
                                }
                              },
                              child: SizedBox(
                                width: 30,
                                height: 30,
                                child: CircleAvatar(
                                  backgroundColor:
                                      Theme.of(context).primaryColor,
                                  child: const Icon(
                                    Icons.edit,
                                    color: Colors.white,
                                    size: 18,
                                  ),
                                ),
                              ),
                            ))
                        : const SizedBox(
                            width: 0,
                          )
                  ],
                ),
                Stack(
                  children: [
                    // Work Option Image 2
                    workOption1Image == null
                        ? Card(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Container(
                                height: 90.0,
                                width: 150.0,
                                decoration: BoxDecoration(
                                  color: Colors.grey[300],
                                  border: Border.all(
                                      width: 1.0, color: Colors.black45),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: ClipRRect(
                                    borderRadius: BorderRadius.circular(7.0),
                                    child: Image.asset(
                                      "assets/images/latest.png",
                                      fit: BoxFit.cover,
                                    ))),
                          )
                        : Card(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Container(
                              height: 90.0,
                              width: 150.0,
                              decoration: BoxDecoration(
                                color: Colors.grey[300],
                                border: Border.all(
                                    width: 1.0, color: Colors.black45),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(7.0),
                                child: Image.file(
                                  workOption2File,
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                          ),

                    // Edit button for Work Option Image 2
                    isEditModeOn
                        ? Positioned(
                            right: 8,
                            bottom: 8,
                            child: GestureDetector(
                              onTap: () async {
                                isWorkOption2Select = true;
                                final XFile? pickImage = await ImagePicker()
                                    .pickImage(
                                        source: ImageSource.gallery,
                                        imageQuality: 100);

                                if (pickImage != null) {
                                  setState(() {
                                    workOption2Image = pickImage.path;
                                    workOption2File = File(workOption2Image!);
                                  });
                                }
                              },
                              child: SizedBox(
                                width: 30,
                                height: 30,
                                child: CircleAvatar(
                                  backgroundColor:
                                      Theme.of(context).primaryColor,
                                  child: const Icon(
                                    Icons.edit,
                                    color: Colors.white,
                                    size: 18,
                                  ),
                                ),
                              ),
                            ))
                        : const SizedBox(
                            width: 0,
                          )
                  ],
                ),
                // BoxArea(context, "assets/images/latest.png", 0.45),
              ],
            ),
            const SizedBox(
              height: 5,
            ),
            GestureDetector(
              onTap: viewAllPreviousWork,
              child: Container(
                padding:
                    const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                decoration: BoxDecoration(
                  color: Colors.blue,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.blue.withOpacity(0.3),
                      spreadRadius: 1,
                      blurRadius: 3,
                      offset: const Offset(0, 2), // changes position of shadow
                    ),
                  ],
                ),
                child: ValueListenableBuilder<bool>(
                    valueListenable: UserSingleton().languageNotifier,
                    builder: (context, isHindi, child) {
                      return Text(
                        UserSingleton().isHindi ? "सभी देखें" : "View All",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          decoration: TextDecoration.none,
                        ),
                      );
                    }),
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                // BoxArea(context, "assets/images/file.png", 0.35),
                Stack(
                  children: [
                    // File Image 1
                    file1Image == null
                        ? Card(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Container(
                                height: 180.0,
                                width: 350.0,
                                decoration: BoxDecoration(
                                  color: Colors.grey[300],
                                  border: Border.all(
                                      width: 1.0, color: Colors.black45),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: ClipRRect(
                                    borderRadius: BorderRadius.circular(7.0),
                                    child: Image.asset(
                                      "assets/images/latest.png",
                                      fit: BoxFit.cover,
                                    ))),
                          )
                        : Card(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Container(
                              height: 100.0,
                              width: 130.0,
                              decoration: BoxDecoration(
                                color: Colors.grey[300],
                                border: Border.all(
                                    width: 1.0, color: Colors.black45),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(7.0),
                                child: Image.file(
                                  image1File,
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                          ),
                    // Edit button for File Image 1
                    isEditModeOn
                        ? Positioned(
                            right: 8,
                            bottom: 8,
                            child: GestureDetector(
                              onTap: () async {
                                file1Select = true;
                                final XFile? pickImage = await ImagePicker()
                                    .pickImage(
                                        source: ImageSource.gallery,
                                        imageQuality: 100);

                                if (pickImage != null) {
                                  setState(() {
                                    file1Image = pickImage.path;
                                    image1File = File(file1Image!);
                                  });
                                }
                              },
                              child: SizedBox(
                                width: 30,
                                height: 30,
                                child: CircleAvatar(
                                  backgroundColor:
                                      Theme.of(context).primaryColor,
                                  child: const Icon(
                                    Icons.edit,
                                    color: Colors.white,
                                    size: 18,
                                  ),
                                ),
                              ),
                            ))
                        : const SizedBox(
                            width: 0,
                          )
                  ],
                ),
              ],
            ),
            const SizedBox(
              height: 20,
            ),
            IconButton(
              onPressed: () {
                // Handle Telegram icon tap
              },
              icon: Icon(Icons.telegram, color: Colors.blue, size: 40),
              color: Colors.blue,
              iconSize: 40,
            ),
            const SizedBox(
              height: 20,
            ),
          ],
        ),
      ),
    );
  }
}

class CustomCard extends StatefulWidget {
  final bool isEditable;

  const CustomCard({Key? key, required this.isEditable}) : super(key: key);

  @override
  _CustomCardState createState() => _CustomCardState();
}

class _CustomCardState extends State<CustomCard> {
  late TextEditingController _point1Controller;
  late TextEditingController _point2Controller;
  late TextEditingController _point3Controller;

  @override
  void initState() {
    super.initState();
    _point1Controller = TextEditingController();
    _point2Controller = TextEditingController();
    _point3Controller = TextEditingController();
  }

  @override
  void dispose() {
    _point1Controller.dispose();
    _point2Controller.dispose();
    _point3Controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 350,
      height: 170,
      child: Card(
        color: Colors.green.shade50,
        elevation: 4, // Adjust elevation as needed
        shadowColor: Colors.green, // Shadow color
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8.0),
        ),
        child: Padding(
          padding: EdgeInsets.all(12),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Points:',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                SizedBox(height: 8),
                _buildPoint('Point 1', _point1Controller),
                _buildPoint('Point 2', _point2Controller),
                _buildPoint('Point 3', _point3Controller),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildPoint(String pointText, TextEditingController controller) {
    return Row(
      children: [
        Icon(
          Icons.circle,
          size: 10,
          color: Colors.blue, // Customize point color
        ),
        SizedBox(width: 8),
        Expanded(
          child: widget.isEditable
              ? TextFormField(
                  controller: controller,
                  decoration: InputDecoration(
                    hintText: pointText,
                    border: InputBorder.none,
                  ),
                )
              : Text(
                  pointText,
                  style: TextStyle(fontSize: 14),
                ),
        ),
      ],
    );
  }
}
