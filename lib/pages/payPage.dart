import 'dart:math';

import 'package:anagram_ladder/models/gameStore.dart';
import 'package:flutter/material.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:provider/provider.dart';

class PayPage extends StatefulWidget {
  const PayPage({Key? key}) : super(key: key);

  @override
  _PayPageState createState() => _PayPageState();
}

class _PayPageState extends State<PayPage> {
  late GameStore _store;
  String? _lastError;

  @override
  void initState() {
    super.initState();
    _store = context.read<GameStore>();
    _store.addListener(_handleEvent);
  }

  @override
  void dispose() {
    _store.removeListener(_handleEvent);
    super.dispose();
  }

  void _handleEvent() {
    if (_store.errorMessage != null && _lastError != _store.errorMessage) {
      _lastError = _store.errorMessage;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(_store.errorMessage!)),
      );
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Store")),
      body: SafeArea(
        child: Stack(
          children: [
            ListView(
              children: [
                _buildConnectionCheckTile(),
                _buildProductList(),
              ],
            ),
            if (_store.storeEvent == StoreEvent.purchasePending)
              _buildLoadingOverlay(),
          ],
        ),
      ),
    );
  }

  Widget _buildLoadingOverlay() {
    return Stack(
      children: [
        Opacity(
          opacity: 0.5,
          child: const ModalBarrier(dismissible: false, color: Colors.black),
        ),
        const Center(
          child: CircularProgressIndicator(),
        ),
      ],
    );
  }

  Widget _buildConnectionCheckTile() {
    final textScaleFactor = min(1.4, MediaQuery.of(context).textScaleFactor);

    if (!_store.isLoaded) {
      return Card(
        child: ListTile(
          leading: const CircularProgressIndicator(),
          title: Text('Connecting to the store...', textScaleFactor: textScaleFactor),
        ),
      );
    }

    if (!_store.isAvailable) {
      return Card(
        child: ListTile(
          leading: const Icon(Icons.error, color: Colors.red),
          title: Text(
            'Store not available',
            style: TextStyle(color: Theme.of(context).colorScheme.error),
            textScaleFactor: textScaleFactor,
          ),
          subtitle: Text('Unable to connect to the store.', textScaleFactor: textScaleFactor),
        ),
      );
    }

    return const SizedBox.shrink();
  }

  Widget _buildProductList() {
    final textScaleFactor = min(1.4, MediaQuery.of(context).textScaleFactor);

    if (!_store.isLoaded) {
      return Card(
        child: ListTile(
          leading: const CircularProgressIndicator(),
          title: Text('Fetching products...', textScaleFactor: textScaleFactor),
        ),
      );
    }

    if (!_store.isAvailable) {
      return const SizedBox.shrink();
    }

    final productTiles = <Widget>[];

    if (_store.notFoundIds.isNotEmpty) {
      productTiles.add(
        ListTile(
          title: Text(
            '[${_store.notFoundIds.join(", ")}] not found',
            style: TextStyle(color: Theme.of(context).colorScheme.error),
            textScaleFactor: textScaleFactor,
          ),
          subtitle: Text('Failed to find products.', textScaleFactor: textScaleFactor),
        ),
      );
    }

    final purchases = {
      for (var purchase in _store.purchases) purchase.productID: purchase,
    };

    productTiles.addAll(
      _store.products.map((productDetails) {
        final previousPurchase = purchases[productDetails.id];
        final isPurchased = previousPurchase != null;

        return ListTile(
          title: Text(
            productDetails.description.isNotEmpty
                ? productDetails.description
                : productDetails.title.isNotEmpty
                    ? productDetails.title
                    : "Unlock levels 51 to 100 in all difficulties",
            textScaleFactor: textScaleFactor,
          ),
          trailing: AnimatedContainer(
            duration: const Duration(milliseconds: 500),
            curve: Curves.easeInOut,
            decoration: BoxDecoration(
              color: isPurchased ? Colors.red : Colors.green[800],
              borderRadius: BorderRadius.circular(20),
            ),
            child: TextButton(
              onPressed: isPurchased
                  ? null
                  : () => _store.purchaseProduct(productDetails),
              child: Text(
                isPurchased ? "Purchased" : productDetails.price,
                style: const TextStyle(color: Colors.white),
                textScaleFactor: textScaleFactor,
              ),
            ),
          ),
        );
      }).toList(),
    );

    return Card(
      margin: const EdgeInsets.fromLTRB(10, 20, 10, 0),
      child: Column(children: productTiles),
    );
  }
}
