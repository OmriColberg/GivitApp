// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:dartz/dartz.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:get_it/get_it.dart';
// import 'package:givit_app/core/firebase_entities/collections.dart';
// import 'package:givit_app/core/models/givit_user.dart';
// import 'package:givit_app/login_feature/core/failures.dart';

//final getIt = GetIt.instance;
/*
void setup() {
  getIt.registerLazySingletonAsync<Either<GivitUser, UserNotFoundFailure>>(
      () async {
    try {
      DocumentSnapshot documentSnapshot = await getIt
          .get<UsersCollection>()
          .collectionReference
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .get();

      // documentSnapshot
      getIt.registerLazySingleton(
          () => GivitUser.fromFirestorUser(documentSnapshot));

      return Left(getIt.get<GivitUser>());
    } catch (err) {
      print("error occured $err");
      getIt.registerLazySingleton(() => GivitUser());
      return Right(UserNotFoundFailure());
    }
  });

  getIt.registerLazySingleton(() => UsersCollection());
}
*/