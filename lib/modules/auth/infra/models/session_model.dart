import '../../domain/entities/session.dart';
import '../../domain/entities/user.dart';

class SessionModel extends Session {
  const SessionModel({required super.token, required super.user});

  factory SessionModel.fromMap(Map<String, dynamic> map) {
    final userMap = Map<String, dynamic>.from(map['user'] as Map);
    return SessionModel(
      token: map['token'] as String,
      user: User(
        id: userMap['id'] as int,
        name: userMap['name'] as String,
        email: userMap['email'] as String,
      ),
    );
  }
}
