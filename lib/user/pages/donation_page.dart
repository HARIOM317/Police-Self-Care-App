import 'dart:convert';
import 'dart:io';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:mp_police/utils/constants.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserDonationPage extends StatefulWidget {
  const UserDonationPage({super.key});

  @override
  State<UserDonationPage> createState() => _UserDonationPageState();
}

class _UserDonationPageState extends State<UserDonationPage> {
  String userName = '';
  String userEmail = '';
  String userPhone = '';
  String userImg = '';

  Future<void> getUserDataFromSharedPreferences() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      userName = prefs.getString('userName') ?? '';
      userEmail = prefs.getString('userEmail') ?? '';
      userPhone = prefs.getString('userPhone') ?? '';
      userImg = prefs.getString('userImg') ?? '';
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    getUserDataFromSharedPreferences();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          ListTile(
            leading: userImg == ''
                ? CircleAvatar(
                    backgroundColor: Theme.of(context).primaryColor,
                    child: const Icon(
                      Icons.person,
                      color: Colors.white,
                    ))
                : CircleAvatar(
                    backgroundImage: NetworkImage(userImg),
                  ),
            title: SizedBox(
              height: 130,
              child: Card(
                color: Colors.white,
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 10.0, vertical: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            children: [
                              Text(userName),
                              Text(userPhone),
                            ],
                          ),
                          ElevatedButton(
                            onPressed: () {
                              setState(() {
                                goTo(context, paymentMethod());
                              });
                            },
                            style: ElevatedButton.styleFrom(
                                backgroundColor: primaryColor,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8))),
                            child: const Text(
                              "Contribute",
                              style: TextStyle(color: Colors.white),
                            ),
                          )
                        ],
                      ),
                      Text(userEmail)
                    ],
                  ),
                ),
              ),
            ),
            selected: true,
          ),
        ],
      ),
    );
  }

  Widget paymentMethod() {
    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        title: const Text("Payment Method"),
      ),
      body: SafeArea(
        child: Card(
          child: Column(
            children: [
              // To pay with UPI
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Card(
                  color: Colors.white,
                  child: GestureDetector(
                    onTap: () {
                      goTo(context, const UPIDetailsPage());
                    },
                    child: ListTile(
                      title: const Text('Payment via Bank'),
                      trailing: Container(
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(100),
                            border: Border.all(width: 1, color: primaryColor)),
                        child: CircleAvatar(
                          backgroundColor: Colors.white,
                          child: Icon(
                            Icons.account_balance,
                            color: primaryColor,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Card(
                  color: Colors.white,
                  child: GestureDetector(
                    onTap: () {},
                    child: ListTile(
                      title: const Text('Payment via UPI'),
                      trailing: Container(
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(100),
                            border: Border.all(width: 1, color: primaryColor)),
                        child: CircleAvatar(
                          backgroundColor: Colors.white,
                          child: Icon(
                            Icons.payment,
                            color: primaryColor,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class UPIDetailsPage extends StatefulWidget {
  const UPIDetailsPage({
    super.key,
  });

  @override
  // ignore: library_private_types_in_public_api
  _UPIDetailsPageState createState() => _UPIDetailsPageState();
}

class _UPIDetailsPageState extends State<UPIDetailsPage> {
  late TextEditingController _proofDocController;
  // final _upiController = TextEditingController();
  File? _proofDocument;
  File? _donationLetter;

  @override
  void initState() {
    super.initState();
    _proofDocController = TextEditingController();
  }

  @override
  void dispose() {
    _proofDocController.dispose();
    super.dispose();
  }

  Future<void> _pickDocument(String type) async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf', 'doc', 'docx'],
    );

    if (result != null) {
      setState(() {
        if (type == 'proofDoc') {
          _proofDocument = File(result.files.single.path!);
        } else {
          _donationLetter = File(result.files.single.path!);
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Documents Verification'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Center(
              child: Padding(
                padding: const EdgeInsets.all(8),
                child: Image.asset("assets/images/qr-code.png"),
              ),
            ),
            Column(
              children: [
                const Card(
                  child: ListTile(
                    title: Text("UPI ID"),
                    trailing: Icon(Icons.copy),
                  ),
                ),
                const SizedBox(height: 20),
                SizedBox(
                  height: 60,
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () async {
                      await _pickDocument('proofDoc');
                    },
                    style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30))),
                    child: const Text(
                      'Upload Screenshot',
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                if (_proofDocument != null)
                  Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 24.0),
                        child: Text(
                          _proofDocument!.path,
                          style: const TextStyle(
                              fontWeight: FontWeight.w500,
                              fontSize: 14,
                              color: Colors.black54),
                        ),
                      ),
                      const Divider(),
                      const SizedBox(height: 20),
                    ],
                  ),
              ],
            ),
            Align(
              alignment: Alignment.bottomRight,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                    shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(8))),
                    textStyle: TextStyle(color: primaryColor, fontSize: 18)),
                onPressed: () {},
                child: const Text('Payment'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class BankDetailsPage extends StatefulWidget {
  final String title;
  final String description;
  final File? proofDocument;
  final File? donationLetter;

  const BankDetailsPage({
    super.key,
    required this.title,
    required this.description,
    required this.proofDocument,
    required this.donationLetter,
  });

  @override
  // ignore: library_private_types_in_public_api
  _BankDetailsPageState createState() => _BankDetailsPageState();
}

class _BankDetailsPageState extends State<BankDetailsPage> {
  late TextEditingController _accountNumberController;
  late TextEditingController _ifscCodeController;
  late TextEditingController _bankHolderNameController;
  late TextEditingController _upiIdController;

  @override
  void initState() {
    super.initState();
    _accountNumberController = TextEditingController();
    _ifscCodeController = TextEditingController();
    _bankHolderNameController = TextEditingController();
    _upiIdController = TextEditingController();
  }

  @override
  void dispose() {
    _accountNumberController.dispose();
    _ifscCodeController.dispose();
    _bankHolderNameController.dispose();
    _upiIdController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Account Details'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: CustomScrollView(
          scrollDirection: Axis.vertical,
          slivers: [
            SliverFillRemaining(
              hasScrollBody: false,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  // Input Fields
                  Column(
                    children: [
                      _buildBankDetails(),
                      const SizedBox(height: 20),
                      _buildUpiDetails(),
                      const SizedBox(height: 20),
                    ],
                  ),

                  // Payment Button
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24.0),
                    child: SizedBox(
                      height: 50,
                      width: 280,
                      child: ElevatedButton(
                        onPressed: () {
                          _confirmDonationRequest();
                        },
                        style: ElevatedButton.styleFrom(
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30))),
                        child: const Text(
                          'Request Donation',
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.w600),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBankDetails() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const Text(
          'Bank Details',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 10),
        TextFormField(
          controller: _accountNumberController,
          decoration: InputDecoration(
              prefixIcon: const Icon(Icons.account_balance),
              labelText: "Account Number",
              focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                  borderSide: BorderSide(
                      style: BorderStyle.solid, color: primaryColor, width: 2)),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(30),
                borderSide: const BorderSide(
                    style: BorderStyle.solid,
                    color: Color(0xFF909A9E),
                    width: 1.5),
              ),
              focusedErrorBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                  borderSide: BorderSide(
                      style: BorderStyle.solid,
                      color: Theme.of(context).primaryColor,
                      width: 2)),
              errorBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                  borderSide: const BorderSide(
                      style: BorderStyle.solid,
                      color: Colors.deepOrange,
                      width: 1.5))),
        ),
        const SizedBox(height: 10),
        TextField(
          controller: _ifscCodeController,
          decoration: InputDecoration(
              prefixIcon: const Icon(Icons.password),
              labelText: "IFSC Code",
              focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                  borderSide: BorderSide(
                      style: BorderStyle.solid, color: primaryColor, width: 2)),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(30),
                borderSide: const BorderSide(
                    style: BorderStyle.solid,
                    color: Color(0xFF909A9E),
                    width: 1.5),
              ),
              focusedErrorBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                  borderSide: BorderSide(
                      style: BorderStyle.solid,
                      color: Theme.of(context).primaryColor,
                      width: 2)),
              errorBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                  borderSide: const BorderSide(
                      style: BorderStyle.solid,
                      color: Colors.deepOrange,
                      width: 1.5))),
        ),
        const SizedBox(height: 10),
        TextField(
          controller: _bankHolderNameController,
          decoration: InputDecoration(
              prefixIcon: const Icon(Icons.account_box),
              labelText: "Bank Holder Name",
              focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                  borderSide: BorderSide(
                      style: BorderStyle.solid, color: primaryColor, width: 2)),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(30),
                borderSide: const BorderSide(
                    style: BorderStyle.solid,
                    color: Color(0xFF909A9E),
                    width: 1.5),
              ),
              focusedErrorBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                  borderSide: BorderSide(
                      style: BorderStyle.solid,
                      color: Theme.of(context).primaryColor,
                      width: 2)),
              errorBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                  borderSide: const BorderSide(
                      style: BorderStyle.solid,
                      color: Colors.deepOrange,
                      width: 1.5))),
        ),
      ],
    );
  }

  Widget _buildUpiDetails() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const Text(
          'UPI Details',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 10),
        TextField(
          controller: _upiIdController,
          decoration: InputDecoration(
              prefixIcon: const Icon(Icons.payment),
              labelText: "UPI Id",
              focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                  borderSide: BorderSide(
                      style: BorderStyle.solid, color: primaryColor, width: 2)),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(30),
                borderSide: const BorderSide(
                    style: BorderStyle.solid,
                    color: Color(0xFF909A9E),
                    width: 1.5),
              ),
              focusedErrorBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                  borderSide: BorderSide(
                      style: BorderStyle.solid,
                      color: Theme.of(context).primaryColor,
                      width: 2)),
              errorBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                  borderSide: const BorderSide(
                      style: BorderStyle.solid,
                      color: Colors.deepOrange,
                      width: 1.5))),
        ),
      ],
    );
  }

  void _confirmDonationRequest() {
    AwesomeDialog(
            context: context,
            dialogType: DialogType.question,
            animType: AnimType.topSlide,
            showCloseIcon: true,
            title: "Confirm Donation Request",
            titleTextStyle: TextStyle(
                color: Colors.green[900],
                fontSize: 20,
                fontWeight: FontWeight.bold),
            desc: "Are you sure you want to request the donation?",
            descTextStyle:
                const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
            btnOkOnPress: () {
              _showSuccessDialog();
            },
            btnOkText: "Confirm",
            btnCancelOnPress: () {})
        .show();
  }

  void _showSuccessDialog() {
    AwesomeDialog(
      context: context,
      dialogType: DialogType.success,
      animType: AnimType.topSlide,
      showCloseIcon: true,
      title: "Donation Requested Successfully",
      titleTextStyle: TextStyle(
          color: Colors.green[900], fontSize: 20, fontWeight: FontWeight.bold),
      desc: "Your donation request has been successfully submitted",
      descTextStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
      btnOkOnPress: () {
        Navigator.pop(context);
        Navigator.pop(context);
      },
      btnOkText: "OK",
    ).show();
  }
}
