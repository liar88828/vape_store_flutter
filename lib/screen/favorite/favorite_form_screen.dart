import 'package:flutter/material.dart';
import 'package:vape_store/models/favorite_model.dart';
import 'package:vape_store/models/user_model.dart';
import 'package:vape_store/network/favorite_network.dart';
import 'package:vape_store/utils/pref_user.dart';

class FavoriteFormScreen extends StatefulWidget {
  final FavoriteModel? favorite;
  const FavoriteFormScreen({super.key, this.favorite});

  @override
  State<FavoriteFormScreen> createState() => _FavoriteFormScreenState();
}

class _FavoriteFormScreenState extends State<FavoriteFormScreen> {
  final _apiFavorite = FavoriteNetwork();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();

  UserModel? userData;

  // Use the helper function to load user data
  Future<void> _fetchUserData() async {
    userData = await loadUserData();
    if (userData != null) {
      setState(() {});
    }
  }

  @override
  void initState() {
    super.initState();
    _fetchUserData();

    if (widget.favorite != null) {
      _titleController.text = widget.favorite!.title;
      _descriptionController.text = widget.favorite!.description;
    }
  }

  Future<void> _saveFavorite() async {
    try {
      final favorite = FavoriteModel(
        id: widget.favorite?.id,
        id_user: userData!.id,
        description: _descriptionController.text,
        title: _titleController.text,
        // id_product: 2,
      );

      // print(favorite);
      // print(favorite);
      if (widget.favorite == null) {
        await _apiFavorite.createFavorite(favorite);
      } else {
        await _apiFavorite.updateFavorite(favorite);
      }
      Navigator.pop(context, true);
    } catch (e) {
      print(e);
      // Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.favorite == null ? "Add Favorite" : "Edit Favorite"),
      ),
      body: Container(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: _titleController,
              decoration: InputDecoration(labelText: 'Title'),
            ),
            TextField(
              controller: _descriptionController,
              decoration: InputDecoration(labelText: 'Description'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
                onPressed: _saveFavorite,
                child: Row(
                  children: [Icon(Icons.save), Text("Save")],
                ))
          ],
        ),
      ),
    );
  }
}
