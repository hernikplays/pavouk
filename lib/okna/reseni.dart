import 'package:flutter/material.dart';
import 'package:pavouk/util/appbar.dart';
import 'package:pavouk/util/subnet_masky.dart';
import 'package:pavouk/util/vzhled.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class Reseni extends StatefulWidget {
  const Reseni({super.key, required this.origoIp, required this.subnety});
  final String origoIp;
  final List<int> subnety;

  @override
  State<Reseni> createState() => _ReseniState();
}

class _ReseniState extends State<Reseni> {
  var origoNetIP = "";
  var content = <TableRow>[
    TableRow(children: [
      TableCell(
        child: Text(
          "Název",
          style: Vzhled.text,
          textAlign: TextAlign.center,
        ),
      ),
      TableCell(
        child: Text("Požadovaný počet zařízení",
            style: Vzhled.text, textAlign: TextAlign.center),
      ),
      TableCell(
        child: Text("Reálný počet zařízení",
            style: Vzhled.text, textAlign: TextAlign.center),
      ),
      TableCell(
        child: Text("Adresa sítě",
            style: Vzhled.text, textAlign: TextAlign.center),
      ),
      TableCell(
        child: Text("Prefix masky",
            style: Vzhled.text, textAlign: TextAlign.center),
      ),
      TableCell(
        child: Text("Adresa prvního zařízení",
            style: Vzhled.text, textAlign: TextAlign.center),
      ),
      TableCell(
        child: Text("Adresa posledního zařízení",
            style: Vzhled.text, textAlign: TextAlign.center),
      ),
      TableCell(
        child: Text("Adresa broadcastu",
            style: Vzhled.text, textAlign: TextAlign.center),
      ),
    ])
  ];

  @override
  void initState() {
    super.initState();
    var p = widget.origoIp.split("/");
    var nm = p[1];
    origoNetIP = "${Util.ipToNetworkAdd(p[0], Util.prefixToMask(nm))}/$nm";
    for (var i = 0; i < widget.subnety.length; i++) {
      content.add(TableRow(children: [
        TableCell(
          child: Text(Util.alphabet[i],
              style: Vzhled.text, textAlign: TextAlign.center),
        ),
        TableCell(
          child:
              Text(widget.subnety[i].toString(), textAlign: TextAlign.center),
        ),
        const TableCell(
          child: SizedBox(height: 50),
        ),
        const TableCell(
          child: SizedBox(height: 50),
        ),
        const TableCell(
          child: SizedBox(height: 50),
        ),
        const TableCell(
          child: SizedBox(height: 50),
        ),
        const TableCell(
          child: SizedBox(height: 50),
        ),
        const TableCell(
          child: SizedBox(height: 50),
        ),
      ]));
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: bar(context, i: 1),
      body: SingleChildScrollView(
        child: Center(
          child: SizedBox(
            width: (Device.orientation == Orientation.landscape) ? 90.w : 100.w,
            height: 100.h,
            child:
                Column(mainAxisAlignment: MainAxisAlignment.center, children: [
              const SizedBox(
                height: 30,
              ),
              TextButton(
                onPressed: () => ukaz(),
                style: Vzhled.tlacitkoStyl,
                child: const Text(
                  "Ukázat řešení",
                  style: Vzhled.tlacitkoText,
                ),
              ),
              const SizedBox(
                height: 30,
              ),
              Row(
                children: [
                  Text(
                    "Zadaná IP:",
                    style: Vzhled.tableContent,
                  ),
                  const SizedBox(
                    width: 20,
                  ),
                  Text(origoNetIP, style: Vzhled.tableContent)
                ],
              ),
              DefaultTextStyle(
                style: Vzhled.tableContent,
                child: Expanded(
                  child: Table(
                    border: TableBorder.all(),
                    defaultVerticalAlignment: TableCellVerticalAlignment.middle,
                    defaultColumnWidth: FixedColumnWidth(
                        Device.orientation == Orientation.landscape
                            ? 90.w / 8
                            : 100.w / 8),
                    children: content,
                  ),
                ),
              )
            ]),
          ),
        ),
      ),
    );
  }

  void ukaz() {
    // Resetovat obsah
    content = <TableRow>[
      TableRow(children: [
        TableCell(
          child: Text(
            "Název",
            style: Vzhled.text,
            textAlign: TextAlign.center,
          ),
        ),
        TableCell(
          child: Text("Požadovaný počet zařízení",
              style: Vzhled.text, textAlign: TextAlign.center),
        ),
        TableCell(
          child: Text("Reálný počet zařízení",
              style: Vzhled.text, textAlign: TextAlign.center),
        ),
        TableCell(
          child: Text("Adresa sítě",
              style: Vzhled.text, textAlign: TextAlign.center),
        ),
        TableCell(
          child: Text("Prefix masky",
              style: Vzhled.text, textAlign: TextAlign.center),
        ),
        TableCell(
          child: Text("Adresa prvního zařízení",
              style: Vzhled.text, textAlign: TextAlign.center),
        ),
        TableCell(
          child: Text("Adresa posledního zařízení",
              style: Vzhled.text, textAlign: TextAlign.center),
        ),
        TableCell(
          child: Text("Adresa broadcastu",
              style: Vzhled.text, textAlign: TextAlign.center),
        ),
      ])
    ];

    // seřazení
    var kopie = [];
    kopie.addAll(widget.subnety);
    widget.subnety.sort((a, b) => b.compareTo(a));

    var iplist = [];
    for (var i = 0; i < widget.subnety.length; i++) {
      var sub = Util.subnety(); // načíst možné subnet masky
      var ip = "";
      if (i == 0) {
        ip = origoNetIP.split("/")[0]; // na začátku nastavíme OG adresu
      } else {
        ip = zvysitIp(iplist[i -
            1]); // jinak nastavujeme předchozí adresu broadcastu o jedno větší
      }

      var prefix = sub.where((element) {
        var id = sub.indexOf(element);
        bool levo, pravo = false;
        // kontrolujeme, že zleva i zprava nejsou lepší hodnoty
        if (id > 0) {
          levo = (sub[id - 1]["hosti"]! - 2 <= widget.subnety[i]);
        } else {
          levo = true;
        }
        if (id < widget.subnety.length - 1) {
          pravo = (sub[id + 1]["hosti"]! - 2 >= widget.subnety[i]);
        } else {
          pravo = true;
        }
        if (levo && pravo) {
          return sub[id]["hosti"]! - 2 >=
              widget.subnety[
                  i]; // a zkontrolujeme že naše samotná hodnota je dostatečná
        } else {
          return false;
        }
      }).toList()[0];

      var prvni = zvysitIp(ip);
      var posledni = zvysitIp(ip);
      for (var j = 0; j < prefix["hosti"]! - 3; j++) {
        posledni = zvysitIp(posledni);
      }
      var broadcast = zvysitIp(posledni);
      iplist.add(broadcast);

      content.add(TableRow(children: [
        TableCell(
          child: Text(Util.alphabet[kopie.indexOf(widget.subnety[i])],
              style: Vzhled.text, textAlign: TextAlign.center),
        ),
        TableCell(
            child: Text(
          widget.subnety[i].toString(),
          textAlign: TextAlign.center,
        )),
        TableCell(
            child: Text((prefix["hosti"]! - 2).toString(),
                textAlign: TextAlign.center)),
        TableCell(
          child: Text(ip, textAlign: TextAlign.center),
        ),
        TableCell(
          child:
              Text(prefix["prefix"]!.toString(), textAlign: TextAlign.center),
        ),
        TableCell(
          child: Text(prvni, textAlign: TextAlign.center),
        ),
        TableCell(
          child: Text(posledni, textAlign: TextAlign.center),
        ),
        TableCell(
          child: Text(broadcast, textAlign: TextAlign.center),
        ),
      ]));
    }
    setState(() {});
  }

  String zvysitIp(String ip) {
    var p = ip.split(".");
    var p1 = int.parse(p[0]);
    var p2 = int.parse(p[1]);
    var p3 = int.parse(p[2]);
    var p4 = int.parse(p[3]);
    if (p4 == 255) {
      if (p3 == 255) {
        if (p2 == 255) {
          p1++;
          p2 = 0;
          p3 = 0;
          p4 = 0;
        } else {
          p2++;
          p3 = 0;
          p4 = 0;
        }
      } else {
        p3++;
        p4 = 0;
      }
    } else {
      p4++;
    }
    return "$p1.$p2.$p3.$p4";
  }
}
