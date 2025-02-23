import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../features/auth/providers/auth_providers.dart';
import '../../models/notice_model.dart';
import '../../models/user.dart';

class NoticeController extends ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  bool isLoading = false;
  String errorMessage = '';

  Future<List<Notice>> fetchNotices({bool notify = true}) async {
    if (notify) {
      isLoading = true;
      notifyListeners();
    }
    try {
      final snapshot = await _firestore
          .collection('notices')
          .orderBy('createdAt', descending: true)
          .get();
      return snapshot.docs.map((doc) => Notice.fromDoc(doc)).toList();
    } catch (e) {
      if (notify) {
        errorMessage = e.toString();
        notifyListeners();
      }
      return [];
    } finally {
      if (notify) {
        isLoading = false;
        notifyListeners();
      }
    }
  }

  Future<void> createNotice(Notice notice) async {
    isLoading = true;
    notifyListeners();
    try {
      final docRef = _firestore.collection('notices').doc();
      await docRef.set(notice.toMap());
    } catch (e) {
      errorMessage = e.toString();
      notifyListeners();
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> updateNotice(Notice notice) async {
    if (notice.id == null) {
      throw Exception('Notice has no ID to update');
    }
    isLoading = true;
    notifyListeners();
    try {
      await _firestore
          .collection('notices')
          .doc(notice.id)
          .update(notice.toMap());
    } catch (e) {
      errorMessage = e.toString();
      notifyListeners();
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> deleteNotice(Notice notice) async {
    if (notice.id == null) {
      throw Exception('Notice has no ID to delete');
    }
    isLoading = true;
    notifyListeners();
    try {
      await _firestore.collection('notices').doc(notice.id).delete();
    } catch (e) {
      errorMessage = e.toString();
      notifyListeners();
      rethrow;
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> addComment(String noticeId, NoticeComment comment) async {
    try {
      final docRef = _firestore.collection('notices').doc(noticeId);
      await docRef.update({
        'comments': FieldValue.arrayUnion([comment.toMap()])
      });
    } catch (e) {
      errorMessage = e.toString();
      notifyListeners();
    }
  }

  Future<void> deleteComment(String noticeId, NoticeComment comment) async {
    try {
      final docRef = _firestore.collection('notices').doc(noticeId);
      await docRef.update({
        'comments': FieldValue.arrayRemove([comment.toMap()])
      });
      // Optionally, call notifyListeners() if needed.
    } catch (e) {
      errorMessage = e.toString();
      notifyListeners();
      rethrow;
    }
  }
}

final noticeProvider = ChangeNotifierProvider<NoticeController>((ref) {
  return NoticeController();
});

// Provider to fetch all notices for admin.
final adminNoticesProvider = FutureProvider<List<Notice>>((ref) async {
  // Disable notifications during initialization.
  return ref.read(noticeProvider.notifier).fetchNotices(notify: false);
});

// Provider to fetch all users from Firestore.
final allUsersProvider = FutureProvider<List<UserModel>>((ref) async {
  final firestore = FirebaseFirestore.instance;
  final snapshot = await firestore.collection('users').get();
  return snapshot.docs.map((doc) {
    final data = doc.data();
    // Inject document ID into the map.
    data['id'] = doc.id;
    return UserModel.fromMap(data);
  }).toList();
});

final userNoticesProvider = StreamProvider<List<Notice>>((ref) {
  final currentUser = ref.watch(customAuthStateProvider);
  if (currentUser == null) {
    return const Stream.empty();
  }
  final firestore = FirebaseFirestore.instance;
  return firestore
      .collection('notices')
      .orderBy('createdAt', descending: true)
      .snapshots()
      .map((snapshot) {
    final allNotices = snapshot.docs.map((doc) {
      final data = doc.data();
      data['id'] = doc.id;
      return Notice.fromMap(data);
    }).toList();
    return allNotices.where((notice) {
      final target = notice.targetUserIds;
      if (target == 'all') return true;
      if (target is List) {
        return target.contains(currentUser.id);
      }
      return false;
    }).toList();
  });
});

final adminNoticesStreamProvider = StreamProvider<List<Notice>>((ref) {
  final firestore = FirebaseFirestore.instance;
  return firestore
      .collection('notices')
      .orderBy('createdAt', descending: true)
      .snapshots()
      .map((snapshot) => snapshot.docs.map((doc) {
            final data = doc.data();
            data['id'] = doc.id;
            return Notice.fromMap(data);
          }).toList());
});
