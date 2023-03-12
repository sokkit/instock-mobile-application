import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../../../theme/common_theme.dart';
import '../services/inventory_service.dart';
import 'category_heading.dart';
import 'inventory_item.dart';

class InventoryBuilder extends StatelessWidget {
  const InventoryBuilder({
    super.key,
    required this.inventoryService,
    required this.theme,
  });

  final InventoryService inventoryService;
  final CommonTheme theme;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: inventoryService.getItems(http.Client()),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          print("=== COME ON ===");
          print(snapshot.data);
          if (snapshot.data == null) {
            print("=== STOP ===");
            return Center(
                child: CircularProgressIndicator(
              // backgroundColor: theme.themeData.splashColor,
              color: theme.themeData.splashColor,
            ));
          }
          if (snapshot.data.length == 0) {
            print("=== EMPTY ===");
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(15, 40, 15, 0),
                    child: Text(
                      "You don't have any items yet, go to Add Item to get started",
                      style: theme.themeData.textTheme.bodyLarge
                          ?.merge(const TextStyle(fontSize: 20)),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ],
              ),
            );
          }
          return ListView.builder(
              itemCount: snapshot.data.length,
              itemBuilder: (BuildContext context, int index) {
                bool isSameCategory = true;
                String category = snapshot.data[index].category;
                if (index == 0) {
                  return Padding(
                    padding: const EdgeInsets.fromLTRB(12, 8, 12, 8),
                    child: Column(
                      children: [
                        CategoryHeading(category: category),
                        InventoryItem(
                            itemName: snapshot.data[index].name,
                            itemCategory: snapshot.data[index].category,
                            itemSku: snapshot.data[index].sku,
                            itemStockNo: snapshot.data[index].stock,
                            itemOrdersNo: "N/A"),
                      ],
                    ),
                  );
                } else {
                  String prevCategory = snapshot.data[index - 1].category;
                  isSameCategory = prevCategory == category;
                }
                if (isSameCategory == true) {
                  return Padding(
                    padding: const EdgeInsets.fromLTRB(12, 8, 12, 8),
                    child: InventoryItem(
                        itemName: snapshot.data[index].name,
                        itemCategory: snapshot.data[index].category,
                        itemSku: snapshot.data[index].sku,
                        itemStockNo: snapshot.data[index].stock,
                        itemOrdersNo: "N/A"),
                  );
                } else if (isSameCategory == false) {
                  return Padding(
                    padding: const EdgeInsets.fromLTRB(12, 8, 12, 8),
                    child: Column(
                      children: [
                        CategoryHeading(category: category),
                        InventoryItem(
                            itemName: snapshot.data[index].name,
                            itemCategory: snapshot.data[index].category,
                            itemSku: snapshot.data[index].sku,
                            itemStockNo: snapshot.data[index].stock,
                            itemOrdersNo: "N/A"),
                      ],
                    ),
                  );
                }
                return null;
              });
        });
  }
}
