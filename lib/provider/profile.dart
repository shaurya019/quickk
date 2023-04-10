import 'package:get/get.dart';

// import '../baseurl.dart';

class Provider extends GetConnect {
  @override
  void onInit() {
    httpClient.baseUrl = 'YOUR-API-URL';
  }

  Future<dynamic> aboutus() async {
    var res = await get('https://quickk.co.in/Home/about', headers: {
      "Accept": "application/json",
    });
    if (res.statusCode == 200 || res.statusCode == 201) {
      return res.body;
    } else if (res.unauthorized) {
      return Future.error(res.body);
    } else {
      print(res.statusText);
      return Future.error('Network Problem');
    }
  }

  Future<dynamic> tc() async {
    var res = await get('https://quickk.co.in/home/tc', headers: {
      "Accept": "application/json",
    });
    if (res.statusCode == 200 || res.statusCode == 201) {
      return res.body;
    } else if (res.unauthorized) {
      return Future.error(res.body);
    } else {
      print(res.statusText);
      return Future.error('Network Problem');
    }
  }

  Future<dynamic> contact() async {
    // httpClient.baseUrl = "https://quickk.frantic.in/home/contact";

    // final form = FormData(formData);
    var res = await get("https://quickk.co.in/home/contact", headers: {
      "Accept": "application/json",
    });
    if (res.statusCode == 200 || res.statusCode == 201) {
      return res.body;
    } else if (res.unauthorized) {
      return Future.error(res.body);
    } else {
      print(res.statusText);
      return Future.error('Network Problem');
    }
  }
}
