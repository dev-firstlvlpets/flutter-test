import 'package:firstlvlpets/src/error_handling/global_error_display.dart';
import 'package:firstlvlpets/src/error_handling/platform_error.dart';
import 'package:firstlvlpets/src/shared/navigator.dart';
import 'package:firstlvlpets/src/welcome/welcome_screen.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sentry_flutter/sentry_flutter.dart';

class GlobalErrorHandler {
  GlobalErrorHandler._();
  static final GlobalErrorHandler _instance = GlobalErrorHandler._();
  static GlobalErrorHandler get instance => _instance;

  bool _initialized = false;

  void initialize() {
    if (!_initialized) {
      FlutterError.onError = (FlutterErrorDetails details) {
        Sentry.captureException(
          details.exception,
          stackTrace: details.stack,
        );
        FlutterError.dumpErrorToConsole(details);
        runApp(GlobalErrorDisplay(
          flutterError: details,
        ));
      };
      PlatformDispatcher.instance.onError = (error, stack) {
        Sentry.captureException(
          error,
          stackTrace: stack,
        );

        if (error is PlatformException &&
            error.code == PlatformErrorCodes.videoError) {
          SystemChrome.setPreferredOrientations([
            DeviceOrientation.portraitUp,
            DeviceOrientation.portraitDown,
          ]);
          //TODO: show dialog + navigator pop
          showDialog(
              context: navigatorKey.currentContext!,
              builder: (context) => SimpleDialog(
                      title: const Text('Video error.'),
                      children: <Widget>[
                        const Padding(
                          padding: EdgeInsets.all(32.0),
                          child: Center(
                            child: Text('Some video error occured.'),
                          ),
                        ),
                        SimpleDialogOption(
                          onPressed: () {
                            //Navigator.pop(context);
                            Navigator.restorablePushNamed(
                                context, WelcomeScreen.routeName);
                          },
                          child: const Text('OK'),
                        ),
                      ]));
          return true;
        }

        runApp(GlobalErrorDisplay(
          platformError: error,
        ));
        return true;
      };

      _initialized = true;
    }
  }
}
