
import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:meta/meta.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'login_event.dart';
part 'login_state.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  LoginBloc() : super(LoginForm()) {
    on<LoginSubmitEvent>((event, emit) async {
      if(state is LoginLoading) {
        return;
      }
      print("LoginSubmitEvent started");
      final dio = GetIt.I<Dio>();
      final sharedPreferences = GetIt.I<SharedPreferences>();
      print("Dio and SharedPreferences retrieved");

      emit(LoginLoading());

      try {
        print("Making request");
        
        final response = await dio.post('/login', data: {
          'email': event.email,
          'password': event.password,
        });
        print("Response received: ${response.data}");
        if (response.data['token'] != null) {
          final token = response.data['token'];
          print("Token: $token");
          if(event.rememberMe){
            sharedPreferences.setString('token', token);

          }

          
          emit(LoginSuccess());
          emit(LoginForm());
          
        } else {
          print("No token found");
          emit(LoginFailure('Hiba a bejelentkezés során'));
        }
      } on DioException catch (dioError) {
        emit(LoginFailure(dioError.response?.data['message'] ??
            'Hiba a bejelentkezés során'));
            emit(LoginForm());
      }
    });
    on<LoginAutoLoginEvent>((event, emit) async {
      final sharedPreferences = GetIt.I<SharedPreferences>();
      final token = sharedPreferences.getString('token');
      if (token != null) {
        emit(LoginSuccess());
        
      } 
      
    });
  }
}
