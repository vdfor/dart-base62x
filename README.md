# dart-base62x

[Base62x](https://ieeexplore.ieee.org/document/6020065/?arnumber=6020065) is an non-symbolic Base64 encoding scheme. It can be used safely in computer file systems, programming languages for data exchange, internet communication systems, etc, and it is an ideal substitute and successor of many variants of Base64 encoding scheme.

This dart implementation was inspired by [wadelau's polyglot Base62x repository](https://github.com/wadelau/Base62x).

[![Pub Package](https://img.shields.io/pub/v/base62x)](https://pub.dev/packages/base62x)

## Installation

```bash
flutter pub add base62x
```

## Usage

```dart
import 'package:base62x/base62x.dart';

final encodeStr = Base62x.encode('hello,world'); // helloxdworldx
final decodeStr = Base62x.encode('helloxdworldx'); // hello,world
```

## Api

Base62x.encode(String input) -> String

Base62x.decode(String input) -> String