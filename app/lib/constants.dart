import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

const URL = 'http://10.0.2.2/fit_home/APIs';

const assetImages = 'assets/images/';

const kbackgroundColor = Color(0xffEEF1F6);
const kprimaryColor = Color(0xff568A9F);

const Color offWhite = Color(0XFFFFFFFF);
const Color darkBlue = Color(0XFF0DA55A);
const Color errorColors = Color.fromARGB(255, 255, 0, 0);
const Color lightblue = Color(0XFFCCAE2A);

SizedBox imageLogo() {
  return SizedBox(
    height: 200,
    width: double.infinity,
    child: Image.asset(
      "${assetImages}Logo.jpg",
      fit: BoxFit.contain,
    ),
  );
}

InputDecoration decoration(
    {required String labelText, required String hintText, required Icon icon}) {
  return InputDecoration(
    // labelText: labelText,
    label: Text(
      labelText,
      style: const TextStyle(color: Colors.blue, fontSize: 20),
    ),
    hintText: hintText,
    hintStyle: const TextStyle(fontSize: 20, color: Colors.blue),
    errorMaxLines: 3,
    floatingLabelBehavior: FloatingLabelBehavior.always,
    suffixIcon: icon,
    contentPadding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(100.0),
      borderSide: const BorderSide(color: Colors.blue),
    ),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(100.0),
      borderSide: const BorderSide(color: Colors.blue),
    ),
    errorBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(100.0),
      borderSide: const BorderSide(color: Colors.red, width: 2.0),
    ),
    focusedErrorBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(100.0),
      borderSide: const BorderSide(color: Colors.red, width: 2.0),
    ),
  );
}

Container button({required String text, required VoidCallback press}) {
  return Container(
    width: double.infinity,
    height: 50,
    padding: const EdgeInsets.only(left: 20, right: 20),
    margin: const EdgeInsets.only(top: 10),
    child: TextButton(
      onPressed: press,
      style: ButtonStyle(
        shape: MaterialStateProperty.all<RoundedRectangleBorder>(
            RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(5.0),
                side: const BorderSide(color: Colors.blue))),
      ),
      child: Text(
        text,
        style: const TextStyle(fontSize: 20, color: Colors.blue),
      ),
    ),
  );
}

Row divider() {
  return Row(children: [
    Expanded(
      child: Container(
          margin: const EdgeInsets.only(left: 20.0, right: 20.0),
          child: const Divider(
            color: darkBlue,
            thickness: 2,
          )),
    ),
    const Text("OR"),
    Expanded(
      child: Container(
          margin: const EdgeInsets.only(left: 20.0, right: 20.0),
          child: const Divider(
            color: darkBlue,
            thickness: 2,
          )),
    ),
  ]);
}

Padding phoneInput(TextEditingController phoneCont) {
  return Padding(
      padding: const EdgeInsets.only(left: 20, right: 20, top: 20),
      child: TextFormField(
          keyboardType: TextInputType.number,
          inputFormatters: [
            FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
          ],
          controller: phoneCont,
          validator: (phone) {
            if (phone!.isEmpty) {
              return 'Phone field required';
            } else if (phone.length > 10 || phone.length < 10) {
              return "Phone Number Must Be 10 Digits Only";
            }
            return null;
          },
          decoration: decoration(
              labelText: 'Phone Number',
              hintText: 'Phone Number',
              icon: const Icon(Icons.phone, color: Colors.blue))));
}

Padding emailInput(TextEditingController emailCont) {
  return Padding(
      padding: const EdgeInsets.only(left: 20, right: 20, top: 20),
      child: TextFormField(
          keyboardType: TextInputType.text,
          controller: emailCont,
          validator: (email) {
            if (email!.isEmpty) {
              return 'Please fill';
            }
            return null;
          },
          decoration: decoration(
              labelText: 'Email',
              hintText: 'Email',
              icon: const Icon(Icons.email, color: Colors.blue))));
}

Padding nameInput(TextEditingController nameCont) {
  return Padding(
      padding: const EdgeInsets.only(left: 20, right: 20, top: 20),
      child: TextFormField(
          keyboardType: TextInputType.text,
          controller: nameCont,
          inputFormatters: [
            FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z\s]'))
          ],
          validator: (name) {
            if (name!.isEmpty) {
              return 'Please fill';
            }
            return null;
          },
          decoration: decoration(
              labelText: 'Full Name',
              hintText: 'Full Name',
              icon: const Icon(Icons.person, color: Colors.blue))));
}

Padding userNameInput(userNameCont) {
  return Padding(
      padding: const EdgeInsets.only(left: 20, right: 20, top: 20),
      child: TextFormField(
          keyboardType: TextInputType.text,
          controller: userNameCont,
          validator: (userName) {
            if (userName!.isEmpty) {
              return 'Username field required';
            }
            return null;
          },
          decoration: decoration(
              labelText: 'User Name',
              hintText: 'User Name',
              icon: const Icon(Icons.book, color: Colors.blue))));
}

Padding passwordInput(TextEditingController passCont, bool isUpdateAccount) {
  return Padding(
      padding: const EdgeInsets.only(left: 20, right: 20, top: 20),
      child: TextFormField(
          keyboardType: TextInputType.text,
          obscureText: true,
          controller: passCont,
          validator: (pass) {
            RegExp regex = RegExp(
                r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{8,}$');

            if (isUpdateAccount) {
              if (pass!.isNotEmpty) {
                if (!regex.hasMatch(pass)) {
                  return ("Password should contain upper,lower,digit and Special character ");
                }
              }
            } else {
              if (pass!.isEmpty) {
                return 'Please fill';
              } else if (!regex.hasMatch(pass)) {
                return ("Password should contain upper,lower,digit and Special character ");
              }
            }
            return null;
          },
          decoration: decoration(
              labelText: 'Password',
              hintText: 'Password',
              icon: const Icon(Icons.lock, color: Colors.blue))));
}

String convertDate(String date) {
  DateTime dateTime = DateTime.parse(date);
  String convertedDateTimeString =
      '${dateTime.year}-${dateTime.month}-${dateTime.day}';

  return convertedDateTimeString;
}

String convertTimeTo12System(String time) {
  String convertedTime = convertTo12HourFormat(time);
  return convertedTime;
}

String convertTo12HourFormat(String timeString) {
  List<String> parts = timeString.split(':');
  int hour = int.parse(parts[0]);
  int minute = int.parse(parts[1]);

  String period = (hour < 12) ? 'AM' : 'PM';
  hour = (hour > 12) ? hour - 12 : hour;
  hour = (hour == 0) ? 12 : hour;

  return '$hour:${_addLeadingZero(minute)} $period';
}

String _addLeadingZero(int number) {
  return number.toString().padLeft(2, '0');
}
