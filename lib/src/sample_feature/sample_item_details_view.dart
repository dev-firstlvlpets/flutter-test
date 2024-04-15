import 'dart:io';
import 'dart:math';

import 'package:firstlvlpets/src/activity_tracking/activity_tracking.dart';
import 'package:firstlvlpets/src/blog/blog.dart';
import 'package:firstlvlpets/src/dashboard/dashboard.dart';
import 'package:firstlvlpets/src/registration/registration.dart';
import 'package:firstlvlpets/src/repository/pet_provider.dart';
import 'package:firstlvlpets/src/shared/file_system_util.dart';
import 'package:firstlvlpets/src/shared/models/image_picker_selection.dart';
import 'package:firstlvlpets/src/video/video_screen.dart';
import 'package:firstlvlpets/src/welcome/welcome_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:sentry_flutter/sentry_flutter.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

/// Displays detailed information about a SampleItem.
class SampleItemDetailsView extends StatelessWidget {
  SampleItemDetailsView({super.key});

  final _supabase = Supabase.instance.client;
  final ImagePicker picker = ImagePicker();
  static const routeName = '/sample_item';

  @override
  Widget build(BuildContext context) {
    //INFO: Consumer2 for two providers etc...
    return Consumer<PetProvider>(
      builder: (context, petProvider, child) => Scaffold(
        appBar: AppBar(
          title: const Text('Item Details'),
        ),
        body: Center(
          child: Column(
            children: [
              const Text('More Information Here'),
              ElevatedButton(
                  onPressed: () => onLogin(),
                  child: const Text('Register+Login')),
              ElevatedButton(
                  onPressed: () => onImageSelection(context, petProvider),
                  child: const Text('Access gallery/camera + Upload')),
              ElevatedButton(
                  onPressed: () {
                    Navigator.restorablePushNamed(
                        context, WelcomeScreen.routeName);
                  },
                  child: const Text('Welcome Screen')),
              ElevatedButton(
                  onPressed: () {
                    Navigator.restorablePushNamed(
                        context, Registration.routeName);
                  },
                  child: const Text('Registration')),
              ElevatedButton(
                  onPressed: () {
                    Navigator.restorablePushNamed(context, Dashboard.routeName);
                  },
                  child: const Text('Dashboard')),
              ElevatedButton(
                  onPressed: () {
                    Navigator.restorablePushNamed(context, Blog.routeName);
                  },
                  child: const Text('Blog')),
              ElevatedButton(
                  onPressed: () {
                    Navigator.restorablePushNamed(
                        context, VideoScreen.routeName);
                  },
                  child: const Text('Watch Video')),
              ElevatedButton(
                  onPressed: () {
                    Navigator.restorablePushNamed(
                        context, ActivityTracking.routeName);
                  },
                  child: const Text('Activity Tracking')),
              ElevatedButton(
                  onPressed: () {
                    throw Exception('Some error');
                  },
                  child: const Text('Throw error'))
            ],
          ),
        ),
      ),
    );
  }

  Future<void> onLogin() async {
    final response = await _supabase.auth.signUp(
        email: 'fantasy@abc.de', password: '_passwordController.toString()');
    await _supabase.auth.signOut();
    final r1 = await _supabase.auth.signInWithPassword(
        email: 'fantasy@abc.de', password: '_passwordController.toString()');
  }

  Future<void> onImageSelection(
      BuildContext context, PetProvider petProvider) async {
    await petProvider.fetchPets();
    //https://api.flutter.dev/flutter/material/SimpleDialog-class.html
    var result = await showDialog<ImagePickerSelection>(
        context: context,
        builder: (context) => SimpleDialog(
              title: const Text('Select image source'),
              children: <Widget>[
                SimpleDialogOption(
                  onPressed: () {
                    Navigator.pop(context, ImagePickerSelection.gallery);
                  },
                  child: const Text('Gallery'),
                ),
                SimpleDialogOption(
                  onPressed: () {
                    Navigator.pop(context, ImagePickerSelection.camera);
                  },
                  child: const Text('Camera'),
                ),
              ],
            ));

    XFile? imageFile;
    if (result == ImagePickerSelection.gallery) {
      imageFile = await picker.pickImage(source: ImageSource.gallery);
    } else {
      imageFile = await picker.pickImage(source: ImageSource.camera);
    }

    if (imageFile != null) {
      var filePath = FileSystemUtil.instance.imageAppDataDir!.absolute.path +
          Platform.pathSeparator +
          imageFile.name;
      await imageFile.saveTo(filePath);
      var myDir =
          Directory(FileSystemUtil.instance.imageAppDataDir!.absolute.path);
      await myDir.list().forEach((element) {
        var file = File(element.path);
        print(
            'Path:${file.path}, file size: ${file.lengthSync()} bytes / ${file.lengthSync() / 1024} KB');
      });

      var compressedFilePath =
          '${FileSystemUtil.instance.imageAppDataDir!.absolute.path}${Platform.pathSeparator}compressed.jpg';
      var compressedImage = await FlutterImageCompress.compressAndGetFile(
          filePath, compressedFilePath,
          minWidth: 800, minHeight: 600, quality: 70);

      final supabase = Supabase.instance.client;
      final files = await supabase.storage.from('PetImages').list(
          path: 'public', searchOptions: SearchOptions(search: imageFile.name));
      if (files.isEmpty) {
        await supabase.storage
            .from('PetImages')
            .upload('public/' + imageFile.name, File(compressedImage!.path));
      }

      final downloadedImg = await supabase.storage
          .from('PetImages')
          .download('public/' + imageFile.name);

      File file = await File(
              '${FileSystemUtil.instance.imageAppDataDir!.absolute.path}${Platform.pathSeparator}downloaded_' +
                  imageFile.name)
          .create();
      file.writeAsBytesSync(downloadedImg);

      await myDir.list().forEach((element) {
        var file = File(element.path);
        print(
            'Path:${file.path}, file size: ${file.lengthSync()} bytes / ${file.lengthSync() / 1024} KB');
      });
    }
  }
}
