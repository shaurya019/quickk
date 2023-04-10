part of 'ProductBloc.dart';

class ProductState extends Equatable {
  final int version;

  const ProductState({this.version});

  ProductState copyWith({
    int version,
  }) {
    return ProductState(
      version: version ?? this.version,
    );
  }

  @override
  List<Object> get props => [version];
}

class ProductInitialState extends ProductState {
  const ProductInitialState({
    this.context,
    this.version,
  }) : super(version: version);

  final BuildContext context;
  final int version;

  @override
  List<Object> get props => [version];
}

class ProductCompleteState extends ProductState {
  const ProductCompleteState({this.context, this.version, this.productDataList})
      : super(version: version);

  final BuildContext context;
  final int version;
  final List<ProductData> productDataList;

  @override
  List<Object> get props => [version];
  get getProductDataList => productDataList;
}

class ProductDataFetchState extends ProductState {
  const ProductDataFetchState({this.context, this.version, this.productData})
      : super(version: version);

  final BuildContext context;
  final int version;
  final ProductData productData;

  @override
  List<Object> get props => [version];
  get getProductData => productData;
}

class AddtoCartCompleteState extends ProductState {
  const AddtoCartCompleteState(
      {this.context, this.version, this.productDataList})
      : super(version: version);

  final BuildContext context;
  final int version;
  final List<ProductData> productDataList;

  @override
  List<Object> get props => [version];
  get getProductDataList => productDataList;
}

class CartDataCompleteState extends ProductState {
  const CartDataCompleteState(
      {this.context,
      this.version,
      this.cartDataList,
      this.subtotal,
      this.Shipchrg,
      this.discount,
      this.total})
      : super(version: version);

  final BuildContext context;
  final int version;
  final List<CartData> cartDataList;
  final String subtotal;
  final String Shipchrg;
  final String discount;
  final String total;

  @override
  List<Object> get props => [version];
  get getCartDataList => cartDataList;
}

class OrderCompleteState extends ProductState {
  const OrderCompleteState({
    this.context,
    this.version,
  }) : super(version: version);

  final BuildContext context;
  final int version;

  @override
  List<Object> get props => [version];
}

class DeleteFromCartCompleteState extends ProductState {
  const DeleteFromCartCompleteState({
    this.context,
    this.version,
  }) : super(version: version);

  final BuildContext context;
  final int version;

  @override
  List<Object> get props => [version];
}

class WishListCompleteState extends ProductState {
  const WishListCompleteState(
      {this.context, this.version, this.wishListDataList})
      : super(version: version);

  final BuildContext context;
  final int version;
  final List<WishListData> wishListDataList;

  @override
  List<Object> get props => [version];
  get getWishListDataList => wishListDataList;
}

class DeleteFromWishListCompleteState extends ProductState {
  const DeleteFromWishListCompleteState(
      {this.context, this.version, this.productDataList})
      : super(version: version);

  final BuildContext context;
  final int version;
  final List<ProductData> productDataList;

  @override
  List<Object> get props => [version];
  get getProductDataList => productDataList;
}

class AddtoWishListCompleteState extends ProductState {
  const AddtoWishListCompleteState(
      {this.context, this.version, this.productDataList})
      : super(version: version);

  final BuildContext context;
  final int version;
  final List<ProductData> productDataList;

  @override
  List<Object> get props => [version];
  get getProductDataList => productDataList;
}

class EditCartListCompleteState extends ProductState {
  const EditCartListCompleteState({
    this.context,
    this.version,
  }) : super(version: version);

  final BuildContext context;
  final int version;

  @override
  List<Object> get props => [version];
}

class SearchedProductCompleteState extends ProductState {
  const SearchedProductCompleteState(
      {this.context, this.version, this.productDataList})
      : super(version: version);

  final BuildContext context;
  final int version;
  final List<ProductData> productDataList;

  @override
  List<Object> get props => [version];
  get getProductDataList => productDataList;
}

class PromocodeCompleteState extends ProductState {
  const PromocodeCompleteState({this.context, this.version, this.discount})
      : super(version: version);

  final BuildContext context;
  final int version;
  final String discount;

  @override
  List<Object> get props => [version];
}

class PromoListCompleteState extends ProductState {
  const PromoListCompleteState({this.context, this.version, this.promolist})
      : super(version: version);

  final BuildContext context;
  final int version;
  final List<PromoList> promolist;

  @override
  List<Object> get props => [version];
}
