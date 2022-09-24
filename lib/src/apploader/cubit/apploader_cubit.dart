import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:sozzle/src/apploader/apploader.dart';

part 'apploader_state.dart';

/// Loads Updates the game data and user data
/// Saves to local
class ApploaderCubit extends Cubit<ApploaderState> {
  ApploaderCubit({required this.apploaderRepository})
      : super(const ApploaderState(LoaderState.initial));

  IApploaderRepository apploaderRepository;

  Future<void> updatePuzzleData() async {
    //start loading data
    emit(const ApploaderState(LoaderState.loadingPuzzle));

    //final levelData = await apploaderRepository.getLevels();

    // update status while loading
    const fakeLoadingTime = 600;
    for (var i = 0; i < fakeLoadingTime; i++) {
      await Future.delayed(
        const Duration(milliseconds: 10),
        () {
          emit(
            ApploaderState(
              LoaderState.loadingPuzzle,
              i * 100 ~/ fakeLoadingTime,
            ),
          );
        },
      );
    }

    // be sure to finalize loading by emitting 100 percent
    emit(const ApploaderState(LoaderState.loadingPuzzle, 100));
    unawaited(updateUserData());
  }

  Future<void> updateUserData() async {
    //start loading user data
    emit(const ApploaderState(LoaderState.loadingUserData, 50));

    //final userData = await apploaderRepository.getUserProgressData();

    // TODO(akyunus): save user data to local
    const fakeLoadingTime = 1;

    await Future.delayed(
      const Duration(seconds: fakeLoadingTime),
      () {
        emit(const ApploaderState(LoaderState.loadingUserData, 100));
      },
    );
    setAppReady();
  }

  void setAppReady() {
    emit(const ApploaderState(LoaderState.loaded, 100));
  }
}
