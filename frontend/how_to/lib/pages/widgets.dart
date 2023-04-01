import 'package:flutter/material.dart';

class CustomDialog extends StatelessWidget {
  final String title;
  final Widget body;

  const CustomDialog({
    Key? key,
    required this.title,
    required this.body,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SimpleDialog(
      insetPadding: const EdgeInsets.all(10),
      titlePadding: const EdgeInsets.all(0),
      contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      title: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(title),
                IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
              ],
            ),
          ),
          Divider(
            height: 1,
            thickness: 1,
            color: Colors.grey[400],
          )
        ],
      ),
      children: [
        SingleChildScrollView(
          child: SizedBox(
            width: MediaQuery.of(context).size.width,
            child: body,
          ),
        ),
      ],
    );
  }
}

// --------------------  --------------------

Widget iconTextButton({
  required String text,
  required IconData icon,
  double width = 100,
  double iconSize = 30,
  double textSize = 16,
  required void Function() onTap,
}) {
  return InkWell(
    onTap: onTap,
    child: SizedBox(
      width: width,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: iconSize),
          const SizedBox(height: 5),
          Text(
            text,
            style: TextStyle(fontSize: textSize),
          ),
        ],
      ),
    ),
  );
}

// --------------------  --------------------

Widget primaryBtn({
  required BuildContext context,
  required String text,
  double height = 50,
  double width = double.infinity,
  bool isLoading = false,
  required void Function() onPressed,
}) {
  return SizedBox(
    width: width,
    height: height,
    child: ElevatedButton(
      style: ElevatedButton.styleFrom(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
      onPressed: onPressed,
      child: isLoading
          ? SizedBox(
              width: height * 3 / 5,
              height: height * 3 / 5,
              child: CircularProgressIndicator(
                color: Theme.of(context).colorScheme.secondary,
                strokeWidth: 3,
              ),
            )
          : Text(
              text,
              style: const TextStyle(fontSize: 16),
            ),
    ),
  );
}

// --------------------  --------------------

Widget secondaryBtn({
  required String text,
  double height = 50,
  required void Function() onPressed,
}) {
  return SizedBox(
    width: double.infinity,
    height: height,
    child: OutlinedButton(
      style: OutlinedButton.styleFrom(
        side: const BorderSide(width: 1, color: Colors.grey),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
      onPressed: onPressed,
      child: Text(
        text,
        style: const TextStyle(fontSize: 16),
      ),
    ),
  );
}

// --------------------  --------------------

Widget iconText({
  required String text,
  required IconData icon,
  double width = 100,
  double iconSize = 30,
  double textSize = 16,
  iconColor = Colors.black,
  textColor = Colors.black,
}) {
  return SizedBox(
    width: width,
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(icon, size: iconSize, color: iconColor),
        const SizedBox(height: 5),
        Text(
          text,
          style: TextStyle(fontSize: textSize, color: textColor),
        ),
      ],
    ),
  );
}

// --------------------  --------------------