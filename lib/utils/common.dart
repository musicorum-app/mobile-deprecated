import 'package:flutter/material.dart';
import 'package:musicorum/constants/common.dart';
import 'package:palette_generator/palette_generator.dart';
import 'package:tinycolor/tinycolor.dart';

class CommonUtils {
   static double convertRanges(double value, double yMin, double yMax, double xMin, double xMax) {
     return ((value - yMin) / (yMax - yMin)) * (xMax - xMin) + xMin + .0;
   }

   static Color getDarkPredominantColor(PaletteGenerator generator, [Color defaultColor = Colors.white]) {
     if (generator == null) return defaultColor;
     print(generator.darkVibrantColor);
     if (generator.darkVibrantColor != null)
       return generator.darkVibrantColor.color;
     PaletteColor vibrant = generator.vibrantColor;
     if (vibrant == null) {
       if (generator.darkMutedColor != null)
         return generator.darkMutedColor.color;
       return defaultColor;
     }
     double brightness = vibrant.color.toTinyColor().getBrightness();
     print('BRIG: $brightness');
     double brightnessNormalized = CommonUtils.convertRanges(
         brightness.toDouble(), 0.0, 255.0, 0.0, 100.0);
     if (brightnessNormalized > LIGHTNESS_LIMIT) {
       print(brightnessNormalized);
       print(vibrant.color
           .toTinyColor()
           .darken((brightnessNormalized - LIGHTNESS_LIMIT).toInt())
           .getBrightness());
       print(CommonUtils.convertRanges(
           vibrant.color
               .toTinyColor()
               .darken((brightnessNormalized - LIGHTNESS_LIMIT).toInt())
               .getBrightness(),
           0,
           255,
           0,
           100));
       return vibrant.color
           .toTinyColor()
           .darken((brightnessNormalized - LIGHTNESS_LIMIT).toInt())
           .color;
     }
     return vibrant.color;
   }

   static Future<Color> getDarkPredominantColorFromImageProvider(ImageProvider image, [Color defaultColor]) async {
     var paletteGenerator = await PaletteGenerator.fromImageProvider(
         image,
         maximumColorCount: 20);
     return CommonUtils.getDarkPredominantColor(paletteGenerator);
   }
}