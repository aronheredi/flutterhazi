import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';
import 'package:get_it/get_it.dart';
import 'package:meta/meta.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../network/user_item.dart';

part 'list_event.dart';
part 'list_state.dart';

class ListBloc extends Bloc<ListEvent, ListState> {
  ListBloc() : super(ListInitial()) {
    on<ListLoadEvent>((event, emit) async {
      print("LoginSubmitEvent started");
      final dio = GetIt.I<Dio>();
      final sharedPreferences = GetIt.I<SharedPreferences>();
      print("Dio and SharedPreferences retrieved");

      try {
        print("Making request");
        dio.options.headers['Authorization'] =
            'Bearer ${sharedPreferences.getString('token')}';
        emit(ListLoading());
        final response = await dio.get('/users');

        if (response.data != null) {
          final usersJson = response.data as List;
          final users = usersJson.map<UserItem>((userJson) {
            return UserItem(
              userJson['name'] as String,
              userJson['avatarUrl'] as String,
            );
          }).toList();
          emit(ListLoaded(users));
        } else {
          emit(ListError('Hiba a lista lekérdezése során'));
        }
      } on DioException catch (dioError) {
        emit(ListError(dioError.response?.data['message'] ??
            'Hiba a lista lekérdezése során'));
      }
    });
  }
}
