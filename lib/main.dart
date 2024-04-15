import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:precious/presenters/setting_presenter.dart';
import 'package:precious/resources/routes/routes.dart';
import 'package:precious/resources/themes/app_theme.dart';
import 'package:precious/resources/utils/firebase_options.dart';
import 'package:precious/views/sign_up_success_page.dart';
import 'package:precious/views/start_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  var settings = SettingPresenter();
  await settings.getFirstRunStatus();
  runApp(MyApp(settings));
}

class MyApp extends StatelessWidget {
  final SettingPresenter _settingPresenter;

  const MyApp(this._settingPresenter, {super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: AppTheme.themeLight,
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('en'),
      ],
      initialRoute:
          _settingPresenter.firstRun ? SignUpSuccessPage.name : StartPage.name,
      routes: MyRoutes(_settingPresenter).routes,
    );
  }
}
