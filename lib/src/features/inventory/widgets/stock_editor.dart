import 'package:expandable/expandable.dart';
import 'package:flutter/material.dart';
import 'package:instock_mobile/src/features/inventory/services/reason_for_change_enum.dart';
import 'package:instock_mobile/src/theme/common_theme.dart';
import 'package:instock_mobile/src/utilities/widgets/instock_button.dart';

class StockEditor extends StatefulWidget {
  StockEditor({super.key, required this.currentStock});

  int currentStock;

  @override
  State<StockEditor> createState() => _StockEditorState();
}

class _StockEditorState extends State<StockEditor> {
  int _changeStockAmountBy = 0;
  int _calculatedStockAmount = 0;
  ReasonForChange _reasonForChange = ReasonForChange.Sale;
  bool _isLoading = false;

  calculateNewStockAmount() {
    int totalStock = widget.currentStock + _changeStockAmountBy;
    setState(() {
      _calculatedStockAmount = totalStock;
    });
  }

  updateChangeStockAmountBy(int changeBy) {
    int newValue = _changeStockAmountBy + changeBy;
    setState(() {
      _changeStockAmountBy = newValue;
    });
  }

  bool determineIfSelected(ReasonForChange selectionOption) {
    if (selectionOption == _reasonForChange) {
      return true;
    }
    return false;
  }

  updateStock() {
    print("Updating");
    print(_reasonForChange.name);
    print(_calculatedStockAmount);
  }

  @override
  Widget build(BuildContext context) {
    calculateNewStockAmount();
    final theme = CommonTheme();
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: Column(
        children: <Widget>[
          Text(
            "In stock:",
            style: theme.themeData.textTheme.titleMedium,
          ),
          Text('${widget.currentStock}',
              style: theme.themeData.textTheme.headlineMedium),
          Text("${_changeStockAmountBy}",
              style: theme.themeData.textTheme.headlineMedium),
          SizedBox(
            width: 100,
            child: Divider(
              thickness: 1,
              height: 16,
              color: theme.themeData.primaryColorDark,
            ),
          ),
          Text("${_calculatedStockAmount}",
              style: theme.themeData.textTheme.headlineMedium),
          Padding(
            padding: const EdgeInsets.fromLTRB(0, 8.0, 0, 0),
            child: Row(
              children: [
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(4.0, 0, 4.0, 0),
                    child: InStockButton(
                        text: "-10",
                        onPressed: () {
                          updateChangeStockAmountBy(-10);
                        },
                        theme: theme.themeData,
                        colorOption: InStockButton.primary),
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(4.0, 0, 4.0, 0),
                    child: InStockButton(
                        text: "-1",
                        onPressed: () {
                          updateChangeStockAmountBy(-1);
                        },
                        theme: theme.themeData,
                        colorOption: InStockButton.primary),
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(4.0, 0, 4.0, 0),
                    child: InStockButton(
                        text: "+1",
                        onPressed: () {
                          updateChangeStockAmountBy(1);
                        },
                        theme: theme.themeData,
                        colorOption: InStockButton.secondary),
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(4.0, 0, 4.0, 0),
                    child: InStockButton(
                        text: "+10",
                        onPressed: () {
                          updateChangeStockAmountBy(10);
                        },
                        theme: theme.themeData,
                        colorOption: InStockButton.secondary),
                  ),
                )
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(0, 12.0, 0, 0),
            child:
                Text("Reason:", style: theme.themeData.textTheme.titleMedium),
          ),
          Row(
            children: <Widget>[
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(4.0, 0, 4.0, 0),
                  child: InStockButton(
                    text: "Sale",
                    onPressed: () {
                      setState(() {
                        _reasonForChange = ReasonForChange.Sale;
                      });
                    },
                    theme: theme.themeData,
                    colorOption: determineIfSelected(ReasonForChange.Sale)
                        ? InStockButton.accent
                        : InStockButton.primary,
                  ),
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(4.0, 0, 4.0, 0),
                  child: InStockButton(
                    text: "Restock",
                    onPressed: () {
                      setState(() {
                        _reasonForChange = ReasonForChange.Restock;
                      });
                    },
                    theme: theme.themeData,
                    colorOption: determineIfSelected(ReasonForChange.Restock)
                        ? InStockButton.accent
                        : InStockButton.primary,
                  ),
                ),
              ),
            ],
          ),
          Row(
            children: <Widget>[
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(4.0, 0, 4.0, 0),
                  child: InStockButton(
                    text: "Correction",
                    onPressed: () {
                      setState(() {
                        _reasonForChange = ReasonForChange.Correction;
                      });
                    },
                    theme: theme.themeData,
                    colorOption: determineIfSelected(ReasonForChange.Correction)
                        ? InStockButton.accent
                        : InStockButton.primary,
                  ),
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(4.0, 0, 4.0, 0),
                  child: InStockButton(
                    text: "Damaged",
                    onPressed: () {
                      setState(() {
                        _reasonForChange = ReasonForChange.Damaged;
                      });
                    },
                    theme: theme.themeData,
                    colorOption: determineIfSelected(ReasonForChange.Damaged)
                        ? InStockButton.accent
                        : InStockButton.primary,
                  ),
                ),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(4.0, 0, 4.0, 0),
            child: Container(
              decoration: BoxDecoration(
                color: theme.themeData.cardColor,
                borderRadius: BorderRadius.all(
                  Radius.circular(5),
                ),
              ),
              padding: null,
              child: ExpandablePanel(
                theme: ExpandableThemeData(
                    animationDuration: Duration(milliseconds: 150),
                    hasIcon: true,
                    tapHeaderToExpand: true),
                header: Container(
                  alignment: Alignment.center,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      "More Options",
                      style: theme.themeData.textTheme.bodySmall,
                    ),
                  ),
                ),
                collapsed: Container(),
                expanded: Expanded(
                  child: Container(
                    color: theme.themeData.cardColor,
                    child: Column(
                      children: [
                        Row(
                          children: <Widget>[
                            Expanded(
                              child: Padding(
                                padding:
                                    const EdgeInsets.fromLTRB(4.0, 0, 4.0, 0),
                                child: InStockButton(
                                  text: "Returned",
                                  onPressed: () {
                                    setState(() {
                                      _reasonForChange =
                                          ReasonForChange.Returned;
                                    });
                                  },
                                  theme: theme.themeData,
                                  colorOption: determineIfSelected(
                                          ReasonForChange.Returned)
                                      ? InStockButton.accent
                                      : InStockButton.primary,
                                ),
                              ),
                            ),
                            Expanded(
                              child: Padding(
                                padding:
                                    const EdgeInsets.fromLTRB(4.0, 0, 4.0, 0),
                                child: InStockButton(
                                  text: "Resent",
                                  onPressed: () {
                                    setState(() {
                                      _reasonForChange = ReasonForChange.Resent;
                                    });
                                  },
                                  theme: theme.themeData,
                                  colorOption: determineIfSelected(
                                          ReasonForChange.Resent)
                                      ? InStockButton.accent
                                      : InStockButton.primary,
                                ),
                              ),
                            ),
                          ],
                        ),
                        Row(
                          children: <Widget>[
                            Expanded(
                              child: Padding(
                                padding:
                                    const EdgeInsets.fromLTRB(4.0, 0, 4.0, 0),
                                child: InStockButton(
                                  text: "Lost",
                                  onPressed: () {
                                    setState(() {
                                      _reasonForChange = ReasonForChange.Lost;
                                    });
                                  },
                                  theme: theme.themeData,
                                  colorOption:
                                      determineIfSelected(ReasonForChange.Lost)
                                          ? InStockButton.accent
                                          : InStockButton.primary,
                                ),
                              ),
                            ),
                            Expanded(
                              child: Padding(
                                padding:
                                    const EdgeInsets.fromLTRB(4.0, 0, 4.0, 0),
                                child: InStockButton(
                                  text: "Giveaway",
                                  onPressed: () {
                                    setState(() {
                                      _reasonForChange =
                                          ReasonForChange.Giveaway;
                                    });
                                  },
                                  theme: theme.themeData,
                                  colorOption: determineIfSelected(
                                          ReasonForChange.Giveaway)
                                      ? InStockButton.accent
                                      : InStockButton.primary,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
          Padding(
            padding: theme.textFieldPadding,
            child: InStockButton(
              text: "Save",
              onPressed: () {
                updateStock();
              },
              theme: theme.themeData,
              colorOption: InStockButton.accent,
              isLoading: _isLoading,
            ),
          )
        ],
      ),
    );
  }
}
