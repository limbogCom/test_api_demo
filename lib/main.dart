import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:intl/intl.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  List<Product> productList = [];
  bool isLoading = true;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
          appBar: AppBar(),
          body: isLoading ? CircularProgressIndicator() : ListView.builder(
              itemBuilder: (context, int index){
                return ListTile(
                  title: Text(productList[index].optionList[index]['descr'].toString()),
                  subtitle: Text(productList[index].counter.toString()),
                );
              },
              itemCount: productList.isNotEmpty ? productList.length : 0,
          ),
        ));
  }

  @override
  void initState() {
    super.initState();
    generateProductList();
  }

  generateProductList() async {
    final response = await http.get(Uri.parse('http://api.retailstars.nl:8080/optionlist?CompanyIdRequest=2&UserIdRequest=2'));
    //var decodedProducts = json.decode(response.body);

    if(response.statusCode == 200){
      setState(() {
        var jsonData = json.decode(response.body);
        productList.add(Product.fromJson(jsonData));
        isLoading = false;
        print(productList);
      });
    }

    //decodedProducts.map((productLists) => productList.add(Product.fromJson(productLists)));

    return productList;
  }
}

class Product {

  final int httpStatusCode;
  final String messageId;
  final int counter;
  final int versionAPI;
  final int versionModule;
  final String operation;
  final String originalURI;
  final List optionList;

  Product(
      {required this.httpStatusCode,
        required this.messageId,
        required this.counter,
        required this.versionAPI,
        required this.versionModule,
        required this.operation,
        required this.originalURI,
        required this.optionList});

  factory Product.fromJson(Map<String, dynamic> parsedJson) {
    return Product(
        httpStatusCode: parsedJson['httpStatusCode'],
        messageId: parsedJson['messageId'],
        counter: parsedJson['counter'],
        versionAPI: parsedJson['versionAPI'],
        versionModule: parsedJson['versionModule'],
        operation: parsedJson['operation'],
        originalURI: parsedJson['originalURI'],
        optionList: parsedJson['optionList']);

  }
}
