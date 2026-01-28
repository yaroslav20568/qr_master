class StringUtils {
  static String cutText(String text, {int letters = 50}) {
    String normalizedText = text.trim();

    return normalizedText.length > letters
        ? '${normalizedText.substring(0, letters)}...'
        : normalizedText;
  }
}
