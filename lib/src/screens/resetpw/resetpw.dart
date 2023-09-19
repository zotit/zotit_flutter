import 'package:flutter/material.dart';
// import 'package:flutter_number_captcha/flutter_number_captcha.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:zotit/src/providers/login_provider/login_provider.dart';

class Resetpw extends ConsumerWidget {
  const Resetpw({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final bool isSmallScreen = MediaQuery.of(context).size.width < 600;

    return Scaffold(
      body: Center(
        child: isSmallScreen
            ? const Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _Logo(),
                  ResetpwFormContent(),
                ],
              )
            : Container(
                padding: const EdgeInsets.all(32.0),
                constraints: const BoxConstraints(maxWidth: 800),
                child: const Row(
                  children: [
                    Expanded(child: _Logo()),
                    Expanded(
                      child: Center(child: ResetpwFormContent()),
                    ),
                  ],
                ),
              ),
      ),
    );
  }
}

class _Logo extends StatelessWidget {
  const _Logo({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final bool isSmallScreen = MediaQuery.of(context).size.width < 600;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // FlutterLogo(size: isSmallScreen ? 100 : 200),
        Text(
          "ZotIt",
          style: TextStyle(fontFamily: 'Satisfy', fontSize: isSmallScreen ? 60 : 80),
        ),
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Text(
            "Welcome to ZotIt",
            textAlign: TextAlign.center,
            style: isSmallScreen
                ? Theme.of(context).textTheme.headlineSmall
                : Theme.of(context).textTheme.headlineMedium?.copyWith(color: Colors.black),
          ),
        )
      ],
    );
  }
}

class ResetpwFormContent extends ConsumerStatefulWidget {
  const ResetpwFormContent({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _ResetpwFormContent();
}

class _ResetpwFormContent extends ConsumerState<ResetpwFormContent> {
  final TextEditingController opwC = TextEditingController(text: "");
  final TextEditingController npwC = TextEditingController(text: "");
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final loginData = ref.watch(loginTokenProvider.notifier);
    final logDataRead = ref.read(loginTokenProvider);

    return Container(
      constraints: const BoxConstraints(maxWidth: 300),
      child: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 15),
              child: Text(
                logDataRead.asData?.value.error ?? "",
                style: const TextStyle(
                  color: Colors.red,
                ),
              ),
            ),
            TextFormField(
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter some text';
                }

                if (value.length < 6) {
                  return 'Password must be at least 6 characters';
                }
                return null;
              },
              controller: opwC,
              obscureText: true,
              decoration: const InputDecoration(
                labelText: 'Password from Email',
                hintText: 'Enter Password from Email',
                prefixIcon: Icon(Icons.lock_outline_rounded),
                border: OutlineInputBorder(),
              ),
            ),
            _gap(),
            TextFormField(
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter some text';
                }

                if (value.length < 6) {
                  return 'Password must be at least 6 characters';
                }
                return null;
              },
              controller: npwC,
              obscureText: true,
              decoration: const InputDecoration(
                labelText: 'New Password',
                hintText: 'Enter new password',
                prefixIcon: Icon(Icons.lock_outline_rounded),
                border: OutlineInputBorder(),
              ),
            ),
            _gap(),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ButtonStyle(
                  padding: MaterialStateProperty.all(const EdgeInsets.symmetric(vertical: 10)),
                  backgroundColor: MaterialStateProperty.all(
                    const Color(0xFF3A568E),
                  ),
                ),
                child: const Padding(
                  padding: EdgeInsets.all(10.0),
                  child: Text(
                    'Reset Password',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ),
                onPressed: () async {
                  if (_formKey.currentState?.validate() ?? false) {
                    // bool isValid = await FlutterNumberCaptcha.show(context);
                    // if (isValid) {

                    await loginData.resetpw(opwC.text, npwC.text);
                    // }
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _gap() => const SizedBox(height: 16);
}
