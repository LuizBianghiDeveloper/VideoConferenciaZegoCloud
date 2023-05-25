import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:zego_uikit_prebuilt_video_conference/zego_uikit_prebuilt_video_conference.dart';

Future main() async {
  await dotenv.load(fileName: '.env');

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Aplicativo de Video Conferência',
      home: HomePage(),
    );
  }
}

// Gerar userId com comprimento de 6 dígitos
// Gerar conferenceId com 10 dígitos
final String userId = Random().nextInt(900000 + 100000).toString();
final String randomConferenceId =
    (Random().nextInt(1000000000) * 10 + Random().nextInt(10))
        .toString()
        .padLeft(10, '0');

class HomePage extends StatelessWidget {
  HomePage({super.key});

  final conferenceIdController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    var buttonStyle = ElevatedButton.styleFrom(
      backgroundColor: const Color(0xff034ada),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
    );
    return Scaffold(
      body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.network(
                'https://www.visual.com.br/wp-content/themes/visual-sistemas-eletronicos/assets/img/visual-sistemas.png',
                width: MediaQuery.of(context).size.width * 0.6,
              ),
              const SizedBox(
                height: 60,
              ),
              Text('Seu ID de usuário: $userId'),
              const Text('Por favor, teste com dois ou mais dispositivos'),
              const SizedBox(
                height: 20,
              ),
              TextFormField(
                maxLength: 10,
                keyboardType: TextInputType.number,
                controller: conferenceIdController,
                decoration: const InputDecoration(
                    labelText: 'Digite o ID da reunião',
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(10)))),
              ),
              ElevatedButton(
                style: buttonStyle,
                child: const Text('Entrar na reunião'),
                onPressed: () => jumpToMeetingPage(context,
                    conferenceId: conferenceIdController.text),
              ),
              const SizedBox(
                height: 16,
              ),
              ElevatedButton(
                style: buttonStyle,
                child: const Text('Nova reunião'),
                onPressed: () => jumpToMeetingPage(
                  context,
                  conferenceId: randomConferenceId,
                ),
              ),
            ],
          )),
    );
  }

  // Ir para a página da reunião
  jumpToMeetingPage(BuildContext context, {required String conferenceId}) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => VideoConferencePage(
          conferenceID: conferenceId,
        ),
      ),
    );
  }
}

// Interface de usuário pré-construída do VideoConferencePage de ZEGOCLOUD UIKits
class VideoConferencePage extends StatelessWidget {
  final String conferenceID;

  VideoConferencePage({super.key, required this.conferenceID});

  // Ler AppID e AppSign do arquivo .env
  // Certifique-se de substituir pelo seu próprio
  final int appID = int.parse(dotenv.get('ZEGO_APP_ID'));
  final String appSign = dotenv.get('ZEGO_APP_SIGN');

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: ZegoUIKitPrebuiltVideoConference(
          appID:
              appID, // Preencha o appID que você obtém do Console Administrativo do ZEGOCLOUD.
          appSign:
              appSign, // Preencha o appSign que você obtém do Console Administrativo do ZEGOCLOUD.
          userID: userId,
          userName: 'user_$userId',
          conferenceID: conferenceID,
          config: ZegoUIKitPrebuiltVideoConferenceConfig(
              leaveConfirmDialogInfo: ZegoLeaveConfirmDialogInfo(
            title: "Sair da conferência",
            message: "Tem certeza que deseja sair da conferência?",
            cancelButtonName: "Cancelar",
            confirmButtonName: "Confirmar",
          ))),
    );
  }
}
