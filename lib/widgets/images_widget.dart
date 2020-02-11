import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'image_source_sheet.dart';

class ImagesWidget extends FormField<List> {
  ImagesWidget({BuildContext context, FormFieldSetter<List> onSaved, FormFieldValidator<List> validator, List initialValue, bool autoValidate = false})
      : super(
            onSaved: onSaved,
            validator: validator,
            initialValue: initialValue,
            autovalidate: autoValidate,
            builder: (state) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Container(
                    height: 124,
                    padding: EdgeInsets.only(top: 16, bottom: 8),
                    child: ListView(
                      scrollDirection: Axis.horizontal,
                      children: state.value.map<Widget>((item) {
                        return Container(
                          width: 100,
                          height: 100,
                          margin: EdgeInsets.only(right: 8),
                          child: GestureDetector(
                            child: item is String
                                ? Image.network(
                                    item,
                                    fit: BoxFit.cover,
                                  )
                                : Image.file(
                                    item,
                                    fit: BoxFit.cover,
                                  ),
                            onLongPress: () {
                              state.didChange(state.value..remove(item));
                            },
                          ),
                        );
                      }).toList()
                        ..add(GestureDetector(
                          child: Container(
                            width: 100,
                            height: 100,
                            child: Icon(
                              Icons.camera_enhance,
                              color: Colors.white,
                            ),
                            color: Colors.white.withAlpha(50),
                          ),
                          onTap: () {
                            showModalBottomSheet(
                                context: context,
                                builder: (context) => ImageSourceSheet(
                                  onImageSelected: (image) {
                                    state.didChange(state.value..add(image));
                                    Navigator.of(context).pop();
                                  },
                                )
                            );
                          },
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
