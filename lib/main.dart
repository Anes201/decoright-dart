
import 'package:decoright/core/config/supabase_config.dart';
import 'package:decoright/utils/helpers/network_manager.dart';
import 'package:decoright/utils/local_storage/storage_utility.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import 'app.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Supabase
  await SupabaseConfig.initialize();

  // If using GetStorage (common with GetX)
  await GetStorage.init();
  await TLocalStorage.init();

  // Register NetworkManager globally so it is accessible via Get.find() in all services
  Get.put(NetworkManager(), permanent: true);

  runApp(const App());
}

