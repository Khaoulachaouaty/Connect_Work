// lib/features/admin/groups/presentation/views/widgets/group_dialog.dart
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../../../data/models/group_model.dart';
import '../../../data/services/group_service.dart';

class GroupDialog extends StatefulWidget {
  final GroupModel? group;
  final Function(String, String, bool, String?) onSave;
  const GroupDialog({super.key, this.group, required this.onSave});

  @override
  State<GroupDialog> createState() => _GroupDialogState();
}

class _GroupDialogState extends State<GroupDialog> {
  final _name = TextEditingController();
  final _desc = TextEditingController();
  bool _isPrivate = false;
  File? _image;
  bool _uploading = false;
  String? _imageUrl;
  
  final ImagePicker _picker = ImagePicker();
  final GroupService _service = GroupService();

  @override
  void initState() {
    super.initState();
    if (widget.group != null) {
      _name.text = widget.group!.name;
      _desc.text = widget.group!.description;
      _isPrivate = widget.group!.isPrivate;
      _imageUrl = widget.group!.imageUrl;
    }
  }

  Future<void> _pick() async {
    final XFile? img = await _picker.pickImage(source: ImageSource.gallery);
    if (img != null) setState(() {
      _image = File(img.path);
      _imageUrl = null;
    });
  }

  Future<void> _upload() async {
    if (_image == null) return;
    setState(() => _uploading = true);
    _imageUrl = await _service.uploadGroupImage(_image!);
    setState(() => _uploading = false);
  }

  @override
  Widget build(BuildContext context) {
    final isEdit = widget.group != null;
    return AlertDialog(
      title: Text(isEdit ? 'Modifier' : 'Nouveau groupe'),
      content: SizedBox(
        width: 300,
        child: SingleChildScrollView(
          child: Column(
            children: [
              GestureDetector(
                onTap: _pick,
                child: Container(
                  height: 100,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade100,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.grey.shade300),
                  ),
                  child: _image != null ? Image.file(_image!, fit: BoxFit.cover) :
                      (_imageUrl != null ? Image.network(_imageUrl!, fit: BoxFit.cover) :
                      const Center(child: Icon(Icons.add_photo_alternate, size: 40))),
                ),
              ),
              if (_image != null && _imageUrl == null) ...[
                const SizedBox(height: 8),
                ElevatedButton(onPressed: _upload, child: _uploading ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator()) : const Text('Uploader')),
              ],
              const SizedBox(height: 12),
              TextField(controller: _name, decoration: const InputDecoration(labelText: 'Nom', border: OutlineInputBorder())),
              const SizedBox(height: 12),
              TextField(controller: _desc, maxLines: 2, decoration: const InputDecoration(labelText: 'Description', border: OutlineInputBorder())),
              const SizedBox(height: 12),
              Row(children: [const Text('Privé'), const Spacer(), Switch(value: _isPrivate, onChanged: (v) => setState(() => _isPrivate = v))]),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(onPressed: () => Navigator.pop(context), child: const Text('Annuler')),
        ElevatedButton(onPressed: () => _name.text.isNotEmpty ? widget.onSave(_name.text, _desc.text, _isPrivate, _imageUrl) : null, child: Text(isEdit ? 'Modifier' : 'Créer')),
      ],
    );
  }
}