class RepositoryException implements Exception {
  const RepositoryException(this.message, this.raisedBy);

  final String message;
  final Type raisedBy;

  @override
  String toString() => "Repository Exception: $message, raised by $raisedBy";
}
