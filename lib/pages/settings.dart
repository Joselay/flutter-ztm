import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_ztm/providers/user_provider.dart';
import 'package:image_picker/image_picker.dart';

class Settings extends ConsumerStatefulWidget {
  const Settings({super.key});

  @override
  ConsumerState<Settings> createState() => _SettingsState();
}

class _SettingsState extends ConsumerState<Settings> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    LocalUser currentUser = ref.watch(userProvider);
    _nameController.text = currentUser.user.name;
    _emailController.text = currentUser.user.email;

    return Scaffold(
        appBar: AppBar(
          title: Container(
            margin: const EdgeInsets.only(top: 20),
            child: const Text("Settings"),
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              GestureDetector(
                onTap: () async {
                  final ImagePicker picker = ImagePicker();
                  final XFile? pickedImage = await picker.pickImage(
                    source: ImageSource.gallery,
                    requestFullMetadata: false,
                  );

                  if (pickedImage != null) {
                    ref
                        .read(userProvider.notifier)
                        .updateImage(File(pickedImage.path));
                  }
                },
                child: CircleAvatar(
                  radius: 100,
                  foregroundImage: NetworkImage(
                    currentUser.user.profilePic,
                  ),
                ),
              ),
              const SizedBox(height: 10),
              const Center(
                child: Text(
                  "Tap Image to Change",
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.black87,
                  ),
                ),
              ),
              const SizedBox(height: 16),
              TextFormField(
                decoration: const InputDecoration(
                  labelText: "Enter Your Name",
                ),
                controller: _nameController,
              ),
              const SizedBox(height: 16),
              TextButton(
                onPressed: () {
                  ref
                      .read(userProvider.notifier)
                      .updateName(_nameController.text);
                },
                child: const Text(
                  "Update",
                  style: TextStyle(
                    color: Colors.blue,
                    fontSize: 16,
                  ),
                ),
              )
            ],
          ),
        ));
  }
}
