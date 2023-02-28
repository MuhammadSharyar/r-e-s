import 'package:clipboard/clipboard.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:r_e_s/controllers/dropdown_controllers.dart';
import 'package:r_e_s/controllers/error_controller.dart';
import 'package:r_e_s/controllers/loading_controller.dart';
import 'package:r_e_s/controllers/obscure_controller.dart';

import '../theme/theme_constants.dart';

Widget addVerticalSpace(double height) {
  return SizedBox(
    height: height,
  );
}

Widget addHorizontalSpace(double width) {
  return SizedBox(
    width: width,
  );
}

Widget customTextField({
  required TextEditingController controller,
  required String labelText,
  required TextInputType textInputType,
}) {
  return TextField(
    controller: controller,
    keyboardType: textInputType,
    decoration: InputDecoration(
      border: const OutlineInputBorder(
        borderRadius: BorderRadius.all(
          Radius.circular(7),
        ),
      ),
      labelText: labelText,
    ),
  );
}

Widget customTextField2({
  required TextEditingController controller,
  required String labelText,
  required TextInputType textInputType,
  required onChanged,
}) {
  return TextField(
    controller: controller,
    onChanged: onChanged,
    keyboardType: textInputType,
    decoration: InputDecoration(
      border: const OutlineInputBorder(
        borderRadius: BorderRadius.all(
          Radius.circular(7),
        ),
      ),
      labelText: labelText,
    ),
  );
}

final obscureController = Get.put(ObscureController());

Widget passwordTextField({
  required TextEditingController controller,
  required String labelText,
  required TextInputType textInputType,
}) {
  return Obx(() {
    return TextField(
      controller: controller,
      obscureText: obscureController.obscure.value,
      keyboardType: textInputType,
      decoration: InputDecoration(
        border: const OutlineInputBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(7),
          ),
        ),
        labelText: labelText,
        suffix: GestureDetector(
          child: (obscureController.obscure.value)
              ? Icon(
                  Icons.password,
                  color: primaryColor,
                )
              : Icon(
                  Icons.text_fields,
                  color: primaryColor,
                ),
          onTap: () {
            obscureController.setObscure(!obscureController.obscure.value);
          },
        ),
      ),
    );
  });
}

Widget errorText(ErrorController controller) {
  return Align(
    alignment: Alignment.centerLeft,
    child: Text(
      controller.errorMessage.value,
      style: TextStyle(
        color: Colors.redAccent,
        fontSize: medium,
      ),
    ),
  );
}

Widget customOutlinedButton({
  required BuildContext context,
  required String text,
  required onPressed,
}) {
  return SizedBox(
    width: MediaQuery.of(context).size.width / 1.5,
    height: 55,
    child: OutlinedButton(
      onPressed: onPressed,
      child: Text(
        text,
        style: TextStyle(
          fontSize: medium,
        ),
      ),
    ),
  );
}

Widget customTextButton({
  required String text,
  required onPressed,
}) {
  return TextButton(
    onPressed: onPressed,
    child: Text(
      text,
      style: const TextStyle(decoration: TextDecoration.underline),
    ),
  );
}

Widget registerButton({
  required BuildContext context,
  required LoadingController controller,
  required onPressed,
}) {
  return SizedBox(
    width: MediaQuery.of(context).size.width,
    height: 50,
    child: ElevatedButton(
      onPressed: onPressed,
      child: (controller.loading.value == false)
          ? Text(
              "Register",
              style: TextStyle(fontSize: large),
            )
          : const CircularProgressIndicator(
              color: Colors.white,
            ),
    ),
  );
}

Widget genderDropdown({required GenderController controller}) {
  return Row(
    children: [
      Expanded(
        child: DropdownButtonHideUnderline(
          child: DropdownButton(
            value: controller.selectedGender.value,
            items: [
              ...controller.genders.map(
                (gender) => DropdownMenuItem(
                  value: gender,
                  child: Text(gender),
                ),
              ),
            ],
            onChanged: (value) {
              controller.setGender(
                value.toString(),
              );
            },
          ),
        ),
      ),
    ],
  );
}

Widget customCard({
  required String title,
  required String imagePath,
  required onPressed,
}) {
  return GestureDetector(
    onTap: onPressed,
    child: Card(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              height: 100,
              child: SvgPicture.asset(imagePath),
            ),
            const SizedBox(height: 20),
            Align(
              alignment: Alignment.bottomLeft,
              child: Text(
                title,
                style: TextStyle(fontSize: xlarge),
              ),
            )
          ],
        ),
      ),
    ),
  );
}

Widget myBottomNavigationBar({required controller, required onTap}) {
  return BottomNavigationBar(
    showSelectedLabels: false,
    showUnselectedLabels: false,
    currentIndex: controller.currentIndex.value,
    items: [
      BottomNavigationBarItem(
        icon: (controller.currentIndex.value == 0)
            ? const Icon(Icons.home)
            : const Icon(Icons.home_outlined),
        label: '',
      ),
      BottomNavigationBarItem(
        icon: (controller.currentIndex.value == 1)
            ? const Icon(Icons.person)
            : const Icon(Icons.person_outlined),
        label: '',
      ),
    ],
    onTap: onTap,
  );
}

Widget keyCard(
    {required BuildContext context,
    required String title,
    required String keyText}) {
  return Card(
    child: SizedBox(
      width: MediaQuery.of(context).size.width,
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: large,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                IconButton(
                    onPressed: () {
                      FlutterClipboard.copy(keyText).then((value) {
                        Get.snackbar(
                          "",
                          "Copied!",
                          duration: const Duration(seconds: 1),
                        );
                      });
                    },
                    icon: const Icon(Icons.copy)),
              ],
            ),
            addVerticalSpace(1),
            Text(
              keyText,
              style: TextStyle(fontSize: medium),
            ),
          ],
        ),
      ),
    ),
  );
}

Widget userCard({
  required BuildContext context,
  required controller,
  required String name,
  required String email,
  required onPressed,
  required onDelete,
}) {
  return GestureDetector(
    onTap: onPressed,
    child: Card(
      child: ListTile(
        leading: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              width: MediaQuery.of(context).size.width / 2.5,
              child: Text(
                name,
                style: TextStyle(
                  fontSize: large,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ),
            Text(
              email,
              style: TextStyle(
                fontSize: medium,
              ),
            ),
          ],
        ),
        trailing: SizedBox(
          width: MediaQuery.of(context).size.width / 2.5,
          child: Row(mainAxisAlignment: MainAxisAlignment.end, children: [
            GestureDetector(
              onTap: onDelete,
              child: (controller.loading.value)
                  ? CircularProgressIndicator(
                      color: primaryColor,
                    )
                  : const Icon(
                      Icons.delete,
                      color: Colors.redAccent,
                    ),
            ),
          ]),
        ),
      ),
    ),
  );
}

Widget addButton({
  required BuildContext context,
  required onPressed,
}) {
  return SizedBox(
    width: MediaQuery.of(context).size.width,
    height: 50,
    child: ElevatedButton(
      onPressed: onPressed,
      child: GetX<LoadingController>(builder: (controller) {
        return (controller.loading.value)
            ? const CircularProgressIndicator(
                color: Color(0xfff6f6f6),
              )
            : Text(
                "Add",
                style: TextStyle(fontSize: medium),
              );
      }),
    ),
  );
}

Widget customCheckBox({
  required String title,
  required bool value,
  required onChange,
}) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: [
      Text(
        title,
        style: TextStyle(fontSize: medium),
      ),
      Checkbox(
        value: value,
        onChanged: onChange,
      ),
    ],
  );
}

Widget deleteAlert({
  required BuildContext context,
  required String content,
  required onConfirm,
}) {
  return AlertDialog(
    content: Text(content),
    actions: [
      ElevatedButton(
        onPressed: () {
          Navigator.pop(context);
        },
        child: const Text("No"),
      ),
      OutlinedButton(
        onPressed: onConfirm,
        child: const Text("Yes"),
      ),
    ],
  );
}

Widget deleteButton({
  required onPressed,
}) {
  return GestureDetector(
    onTap: onPressed,
    child: GetX<LoadingController>(builder: (controller) {
      return (controller.loading.value)
          ? CircularProgressIndicator(
              color: primaryColor,
            )
          : const Icon(
              Icons.delete,
              color: Colors.redAccent,
            );
    }),
  );
}

Widget questionCard({
  required int item,
  required List list,
  required onPressed,
}) {
  return GestureDetector(
    onTap: onPressed,
    child: Card(
      child: ListTile(
        title: Text(list[0][item]['question']),
      ),
    ),
  );
}

Widget customButton1({
  required BuildContext context,
  required String title,
  required onPressed,
}) {
  return GetX<LoadingController>(builder: (controller) {
    return SizedBox(
      height: 55,
      width: MediaQuery.of(context).size.width,
      child: ElevatedButton(
        onPressed: onPressed,
        child: (controller.loading.value)
            ? const CircularProgressIndicator()
            : Text(
                title,
                style: TextStyle(fontSize: medium),
              ),
      ),
    );
  });
}

Widget examTypeButton({
  required BuildContext context,
  required String title,
  required onPressed,
}) {
  return SizedBox(
    width: MediaQuery.of(context).size.width / 1.5,
    height: 55,
    child: OutlinedButton(
      onPressed: onPressed,
      child: Text(
        title,
        style: TextStyle(
          fontSize: medium,
        ),
      ),
    ),
  );
}

Widget curriculumCard({
  required String title,
  required onPressed,
}) {
  return GestureDetector(
    onTap: onPressed,
    child: Card(
      child: ListTile(
        title: Text(title),
      ),
    ),
  );
}

Widget questionButton({
  required BuildContext context,
  required String title,
  required onPressed,
}) {
  return SizedBox(
    width: MediaQuery.of(context).size.width,
    height: 45,
    child: ElevatedButton(
      onPressed: onPressed,
      child: Text(
        title,
        style: TextStyle(fontSize: xlarge),
      ),
    ),
  );
}
