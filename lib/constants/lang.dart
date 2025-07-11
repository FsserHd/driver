
import 'package:flutter/cupertino.dart';

import '../language/app_localizations.dart';


class S{

  static of(BuildContext context,String value){
    return AppLocalizations.of(context).translate(value);
  }
}