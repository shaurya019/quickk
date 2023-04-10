part of 'WalletBloc.dart';

class WalletState extends Equatable {
  final int version;


  const WalletState({this.version});

  WalletState copyWith({
    int version
  }) {
    return WalletState(
      version: version ?? this.version,
    );
  }


  @override
  List<Object> get props => [version];

}



class WalletInitialState extends WalletState {

  const WalletInitialState({
    this.context,
    this.version,
  }):super(version: version);

  final BuildContext context;
  final  int version;

  @override
  List<Object> get props => [version];
}

class WalletCompleteState extends WalletState {

  const WalletCompleteState({
    this.context,
    this.version,
    this.walletAmount,
    this.walletrList
  }):super(version: version);

  final BuildContext context;
  final int version;
  final String walletAmount;
  final List<WalletData> walletrList;

  @override
  List<Object> get props => [version];
  get getWalletrList => walletrList;
}

