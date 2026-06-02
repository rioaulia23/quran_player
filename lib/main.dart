import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

// Repository classes used to handle data/business logic
import 'package:quran_player/repositories/audio_repository.dart';
import 'package:quran_player/repositories/quran_repository.dart';

// Bloc classes used for state management
import 'blocs/player_bloc/player_bloc.dart';
import 'blocs/surah_bloc/surah_list_bloc.dart';

// Main screen of the application
import 'screens/home_screen.dart';

// App theme configuration
import 'utils/app_theme.dart';

void main() {
  // Ensures Flutter engine is initialized before running native/platform code
  WidgetsFlutterBinding.ensureInitialized();

  // Locks the app orientation to portrait mode only
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  // Sets the system UI style, such as the status bar appearance
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      // Makes the status bar transparent
      statusBarColor: Colors.transparent,

      // Sets status bar icons to light color
      statusBarIconBrightness: Brightness.light,
    ),
  );

  // Starts the Flutter application
  runApp(const QuranPlayerApp());
}

// Root widget of the application
class QuranPlayerApp extends StatelessWidget {
  const QuranPlayerApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      // Provides repository instances to the widget tree
      // Repositories are responsible for handling data sources and business logic
      providers: [
        RepositoryProvider<QuranRepository>(
          create: (_) => QuranRepository(),
        ),
        RepositoryProvider<AudioRepository>(
          create: (_) => AudioRepository(),
        ),
      ],

      child: MultiBlocProvider(
        // Provides multiple Bloc instances to the widget tree
        // Bloc is used to manage and separate application state
        providers: [
          BlocProvider<SurahListBloc>(
            create: (context) => SurahListBloc(
              // Reads QuranRepository from RepositoryProvider
              repository: context.read<QuranRepository>(),
            ),
          ),
          BlocProvider<PlayerBloc>(
            create: (context) => PlayerBloc(
              // Reads AudioRepository from RepositoryProvider
              repository: context.read<AudioRepository>(),
            ),
          ),
        ],

        child: MaterialApp(
          // Application title
          title: 'Quran Player',

          // Removes the debug banner in debug mode
          debugShowCheckedModeBanner: false,

          // Applies the custom app theme
          theme: AppTheme.theme,

          // Sets HomeScreen as the first screen of the app
          home: const HomeScreen(),
        ),
      ),
    );
  }
}
