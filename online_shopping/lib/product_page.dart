import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'rating_page.dart';

class Product {
  final String id;
  String name;
  String category;
  int price;
  int stock;
  String image;
  Product({
    required this.id,
    required this.name,
    required this.category,
    required this.price,
    required this.stock,
    required this.image,
  });

  factory Product.fromMap(Map<String, dynamic> data, String documentId) {
    return Product(
      id: documentId,
      name: data['name'] ?? '',
      category: data['category'] ?? '',
      price: (data['price'] as num).toInt(),
      stock: data['stock'] ?? 0,
      image: data['image'] ?? '',
    );
  }
}

class ProductPage extends StatefulWidget {
  const ProductPage({super.key});

  @override
  State<ProductPage> createState() => ProductPageState();
}

class ProductPageState extends State<ProductPage> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  final TextEditingController _stockController = TextEditingController();
  final TextEditingController _imageController = TextEditingController();

  String? _selectedCategory;
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  Future<List<String>> fetchCategories() async {
    try {
      final snapshot = await firestore.collection('Category').get();
      return snapshot.docs.map((doc) => doc['name'].toString()).toList();
    } catch (e) {
      throw Exception('Failed to fetch categories: $e');
    }
  }

  Future<List<Product>> fetchProducts() async {
    try {
      final snapshot = await firestore.collection('Product').get();
      return snapshot.docs
          .map((doc) => Product.fromMap(doc.data(), doc.id))
          .toList();
    } catch (e) {
      throw Exception('Failed to fetch products: $e');
    }
  }

  Future<void> addProduct(
      String name, String category, int price, int stock, String image) async {
    try {
      await firestore.collection('Product').add({
        'name': name,
        'category': category,
        'price': price,
        'stock': stock,
        'image': image,
      });
    } catch (e) {
      showErrorDialog('Failed to add product: $e');
    }
  }

  Future<void> addTransaction(String username, String productName, int quantity,
      int price, String date) async {
    try {
      await firestore.collection('Transaction').doc().set({
        'username': username,
        'product': productName,
        'quantity': quantity,
        'totalPrice': price,
        'purchaseDate': date
      });
    } catch (e) {
      showErrorDialog('Failed to add transaction: $e');
    }
  }

  Future<List<Map<String, dynamic>>> getProduct(String productName) async {
    List<Map<String, dynamic>> list = [];
    try {
      QuerySnapshot querySnapshot = await firestore
          .collection('Transaction')
          .where('name', isEqualTo: productName)
          .get();

      setState(() {
        list = querySnapshot.docs
            .map((doc) => doc.data() as Map<String, dynamic>)
            .toList();
      });
    } catch (e) {
      print('Error fetching transactions: $e');
    }
    return list;
  }

  Future<void> updateProduct(Product product) async {
    try {
      await firestore.collection('Product').doc(product.id).update({
        'name': product.name,
        'category': product.category,
        'price': product.price,
        'stock': product.stock,
        'image': product.image,
      });
    } catch (e) {
      showErrorDialog('Failed to update product: $e');
    }
  }

  Future<void> deleteProduct(String id) async {
    try {
      await firestore.collection('Product').doc(id).delete();
    } catch (e) {
      showErrorDialog('Failed to delete product: $e');
    }
  }

  void showProductDialog({Product? product, required List<String> categories}) {
    if (product != null) {
      _nameController.text = product.name;
      _selectedCategory = product.category;
      _priceController.text = product.price.toString();
      _stockController.text = product.stock.toString();
      _imageController.text = product.image;
    } else {
      _nameController.clear();
      _selectedCategory = null;
      _priceController.clear();
      _stockController.clear();
      _imageController.clear();
    }

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(product == null ? 'Add Product' : 'Edit Product'),
          content: SingleChildScrollView(
            child: Column(
              children: [
                TextField(
                  controller: _nameController,
                  decoration: const InputDecoration(labelText: 'Product Name'),
                ),
                DropdownButtonFormField<String>(
                  value: _selectedCategory,
                  items: categories
                      .map((category) => DropdownMenuItem(
                            value: category,
                            child: Text(category),
                          ))
                      .toList(),
                  onChanged: (value) {
                    setState(() {
                      _selectedCategory = value;
                    });
                  },
                  decoration: const InputDecoration(labelText: 'Category'),
                ),
                TextField(
                  controller: _priceController,
                  decoration: const InputDecoration(labelText: 'Price'),
                  keyboardType: TextInputType.number,
                ),
                TextField(
                  controller: _stockController,
                  decoration:
                      const InputDecoration(labelText: 'Stock Quantity'),
                  keyboardType: TextInputType.number,
                ),
                TextField(
                  controller: _imageController,
                  decoration: const InputDecoration(labelText: 'Product Image'),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () async {
                if (_selectedCategory == null ||
                    _nameController.text.trim().isEmpty) {
                  showErrorDialog('Please select a category.');
                  return;
                }

                if (product == null) {
                  await addProduct(
                    _nameController.text.trim(),
                    _selectedCategory!,
                    int.tryParse(_priceController.text) ?? 0,
                    int.tryParse(_stockController.text) ?? 0,
                    _imageController.text.trim(),
                  );
                } else {
                  product.name = _nameController.text.trim();
                  product.category = _selectedCategory!;
                  product.price = int.tryParse(_priceController.text) ?? 0;
                  product.stock = int.tryParse(_stockController.text) ?? 0;
                  product.image = _imageController.text.trim();
                  await updateProduct(product);
                }

                Navigator.of(context).pop();
              },
              child: Text(product == null ? 'Add' : 'Save'),
            ),
          ],
        );
      },
    );
  }

  void showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Error'),
          content: Text(message),
          actions: [
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Manage Products')),
      body: StreamBuilder<QuerySnapshot>(
        stream: firestore.collection('Category').snapshots(),
        builder: (context, categorySnapshot) {
          if (categorySnapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (categorySnapshot.hasError) {
            return Center(child: Text('Error: ${categorySnapshot.error}'));
          } else if (!categorySnapshot.hasData ||
              categorySnapshot.data!.docs.isEmpty) {
            return const Center(child: Text('No categories found.'));
          } else {
            final categoryNames = categorySnapshot.data!.docs
                .map((doc) => doc['name'] as String? ?? '')
                .where((name) => name.isNotEmpty)
                .toList();

            return StreamBuilder<QuerySnapshot>(
              stream: firestore.collection('Product').snapshots(),
              builder: (context, productSnapshot) {
                if (productSnapshot.connectionState ==
                    ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (productSnapshot.hasError) {
                  return Center(child: Text('Error: ${productSnapshot.error}'));
                } else if (!productSnapshot.hasData ||
                    productSnapshot.data!.docs.isEmpty) {
                  return const Center(child: Text('No products found.'));
                } else {
                  final products = productSnapshot.data!.docs
                      .map((doc) => Product.fromMap(
                          doc.data() as Map<String, dynamic>, doc.id))
                      .toList();

                  return ListView(
                    children: [
                      ListTile(
                        title: const Text('Add New Product'),
                        trailing: const Icon(Icons.add),
                        onTap: () =>
                            showProductDialog(categories: categoryNames),
                      ),
                      const Divider(),
                      ...products.map((product) => ListTile(
                            title: Text(product.name),
                            subtitle: Text(
                                'Category: ${product.category} | Price: \$${product.price} | Stock: ${product.stock}'),
                            trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                IconButton(
                                  icon: const Icon(Icons.edit,
                                      color: Colors.blue),
                                  onPressed: () => showProductDialog(
                                      product: product,
                                      categories: categoryNames),
                                ),
                                IconButton(
                                  icon: const Icon(Icons.delete,
                                      color: Colors.red),
                                  onPressed: () async {
                                    final confirm = await showDialog(
                                      context: context,
                                      builder: (context) {
                                        return AlertDialog(
                                          title: const Text('Confirm Delete'),
                                          content: const Text(
                                              'Are you sure you want to delete this product?'),
                                          actions: [
                                            TextButton(
                                              onPressed: () =>
                                                  Navigator.of(context)
                                                      .pop(false),
                                              child: const Text('Cancel'),
                                            ),
                                            ElevatedButton(
                                              onPressed: () =>
                                                  Navigator.of(context)
                                                      .pop(true),
                                              child: const Text('Delete'),
                                            ),
                                          ],
                                        );
                                      },
                                    );

                                    if (confirm == true) {
                                      await deleteProduct(product.id);
                                    }
                                  },
                                ),
                                IconButton(
                                  icon: const Icon(Icons.stars,
                                      color: Colors.yellow),
                                  onPressed: () async {
                                    await Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            RatingPage(productId: product.id),
                                      ),
                                    );
                                    setState(() {});
                                  },
                                ),
                              ],
                            ),
                          )),
                    ],
                  );
                }
              },
            );
          }
        },
      ),
    );
  }
}
