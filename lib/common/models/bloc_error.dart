class BlocError extends Error {
  BlocError([this.message]);

  final String? message;

  @override
  String toString() {
    if (message == null) return 'Something went wrong in the BLoC';

    return 'Something went wrong in the BLoC: $message';
  }
}
