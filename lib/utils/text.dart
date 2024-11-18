String truncate(String text, int length) {
  if (text.length > length) {
    return "${text.substring(0, length)}...";
  }
  return text;
}
