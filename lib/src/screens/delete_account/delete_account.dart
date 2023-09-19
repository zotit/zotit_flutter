import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:zotit/src/app_router.dart';
import 'package:zotit/src/providers/login_provider/login_provider.dart';

class DeleteAccount extends ConsumerWidget {
  const DeleteAccount({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final bool isSmallScreen = MediaQuery.of(context).size.width < 600;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 180, 70, 70),
        title: const Text("Delete My Account"),
      ),
      body: const Center(
          heightFactor: 1,
          child: SingleChildScrollView(
            child: DeleteAccountFormContent(),
          )),
    );
  }
}

class DeleteAccountFormContent extends ConsumerStatefulWidget {
  const DeleteAccountFormContent({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _DeleteAccountFormContent();
}

enum DeleteReason { broken, privacy, unuseful, other }

class _DeleteAccountFormContent extends ConsumerState<DeleteAccountFormContent> {
  final TextEditingController pwC = TextEditingController(text: "");
  final TextEditingController reasonC = TextEditingController(text: "");
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  DeleteReason? _reason = DeleteReason.broken;

  @override
  Widget build(BuildContext context) {
    final loginData = ref.watch(loginTokenProvider.notifier);
    final logDataRead = ref.watch(loginTokenProvider);

    return Container(
      constraints: const BoxConstraints(maxWidth: 300),
      child: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.start,
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
              controller: pwC,
              obscureText: true,
              cursorColor: const Color.fromARGB(255, 180, 70, 70),
              decoration: const InputDecoration(
                labelText: 'Password',
                hintText: 'Enter your password',
                prefixIcon: Icon(
                  Icons.lock_outline_rounded,
                ),
                floatingLabelStyle: TextStyle(color: Color.fromARGB(255, 180, 70, 70)),
                prefixIconColor: Color.fromARGB(255, 180, 70, 70),
                border: OutlineInputBorder(),
                focusColor: Color.fromARGB(255, 180, 70, 70),
                fillColor: Color.fromARGB(255, 180, 70, 70),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Color.fromARGB(255, 180, 70, 70), width: 2.0),
                ),
              ),
            ),
            const Gap(16),
            const Text("Please Give us a reason for the account deletion"),
            ListTile(
              title: const Text('Something was broken'),
              leading: Radio<DeleteReason>(
                activeColor: const Color.fromARGB(255, 180, 70, 70),
                value: DeleteReason.broken,
                groupValue: _reason,
                onChanged: (DeleteReason? value) {
                  setState(() {
                    _reason = value;
                  });
                },
              ),
            ),
            ListTile(
              title: const Text('I have privacy concerns.'),
              leading: Radio<DeleteReason>(
                activeColor: const Color.fromARGB(255, 180, 70, 70),
                value: DeleteReason.privacy,
                groupValue: _reason,
                onChanged: (DeleteReason? value) {
                  setState(() {
                    _reason = value;
                  });
                },
              ),
            ),
            ListTile(
              title: const Text('I  dont use this app often.'),
              leading: Radio<DeleteReason>(
                activeColor: const Color.fromARGB(255, 180, 70, 70),
                value: DeleteReason.unuseful,
                groupValue: _reason,
                onChanged: (DeleteReason? value) {
                  setState(() {
                    _reason = value;
                  });
                },
              ),
            ),
            ListTile(
              title: const Text('Other'),
              leading: Radio<DeleteReason>(
                activeColor: const Color.fromARGB(255, 180, 70, 70),
                value: DeleteReason.other,
                groupValue: _reason,
                onChanged: (DeleteReason? value) {
                  setState(() {
                    _reason = value;
                  });
                },
              ),
            ),
            const Gap(16),
            TextField(
              controller: reasonC,
              maxLines: 4,
              minLines: 3,
              cursorColor: const Color.fromARGB(255, 180, 70, 70),
              decoration: const InputDecoration(
                labelText: 'Explanation',
                hintText: 'Your explanation is entirely optional...',
                floatingLabelStyle: TextStyle(color: Color.fromARGB(255, 180, 70, 70)),
                prefixIconColor: Color.fromARGB(255, 180, 70, 70),
                border: OutlineInputBorder(),
                focusColor: Color.fromARGB(255, 180, 70, 70),
                fillColor: Color.fromARGB(255, 180, 70, 70),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Color.fromARGB(255, 180, 70, 70), width: 2.0),
                ),
              ),
            ),
            const Gap(16),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ButtonStyle(
                  padding: MaterialStateProperty.all(const EdgeInsets.symmetric(vertical: 10)),
                  backgroundColor: MaterialStateProperty.all(
                    const Color.fromARGB(255, 180, 70, 70),
                  ),
                ),
                child: const Padding(
                  padding: EdgeInsets.all(10.0),
                  child: Text(
                    'Delete Account',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ),
                onPressed: () async {
                  if (_formKey.currentState?.validate() ?? false) {
                    await loginData.deleteAccount(
                      pwC.text,
                      _reason.toString(),
                      reasonC.text,
                    );
                    if (context.mounted && loginData.getData().error == "") {
                      showDialog<void>(
                        context: context,
                        builder: (c) {
                          return ProviderScope(
                            parent: ProviderScope.containerOf(context),
                            child: AlertDialog(
                              title: const Text('Success'),
                              content: const Text("Your Account has been deleted"),
                              actions: <Widget>[
                                TextButton(
                                  onPressed: () => {
                                    Navigator.pushReplacementNamed(context, AppRoutes.startupPage),
                                  },
                                  child: const Text('OK'),
                                ),
                              ],
                            ),
                          );
                        },
                      );
                    }
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
