part of 'WalletBloc.dart';


abstract class WalletEvent extends Equatable {
  const WalletEvent();

  @override
  List<Object> get props => [];
}

class WalletListEvent extends WalletEvent {
  const WalletListEvent({this.context , this.userId});


  final String userId;
  final BuildContext context;



  @override
  List<Object> get props => [context];

}

