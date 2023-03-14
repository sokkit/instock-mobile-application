import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:jwt_decode/jwt_decode.dart';

import '../../../utilities/objects/response_object.dart';
import '../../authentication/services/authentication_service.dart';
import '../data/item.dart';

class ItemService {
  Future<List<Item>> getItems(http.Client client) async {
    var tokenDict = await AuthenticationService.retrieveBearerToken();
    var token = tokenDict["bearerToken"];
    Map<String, dynamic> payload = Jwt.parseJwt(token);

    String businessId = payload["BusinessId"];

    final uri = Uri.parse(
        'http://api.instockinventory.co.uk/businesses/$businessId/items');
    final response = await client.get(
      uri,
      headers: {
        HttpHeaders.authorizationHeader: 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      var jsonData = json.decode(response.body);
      List<Item> items = [];

      for (var itemJson in jsonData) {
        Item item = Item.fromJson(itemJson);
        items.add(item);
      }
      items.sort((a, b) => a.category.compareTo(b.category));
      return items;
    } else {
      throw Exception('Failed to load items');
    }
  }

  Future<ResponseObject> addItem(String name, String category, String stockLevel, String sku) async {
    var tokenDict = await AuthenticationService.retrieveBearerToken();
    var token = tokenDict["bearerToken"];
    Map<String, dynamic> payload = Jwt.parseJwt(token);

    String businessId = payload["BusinessId"];

    final url = Uri.parse('http://api.instockinventory.co.uk/businesses/$businessId/items');
    var data = Map<String, dynamic>();
    data['name'] = name;
    data['category'] = category;
    data['stock'] = stockLevel;
    data['sku'] = sku;

    var body = json.encode(data);

    final response = await http.post(
        url,
        headers: {
          HttpHeaders.authorizationHeader: 'Bearer $token',
          "Content-Type": "application/json"
        },
        body: body
    );

    ResponseObject responseObject =
    ResponseObject(response.statusCode, response.body);

    return (responseObject);
  }
}
