import 'database_item.dart';

class CartItem extends DatabaseItem{
  final String id;
  final String name;
  final String imageUrl;
  final int price;
  final int quantity;
  final String userId;
  final String productId;
  final String size;

  CartItem({this.name, this.id, this.imageUrl, this.userId, this.price, this.quantity, this.productId, this.size}):super(id);
 
  CartItem.fromDS(String id, Map<String,dynamic> data):
    id=id,
    name=data['name'],
    userId=data['userId'],
    imageUrl=data['imageUrl'],
    quantity = data['quantity'],
    productId = data['productId'],
    price = data['price'],
    size = data['size'],
    super(id);

  Map<String,dynamic> toMap() => {
    "name":name,
    "userId": userId,
    "imageUrl": imageUrl,
    "quantity" : quantity,
    "productId" : productId,
    "price" : price,
    "size" : size,
  };
}
