import 'package:get_it/get_it.dart';
import 'package:nassin/core/services/AuthService.dart';
import 'package:nassin/core/services/FireStoreDb.dart';
import 'package:nassin/core/services/NavigatorService.dart';
import 'package:nassin/core/services/PushNotificationService.dart';
import 'package:nassin/core/services/StorageService.dart';
import 'package:nassin/viewModules/BaseModel.dart';
import 'package:nassin/viewModules/ChatModel.dart';
import 'package:nassin/viewModules/ContactModel.dart';
import 'package:nassin/viewModules/ConversationModel.dart';
import 'package:nassin/viewModules/MainModel.dart';
import 'package:nassin/viewModules/SignInModel.dart';
import 'package:nassin/viewModules/StreamPageModel.dart';

GetIt getIt = GetIt.instance;

void setupLocator() async{
  //Service
  getIt.registerLazySingleton(() => NavigatorService());
  getIt.registerLazySingleton(() => FireStoreDb());
  getIt.registerLazySingleton(() => AuthService());
  getIt.registerLazySingleton(() => StorageService());
  getIt.registerLazySingleton(() => PushNotificationService());

  //Model
  getIt.registerLazySingleton(() => BaseModel());
  getIt.registerLazySingleton(() => MainModel());
  getIt.registerLazySingleton(() => ChatModel());
  getIt.registerLazySingleton(() => ConversationModel());
  getIt.registerLazySingleton(() => SignInModel());
  getIt.registerLazySingleton(() => ContactModel());
  getIt.registerLazySingleton(() => StreamPageModel());

}