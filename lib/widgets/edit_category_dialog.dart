import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:gerenteloja/blocs/category_bloc.dart';
import 'package:gerenteloja/widgets/image_source_sheet.dart';

class EditCategoryDialog extends StatefulWidget {
  final CategoryBloc _categoryBloc;

  final TextEditingController _controller;

  EditCategoryDialog({DocumentSnapshot category})
      : _categoryBloc = CategoryBloc(category),
        _controller = TextEditingController(text: category != null ? category.data["title"] : "");

  @override
  _EditCategoryDialogState createState() => _EditCategoryDialogState();
}

class _EditCategoryDialogState extends State<EditCategoryDialog> {

  @override
  Widget build(BuildContext context) {

    final _categoryBloc = widget._categoryBloc;

    return Dialog(
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              ListTile(
                leading: GestureDetector(
                    onTap: () {
                      showModalBottomSheet(
                          context: context,
                          builder: (context) => ImageSourceSheet(
                                onImageSelected: (image) {
                                  Navigator.of(context).pop();
                                  _categoryBloc.setImage(image);
                                },
                              ));
                    },
                    child: StreamBuilder(
                        stream: widget._categoryBloc.outImage,
                        builder: (context, snapshot) {
                          if (snapshot.data != null) {
                            return CircleAvatar(
                                backgroundColor: Colors.transparent,
                                child: snapshot.data is File
                                    ? Image.file(
                                        snapshot.data,
                                        fit: BoxFit.cover,
                                      )
                                    : Image.network(
                                        snapshot.data,
                                        fit: BoxFit.cover,
                                      ));
                          } else {
                            return Icon(Icons.image);
                          }
                        })),
                title: StreamBuilder<String>(
                  stream: _categoryBloc.outTitle,
                  builder: (context, snapshot) {
                    return TextField(
                      controller: widget._controller,
                      onChanged: _categoryBloc.setTitle,
                      decoration: InputDecoration(
                        errorText: snapshot.hasError ? snapshot.error : null
                      ),
                    );
                  }
                ),
              ),
              SizedBox(
                height: 16,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  StreamBuilder<bool>(
                      stream: widget._categoryBloc.outDelete,
                      initialData: false,
                      builder: (context, snapshot) {
                        if (!snapshot.hasData) return Container();
                        return FlatButton(
                          onPressed: snapshot.data ? () {} : null,
                          child: Text("Excluir"),
                          color: Colors.red,
                        );
                      }),
                  StreamBuilder<bool>(
                    stream: _categoryBloc.submitValid,
                    builder: (context, snapshot) {
                      return FlatButton(
                        onPressed: snapshot.hasData ? () async {
                          await _categoryBloc.saveData();
                          Navigator.of(context).pop();
                        } : null,
                        child: Text("Salvar"),
                      );
                    }
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
