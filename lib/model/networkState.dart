  import 'package:connectivity/connectivity.dart';
class NetworkState {
 static bool _result = false;

  static Future<void> state() async{
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.mobile || connectivityResult == ConnectivityResult.wifi) {
     _result = true;
    } else {
      _result = false;
    }

    }
 static bool status(){
    return _result;
 }
}
