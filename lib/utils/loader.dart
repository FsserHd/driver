
import 'package:loader_overlay/loader_overlay.dart';

import '../navigation/navigation_service.dart';

class Loader{

  static show(){
    return NavigationService.navigatorKey.currentContext?.loaderOverlay.show();
  }

  static hide(){
    return NavigationService.navigatorKey.currentContext?.loaderOverlay.hide();
  }

}