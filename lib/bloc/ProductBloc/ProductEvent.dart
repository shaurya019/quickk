part of 'ProductBloc.dart';

abstract class ProductEvent extends Equatable {
  const ProductEvent();

  @override
  List<Object> get props => [];
}

class FetchProductList extends ProductEvent {
  const FetchProductList({this.context, this.categoryId, this.userId});

  final String categoryId, userId;
  final BuildContext context;

  @override
  List<Object> get props => [context];
}

class FetchProductData extends ProductEvent {
  const FetchProductData({this.context, this.productId});

  final String productId;
  final BuildContext context;

  @override
  List<Object> get props => [context];
}

class AddToCartEvent extends ProductEvent {
  const AddToCartEvent(
      {this.context,
      this.productId,
      this.userId,
      this.userType,
      this.productDataList,
      this.currentIndex});

  final String productId;
  final String userId;
  final String userType;
  final BuildContext context;
  final List<ProductData> productDataList;
  final int currentIndex;

  @override
  List<Object> get props => [context];
  get getProductDataList => productDataList;
}

class FetchAllProductList extends ProductEvent {
  const FetchAllProductList({this.context, this.userId});

  final BuildContext context;
  final String userId;

  @override
  List<Object> get props => [context];
}

class FetchCartList extends ProductEvent {
  const FetchCartList({this.context, this.userId});

  final BuildContext context;
  final String userId;

  @override
  List<Object> get props => [context];
}

class AddOrder extends ProductEvent {
  const AddOrder({this.context, this.userId, this.delieveryAddId});

  final BuildContext context;
  final String userId;
  final String delieveryAddId;

  @override
  List<Object> get props => [context];
}

class DeleteFromCart extends ProductEvent {
  const DeleteFromCart(
      {this.context, this.cartId, this.cartDataList, this.cartIndex});

  final BuildContext context;
  final String cartId;
  final List<CartData> cartDataList;
  final int cartIndex;

  @override
  List<Object> get props => [context];
  get getCartDataList => cartDataList;
}

class AddtoWishlist extends ProductEvent {
  const AddtoWishlist(
      {this.context,
      this.productId,
      this.userId,
      this.userType,
      this.productDataList,
      this.currentIndex});

  final BuildContext context;
  final String productId;
  final String userId;
  final String userType;
  final List<ProductData> productDataList;
  final int currentIndex;

  @override
  List<Object> get props => [context];
  get getProductDataList => productDataList;
}

class WishDatalist extends ProductEvent {
  const WishDatalist({this.context, this.userId, this.wishListDataList});

  final BuildContext context;
  final String userId;
  final List<WishListData> wishListDataList;

  @override
  List<Object> get props => [context];
  get getWishListDataList => wishListDataList;
}

class DeleteFromWishDatalist extends ProductEvent {
  const DeleteFromWishDatalist(
      {this.context, this.wishListId, this.productDataList, this.currentIndex});

  final BuildContext context;
  final String wishListId;
  final List<ProductData> productDataList;
  final int currentIndex;

  @override
  List<Object> get props => [context];
  get getProductDataList => productDataList;
}

class EditCart extends ProductEvent {
  const EditCart({this.context, this.cartId, this.userId, this.qty});

  final BuildContext context;
  final String cartId;
  final String userId;
  final String qty;

  @override
  List<Object> get props => [context];
}

class SearchProduct extends ProductEvent {
  const SearchProduct({this.context, this.text, this.userId});

  final BuildContext context;
  final String text;
  final String userId;

  @override
  List<Object> get props => [context];
}

class AddPromoCode extends ProductEvent {
  const AddPromoCode(
      {this.context, this.userId, this.promocode, this.billamount});

  final BuildContext context;
  final String userId;
  final String promocode;
  final String billamount;

  @override
  List<Object> get props => [context];
}

class PromoListdata extends ProductEvent {
  const PromoListdata({
    this.context,
  });

  final BuildContext context;

  @override
  List<Object> get props => [context];
}
