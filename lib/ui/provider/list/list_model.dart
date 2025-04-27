import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';

import '../../../network/user_item.dart';

class ListException extends Equatable implements Exception {
  final String message;

  const ListException(this.message);

  @override
  List<Object?> get props => [message];
}

class ListModel extends ChangeNotifier{
  var isLoading = false;
  var users = <UserItem>[];

  Future loadUsers() async {

  }
}