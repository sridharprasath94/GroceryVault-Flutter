abstract class FirestoreSyncAdapter {
  String collectionPath();

  Future<void> pushLocalToRemote();

  Future<void> applyRemoteDocument(
    Map<String, dynamic> data,
    String documentId,
  );
}
