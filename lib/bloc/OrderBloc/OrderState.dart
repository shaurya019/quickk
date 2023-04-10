part of 'OrderBloc.dart';

class OrderState extends Equatable {
  final int version;


  const OrderState({this.version});

  OrderState copyWith({
    int version
  }) {
    return OrderState(
      version: version ?? this.version,
    );
  }


  @override
  List<Object> get props => [version];

}



class OrderInitialState extends OrderState {

  const OrderInitialState({
    this.context,
    this.version,
  }):super(version: version);

  final BuildContext context;
  final  int version;

  @override
  List<Object> get props => [version];
}

class OrderCompleteState extends OrderState {

  const OrderCompleteState({
    this.context,
    this.version,
    this.fromCancelOrder,
    this.orderList
  }):super(version: version);

  final BuildContext context;
  final int version;
  final bool fromCancelOrder;
  final List<OrderData> orderList;

  @override
  List<Object> get props => [version];
  get getOrderList => orderList;
}

class CancelOrderCompleteState extends OrderState {

  const CancelOrderCompleteState({
    this.context,
    this.version,

  }):super(version: version);

  final BuildContext context;
  final int version;



  @override
  List<Object> get props => [version];

}