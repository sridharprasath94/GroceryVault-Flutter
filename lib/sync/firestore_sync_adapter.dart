abstract class FirestoreSyncAdapter {
  String collectionPath();

  Future<void> pushLocalToRemote();

  Future<void> applyRemoteDocument(
    Map<String, Object?> data,
    String documentId,
  );
}
