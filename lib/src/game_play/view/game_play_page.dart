import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:level_data/level_data.dart';
import 'package:sozzle/src/audio/domain/i_audio_controller.dart';
import 'package:sozzle/src/game_play/game_play.dart';
import 'package:sozzle/src/game_play/view/components/game_loader.dart';
import 'package:sozzle/src/level/domain/i_level_repository.dart';
import 'package:sozzle/src/theme/theme.dart';

class GamePlayPage extends StatelessWidget {
  const GamePlayPage({super.key, required this.levelID});
  static const path = 'play';
  final int levelID;

  @override
  Widget build(BuildContext context) {
    final theme = BlocProvider.of<ThemeCubit>(context).state;
    return Scaffold(
      backgroundColor: theme.backgroundColor,
      body: Center(
        child: GameLoader(
          future: RepositoryProvider.of<ILevelRepository>(context)
              .getLevel(levelID),
          builder: (BuildContext context, AsyncSnapshot<LevelData> snapshot) {
            if (snapshot.connectionState != ConnectionState.done) {
              return const CircularProgressIndicator();
            }
            if (!snapshot.hasData) {
              return const Text('Ops an error!');
            } else {
              final bloc = GamePlayBloc(
                levelData: snapshot.data!,
                audio: RepositoryProvider.of<IAudioController>(context),
              );
              return BlocProvider<GamePlayBloc>(
                create: (context) => bloc,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const GamePlayHeader(),
                    Expanded(child: GamePlayBoard(snapshot.data!)),
                    GamePlayLetters(snapshot.data!),
                  ],
                ),
              );
            }
          },
        ),
      ),
    );
  }
}
