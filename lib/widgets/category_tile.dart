import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:gerenteloja/screens/product_screen.dart';
import 'package:gerenteloja/widgets/edit_category_dialog.dart';

class CategoryTile extends StatefulWidget {

  final DocumentSnapshot category;

  CategoryTile(this.category);

  @override
  _CategoryTileState createState() => _CategoryTileState();
}

class _CategoryTileState extends State<CategoryTile> with AutomaticKeepAliveClientMixin {

  @override
  Widget build(BuildContext context) {
    super.build(context);

    final DocumentSnapshot category = widget.category;

    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: Card(
        child: ExpansionTile(
          leading: GestureDetector(
            onTap: () {
              showDialog(context: context, builder: (context) => EditCategoryDialog(category: category,));
            },
            child: CircleAvatar(
              backgroundColor: Colors.transparent,
              backgroundImage: NetworkImage(widget.category.data["icon"]),
            ),
          ),
          title: Text(
            widget.category.data["title"],
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.w500),
          ),
          children: <Widget>[
            FutureBuilder<QuerySnapshot>(
              future: category.reference.collection("items").getDocuments(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) return Container();
                return Column(
                  children: snapshot.data.documents.map<Widget>((document) {
                    return ListTile(
                      leading: CircleAvatar(
                        backgroundColor: Colors.transparent,
                        backgroundImage: NetworkImage(document.data["images"][0]),
                      ),
                      title: Text(document.data["title"]),
                      trailing: Text(
                          "R\$${document.data["price"].toStringAsFixed(2)}"
                      ),
                      onTap: () {
                        Navigator.of(context).push(
                            MaterialPageRoute(builder: (context) =>
                                ProductScreen(
                                  categoryId: category.documentID,
                                  product: document,
                                )
                            )
                        );
                      },
                    );
                  }).toList()
                    ..add(
                        ListTile(
                          leading: CircleAvatar(
                            backgroundColor: Colors.transparent,
                            child: Icon(Icons.add, color: Theme
                                .of(context)
                                .accentColor),
                          ),
                          title: Text("Adicionar"),
                          onTap: () {
                            Navigator.of(context).push(
                                MaterialPageRoute(builder: (context) =>
                                    ProductScreen(
                                      categoryId: category.documentID
                                    )
                                )
                            );
                          },
                        )
                    ),
                );
              },
            )
          ],
        ),
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
