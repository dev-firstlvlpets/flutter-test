import 'package:firstlvlpets/src/error_handling/global_error_handler.dart';
import 'package:firstlvlpets/src/repository/pet_provider.dart';
import 'package:firstlvlpets/src/shared/file_system_util.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sentry_flutter/sentry_flutter.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'src/app.dart';
import 'src/settings/settings_controller.dart';
import 'src/settings/settings_service.dart';

Future<void> main() async {
  // Global error handling
  GlobalErrorHandler.instance.initialize();

  // Supabase initialization
  const publicAnonKey = '';
  await Supabase.initialize(
    url: '',
    anonKey: publicAnonKey,
  );

  await FileSystemUtil.initialize();

  // Set up the SettingsController, which will glue user settings to multiple
  // Flutter Widgets.
  final settingsController = SettingsController(SettingsService());

  // Load the user's preferred theme while the splash screen is displayed.
  // This prevents a sudden theme change when the app is first displayed.
  await settingsController.loadSettings();

  // Run the app and pass in the SettingsController. The app listens to the
  // SettingsController for changes, then passes it further down to the
  // SettingsView.

  //INFO: Consumer2,3,4 for multiple singleton providers.
  // Scoped providers when adding the ChangeNotifierProvider/MultiProvider directly into a widget.

  await SentryFlutter.init(
    (options) {
      options.dsn = '';
    },
    appRunner: () => runApp(MultiProvider(
      providers: [
        ChangeNotifierProvider<PetProvider>(
          create: (_) => PetProvider(),
        )
      ],
      child: MyApp(settingsController: settingsController),
    )),
  );
}
