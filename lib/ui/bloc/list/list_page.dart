import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_homework_24_2/ui/bloc/list/list_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ListPageBloc extends StatefulWidget {
  final String? token; // <--- Add this

  const ListPageBloc({super.key, this.token});

  @override
  State<ListPageBloc> createState() => _ListPageBlocState();
}

class _ListPageBlocState extends State<ListPageBloc> {
  ListBloc? listBloc;
  
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      listBloc = BlocProvider.of<ListBloc>(context);
      listBloc?.add(ListLoadEvent());
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<ListBloc, ListState>(
      listener: (context, state) {
        if (state is ListLoaded) {
          print("List loaded: ${state.users}");
        }
        if (state is ListError) {
          print("List error: ${state.message}");
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text(state.message),
            duration: const Duration(seconds: 2),
          ));
        }
      },
      child: BlocBuilder<ListBloc, ListState>(
        builder: (context, state) {
          if (state is ListLoading) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          if (state is ListLoaded) {
            return Scaffold(
              appBar: AppBar(
                title: const Text('List Page'),
                actions: [
                  IconButton(
                    icon: const Icon(Icons.logout),
                    onPressed: () {
                        final sharedPreferences = GetIt.I<SharedPreferences>();

                      sharedPreferences.remove('token');
                      sharedPreferences.remove('email');
                      sharedPreferences.remove('password');
                      Navigator.pushReplacementNamed(context, '/');
                    },
                  ),
                ],
              ),
              body: ListView.builder(
                itemCount: state.users.length,
                itemBuilder: (context, index) {
                  final user = state.users[index];
                  return Padding(
                    padding: const EdgeInsets.only(left: 20.0, right: 20.0, bottom: 20.0),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        CircleAvatar(
                          radius: 45,
                          backgroundImage: NetworkImage(user.avatarUrl),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Text(user.name,
                              textAlign: TextAlign.start,
                              style: const TextStyle(
                                fontSize: 25,
                                fontWeight: FontWeight.bold,
                              )),
                        ),
                      ],
                    ),
                  );
                },
              ),
            );
          }
          return Scaffold(
            appBar: AppBar(
              title: const Text('List Page'),
              actions: [
                IconButton(
                  icon: const Icon(Icons.logout),
                  onPressed: () {
                      final sharedPreferences = GetIt.I<SharedPreferences>();

                    sharedPreferences.remove('token');
                    sharedPreferences.remove('email');
                    sharedPreferences.remove('password');
                    Navigator.pushReplacementNamed(context, '/login');
                  },
                ),
              ],
            ),
            body: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [],
              ),
            ),
          );
        },
      ),
    );
  }
}
