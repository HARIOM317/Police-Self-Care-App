import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

Widget boxArea(BuildContext context, String title, area) {
  print("url : $title");
  return Container(
    width: MediaQuery.of(context).size.width * area,
    height: 100,
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(8.0),
      color: Colors.grey[300],
    ),
    child: Center(
      child: ClipRRect(
        borderRadius: BorderRadius.circular(8.0),
        child: Image.network(
          title,
          fit: BoxFit.fill,
        ),
      ),
    ),
  );
}

void nextScreen(context, page) {
  Navigator.push(context, MaterialPageRoute(builder: (context) => page));
}

void nextScreenReplace(context, page) {
  Navigator.pushReplacement(
      context, MaterialPageRoute(builder: (context) => page));
}

Widget header(BuildContext context) {
  return Scaffold(
    appBar: AppBar(
      iconTheme: const IconThemeData(
        color: Colors.white,
      ),
      elevation: 0,
      backgroundColor: Theme.of(context).colorScheme.primary,
      title: const Text(
        'MP Police Seva',
        style: TextStyle(
          color: Colors.white,
          fontSize: 24,
        ),
      ),
      actions: [
        IconButton(
          onPressed: () {},
          icon: const Icon(
            Icons.notifications,
            color: Colors.white,
          ),
        ),
      ],
    ),
  );
}

String verify =
    '''<svg xmlns="http://www.w3.org/2000/svg" width="32" height="32" viewBox="0 0 24 24"><path fill="currentColor" fill-rule="evenodd" d="M15.418 5.643a1.25 1.25 0 0 0-1.34-.555l-1.798.413a1.25 1.25 0 0 1-.56 0l-1.798-.413a1.25 1.25 0 0 0-1.34.555l-.98 1.564c-.1.16-.235.295-.395.396l-1.564.98a1.25 1.25 0 0 0-.555 1.338l.413 1.8a1.25 1.25 0 0 1 0 .559l-.413 1.799a1.25 1.25 0 0 0 .555 1.339l1.564.98c.16.1.295.235.396.395l.98 1.564c.282.451.82.674 1.339.555l1.798-.413a1.25 1.25 0 0 1 .56 0l1.799.413a1.25 1.25 0 0 0 1.339-.555l.98-1.564c.1-.16.235-.295.395-.395l1.565-.98a1.25 1.25 0 0 0 .554-1.34L18.5 12.28a1.25 1.25 0 0 1 0-.56l.413-1.799a1.25 1.25 0 0 0-.554-1.339l-1.565-.98a1.25 1.25 0 0 1-.395-.395zm-.503 4.127a.5.5 0 0 0-.86-.509l-2.615 4.426l-1.579-1.512a.5.5 0 1 0-.691.722l2.034 1.949a.5.5 0 0 0 .776-.107z" clip-rule="evenodd"/></svg>''';

void openAnimatedDialog(BuildContext context) {
  showGeneralDialog(
    barrierDismissible: true,
    barrierLabel: "",
    transitionDuration: const Duration(milliseconds: 400),
    context: context,
    pageBuilder: (context, animation, secondaryAnimation) {
      return Container();
    },
    transitionBuilder: (context, a1, a2, widget) {
      return ScaleTransition(
        scale: Tween<double>(begin: 0, end: 1).animate(a1),
        child: FadeTransition(
          opacity: Tween<double>(begin: 0, end: 1).animate(a1),
          child: AlertDialog(
            icon: SvgPicture.string(
              verify,
              height: 150,
              width: 150,
            ),
            title: const Text(
              "Verified",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
          ),
        ),
      );
    },
  );
}

class UserSingleton {
  static final UserSingleton _singleton = UserSingleton._internal();

  factory UserSingleton() {
    return _singleton;
  }

  UserSingleton._internal() : userId = '';

  String userId;
  bool isHindi = false;
  ValueNotifier<bool> languageNotifier = ValueNotifier(false);

  void setUserId(String id) {
    userId = id;
  }

  String getUserId() {
    return userId;
  }

  void toggleLanguage() {
    isHindi = !isHindi;
    languageNotifier.value = isHindi; // Notify listeners
  }

  // Add this getter
  static UserSingleton get instance => _singleton;
}
