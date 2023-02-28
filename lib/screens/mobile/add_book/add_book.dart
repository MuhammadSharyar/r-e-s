import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cool_alert/cool_alert.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:r_e_s/controllers/book_download_controller.dart';
import 'package:r_e_s/controllers/school_email_controller.dart';
import '../../../controllers/file_name_controller.dart';
import '../../../controllers/get_data_controllers.dart';
import '../../../controllers/loading_controller.dart';
import '../../../utils/helper_widgets.dart';

class AddBook extends StatelessWidget {
  AddBook({Key? key}) : super(key: key);

  final fileNameController = TextEditingController();
  FilePickerResult? pickResult;

  final getBooksController = Get.put(GetBooksController());
  final bookDownloadController = Get.put(BookDownloadController());
  final filenameController = Get.put(FilenameController());
  final loadingController = Get.put(LoadingController());
  String schoolEmail = Get.find<SchoolEmailController>().schoolEmail.value;

  Future downloadBook({required context, required bookname}) async {
    final bookRef =
        FirebaseStorage.instance.ref().child("Books/$schoolEmail/$bookname");
    final filePath = "/storage/emulated/0/Download/$bookname.pdf";
    final file = File(filePath);
    final downloadTask = bookRef.writeToFile(file);
    downloadTask.snapshotEvents.listen((taskSnapshot) {
      switch (taskSnapshot.state) {
        case TaskState.running:
          bookDownloadController.setLoading(true);
          break;
        case TaskState.paused:
          bookDownloadController.setLoading(false);
          break;
        case TaskState.success:
          bookDownloadController.setLoading(false);
          CoolAlert.show(
            context: context,
            type: CoolAlertType.success,
            title: "Downloaded Successfully!",
            text: "Your book is in your downloads folder",
          );
          break;
        case TaskState.error:
          bookDownloadController.setLoading(false);
          CoolAlert.show(
            context: context,
            type: CoolAlertType.error,
            title: "Downloaded Failed",
            text: "Please try again later",
          );
          break;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    getBooksController.getBooks();
    return Scaffold(
      appBar: AppBar(title: const Text("Books")),
      body: GetX<GetBooksController>(builder: (controller) {
        if (controller.books.isNotEmpty) {
          return Stack(children: [
            ListView.builder(
              itemCount: controller.books.length,
              itemBuilder: (context, index) {
                return Card(
                  child: Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: Row(
                      children: [
                        Text(controller.books[index]['name']),
                        Expanded(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              GestureDetector(
                                onTap: () async {
                                  if (await Permission.storage.isDenied ||
                                      await Permission.storage.isLimited) {
                                    await Permission.storage.request();
                                    if (await Permission.storage.isGranted) {
                                      await downloadBook(
                                        context: context,
                                        bookname: controller.books[index]
                                            ['name'],
                                      );
                                    }
                                  } else {
                                    await downloadBook(
                                      context: context,
                                      bookname: controller.books[index]['name'],
                                    );
                                  }
                                },
                                child: const Icon(
                                  Icons.download,
                                  color: Colors.blueAccent,
                                ),
                              ),
                              const SizedBox(width: 10),
                              GestureDetector(
                                onTap: () async {
                                  showDialog(
                                      context: context,
                                      builder: (context) {
                                        return deleteAlert(
                                          context: context,
                                          content:
                                              "Are you sure you want to delete ${controller.books[index]['name']}",
                                          onConfirm: () async {
                                            await FirebaseStorage.instance
                                                .ref()
                                                .child(
                                                    "Books/$schoolEmail/${controller.books[index]['name']}")
                                                .delete();
                                            await FirebaseFirestore.instance
                                                .collection("Schools")
                                                .doc(schoolEmail)
                                                .collection("Books")
                                                .doc(controller.books[index]
                                                    ['name'])
                                                .delete();
                                            Get.snackbar(
                                              "",
                                              "",
                                              messageText: Text(
                                                  "${controller.books[index]['name']} deleted successfully"),
                                            );
                                            getBooksController.getBooks();
                                          },
                                        );
                                      });
                                },
                                child: const Icon(
                                  Icons.delete,
                                  color: Colors.redAccent,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
            GetX<BookDownloadController>(builder: (controller) {
              if (controller.showLoading.value) {
                return Container(
                  height: MediaQuery.of(context).size.height,
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                      backgroundBlendMode: BlendMode.darken,
                      color: Colors.grey[300]),
                  child: const Center(
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 30.0),
                      child: LinearProgressIndicator(minHeight: 7),
                    ),
                  ),
                );
              } else {
                return Container();
              }
            })
          ]);
        } else {
          return const Center(
            child: CircularProgressIndicator(
              color: Color(0xfff6f6f6),
            ),
          );
        }
      }),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          if (filenameController.filename.value != "") {
            filenameController.setFilename("");
          }
          showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                title: const Text("Add Book"),
                content: SizedBox(
                  height: MediaQuery.of(context).size.height / 3,
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        customTextField(
                          controller: fileNameController,
                          labelText: "File Name",
                          textInputType: TextInputType.text,
                        ),
                        addVerticalSpace(10),
                        customButton1(
                          context: context,
                          title: "Pick File",
                          onPressed: () async {
                            pickResult = await FilePicker.platform.pickFiles();
                            filenameController
                                .setFilename(pickResult!.files.single.name);
                          },
                        ),
                        GetX<FilenameController>(
                          builder: ((controller) {
                            if (controller.filename.value != "") {
                              return Text(
                                controller.filename.value,
                                overflow: TextOverflow.ellipsis,
                              );
                            } else {
                              return Container();
                            }
                          }),
                        ),
                        addVerticalSpace(10),
                        addButton(
                          context: context,
                          onPressed: () async {
                            if (loadingController.loading.value == false) {
                              if (fileNameController.text == "") {
                                Get.snackbar(
                                  "",
                                  "",
                                  messageText:
                                      const Text("Please write a file name"),
                                );
                              } else if (pickResult == null) {
                                Get.snackbar(
                                  "",
                                  "",
                                  messageText: const Text("Please pick a file"),
                                );
                              } else {
                                loadingController.setLoading(true);
                                var downloadLink = "";
                                await FirebaseStorage.instance
                                    .ref()
                                    .child(
                                        "Books/$schoolEmail/${fileNameController.text.trim()}")
                                    .putFile(
                                      File(
                                        pickResult!.files.single.path
                                            .toString(),
                                      ),
                                    )
                                    .whenComplete(() async {
                                  await FirebaseStorage.instance
                                      .ref()
                                      .child(
                                          "Books/$schoolEmail/${fileNameController.text.trim()}")
                                      .getDownloadURL()
                                      .then((value) => downloadLink = value);
                                });
                                await FirebaseFirestore.instance
                                    .collection("Schools")
                                    .doc(schoolEmail)
                                    .collection("Books")
                                    .doc(fileNameController.text.trim())
                                    .set({
                                  "name": fileNameController.text.trim(),
                                  "downloadLink": downloadLink,
                                });
                                Get.snackbar(
                                  "",
                                  "",
                                  messageText:
                                      const Text("File uploaded successfully"),
                                );
                                loadingController.setLoading(false);
                                Navigator.pop(context);
                                filenameController.setFilename("");
                                getBooksController.getBooks();
                              }
                            }
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          );
        },
        label: const Text("Add Book"),
      ),
    );
  }
}
