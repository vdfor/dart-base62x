import 'dart:convert';
import 'dart:typed_data';

class Base62x {
  Map<String, dynamic> config = {
    'xtag': 'x',
    'encd': '-enc',
    'decd': '-dec',
    'debg': 'v',
    'cvtn': '-n',
    'b62x': [
      '0',
      '1',
      '2',
      '3',
      '4',
      '5',
      '6',
      '7',
      '8',
      '9',
      'A',
      'B',
      'C',
      'D',
      'E',
      'F',
      'G',
      'H',
      'I',
      'J',
      'K',
      'L',
      'M',
      'N',
      'O',
      'P',
      'Q',
      'R',
      'S',
      'T',
      'U',
      'V',
      'W',
      'X',
      'Y',
      'Z',
      'a',
      'b',
      'c',
      'd',
      'e',
      'f',
      'g',
      'h',
      'i',
      'j',
      'k',
      'l',
      'm',
      'n',
      'o',
      'p',
      'q',
      'r',
      's',
      't',
      'u',
      'v',
      'w',
      'y',
      'z',
      '1',
      '2',
      '3',
      'x'
    ],
    'bpos': 60,
    'xpos': 64,
    'ascmax': 127,
    'asclist': [
      '4',
      '5',
      '6',
      '7',
      '8',
      '9',
      '0',
      'A',
      'B',
      'C',
      'D',
      'E',
      'F',
      'G',
      'H',
      'I',
      'J',
      'K',
      'L',
      'M',
      'N',
      'O',
      'P',
      'Q',
      'R',
      'S',
      'T',
      'U',
      'V',
      'W',
      'X',
      'Y',
      'Z',
      'a',
      'b',
      'c',
      'd',
      'e',
      'f',
      'g',
      'h',
      'i',
      'j',
      'k',
      'l',
      'm',
      'n',
      'o',
      'p',
      'q',
      'r',
      's',
      't',
      'u',
      'v',
      'w',
      'y',
      'z'
    ],
    'ascidx': [],
    'ascrlist': {},
    'max_safe_base': 36,
    'ver': 1.0,
    'base59': 59,
  };

  Base62xUtil() {
    //
  }

  dynamic getItem(String k) {
    return config[k];
  }

  Map<String, int> fillRb62x(
      {required List<String> b62x, required int bpos, required int xpos}) {
    Map<String, int> rb62x = {};
    for (var i = 0; i <= xpos; i++) {
      if (!(i > bpos && i < xpos)) {
        rb62x[b62x[i]] = i;
      }
    }
    return rb62x;
  }

  Map<String, dynamic> setAscii(
      {required int codetype,
      required List<int> inputArr,
      required List<dynamic> ascidx,
      required int ascmax,
      required List<String> asclist,
      required Map<String, int> ascrlist}) {
    Map<String, dynamic> rtn = {};
    int rtnAsctype = 0;
    List<dynamic> rtnAscidx = [...ascidx]; // String | -1
    Map<String, int> rtnAscrlist = {...ascrlist};
    final xtag = getItem('xtag') as String;
    final ixtag = xtag.codeUnitAt(0);
    final inputlen = inputArr.length;
    if (codetype == 0 && inputArr[0] <= ascmax) {
      rtnAsctype = 1;
      var tmpi = 0;
      for (var i = 1; i < inputlen; i++) {
        tmpi = inputArr[i];
        if (tmpi > ascmax ||
            (tmpi > 16 && tmpi < 21) //DC1-4
            ||
            (tmpi > 27 && tmpi < 32)) {
          //FC, GS, RS, US
          rtnAsctype = 0;
          break;
        }
      }
    } else if (codetype == 1 && inputArr[inputlen - 1] == ixtag) {
      rtnAsctype = 1;
    }
    rtn['asctype'] = rtnAsctype;
    if (rtnAsctype == 1) {
      for (var i = 0; i < ascmax; i++) {
        if (rtnAscidx.length >= i + 1) {
          rtnAscidx[i] = -1;
        } else {
          rtnAscidx.add(-1);
        }
      }
      int idxi = 0;
      final bgnArr = [0, 21, 32, 58, 91, 123];
      final endArr = [17, 28, 48, 65, 97, ascmax + 1];
      bgnArr.asMap().entries.forEach((element) {
        final k = element.key;
        var v1 = bgnArr[k];
        var v2 = endArr[k];
        for (var i = v1; i < v2; i++) {
          if (rtnAscidx.length >= i + 1) {
            rtnAscidx[i] = asclist[idxi];
          } else {
            rtnAscidx.add(asclist[idxi]);
          }
          rtnAscrlist[asclist[idxi]] = i;
          idxi++;
        }
      });
    }
    rtn['ascidx'] = rtnAscidx;
    rtn['ascrlist'] = rtnAscrlist;
    return rtn;
  }

  List<int> decodeByLength(
      {required List<int?> tmpArr, required List<int> op}) {
    final s0 = tmpArr[0];
    final s1 = tmpArr[1];
    final s2 = tmpArr.length <= 2 ? null : tmpArr[2];
    final s3 = tmpArr.length <= 3 ? null : tmpArr[3];
    var c0 = 0;
    var c1 = 0;
    var c2 = 0;
    List<int> _op = [...op];
    if (s3 != null) {
      c0 = s0! << 2 | s1! >> 4;
      c1 = ((s1 << 4) & 0xf0) | (s2! >> 2);
      c2 = ((s2 << 6) & 0xff) | s3;
      _op.add(c0);
      _op.add(c1);
      _op.add(c2);
    } else if (s2 != null) {
      c0 = s0! << 2 | s1! >> 4;
      c1 = ((s1 << 4) & 0xf0) | s2;
      _op.add(c0);
      _op.add(c1);
    } else if (s1 != null) {
      c0 = s0! << 2 | s1;
      _op.add(c0);
    } else {
      c0 = s0!;
      _op.add(c0);
    }
    return _op;
  }

  String _encode(String input) {
    String rtn = '';
    if (input.trim() == '') {
      return rtn;
    }
    int codetype = 0;
    final xtag = getItem('xtag') as String;
    final b62x = getItem('b62x') as List<String>;
    final asclist = getItem('asclist') as List<String>;
    Map<String, int> ascrlist = {};
    final bpos = getItem('bpos') as int;
    var ascidx = getItem('ascidx') as List<dynamic>; // String or -1
    final ascmax = getItem('ascmax') as int;
    final inputArr = Uint8List.fromList(utf8.encode(input)).toList();
    final inputlen = inputArr.length;
    final setResult = setAscii(
        codetype: codetype,
        inputArr: inputArr,
        ascidx: ascidx,
        ascmax: ascmax,
        asclist: asclist,
        ascrlist: ascrlist);
    final asctype = setResult['asctype'];
    ascidx = setResult['ascidx'];
    ascrlist = setResult['ascrlist'];
    var op = [];
    var i = 0;
    if (asctype == 1) {
      var ixtag = xtag.codeUnitAt(0);
      do {
        if (ascidx[inputArr[i]] != -1) {
          op.addAll([xtag, ascidx[inputArr[i]]]);
        } else if (inputArr[i] == ixtag) {
          op.addAll([xtag, xtag]);
        } else {
          op.add(String.fromCharCode(inputArr[i]));
        }
      } while (++i < inputlen);
      op.add(xtag);
    } else {
      var c0 = 0;
      var c1 = 0;
      var c2 = 0;
      var c3 = 0;
      var remaini = 0;
      do {
        remaini = inputlen - i;
        if (remaini > 2) {
          c0 = inputArr[i] >> 2;
          c1 = (((inputArr[i] << 6) & 0xff) >> 2) | (inputArr[i + 1] >> 4);
          c2 = (((inputArr[i + 1] << 4) & 0xff) >> 2) | (inputArr[i + 2] >> 6);
          c3 = ((inputArr[i + 2] << 2) & 0xff) >> 2;
          if (c0 > bpos) {
            op.addAll([xtag, b62x[c0]]);
          } else {
            op.add(b62x[c0]);
          }
          if (c1 > bpos) {
            op.addAll([xtag, b62x[c1]]);
          } else {
            op.add(b62x[c1]);
          }
          if (c2 > bpos) {
            op.addAll([xtag, b62x[c2]]);
          } else {
            op.add(b62x[c2]);
          }
          if (c3 > bpos) {
            op.addAll([xtag, b62x[c3]]);
          } else {
            op.add(b62x[c3]);
          }
          i += 2;
        } else if (remaini == 2) {
          c0 = inputArr[i] >> 2;
          c1 = (((inputArr[i] << 6) & 0xff) >> 2) | (inputArr[i + 1] >> 4);
          c2 = ((inputArr[i + 1] << 4) & 0xff) >> 4;
          if (c0 > bpos) {
            op.addAll([xtag, b62x[c0]]);
          } else {
            op.add(b62x[c0]);
          }
          if (c1 > bpos) {
            op.addAll([xtag, b62x[c1]]);
          } else {
            op.add(b62x[c1]);
          }
          if (c2 > bpos) {
            op.addAll([xtag, b62x[c2]]);
          } else {
            op.add(b62x[c2]);
          }
          i += 1;
        } else {
          // ==1
          c0 = inputArr[i] >> 2;
          c1 = ((inputArr[i] << 6) & 0xff) >> 6;
          if (c0 > bpos) {
            op.addAll([xtag, b62x[c0]]);
          } else {
            op.add(b62x[c0]);
          }
          if (c1 > bpos) {
            op.addAll([xtag, b62x[c1]]);
          } else {
            op.add(b62x[c1]);
          }
        }
      } while (++i < inputlen);
    }
    rtn = op.join('');
    return rtn;
  }

  String _decode(String input) {
    String rtn = '';
    if (input.trim() == '') {
      return rtn;
    }
    var codetype = 1;
    final xtag = getItem('xtag') as String;
    final b62x = getItem('b62x') as List<String>;
    final asclist = getItem('asclist') as List<String>;
    Map<String, int> ascrlist = {};
    final bpos = getItem('bpos') as int;
    final xpos = getItem('xpos') as int;
    var ascidx = getItem('ascidx') as List<dynamic>; // String or -1
    final ascmax = getItem('ascmax') as int;
    var rb62x = fillRb62x(b62x: b62x, bpos: bpos, xpos: xpos);
    final inputArr = Uint8List.fromList(utf8.encode(input)).toList();
    var inputlen = inputArr.length;
    final setResult = setAscii(
        codetype: codetype,
        inputArr: inputArr,
        ascidx: ascidx,
        ascmax: ascmax,
        asclist: asclist,
        ascrlist: ascrlist);
    final asctype = setResult['asctype'];
    ascidx = setResult['ascidx'];
    ascrlist = setResult['ascrlist'];
    var i = 0;
    final ixtag = xtag.codeUnitAt(0);
    if (asctype == 1) {
      final op = [];
      // ascii
      inputlen--; // pop the last one as 'x'
      var tmpc = '';
      do {
        if (inputArr[i] == ixtag) {
          if (inputArr[i + 1] == ixtag) {
            op.add(xtag);
            i++;
          } else {
            tmpc = String.fromCharCode(inputArr[++i]);
            op.add(String.fromCharCode(ascrlist[tmpc]!));
          }
        } else {
          op.add(String.fromCharCode(inputArr[i]));
        }
      } while (++i < inputlen);
      rtn = op.join('');
    } else {
      List<int> op = [];
      var bint = {1: 1, 2: 2, 3: 3};
      var remaini = 0;
      var rki = 0;
      var j = 0;
      Map<String, int> _rb62x = {};
      Map<int, int> _bint = {};
      for (var element in rb62x.entries) {
        final rk = element.key;
        rki = rk.codeUnitAt(0);
        _rb62x['$rki'] = element.value;
      }
      for (var element in bint.entries) {
        final rk = '${element.key}';
        rki = rk.codeUnitAt(0);
        _bint[rki] = element.value;
      }
      do {
        List<int?> tmpArr = [];
        remaini = inputlen - i;
        if (remaini > 1) {
          j = 0;
          do {
            if (inputArr[i] == ixtag) {
              i++;
              tmpArr.add(bpos + _bint[inputArr[i]]!);
            } else {
              tmpArr.add(_rb62x['${inputArr[i]}']);
            }
            i++;
            j++;
          } while (j < 4 && i < inputlen);
          op = decodeByLength(tmpArr: tmpArr, op: op);
        } else {
          i++;
          continue;
        }
      } while (i < inputlen);
      rtn = utf8.decode(Uint8List.fromList(op));
    }
    return rtn;
  }

  static String encode(String input) {
    return Base62x()._encode(input);
  }

  static String decode(String input) {
    return Base62x()._decode(input);
  }
}
