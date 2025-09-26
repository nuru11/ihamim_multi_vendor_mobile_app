import 'package:flutter/material.dart';


/// Main Color
Color green77() => const Color(0xff366ab6);
Color green91() => const Color(0xff1F3B64);
Color blue64() => const Color(0xff366ab6);
LinearGradient greenGradint() => LinearGradient(
  colors: [
    green77(),
    green91()
  ],
  begin: Alignment.bottomCenter,
  end: Alignment.topCenter
);

// use in drawer background color
Color green63 = const Color(0xff657ad1);

// grey Shade
Color grey33 = const Color(0xff260707);
Color grey3A = const Color(0xff008cff);
Color grey5E = const Color(0xff5E5E5E);
Color greyD0 = const Color(0xffABB7D0);
Color greyB2 = const Color(0xffA9AEB2);
Color greyA5 = const Color(0xffA5A5A5);
Color greyCF = const Color(0xffCFCFCF);
Color greyE7 = const Color(0xffE7E7E7);
Color greyF8 = const Color(0xffF8F8F8);
Color greyFA = const Color(0xffFAFAFA);
LinearGradient greyGradint = LinearGradient(
  colors: [
    Colors.black.withOpacity(.8),
    Colors.black.withOpacity(0),
  ],
  begin: Alignment.bottomCenter,
  end: Alignment.topCenter
);



// Semantics
Color red49 = const Color(0xffFF4949);
Color yellow29 = const Color(0xffFFC529);
Color orange50 = const Color(0xffFE7950);



// Semantics
Color green50 = const Color(0xff8FBF50);
Color green4B = const Color(0xff218F48);
Color green9D = const Color(0xff50BF9D);

Color cyan50 = const Color(0xff50BF9D);
Color blueFE = const Color(0xff5090FE);
Color blueA4 = const Color(0xff2849A4);
Color yellow4C = const Color(0xffFFCD4C);



// Color mainColor = const Color(0xFFF58634);
Color mainColor = const Color(0xFF38A001);
Color secondaryColor = const Color(0xFF404196);

Color secondaryColorTeal = const Color(0xFF34F5F5);
Color secondaryColorPurple = const Color(0xFFA334F5);
Color secondaryColorDeepBlue = const Color(0xFF344BF5);

Color backgroundColor = const Color.fromARGB(255, 236, 115, 115);




// Shadow
BoxShadow boxShadow(Color color,{int blur=20,int y=8,int x=0}){
  return BoxShadow(
    color: color,
    blurRadius: blur.toDouble(),
    offset: Offset(x.toDouble(), y.toDouble())
  );
}