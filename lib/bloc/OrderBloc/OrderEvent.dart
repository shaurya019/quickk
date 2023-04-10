part of 'OrderBloc.dart';


abstract class OrderEvent extends Equatable {
  const OrderEvent();

  @override
  List<Object> get props => [];
}

class OrderListEvent extends OrderEvent {
  const OrderListEvent({this.context , this.userId,this.fromCancelOrder});


  final String userId;
  final bool fromCancelOrder;
  final BuildContext context;



  @override
  List<Object> get props => [context];

}


class CancelOrderEvent extends OrderEvent {
  const CancelOrderEvent({this.context ,this.orderId,this.cancelReason, this.userId});

  final String orderId;
  final String cancelReason;
  final String userId;
  final BuildContext context;



  @override
  List<Object> get props => [context];

}

