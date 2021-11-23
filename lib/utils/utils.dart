class Utils {
  static showKeyboard(textFieldFocus) => textFieldFocus.requestFocus();

  static hideKeyboard(textFieldFocus) => textFieldFocus.unfocus();

  static int strToInt(String str) {
    return int.parse(str);
  }
}
