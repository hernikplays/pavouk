import 'dart:math';

class Util {
  static List<Map<String, int>> subnety() {
    var list = <Map<String, int>>[
      {
        "prefix": 30,
        "hosti": 4,
      }
    ];
    for (int i = 30; i > 8; i--) {
      list.add({"prefix": i - 1, "hosti": list[30 - i]["hosti"]! * 2});
    }
    return list;
  }

  static List<String> _strToBin(String input) {
    var list = <String>[];
    input.split(".").forEach((numero) {
      print(numero);
      var bin = int.parse(numero).toRadixString(2);
      while (bin.length < 8) {
        bin = "0$bin";
      }
      print(bin);
      list.add(bin);
    });
    return list;
  }

  static List<String> _binToStr(List<String> input) {
    var list = <String>[];
    for (var numero in input) {
      list.add(int.parse(numero, radix: 2).toString());
    }
    return list;
  }

  static String prefixToMask(String prefix) {
    var bin = "1" * int.parse(prefix);
    while (bin.length < 32) {
      bin += "0";
    }
    var match = RegExp(r"\d{8}").allMatches(bin);
    return _binToStr(match
            .map(
              (e) => e.group(0)!,
            )
            .toList())
        .join(".");
  }

  static String ipToNetworkAdd(String ip, String nm) {
    var nmBin = _strToBin(nm);
    print(nmBin);
    var ipBin = _strToBin(ip);
    print(ipBin);

    var networkAdd = <String>[];
    for (int i = 0; i < 4; i++) {
      var nmBinChar = nmBin[i].split("");
      var ipBinChar = ipBin[i].split("");
      var networkAddChar = <String>[];
      for (int j = 0; j < 8; j++) {
        if (nmBinChar[j] == "1" && ipBinChar[j] == "1") {
          networkAddChar.add(ipBinChar[j]);
        } else {
          networkAddChar.add("0");
        }
      }
      networkAdd.add(networkAddChar.join());
    }
    return _binToStr(networkAdd).join(".");
  }

  static const String alphabet = "ABCDEFGHIJKLMNOPQRSTUVWXYZ";
}
