import 'package:flutter/material.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'dart:html' as html;

AppBar bar(BuildContext context, {int i = 0}) => AppBar(
      title: const Text('Pavouk - generátor příkladů pro výuku subnetování'),
      centerTitle: true,
      backgroundColor: Colors.red,
      actions: [
        IconButton(
          icon: const Icon(Icons.info_outline),
          onPressed: () {
            PackageInfo.fromPlatform().then(
              (v) => showAboutDialog(
                  context: context,
                  applicationName: "Pavouk",
                  applicationVersion: v.version,
                  applicationLegalese:
                      "© 2022 Matyáš Caras\nVydáno pod licencí GNU AGPLv3\nVěnováno SŠTE Brno, Olomoucká",
                  children: [
                    TextButton(
                        onPressed: () => html.window.open(
                            "https://github.com/hernikplays/pavouk", "_blank"),
                        child: const Text("Zdrojový kód"))
                  ]),
            );
          },
        )
      ],
    );
