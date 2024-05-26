class ProductModel {
  String? id;
  String? productName;
  String? productCode;
  String? image;
  String? unitPrice;
  String? quantity;
  String? totalPrice;

  ProductModel.fromJson(Map<String, dynamic> json) {
    id = json['_id'];
    productName = json['ProductName'] ?? 'Product Name';
    productCode = json['ProductCode'] ?? 'Product Code';
    image = json['Img'] ?? '';
    unitPrice = json['UnitPrice'] ?? 'Price';
    quantity = json['Qty'] ?? 'Quantity';
    totalPrice = json['TotalPrice'] ?? 'Total Price';
  }
}