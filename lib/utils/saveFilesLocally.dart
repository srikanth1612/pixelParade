import 'package:file/file.dart';
import 'package:file/local.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:flutter_cache_manager/src/storage/file_system/file_system.dart'
    as c;
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

class IOFileSystem implements c.FileSystem {
  final Future<Directory> _fileDir;

  IOFileSystem(String key) : _fileDir = createDirectory(key);

  static Future<Directory> createDirectory(String key) async {
    var baseDir = await getTemporaryDirectory();
    var path = p.join(baseDir.path, key);

    var fs = const LocalFileSystem();
    var directory = fs.directory((path));
    await directory.create(recursive: true);
    return directory;
  }

  @override
  Future<File> createFile(String name) async {
    return (await _fileDir).childFile(name);
  }
}

class CustomCacheManager extends CacheManager with ImageCacheManager {
  static const String key = "customCache";

  static CustomCacheManager? _instance;

  factory CustomCacheManager() {
    return _instance ??= CustomCacheManager._();
  }

  CustomCacheManager._()
      : super(
          Config(key, fileSystem: IOFileSystem(key)),
        );
}
