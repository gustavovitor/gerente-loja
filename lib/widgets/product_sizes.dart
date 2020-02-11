import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'add_size_dialog.dart';

class ProductSizes extends FormField<List> {
  ProductSizes({BuildContext context, List initialValue, FormFieldSetter<List> onSaved, FormFieldValidator<List> validator})
      : super(
            initialValue: initialValue,
            onSaved: onSaved,
            validator: validator,
            builder: (state) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  SizedBox(
                    height: 34,
                    child: GridView(
                      padding: EdgeInsets.symmetric(vertical: 4),
                      scrollDirection: Axis.horizontal,
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 1, mainAxisSpacing: 8, childAspectRatio: 0.5),
                      children: state.value.map<Widget>((value) {
                        return GestureDetector(
                          onLongPress: () {
                            state.didChange(state.value..remove(value));
                          },
                          child: Container(
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.all(Radius.circular(4)), border: Border.all(color: Theme.of(context).accentColor, width: 2)),
                            alignment: Alignment.center,
                            child: Text(
                              value,
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                        );
                      }).toList()
                        ..add(GestureDetector(
                          onTap: () async {
                            String size = await showDialog(context: context, builder: (context) => AddSizeDialog());
                            if (size != null) state.didChange(state.value..add(size));
                          },
                          child: Container(
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.all(Radius.circular(4)), border: Border.all(color: Theme.of(context).accentColor, width: 2)),
                            alignment: Alignment.center,
                            child: Text(
                              "+",
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                        )),
                    ),
                  ),
                  state.hasError
                      ? Text(
                          state.errorText,
                          style: TextStyle(color: Colors.red, fontSize: 12),
                        )
                      : Container()
                ],
              );
            });
}
