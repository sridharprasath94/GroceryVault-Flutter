import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/grocery_list_bloc.dart';
import '../domain/grocery_list.dart';
import '../../auth/bloc/auth_bloc.dart';
import '../../../app/di/injection.dart';
import '../repository/grocery_list_repository.dart';

class GroceryListScreen extends StatelessWidget {
  const GroceryListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => GroceryListBloc(
        getIt<GroceryListRepository>(),
      )..add(GroceryListStarted()),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Groceries'),
          actions: [
            IconButton(
              icon: const Icon(Icons.logout),
              onPressed: () {
                context.read<AuthBloc>().add(AuthLogoutRequested());
              },
            ),
          ],
        ),
        body: BlocBuilder<GroceryListBloc, GroceryListState>(
          builder: (context, state) {
            if (state is GroceryListLoading) {
              return const Center(child: CircularProgressIndicator());
            }

            if (state is GroceryListFailure) {
              return Center(
                child: Text(
                  state.failure.toString(),
                  style: const TextStyle(color: Colors.red),
                ),
              );
            }

            if (state is GroceryListLoaded) {
              if (state.groceries.isEmpty) {
                return const Center(
                  child: Text('No grocery lists yet'),
                );
              }

              return ListView.builder(
                itemCount: state.groceries.length,
                itemBuilder: (_, listIndex) {
                  final list = state.groceries[listIndex];

                  return ExpansionTile(
                    title: Text(
                      list.title,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    children: list.items.map((item) {
                      return CheckboxListTile(
                        title: Text(item.name),
                        value: item.isChecked,
                        onChanged: (_) {
                          context.read<GroceryListBloc>().add(
                            GroceryItemToggled(item.id),
                          );
                        },
                      );
                    }).toList(),
                  );
                },
              );
            }

            return const SizedBox.shrink();
          },
        ),
      ),
    );
  }
}