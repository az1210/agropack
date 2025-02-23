import 'package:cloud_firestore/cloud_firestore.dart';

class Notice {
  final String? id;
  final String title;
  final String content;
  final DateTime createdAt;
  // A list of targeted user IDs or a special string "all"
  final dynamic targetUserIds;
  final List<NoticeComment>? comments;
  // Optional admin comment field (if admin wants to add additional commentary after publishing)
  final String? adminComment;

  Notice({
    this.id,
    required this.title,
    required this.content,
    required this.createdAt,
    this.targetUserIds, // can be List<String> or "all"
    this.comments,
    this.adminComment,
  });

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'content': content,
      'createdAt': Timestamp.fromDate(createdAt),
      'targetUserIds':
          targetUserIds, // must be either a list of strings or "all"
      'comments': comments?.map((c) => c.toMap()).toList() ?? [],
      'adminComment': adminComment,
    };
  }

  factory Notice.fromDoc(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return Notice(
      id: doc.id,
      title: data['title'] as String,
      content: data['content'] as String,
      createdAt: data['createdAt'] is Timestamp
          ? (data['createdAt'] as Timestamp).toDate()
          : DateTime.now(),
      targetUserIds: data['targetUserIds'], // could be a List or "all"
      comments: data['comments'] != null
          ? (data['comments'] as List)
              .map((c) => NoticeComment.fromMap(c as Map<String, dynamic>))
              .toList()
          : [],
      adminComment: data['adminComment'] as String?,
    );
  }

  factory Notice.fromMap(Map<String, dynamic> map) {
    return Notice(
      id: map['id'] as String?,
      title: map['title'] as String,
      content: map['content'] as String,
      createdAt: map['createdAt'] is Timestamp
          ? (map['createdAt'] as Timestamp).toDate()
          : DateTime.parse(map['createdAt'] as String),
      targetUserIds: map['targetUserIds'],
      comments: map['comments'] != null
          ? (map['comments'] as List)
              .map((c) => NoticeComment.fromMap(c as Map<String, dynamic>))
              .toList()
          : [],
      adminComment: map['adminComment'] as String?,
    );
  }
}

class NoticeComment {
  final String commenter;
  final String comment;
  final DateTime commentedAt;

  NoticeComment({
    required this.commenter,
    required this.comment,
    required this.commentedAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'commenter': commenter,
      'comment': comment,
      'commentedAt': Timestamp.fromDate(commentedAt),
    };
  }

  factory NoticeComment.fromMap(Map<String, dynamic> map) {
    return NoticeComment(
      commenter: map['commenter'] as String,
      comment: map['comment'] as String,
      commentedAt: map['commentedAt'] is Timestamp
          ? (map['commentedAt'] as Timestamp).toDate()
          : DateTime.parse(map['commentedAt'] as String),
    );
  }
}
