import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:zotit/src/app_router.dart';
import 'package:zotit/src/providers/login_provider/login_provider.dart';
import 'package:zotit/src/screens/update_profile/providers/profile.dart';
import 'package:zotit/src/utils/utils.dart';

class UpdateProfile extends ConsumerWidget {
  const UpdateProfile({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF3A568E),
        title: const Text("Update Profile"),
      ),
      body: const Center(
          heightFactor: 1,
          child: SingleChildScrollView(
            child: UpdateProfileFormContent(),
          )),
    );
  }
}

class UpdateProfileFormContent extends ConsumerStatefulWidget {
  const UpdateProfileFormContent({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _UpdateProfileFormContent();
}

class _UpdateProfileFormContent
    extends ConsumerState<UpdateProfileFormContent> {
  final TextEditingController usernameC = TextEditingController(text: "");
  final TextEditingController pwC = TextEditingController(text: "");
  final TextEditingController emailC = TextEditingController(text: "");
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool hasAggreedTNC = false;

  @override
  Widget build(BuildContext context) {
    final logDataRead = ref.watch(loginTokenProvider);
    final profileData = ref.watch(profileProvider);
    usernameC.text = logDataRead.hasValue ? logDataRead.value!.username : "";
    emailC.text = profileData.hasValue ? profileData.value! : "";

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
                "",
                style: const TextStyle(
                  color: Colors.red,
                ),
              ),
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
              decoration: const InputDecoration(
                labelText: 'Username',
                hintText: 'Enter a username',
                prefixIcon: Icon(Icons.person),
                border: OutlineInputBorder(),
              ),
            ),
            const Gap(16),
            TextFormField(
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter your email id';
                }
                if (!isValidEmail(value)) {
                  return 'Please enter a valid email';
                }
                return null;
              },
              controller: emailC,
              decoration: const InputDecoration(
                labelText: 'Email Id',
                hintText: 'Enter your email Id',
                prefixIcon: Icon(Icons.email_outlined),
                border: OutlineInputBorder(),
              ),
            ),
            const Gap(16),
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
                    'Update Profile',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ),
                onPressed: () async {
                  if (_formKey.currentState?.validate() ?? false) {
                    await ref
                        .read(loginTokenProvider.notifier)
                        .updateProfile(usernameC.text, emailC.text);
                    if (context.mounted) {
                      showDialog<void>(
                        context: context,
                        builder: (c) {
                          return ProviderScope(
                            parent: ProviderScope.containerOf(context),
                            child: AlertDialog(
                              title: const Text('Success'),
                              content: const Text("Updated Profile"),
                              actions: <Widget>[
                                TextButton(
                                  onPressed: () => {
                                    Navigator.pop(context, 'OK'),
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
            const Gap(50),
            SizedBox(
              width: double.infinity,
              child: TextButton(
                style: ButtonStyle(
                  foregroundColor: MaterialStateProperty.all(
                    const Color.fromARGB(255, 173, 174, 175),
                  ),
                ),
                child: const Padding(
                  padding: EdgeInsets.all(10.0),
                  child: Text(
                    'Delete Profile',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ),
                onPressed: () {
                  Navigator.of(context).pushNamed(AppRoutes.deleteAccount);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
