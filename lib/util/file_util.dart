
class FileUtil {

  static String getFileNameFromUrl(String url) {
    Uri uri = Uri.parse(url);
    String path = Uri.decodeComponent(uri.path);
    String fileName = path.split('/').last;
    return fileName;
  }
}