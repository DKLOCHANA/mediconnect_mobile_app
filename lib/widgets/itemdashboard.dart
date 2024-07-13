import 'package:flutter/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';

Widget itemProfile2(String title, String subtitle, IconData iconData) {
  return Container(
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(10),
      boxShadow: [
        BoxShadow(
          offset: const Offset(0, 5),
          color: const Color.fromARGB(255, 122, 117, 209).withOpacity(.2),
          spreadRadius: 2,
          blurRadius: 10,
        ),
      ],
    ),
    child: ListTile(
      title: Text(
        title,
        style: const TextStyle(
          fontWeight: FontWeight.bold,
        ),
      ),
      subtitle: Text(
        subtitle,
        style: const TextStyle(fontWeight: FontWeight.normal),
      ),
      leading: Icon(iconData),
      tileColor: const Color.fromARGB(255, 255, 255, 255),
    ),
  );
}

Widget itemProfile3(String title, String subtitle1, String subtitle2,
    String subtitle3, IconData iconData) {
  return Container(
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(10),
      boxShadow: [
        BoxShadow(
          offset: const Offset(0, 5),
          color: const Color.fromARGB(255, 122, 117, 209).withOpacity(.2),
          spreadRadius: 2,
          blurRadius: 10,
        ),
      ],
    ),
    child: ListTile(
      title: Text(
        title,
        style: const TextStyle(
          fontWeight: FontWeight.bold,
        ),
      ),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            subtitle1,
            style: const TextStyle(fontWeight: FontWeight.normal),
          ),
          Text(
            subtitle2,
            style: const TextStyle(fontWeight: FontWeight.normal),
          ),
          Text(
            subtitle3,
            style: const TextStyle(fontWeight: FontWeight.normal),
          ),
        ],
      ),
      leading: Icon(iconData),
      tileColor: const Color.fromARGB(255, 255, 255, 255),
    ),
  );
}

Widget itemProfile4(
    String title, TextEditingController controller, IconData iconData) {
  return Container(
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(10),
      boxShadow: [
        BoxShadow(
          offset: const Offset(0, 5),
          color: const Color.fromARGB(255, 122, 117, 209).withOpacity(.2),
          spreadRadius: 2,
          blurRadius: 10,
        ),
      ],
    ),
    child: ListTile(
      title: Text(
        title,
        style: const TextStyle(
          fontWeight: FontWeight.bold,
        ),
      ),
      subtitle: Text(
        controller.text,
        style: const TextStyle(
          fontWeight: FontWeight.normal,
        ),
      ),
      leading: Icon(iconData),
      tileColor: const Color.fromARGB(255, 255, 255, 255),
    ),
  );
}
