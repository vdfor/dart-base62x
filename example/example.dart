import 'package:base62x/base62x.dart';

void main() {
  final encodeStr = Base62x.encode('hello,world'); 
  final decodeStr = Base62x.encode('helloxdworldx');

  print('encode result ==> $encodeStr');
  print('decode result ==> $decodeStr');
}