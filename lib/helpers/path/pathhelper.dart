import 'package:path/path.dart' as path;

class PathHelper {
  static String pathJoin(String dirName, String fileName){
    return path.join(dirName,fileName);
  }
}