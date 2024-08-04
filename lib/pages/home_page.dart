import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:start/bloc/auth_bloc.dart';
import 'package:start/bloc/auth_event.dart';
import 'package:start/bloc/auth_state.dart';
import 'package:start/components/my_button.dart';
import 'package:start/components/my_listview.dart';
import 'package:start/pages/login_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  // final AuthViewModel authViewModel;

  @override
  _HomeViewState createState() => _HomeViewState();
}

class _HomeViewState extends State<HomePage> {
  List<String> items = List.generate(10, (index) => 'Item ${index + 1}');
  bool isLoadingMore = false;

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is AuthInitial) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => LoginPage(),
            ),
          );
        }
      },
      child: Scaffold(
        backgroundColor: Colors.grey[300],
        appBar: AppBar(
          backgroundColor: Colors.grey[500],
          title: const Text(
            'Home Page',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          actions: [
            IconButton(
              icon: const Icon(
                Icons.logout,
                color: Colors.black,
              ),
              onPressed: () {
                context.read<AuthBloc>().add(
                      LogoutEvent(),
                    );
              },
            ),
          ],
        ),
        body: RefreshIndicator(
          onRefresh: _refreshList,
          child: ListView.builder(
            itemCount: items.length + 1,
            itemBuilder: (context, index) {
              if (index == items.length) {
                if (isLoadingMore) {
                  return const Center(child: CircularProgressIndicator());
                } else {
                  return Column(
                    children: [
                      const SizedBox(
                        height: 25,
                      ),
                      MyButton(
                        onTap: _loadMoreItems,
                        text: 'Load More Item',
                      ),
                      const SizedBox(
                        height: 40,
                      ),
                    ],
                  );
                }
              }

              return MyListview(item: items[index], index: index);
            },
          ),
        ),
      ),
    );
  }

  Future<void> _refreshList() async {
    await Future.delayed(const Duration(seconds: 1));
    setState(() {
      items = List.generate(10, (index) => 'Item ${index + 1}');
    });
  }

  void _loadMoreItems() async {
    setState(() {
      isLoadingMore = true;
    });
    await Future.delayed(const Duration(seconds: 1));
    setState(() {
      items.addAll(
          List.generate(1, (index) => 'Item ${items.length + index + 1}'));
      isLoadingMore = false;
    });
  }
}
