import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:gerenteloja/blocs/orders_bloc.dart';
import 'package:gerenteloja/blocs/user_bloc.dart';
import 'package:gerenteloja/tabs/orders_tab.dart';
import 'package:gerenteloja/tabs/products_tab.dart';
import 'package:gerenteloja/tabs/users_tab.dart';
import 'package:gerenteloja/widgets/edit_category_dialog.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  PageController _pageController;
  int page = 0;

  UserBloc _userBloc;
  OrdersBloc _ordersBloc;

  @override
  void initState() {
    super.initState();

    _pageController = PageController();

    _userBloc = UserBloc();
    _ordersBloc = OrdersBloc();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: Theme(
        data: ThemeData(
            canvasColor: Colors.pinkAccent,
            primaryColor: Colors.white,
            textTheme: Theme.of(context).textTheme.copyWith(caption: TextStyle(color: Colors.white54))),
        child: BottomNavigationBar(
          currentIndex: page,
          onTap: (page) {
            _pageController.animateToPage(page, duration: Duration(milliseconds: 500), curve: Curves.ease);
          },
          items: [
            BottomNavigationBarItem(icon: Icon(Icons.person), title: Text("Clientes")),
            BottomNavigationBarItem(icon: Icon(Icons.shopping_cart), title: Text("Pedidos")),
            BottomNavigationBarItem(icon: Icon(Icons.list), title: Text("Produtos"))
          ],
        ),
      ),
      body: SafeArea(
        child: BlocProvider<UserBloc>(
          bloc: _userBloc,
          child: BlocProvider<OrdersBloc>(
            bloc: _ordersBloc,
            child: PageView(
              controller: _pageController,
              onPageChanged: (page) {
                setState(() {
                  this.page = page;
                });
              },
              children: <Widget>[
                UsersTab(),
                OrdersTab(),
                ProductsTab(),
              ],
            ),
          ),
        ),
      ),
      floatingActionButton: _buildFloating(),
    );
  }

  Widget _buildFloating() {
    switch(page) {
      case 0:
        return null;
      case 1:
        return SpeedDial(
          child: Icon(Icons.sort),
          backgroundColor: Theme.of(context).accentColor,
          overlayOpacity: 0.4,
          overlayColor: Colors.black,
          children: [
            SpeedDialChild(
                child: Icon(Icons.arrow_downward, color: Theme.of(context).accentColor,),
                backgroundColor: Colors.white,
                label: "Concluídos Abaixo",
                labelStyle: TextStyle(fontSize: 14, color: Colors.black),
                onTap: () {
                  _ordersBloc.setOrderCriteria(SortCriteria.READY_LAST);
                }
            ),
            SpeedDialChild(
                child: Icon(Icons.arrow_upward, color: Theme.of(context).accentColor,),
                backgroundColor: Colors.white,
                label: "Concluídos Acima",
                labelStyle: TextStyle(fontSize: 14, color: Colors.black),
                onTap: () {
                  _ordersBloc.setOrderCriteria(SortCriteria.READY_FIRST);
                }
            )
          ],
        );
      case 2:
        return FloatingActionButton(
          onPressed: () {
            showDialog(context: context, builder: (context) => EditCategoryDialog());
          },
          child: Icon(Icons.add),
        );
    }
  }

  @override
  void dispose() {
    _pageController.dispose();
  }
}
