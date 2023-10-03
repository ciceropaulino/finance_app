import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';

void main() {
  runApp(MaterialApp(
    home: FinancePage(),
  ));
}

class FinancePage extends StatefulWidget {
  @override
  _FinancePageState createState() => _FinancePageState();
}

class _FinancePageState extends State<FinancePage> {
  List<dynamic> stocksData = [];

  Future<void> fetchStocksData() async {
    final response = await http.get(
      Uri.parse(
          "https://api.hgbrasil.com/finance?format=json-cors&key=2a34b926"),
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final stocks = data["results"]["stocks"];
      setState(() {
        stocksData = stocks.values.toList(); // Converte os valores em uma lista
      });
    }
  }

  @override
  void initState() {
    super.initState();
    fetchStocksData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue,
      appBar: AppBar(
        title: Text("Finance"),
        backgroundColor: Colors.transparent,
      ),
      body: ListView.builder(
        itemCount: stocksData.length,
        itemBuilder: (context, index) {
          final stock = stocksData[index];
          final stockName = stock["name"];
          final stockPoints = stock["points"];
          final stockVariation = stock["variation"];

          return ListTile(
            titleTextStyle: TextStyle(color: Colors.white),
            title: Text(stockName),
            subtitleTextStyle: TextStyle(color: Colors.red),
            subtitle: Text("Pontos: $stockPoints\nVariação: $stockVariation%"),
          );
        },
      ),
    );
  }
}
