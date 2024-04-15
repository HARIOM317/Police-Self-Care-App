import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:mp_police/utils/custom_page_route.dart';
import 'package:url_launcher/url_launcher.dart';

Color primaryColor = const Color(0xff718639);
Color secondaryColor = const Color(0xffbdb76b);
Color bgColor = const Color(0xffffffff);

// function to add dropdown list of total admin role
Widget adminRoleDropdownList({required String? selectedRole, required Function(String? newRole) callbackFunction}){
  return Padding(
    padding: const EdgeInsets.all(10),
    child: DecoratedBox(
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(30),
          border: Border.all(width: 1.5, color: Colors.grey),
          boxShadow: const <BoxShadow>[
            BoxShadow(color: Color(0xffafafaf), blurRadius: 1)
          ]),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 6),
        child: Center(
          child: DropdownButton<String>(
              borderRadius: BorderRadius.circular(30),
              isExpanded: true,
              hint: const Text("Choose Role"),
              value: selectedRole,
              icon: const Icon(
                Icons.arrow_drop_down,
                size: 35,
              ),
              dropdownColor: Colors.white,
              underline: Container(), //empty line
              style: TextStyle(fontSize: 18, color: primaryColor),
              iconEnabledColor: primaryColor,
              items: const [
                DropdownMenuItem<String>(
                    value: "Full Access Admin", child: Text("Full Access Admin")),
                DropdownMenuItem<String>(
                    value: "Members Management", child: Text("Members Management")),
                DropdownMenuItem<String>(
                    value: "Donation Management", child: Text("Donation Management")),
                DropdownMenuItem<String>(
                    value: "Application Management", child: Text("Application Management")),
                DropdownMenuItem<String>(
                    value: "Chat Moderator", child: Text("Chat Moderator")),
              ],
              onChanged: callbackFunction
          ),
        ),
      ),
    ),
  );
}

// function to show progress indicator
Widget progressIndicator(BuildContext context) {
  return Center(
      child: CircularProgressIndicator(
          backgroundColor: primaryColor.withOpacity(0.5),
          color: primaryColor,
          strokeWidth: 4)
  );
}

// function to show snackbar
void showSnackbar(BuildContext context, String msg, {Color bgColor = Colors.green}) {
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(
        msg,
        style: const TextStyle(fontSize: 16, color: Colors.white),
      ),
      backgroundColor: bgColor,
      behavior: SnackBarBehavior.floating));
}

// function to show an alert dialog box
showAlertDialogueBox(BuildContext context, String msg) {
  showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: primaryColor,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(24)),
        ),
        shadowColor: Colors.deepPurpleAccent.withOpacity(0.5),
        titlePadding: const EdgeInsets.all(25),
        titleTextStyle: const TextStyle(
          color: Colors.white,
          fontSize: 18,
        ),
        title: Text(
          msg,
          textAlign: TextAlign.center,
        ),
      ));
}

//  function to switch page
void goTo(BuildContext context, Widget nextScreen) {
  Navigator.push(context, MaterialPageRoute(builder: (context) => nextScreen));
}

//  function to switch page with left transition
void goToByLeft(BuildContext context, Widget nextScreen) {
  Navigator.push(
      context,
      CustomPageRouteDirection(
          child: nextScreen, direction: AxisDirection.left));
}

// function to redirect on gmail for feedback
openEmail() async {
  String email = Uri.encodeComponent("policeselfcare@gmail.com");
  String subject = Uri.encodeComponent("Request for Rail Netra community feedback");
  String body = Uri.encodeComponent("Dear Rail Netra community, \n\n");
  Uri mail = Uri.parse("mailto:$email?subject=$subject&body=$body");
  if (await launchUrl(mail)) {
    //email app opened
  } else {
    Fluttertoast.showToast(msg: "Something went wrong");
  }
}

// function to write heading
Widget writeHeading(String title) {
  return SizedBox(
    width: double.infinity,
    child: Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 20.0),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: primaryColor,
        ),
        textAlign: TextAlign.start,
      ),
    ),
  );
}

// function to write sub-heading
Widget writeSubHeading(String title) {
  return SizedBox(
    width: double.infinity,
    child: Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
      child: Text(
        title,
        style: const TextStyle(
            fontSize: 18,
            color: Colors.black,
            fontWeight: FontWeight.w500),
        textAlign: TextAlign.start,
      ),
    ),
  );
}

// function to write description
Widget writeDescription(String text, {TextAlign align = TextAlign.justify}) {
  return Container(
    width: double.infinity,
    padding: const EdgeInsets.only(left: 16, right: 16, top: 8, bottom: 8),
    child: Center(
      child: Text(
        text,
        style: const TextStyle(
            fontSize: 16,
            color: Colors.black54),
        textAlign: align,
      ),
    ),
  );
}

Widget introTextDesign1(String text, {double fontSize = 20.0, TextAlign alignment = TextAlign.center}) {
  return Text(
    text,
    style: TextStyle(
        fontSize: fontSize,
        color: primaryColor
    ),
    textAlign: alignment,
  );
}

