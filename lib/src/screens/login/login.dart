import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:zotit/src/providers/login_provider/login_provider.dart';

class Login extends ConsumerWidget {
  const Login({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final bool isSmallScreen = MediaQuery.of(context).size.width < 600;

    return Scaffold(
      body: Center(
        child: isSmallScreen
            ? const SingleChildScrollView(
                child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _Logo(),
                  LoginFormContent(),
                ],
              ))
            : Container(
                padding: const EdgeInsets.all(32.0),
                constraints: const BoxConstraints(maxWidth: 800),
                child: const Row(
                  children: [
                    Expanded(child: _Logo()),
                    Expanded(
                      child: Center(child: LoginFormContent()),
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
          style: TextStyle(
              fontFamily: 'Satisfy', fontSize: isSmallScreen ? 60 : 80),
        ),
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Text(
            "Welcome to ZotIt",
            textAlign: TextAlign.center,
            style: isSmallScreen
                ? Theme.of(context).textTheme.headlineSmall
                : Theme.of(context)
                    .textTheme
                    .headlineMedium
                    ?.copyWith(color: Colors.black),
          ),
        )
      ],
    );
  }
}

class LoginFormContent extends ConsumerStatefulWidget {
  const LoginFormContent({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _LoginFormContent();
}

class _LoginFormContent extends ConsumerState<LoginFormContent> {
  final TextEditingController usernameC = TextEditingController(text: "");
  final TextEditingController pwC = TextEditingController(text: "");
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final loginData = ref.watch(loginTokenProvider.notifier);
    final loginformData = ref.watch(loginTokenProvider);
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
              child: loginformData.when(
                  data: (data) => Text(
                        data.error,
                        style: const TextStyle(
                          color: Colors.red,
                        ),
                      ),
                  error: (err, st) => Text(
                        ref.watch(loginTokenProvider).value!.error,
                        style: const TextStyle(
                          color: Colors.red,
                        ),
                      ),
                  loading: () => const Center(
                        child: CircularProgressIndicator(),
                      )),
            ),
            TextFormField(
              controller: usernameC,
              validator: (value) {
                // add email validation
                if (value == null || value.isEmpty) {
                  return 'Please enter some text';
                }
                return null;
              },
              onFieldSubmitted: (s) async {
                if (_formKey.currentState?.validate() ?? false) {
                  await loginData.login(usernameC.text, pwC.text);
                }
              },
              decoration: const InputDecoration(
                labelText: 'Username',
                hintText: 'Enter your username',
                prefixIcon: Icon(Icons.person),
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
              controller: pwC,
              onFieldSubmitted: (s) async {
                if (_formKey.currentState?.validate() ?? false) {
                  await loginData.login(usernameC.text, pwC.text);
                }
              },
              obscureText: true,
              decoration: const InputDecoration(
                labelText: 'Password',
                hintText: 'Enter your password',
                prefixIcon: Icon(Icons.lock_outline_rounded),
                border: OutlineInputBorder(),
              ),
            ),
            _gap(),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ButtonStyle(
                  padding: MaterialStateProperty.all(
                      const EdgeInsets.symmetric(vertical: 10)),
                  backgroundColor: MaterialStateProperty.all(
                    const Color(0xFF3A568E),
                  ),
                ),
                child: const Padding(
                  padding: EdgeInsets.all(10.0),
                  child: Text(
                    'Sign in',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ),
                onPressed: () async {
                  if (_formKey.currentState?.validate() ?? false) {
                    await loginData.login(usernameC.text, pwC.text);
                  }
                },
              ),
            ),
            const Divider(
              height: 40,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ElevatedButton(
                  style: ButtonStyle(
                    padding: MaterialStateProperty.all(
                        const EdgeInsets.symmetric(vertical: 10)),
                    backgroundColor: MaterialStateProperty.all(
                      const Color(0xFF3A568E),
                    ),
                  ),
                  child: const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                    child: Text(
                      'Register',
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                  ),
                  onPressed: () {
                    loginData.setPage('register');
                  },
                ),
                TextButton(
                  child: const Padding(
                    padding: EdgeInsets.all(10.0),
                    child: Text(
                      'Forgot Password ?',
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                  ),
                  onPressed: () {
                    loginData.setPage('forgotpw');
                  },
                ),
              ],
            )
          ],
        ),
      ),
    );
  }

  Widget _gap() => const SizedBox(height: 16);
}
