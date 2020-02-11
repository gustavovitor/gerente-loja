import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:gerenteloja/blocs/product_bloc.dart';
import 'package:gerenteloja/validators/product_validator.dart';
import 'package:gerenteloja/widgets/images_widget.dart';
import 'package:gerenteloja/widgets/product_sizes.dart';

class ProductScreen extends StatefulWidget {

  final String categoryId;
  final DocumentSnapshot product;

  ProductScreen({ @required this.categoryId, this.product });

  @override
  _ProductScreenState createState() => _ProductScreenState(categoryId, product);
}

class _ProductScreenState extends State<ProductScreen> with ProductValidator {
  final _formKey = GlobalKey<FormState>();
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  final ProductBloc _productBloc;

  _ProductScreenState(String categoryId, DocumentSnapshot product) :
        _productBloc = ProductBloc(categoryId: categoryId, product: product);

  @override
  Widget build(BuildContext context) {

    final _fieldStyle = const TextStyle(
      fontSize: 16
    );

    InputDecoration _buildDecoration(String label) {
      return InputDecoration(
        labelText: label,
        labelStyle: TextStyle(
          color: Colors.grey
        )
      );
    }

    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        elevation: 0,
        title: StreamBuilder<bool>(
          stream: _productBloc.outCreated,
          initialData: false,
          builder: (context, snapshot) {
            return Text(snapshot.data ? "Editar Produto" : "Criar Produto");
          }
        ),
        actions: <Widget>[
          StreamBuilder<bool>(
            stream: _productBloc.outCreated,
            initialData: false,
            builder: (context, snapshot) {
              if (snapshot.data) {
                return StreamBuilder<bool>(
                    stream: _productBloc.outLoading,
                    initialData: false,
                    builder: (context, snapshot) {
                      return IconButton(
                          icon: Icon(Icons.remove),
                          onPressed: snapshot.data ? null : () {
                            _productBloc.deleteProduct();
                            Navigator.of(context).pop();
                          }
                      );
                    }
                );
              } else return Container();
            }
          ),
          StreamBuilder<bool>(
              stream: _productBloc.outLoading,
              initialData: false,
              builder: (context, snapshot) {
                return IconButton(
                    icon: Icon(Icons.save),
                    onPressed: snapshot.data ? null : saveProduct
                );
              }
          )
        ],
      ),
      body: Stack(
        children: <Widget>[
          Form(
            key: _formKey,
            child: StreamBuilder<Map>(
              stream: _productBloc.outData,
              builder: (context, snapshot) {
                if (!snapshot.hasData) return Container();

                return ListView(
                  padding: EdgeInsets.all(16),
                  children: <Widget>[
                    Text(
                      "Imagens",
                      style: TextStyle(
                        fontSize: 12
                      ),
                    ),
                    ImagesWidget(
                      context: context,
                      initialValue: snapshot.data["images"],
                      onSaved: _productBloc.saveImages,
                      validator: validateImages
                    ),
                    TextFormField(
                      initialValue: snapshot.data["title"],
                      style: _fieldStyle,
                      decoration: _buildDecoration("Titulo"),
                      onSaved: _productBloc.saveTitle,
                      validator: validateTitle,
                    ),
                    TextFormField(
                      initialValue: snapshot.data["description"],
                      style: _fieldStyle,
                      decoration: _buildDecoration("Descrição"),
                      maxLines: 6,
                      onSaved: _productBloc.saveDescription,
                      validator: validateDescription,
                    ),
                    TextFormField(
                      initialValue: snapshot.data["price"]?.toStringAsFixed(2),
                      style: _fieldStyle,
                      decoration: _buildDecoration("Preço"),
                      keyboardType: TextInputType.numberWithOptions(decimal: true),
                      onSaved: _productBloc.savePrice,
                      validator: validatePrice,
                    ),
                    SizedBox(height: 16,),
                    Text(
                      "Tamanhos",
                      style: TextStyle(
                          fontSize: 12
                      ),
                    ),
                    ProductSizes(
                      context: context,
                      validator: validateSizes,
                      onSaved: _productBloc.saveSizes,
                      initialValue: snapshot.data["sizes"],
                    )
                  ],
                );
              }
            ),
          ),
          StreamBuilder<bool>(
              stream: _productBloc.outLoading,
              initialData: false,
              builder: (context, snapshot) {
                return IgnorePointer(
                  ignoring: !snapshot.data,
                  child: Container(
                    color: snapshot.data ? Colors.black54 : Colors.transparent,
                  ),
                );
              }
          )
        ],
      ),
    );
  }

  void saveProduct() async {
    if (_formKey.currentState.validate()) {
      _formKey.currentState.save();

      _scaffoldKey.currentState.showSnackBar(
          SnackBar(
            content: Text("Salvando produto..", style: TextStyle(color: Colors.white),),
            backgroundColor: Theme.of(context).accentColor,
            duration: Duration(minutes: 1),
          )
      );

      bool success = await _productBloc.saveProduct();

      _scaffoldKey.currentState.removeCurrentSnackBar();

      _scaffoldKey.currentState.showSnackBar(
          SnackBar(
            content: Text(success ? "Produto salvo.." : "Erro ao salvar produto!", style: TextStyle(color: Colors.white),),
            backgroundColor: Theme.of(context).accentColor,
          )
      );
    }
  }
}
