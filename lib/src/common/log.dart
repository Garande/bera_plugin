// ignore_for_file: avoid_print
const appTag = "[kazi_mobile]:: ";
const enablePrintLog = true;

printLog(dynamic data) {
  if (enablePrintLog) {
    print("$appTag${data.toString()}");
  }
}
