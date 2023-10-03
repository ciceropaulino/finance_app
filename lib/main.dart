import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';

void main() {
  runApp(MaterialApp(
    home: Financas(),
  ));
}

class Financas extends StatefulWidget {
  @override
  _FinancasState createState() => _FinancasState();
}

class _FinancasState extends State<Financas> {
  Map<String, dynamic> stocksData = {};
  Map<String, dynamic> currenciesData = {};

  Future<void> fetchData() async {
    final response = await http.get(
      Uri.parse(
          "https://api.hgbrasil.com/finance?format=json-cors&key=2a34b926"),
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final stocks = data["results"]["stocks"];
      final currencies = data["results"]["currencies"];
      
      // Remove a entrada "BRL" dos dados de moeda
      currencies.remove("BRL");

      setState(() {
        stocksData = Map<String, dynamic>.from(stocks);
        currenciesData = Map<String, dynamic>.from(currencies);
      });
    }
  }

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Página de Finanças"),
      ),
      body: ListView(
        children: <Widget>[
          _buildSection("Ações", stocksData),
          _buildSection("Moedas", currenciesData),
        ],
      ),
    );
  }

  Widget _buildSection(String title, Map<String, dynamic> data) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Padding(
          padding: EdgeInsets.all(8.0),
          child: Text(
            title,
            style: TextStyle(
              fontSize: 20.0,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        if (data != null && data.isNotEmpty)
          ListView.builder(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            itemCount: data.length,
            itemBuilder: (context, index) {
              final itemName = data.keys.elementAt(index);
              final item = data[itemName];
              final itemBuy = item["buy"];
              final itemSell = item["sell"];
              final itemVariation = item["variation"];

              return ListTile(
                title: Text(itemName),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text("Compra: $itemBuy"),
                    Text("Venda: $itemSell"),
                    Text("Variação: $itemVariation%"),
                  ],
                ),
              );
            },
          ),
      ],
    );
  }
}
