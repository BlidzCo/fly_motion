/// Exception thrown when an error occurs in the FlyMotion library.
class FlyMotionException extends Error {
  final String message;

  FlyMotionException(this.message);

  @override
  String toString() {
    return 'FlyMotionException: $message';
  }
}
