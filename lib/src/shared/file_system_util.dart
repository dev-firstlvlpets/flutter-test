import 'dart:io';

import 'package:path_provider/path_provider.dart';

class FileSystemUtil {
  FileSystemUtil._();
  static final FileSystemUtil _instance = FileSystemUtil._();

  bool _initialized = false;
  Directory? _appDocumentsDir;
  Directory? _appCacheDir;

  Directory? imageAppDataDir;
  Directory? cacheDataDir;

  static FileSystemUtil get instance {
    assert(
      _instance._initialized,
      'You must initialize the supabase instance before calling Supabase.instance',
    );
    return _instance;
  }

  static Future<void> initialize() async {
    _instance._appDocumentsDir = await getApplicationDocumentsDirectory();
    var dataPath =
        '${_instance._appDocumentsDir!.absolute.path}${Platform.pathSeparator}data';
    _instance.imageAppDataDir =
        Directory('$dataPath${Platform.pathSeparator}images');
    await _instance.imageAppDataDir!.create(recursive: true);
    print('Documents: image data dir: ' +
        _instance.imageAppDataDir!.absolute.path);

    _instance._appCacheDir = await getApplicationCacheDirectory();
    var dataCachePath =
        '${_instance._appCacheDir!.absolute.path}${Platform.pathSeparator}data';
    _instance.cacheDataDir = Directory(dataCachePath);
    await _instance.cacheDataDir!.create(recursive: true);
    print('Cache: data dir: ' + _instance.cacheDataDir!.absolute.path);

    _instance._initialized = true;
  }
}
