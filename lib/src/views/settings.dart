import 'package:authenticator/application.dart';
import 'package:flutter/material.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({Key? key}) : super(key: key);

  static const socialMediaLinks = [
    {
      'name': SocialMediaIcons.instagram,
      'url': 'https://www.instagram.com/priyank-kumar-singh/',
    },
    {
      'name': SocialMediaIcons.github,
      'url': 'https://www.github.com/priyank-kumar-singh/',
    },
    {
      'name': SocialMediaIcons.linkedIn,
      'url': 'https://www.linkedin.com/in/priyank-kumar-singh-705/',
    },
    {
      'name': SocialMediaIcons.twitter,
      'url': 'https://twitter.com/PRIYANKKUMARS18',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            children: [
              ListTile(
                title: const Text('Theme Mode'),
                trailing: SwitchButtonWithIcon(
                  toggle: (value) => currentAppTheme.switchTheme(),
                  value: currentAppTheme.isDark,
                ),
              ),
              ListTile(
                title: const Text('Terms and Conditions'),
                onTap: () {
                  Navigator.of(context).pushNamed(Routes.tnc);
                },
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 16.0),
            child: Column(
              children: [
                const Text('Follow me on social media. Links Below...'),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: socialMediaLinks.map((e) {
                    return Padding(
                      padding: const EdgeInsets.all(4.0),
                      child: SocialMediaButton(
                        e['name'] as SocialMediaIcons,
                        url: e['url'] as String,
                        constrainMinWidth: false,
                      ),
                    );
                  }).toList(),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
