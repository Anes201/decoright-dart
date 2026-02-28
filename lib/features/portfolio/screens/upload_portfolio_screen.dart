import 'dart:io';
import 'package:decoright/data/services/portfolio_service.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:decoright/utils/constants/sizes.dart';
import 'package:decoright/l10n/app_localizations.dart';

class UploadPortfolioScreen extends StatefulWidget {
  const UploadPortfolioScreen({super.key});

  @override
  State<UploadPortfolioScreen> createState() => _UploadPortfolioScreenState();
}

class _UploadPortfolioScreenState extends State<UploadPortfolioScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descController = TextEditingController();
  File? _selectedFile;
  bool _isLoading = false;
  String _mediaType = 'image';

  Future<void> _pickFile() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['jpg', 'jpeg', 'png', 'mp4'],
    );

    if (result != null) {
      setState(() {
        _selectedFile = File(result.files.single.path!);
        final ext = result.files.single.extension?.toLowerCase();
        _mediaType = (ext == 'mp4') ? 'video' : 'image';
      });
    }
  }

  Future<void> _upload() async {
    if (!_formKey.currentState!.validate() || _selectedFile == null) {
      if (_selectedFile == null) Get.snackbar(AppLocalizations.of(context)!.error, AppLocalizations.of(context)!.pleaseSelectFile);
      return;
    }

    setState(() => _isLoading = true);
    
    try {
      await PortfolioService().uploadPortfolioItem(
        title: _titleController.text.trim(),
        description: _descController.text.trim(),
        file: _selectedFile!,
        mediaType: _mediaType,
      );
      
      Get.back(result: true); // Return true to trigger refresh
      Get.snackbar(AppLocalizations.of(context)!.done, AppLocalizations.of(context)!.itemUploadedSuccess);
    } catch (e) {
      Get.snackbar(AppLocalizations.of(context)!.error, "${AppLocalizations.of(context)!.uploadFailed}: $e");
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final i18n = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AppBar(title: Text(i18n.uploadPortfolioItem)),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(TSizes.defaultSpace),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _titleController,
                decoration: InputDecoration(labelText: i18n.title, prefixIcon: const Icon(Iconsax.text_block)),
                validator: (v) => v!.isEmpty ? i18n.required : null,
              ),
              const SizedBox(height: TSizes.spaceBtwInputFields),
              
              TextFormField(
                controller: _descController,
                maxLines: 3,
                decoration: InputDecoration(labelText: i18n.description, prefixIcon: const Icon(Iconsax.note)),
              ),
              const SizedBox(height: TSizes.spaceBtwSections),
              
              // File Select
              InkWell(
                onTap: _pickFile,
                child: Container(
                  height: 200,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.grey[100],
                    border: Border.all(color: Colors.grey),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: _selectedFile != null
                      ? Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              _mediaType == 'video' ? Iconsax.video : Iconsax.image,
                              size: 48,
                              color: Colors.green,
                            ),
                            const SizedBox(height: 8),
                            Text(_selectedFile!.path.split('/').last),
                          ],
                        )
                      : Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(Iconsax.document_upload, size: 48, color: Colors.grey),
                            const SizedBox(height: 8),
                            Text(i18n.tapToSelectMedia),
                          ],
                        ),
                ),
              ),
              const SizedBox(height: TSizes.spaceBtwSections),
              
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _isLoading ? null : _upload,
                  child: _isLoading 
                    ? const CircularProgressIndicator(color: Colors.white) 
                    : Text(i18n.uploadItem),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
