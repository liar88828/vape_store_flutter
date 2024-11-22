import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';
import 'package:vape_store/bloc/favorite/favorite_bloc.dart';
import 'package:vape_store/models/favorite_model.dart';

class FavoriteFormScreen extends StatefulWidget {
  final FavoriteModel? favorite;
  const FavoriteFormScreen({super.key, this.favorite});

  @override
  State<FavoriteFormScreen> createState() => _FavoriteFormScreenState();
}

class _FavoriteFormScreenState extends State<FavoriteFormScreen> {
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    if (widget.favorite != null) {
      _titleController.text = widget.favorite!.title;
      _descriptionController.text = widget.favorite!.description;
    }

    void saveFavorite() async {
      final favorite = FavoriteModel(
        id: widget.favorite?.id,
        idUser: 0,
        description: _descriptionController.text,
        title: _titleController.text,
      );

      if (widget.favorite == null) {
        context.read<FavoriteBloc>().add(FavoriteCreateEvent(favorite: favorite));
      } else {
        context.read<FavoriteBloc>().add(FavoriteUpdateEvent(favorite: favorite));
      }
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.favorite == null ? "Add Favorite" : "Edit Favorite"),
      ),
      body: BlocListener<FavoriteBloc, FavoriteState>(
        listener: (context, state) {
          if (state is FavoriteCreateState) {
            Navigator.pop(context, true);
          }
          if (state is FavoriteUpdateState) {
            Navigator.pop(context, true);
          }
        },
        child: Container(
          padding: const EdgeInsets.all(16),
          child: Column(children: [
            TextField(
              controller: _titleController,
              decoration: const InputDecoration(labelText: 'Title'),
            ),
            TextField(
              controller: _descriptionController,
              decoration: const InputDecoration(labelText: 'Description'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
                onPressed: () => saveFavorite(),
                child: const Row(
                  children: [Icon(Icons.save), Text("Save")],
                ))
          ]),
        ),
      ),
    );
  }
}
