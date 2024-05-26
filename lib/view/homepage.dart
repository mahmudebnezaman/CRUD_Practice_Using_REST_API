import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart';

import 'package:crud_practice_using_rest_api/model/product_model.dart';
import 'package:crud_practice_using_rest_api/view/product_form_view.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  bool _getProductListInProgress = false;
  List<ProductModel> productList = [];

  @override
  void initState() {
    super.initState();
    _getProductList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.primary,
        leading: const Icon(Icons.shopping_cart),
        title: Text(
          widget.title,
          style: TextStyle(color: Theme.of(context).colorScheme.onPrimary),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const ProductFromView(),
              ),
            ),
            icon: const Icon(Icons.add),
          ),
        ],
        iconTheme: IconThemeData(
          color: Theme.of(context).colorScheme.onPrimary,
        ),
      ),
      body: RefreshIndicator(
        onRefresh: _getProductList,
        child: Visibility(
          visible: _getProductListInProgress == false,
          replacement: const Center(
            child: CircularProgressIndicator(),
          ),
          child: GridView.builder(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 2,
              mainAxisSpacing: 2,
              childAspectRatio: 0.75,
            ),
            itemCount: productList.length,
            itemBuilder: (BuildContext context, int index) {
              return buildItemBuilder(productList[index], context);
            },
          ),
        ),
      ),
    );
  }

  Stack buildItemBuilder(ProductModel product, BuildContext context) {
    return Stack(
      alignment: Alignment.bottomRight,
      children: [
        Card(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                AspectRatio(
                  aspectRatio: 1.5,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Image(
                      image: NetworkImage(
                        product.image ?? 'assets/images/errorimage.png',
                      ),
                      width: double.maxFinite,
                      fit: BoxFit.fitHeight,
                      errorBuilder: (context, error, stackTrace) {
                        return Image.asset(
                          'assets/images/errorimage.png',
                          width: double.maxFinite,
                          fit: BoxFit.fitHeight,
                        );
                      },
                    ),
                  ),
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      product.productName!,
                      style: Theme.of(context).textTheme.titleLarge,
                      // const TextStyle(
                      //   fontWeight: FontWeight.w500,
                      //   fontSize: 16,
                      // ),
                      overflow: TextOverflow.fade,
                      maxLines: 1,
                    ),
                    Text(
                      product.productCode!,
                      style: Theme.of(context).textTheme.bodySmall,
                      overflow: TextOverflow.fade,
                      maxLines: 1,
                    ),
                    Text(
                      '${product.unitPrice}tk x ${product.quantity}pc',
                      style: Theme.of(context).textTheme.bodyMedium,
                      overflow: TextOverflow.fade,
                      maxLines: 1,
                    ),
                    Text(
                      'Total Price:',
                      style: Theme.of(context).textTheme.bodyMedium,
                      overflow: TextOverflow.fade,
                      maxLines: 1,
                    ),
                    Text(
                      '${product.totalPrice}Tk',
                      style: Theme.of(context).textTheme.titleMedium,
                      overflow: TextOverflow.fade,
                      maxLines: 1,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              CircleAvatar(
                child: IconButton(
                  onPressed: () async {
                    final result = await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ProductFromView(
                          product: product,
                        ),
                      ),
                    );
                    if (result == true) {
                      _getProductList();
                    }
                  },
                  icon: const Icon(Icons.edit),
                ),
              ),
              const SizedBox(
                height: 2,
              ),
              CircleAvatar(
                child: IconButton(
                  onPressed: () {
                    _showDeleteConfirmationDialog(product.id!);
                  },
                  icon: const Icon(Icons.delete),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Future<void> _getProductList() async {
    _getProductListInProgress = true;
    setState(() {});
    productList.clear();
    const String productListUrl =
        'https://crud.teamrabbil.com/api/v1/ReadProduct';
    Uri uri = Uri.parse(productListUrl);
    Response response = await get(uri);
    print(response.statusCode);
    print(response.body);

    if (response.statusCode == 200) {
      final decodedData = jsonDecode(response.body);
      final jsonProductList = decodedData['data'];
      for (Map<String, dynamic> json in jsonProductList) {
        ProductModel productModel = ProductModel.fromJson(json);
        productList.add(productModel);
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Getting product list failed! Try again.')),
      );
    }

    _getProductListInProgress = false;
    setState(() {});
  }

  void _showDeleteConfirmationDialog(String productId) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Delete'),
          content:
              const Text('Are you sure that you want to delete this product?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                _deleteProduct(productId);
                Navigator.pop(context);
              },
              child: const Text('Yes, delete'),
            ),
          ],
        );
      },
    );
  }

  Future<void> _deleteProduct(String productId) async {
    _getProductListInProgress = true;
    setState(() {});
    String deleteProductUrl =
        'https://crud.teamrabbil.com/api/v1/DeleteProduct/$productId';
    Uri uri = Uri.parse(deleteProductUrl);
    Response response = await get(uri);
    print(response.statusCode);
    print(response.body);

    if (response.statusCode == 200) {
      _getProductList();
    } else {
      _getProductListInProgress = false;
      setState(() {});
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Product deletion failed! Try again.')),
      );
    }
  }
}
