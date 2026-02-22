
import 'package:decoright/core/config/supabase_config.dart';
import 'package:decoright/utils/local_storage/storage_utility.dart';
import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';


import 'app.dart';



Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Supabase
  await SupabaseConfig.initialize();

  // If using GetStorage (common with GetX)
  await GetStorage.init();
  await TLocalStorage.init();

  runApp(const App());
}

