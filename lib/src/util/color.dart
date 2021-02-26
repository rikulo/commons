//Copyright (C) 2012 Potix Corporation. All Rights Reserved.
//History: Tue, Sep 4, 2012 12:43:16 AM
//Author: simonpai

part of rikulo_util;

/** An RGB based color object. The toString method returns a CSS-compatible color value.
 */
class Color {
  /** Construct a Color object with given RGB and alpha (i.e., opacity) values.
   * 
   * + [red], [green], [blue] should be numbers between 0 (inclusive) and 255 
   * (inclusive);
   * + [alpha] should be a number between 0 (inclusive) and 1 (inclusive).
   * Default: 1
   */
  const Color(num red, num green, num blue, [num alpha = 1]) : 
  this.red = red, this.green = green, this.blue = blue, this.alpha = alpha;
  
  /// The red component.
  final num red;
  
  /// The green component.
  final num green;
  
  /// The blue component.
  final num blue;
  
  /// The opacity of color.
  final num alpha;
  
  /// Convert to [HsvColor].
  HsvColor hsv() {
    final num mx = max(max(red, green), blue), 
        mn = min(min(red, green), blue), ch = mx - mn;
    final int lead = red > green ? 
        (red > blue ? 0 : 2) : (green > blue ? 1 : 2);
    final num hue = 60 * (ch == 0 ? 0 : 
      lead == 0 ? ((green - blue) / ch) % 6 : 
      lead == 1 ? (blue - red) / ch + 2 : (red - green) / ch + 4);
    final num val = mx  / 255;
    final num sat = mx == 0 ? 0 : ch / mx;
    return HsvColor(hue, sat, val, alpha);
  }
  ///Convert to [HslColor]
  HslColor hsl() {
    throw UnsupportedError("TODO");
  }
  
  /** Parses the color code as a Color literal and returns its value. Example,
   *
   *     Color.parse("#ffe");
   *     Color.parse("#73b5a9");
   *     Color.parse("white");
   *     Color.parse("rgba(100, 80, 100%, 0.5)");
   *     Color.parse("hsl(100, 65%, 100%, 0.5)");
   *
   * Notice: it recognized 17 standard colors:
   * aqua, black, blue, fuchsia, gray, grey, green, lime, maroon, navy, olive, purple, red, silver, teal, white, and yellow.
   */
  static Color parse(String colorCode) {
    final len = (colorCode = colorCode.trim()).length;
    try {
      if (colorCode.codeUnitAt(0) == 35) { //#
        final step = len <= 4 ? 1: 2;
        List<int> rgb = [0, 0, 0];
        for (int i = 1, j = 0; i < len && j < 3; i += step, ++j) {
          rgb[j] = int.parse(colorCode.substring(i, i + step), radix: 16);
          if (step == 1)
            rgb[j] = (rgb[j] * 255) ~/ 15;
        }
        return Color(rgb[0], rgb[1], rgb[2]);
      } else {
        final k = colorCode.indexOf('(');
        if (k >= 0) {
          List<num> val = [0, 0, 0, 1];
          List<bool> hundredth = [false, false, false, false];
  
          int i = colorCode.indexOf(')', k + 1);
          final args = (i >= 0 ? colorCode.substring(k + 1, i): colorCode.substring(k + 1)).split(',');
          for (i = 0; i < 4 && i < args.length; ++i) {
            String arg = args[i].trim();
            hundredth[i] = arg.endsWith("%");
            if (hundredth[i])
              arg = arg.substring(0, arg.length - 1).trim();
            val[i] = arg.contains('.') ? double.parse(arg): int.parse(arg);
          }

          final type = colorCode.substring(0, k).trim().toLowerCase();
          switch (type) {
            case "rgb":
            case "rgba":
              if (hundredth[3])
                val[3] = val[3] / 100;
              for (int i = 0; i < 3; ++i)
                if (hundredth[i])
                  val[i] = (255 * val[i]) ~/ 100;
              return Color(val[0], val[1], val[2], val[3]);

            case "hsl":
            case "hsla":
            case "hsv":
            case "hsva":
              if (hundredth[0])
                val[0] = (360 * val[0]) / 100;
              for (int i = 1; i < 4; ++i)
                if (hundredth[i])
                  val[i] /= 100;
              return type.startsWith("hsl") ?
                HslColor(val[0], val[1], val[2], val[3]):
                HsvColor(val[0], val[1], val[2], val[3]);
          }
        } else {
          final color = _stdcolors[colorCode.toLowerCase()];
          if (color != null)
            return color;
        }
      }
    } catch (e) {
      throw FormatException(colorCode);
    }
    throw FormatException(colorCode);
  }

  @override
  int get hashCode => red.hashCode ^ green.hashCode ^ blue.hashCode ^ alpha.hashCode;
  @override
  bool operator==(o)
  => o is Color && o.red == red && o.green == green && o.blue == blue && o.alpha == alpha;
  @override
  String toString() =>
      alpha == 1 ? "#${_hex(red)}${_hex(green)}${_hex(blue)}" : 
      "rgba($red, $green, $blue, $alpha)";
  
}
// helper //
String _hex(num n) => n.toInt().toRadixString(16);

/** An HSL based color object.
 *
 * Notice, although [HslColor] also implements [Color], [red], [green] and [blue] are calculated
 * when called. For better performance, you shall use [rgb] to convert it to [Color] and
 * access the converted [Color] if you have to access [red], [green] and/or [blue] multiple
 * times.
 */
class HslColor implements Color {
  
  /** Construct a Color object with given HSV and alpha (i.e., opacity) values.
   * 
   * + [hue] should be a number between 0 (inclusive) and 360 (exclusive).
   * + [saturation] and [lightness] should be numbers between 0 (inclusive) and 
   * 1 (inclusive).
   * + [alpha] should be a number between 0 (inclusive) and 1 (inclusive).
   * Default: 1
   */
  const HslColor(num hue, num saturation, num lightness, [num alpha = 1]) : 
  this.hue = hue, this.saturation = saturation, this.lightness = lightness, this.alpha = alpha;
  
  /// The hue of the color.
  final num hue;
  
  /// The saturation of the color.
  final num saturation;
  
  /// The lightness of the color.
  final num lightness;
  
  /// The opacity of color.
  @override
  final num alpha;
  
  /// The red component.
  ///Note: it is a shortcut of `rgb().red`, so the performance might not be good
  @override
  num get red => rgb().red;
  /// The green component.
  ///Note: it is a shortcut of `rgb().green`, so the performance might not be good
  @override
  num get green => rgb().green;
  /// The blue component.
  ///Note: it is a shortcut of `rgb().blue`, so the performance might not be good
  @override
  num get blue => rgb().blue;
  @override
  HslColor hsl() => this;

  /// Convert to RGB based [Color].
  Color rgb() {
    throw UnsupportedError("TODO");
  }
  ///Convert to [HsvColor]
  @override
  HsvColor hsv() {
    throw UnsupportedError("TODO");
  }

  @override
  int get hashCode => hue.hashCode ^ saturation.hashCode ^ lightness.hashCode ^ alpha.hashCode;
  @override
  bool operator==(o)
  => o is HslColor && o.hue == hue && o.saturation == saturation && o.lightness == lightness && o.alpha == alpha;
  @override
  String toString() => "hsl($hue, $saturation, $lightness, $alpha)";
}

/** An HSV based color object.
 *
 * Notice, although [HsvColor] also implements [Color], [red], [green] and [blue] are calculated
 * when called. For better performance, you shall use [rgb] to convert it to [Color] and
 * access the converted [Color] if you have to access [red], [green] and/or [blue] multiple
 * times.
 */
class HsvColor implements Color {
  
  /** Construct a Color object with given HSV and alpha (i.e., opacity) values.
   * 
   * + [hue] should be a number between 0 (inclusive) and 360 (exclusive).
   * + [saturation] and [value] should be numbers between 0 (inclusive) and 
   * 1 (inclusive).
   * + [alpha] should be a number between 0 (inclusive) and 1 (inclusive).
   * Default: 1
   */
  const HsvColor(num hue, num saturation, num value, [num alpha = 1]) : 
  this.hue = hue, this.saturation = saturation, this.value = value, this.alpha = alpha;
  
  /// The hue of the color.
  final num hue;
  
  /// The saturation of the color.
  final num saturation;
  
  /// The value of the color.
  final num value;
  
  /// The opacity of color.
  @override
  final num alpha;
  
  /// The red component.
  ///Note: it is a shortcut of `rgb().red`, so the performance might not be good
  @override
  num get red => rgb().red;
  /// The green component.
  ///Note: it is a shortcut of `rgb().green`, so the performance might not be good
  @override
  num get green => rgb().green;
  /// The blue component.
  ///Note: it is a shortcut of `rgb().blue`, so the performance might not be good
  @override
  num get blue => rgb().blue;
  @override
  HsvColor hsv() => this;

  /// Convert to RGB based [Color].
  Color rgb() {
    final num ch = value * saturation, h2 = hue / 60, 
        x = ch * (1 - (h2 % 2 - 1).abs()), m = value - ch;
    num r = 0, g = 0, b = 0;
    if (h2 < 1) {
      r = ch; g = x;
    } else if (h2 < 2) {
      r = x; g = ch;
    } else if (h2 < 3) {
      g = ch; b = x;
    } else if (h2 < 4) {
      g = x; b = ch;
    } else if (h2 < 5) {
      b = ch; r = x;
    } else {
      b = x; r = ch;
    }
    return Color((r + m) * 255, (g + m) * 255, (b + m) * 255, alpha);
  }
  ///Convert to [HslColor]
  @override
  HslColor hsl() {
    throw UnsupportedError("TODO");
  }

  @override
  int get hashCode => hue.hashCode ^ saturation.hashCode ^ value.hashCode ^ alpha.hashCode;
  @override
  bool operator==(o)
  => o is HsvColor && o.hue == hue && o.saturation == saturation && o.value == value && o.alpha == alpha;
  @override
  String toString() => "hsv($hue, $saturation, $value, $alpha)";
}

///The white color
const black = Color(0, 0, 0);
///The black color
const white = Color(0xff, 0xff, 0xff);
const Map<String, Color>_stdcolors = {
  "aqua": Color(0, 0xff, 0xff),
   "black": black,
   "blue": Color(0, 0, 0xff),
   "fuchsia": Color(0xff, 0, 0xff),
   "gray": Color(0x80, 0x80, 0x80),
   "grey": Color(0x80, 0x80, 0x80),
   "green": Color(0, 0x80, 0),
   "lime": Color(0, 0xff, 0),
   "maroon": Color(0x80, 0, 0),
   "navy": Color(0, 0, 0x80),
   "olive": Color(0x80, 0x80, 0),
   "purple": Color(0x80, 0, 0x80),
   "red": Color(0xff, 0, 0),
   "silver": Color(0xc0, 0xc0, 0xc0),
   "teal": Color(0, 0x80, 0x80),
   "white": white,
   "yellow": Color(0xff, 0xff, 0)
};