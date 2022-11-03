import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pavouk/okna/reseni.dart';
import 'package:pavouk/util/appbar.dart';
import 'package:pavouk/util/subnet_masky.dart';
import 'package:pavouk/util/vzhled.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class DomovskaStrana extends StatefulWidget {
  const DomovskaStrana({super.key});

  @override
  State<DomovskaStrana> createState() => _DomovskaStranaState();
}

class _DomovskaStranaState extends State<DomovskaStrana> {
  // proměnné pro řešitel
  var origoIp = "";
  var subnety = <int>[];
  var content = [];
  final _origoController = TextEditingController();

  // proměnné pro generátor
  var pocetSubnetu = 0;
  var maxPocetRealnych = 0;
  var chytakovyMod = false;

  @override
  void initState() {
    super.initState();
    setState(() {
      generovatSubnetFieldy(3);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: bar(context),
        body: SingleChildScrollView(
          child: Center(
            child: SizedBox(
              width:
                  (Device.orientation == Orientation.landscape) ? 45.w : 100.w,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const SizedBox(
                        height: 50,
                      ),
                      Text("Parametry pro generátor", style: Vzhled.nadpis),
                      const SizedBox(height: 15),
                      SizedBox(
                        width: 20.w,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text("Počet subnetů:",
                                    style: Vzhled.fieldNadpis),
                                const SizedBox(
                                  width: 20,
                                ),
                                SizedBox(
                                  width: 100,
                                  child: Tooltip(
                                    message:
                                        "Maximální počet: ${Util.alphabet.length - 1}",
                                    child: TextField(
                                      inputFormatters: [
                                        FilteringTextInputFormatter.digitsOnly
                                      ],
                                      onChanged: (value) {
                                        if (value.isNotEmpty) {
                                          pocetSubnetu = int.parse(value);
                                        }
                                      },
                                    ),
                                  ),
                                )
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text("Max. počet reálných hostů:",
                                    style: Vzhled.fieldNadpis),
                                const SizedBox(
                                  width: 20,
                                ),
                                SizedBox(
                                  width: 100,
                                  child: TextField(
                                    inputFormatters: [
                                      FilteringTextInputFormatter.digitsOnly
                                    ],
                                    onChanged: (value) {
                                      if (value.isNotEmpty) {
                                        maxPocetRealnych = int.parse(value);
                                      }
                                    },
                                  ),
                                )
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text("Chytákový režim:",
                                    style: Vzhled.fieldNadpis),
                                const SizedBox(
                                  width: 20,
                                ),
                                Tooltip(
                                    message:
                                        "Garantuje 20% šanci na subnet, který bude mít počet reálných hostů 64, 128 atp.",
                                    child: Checkbox(
                                      value: chytakovyMod,
                                      onChanged: (value) {
                                        setState(() {
                                          chytakovyMod = value ?? false;
                                        });
                                      },
                                    ))
                              ],
                            ),
                          ],
                        ),
                      ),
                      TextButton(
                          onPressed: () => generuj(),
                          style: Vzhled.tlacitkoStyl,
                          child: const Text(
                            "Generuj příklad",
                            style: Vzhled.tlacitkoText,
                          )),
                      const Divider(
                        height: 20,
                      ),
                      Text(
                        "Parametry pro řešitel",
                        style: Vzhled.nadpis,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Zadaná (originální) síť:",
                            style: Vzhled.fieldNadpis,
                          ),
                          SizedBox(
                            width: 30.w,
                            child: TextField(
                              onChanged: (value) {
                                origoIp = value;
                              },
                              controller: _origoController,
                            ),
                          )
                        ],
                      ),
                      ...content,
                    ],
                  )
                ],
              ),
            ),
          ),
        ));
  }

  final chytaky = [64, 128, 32, 16, 8, 4];
  void generovatSubnetFieldy(int pocet, {List<int>? hodnoty}) {
    if (pocet > Util.alphabet.length - 1) return;
    content = [];
    subnety = hodnoty ?? [];
    for (var i = 0; i < pocet; i++) {
      if (subnety.length == i) subnety.add(40); // dummy hodnoty
      content.add(Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            Util.alphabet[i],
            style: Vzhled.fieldNadpis,
          ),
          SizedBox(
            width: 30.w,
            child: Tooltip(
              message: "Počet reálných hostů",
              child: TextField(
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                onChanged: (value) {
                  subnety[i] = int.parse(value);
                },
                controller: TextEditingController(text: subnety[i].toString()),
              ),
            ),
          )
        ],
      ));
    }
    content.add(const SizedBox(
      height: 30,
    ));
    content.add(Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text("Počet subnetů:", style: Vzhled.fieldNadpis),
        const SizedBox(
          width: 20,
        ),
        SizedBox(
          width: 100,
          child: Tooltip(
            message: "Maximální počet: ${Util.alphabet.length - 1}",
            child: TextField(
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              onChanged: (value) {
                if (value.isNotEmpty) {
                  generovatSubnetFieldy(int.parse(value));
                }
              },
              controller: TextEditingController(text: pocet.toString()),
            ),
          ),
        )
      ],
    ));
    content.add(const SizedBox(
      height: 20,
    ));
    content.add(
      TextButton(
          onPressed: () {
            var checkIp =
                RegExp(r'(\d){1,3}\.(\d){1,3}\.(\d){1,3}\.(\d){1,3}\/\d{1,2}')
                    .hasMatch(_origoController.text);
            if (!checkIp) {
              ScaffoldMessenger.of(context).clearSnackBars();
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    "Nezadali jste platný tvar IP adresy a masky.",
                    style: TextStyle(fontSize: 12.sp),
                  ),
                ),
              );
              return;
            }
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (c) => Reseni(
                        origoIp: _origoController.text, subnety: subnety)));
          },
          style: Vzhled.tlacitkoStyl,
          child: const Text(
            "Vyřešit příklad",
            style: Vzhled.tlacitkoText,
          )),
    );
    setState(() {});
  }

  void generuj() {
    if (pocetSubnetu == 0 || maxPocetRealnych == 0) {
      ScaffoldMessenger.of(context).clearSnackBars();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            "Nezadali jste platné údaje pro generátor.",
            style: TextStyle(fontSize: 12.sp),
          ),
        ),
      );
    }
    Random rnd = Random();
    // vytvořit zdrojovou IP
    var ip = "";
    for (var i = 0; i < 4; i++) {
      var p = rnd.nextInt(254) + 1;
      ip += p.toString();
      if (i != 3) ip += ".";
    }
    // vytvořit subnet data
    var subnetData = <int>[];
    for (var i = 0; i < pocetSubnetu; i++) {
      if (chytakovyMod) {
        var sance = rnd.nextInt(4) + 1;
        if (sance == 1) {
          subnetData.add(chytaky[rnd.nextInt(chytaky.length)]);
          continue;
        }
      }
      subnetData.add(rnd.nextInt(maxPocetRealnych) + 2);
    }
    // vložit
    _origoController.text = "$ip/22";
    generovatSubnetFieldy(pocetSubnetu, hodnoty: subnetData);
  }
}
