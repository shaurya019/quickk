part of 'AddressBloc.dart';

class AddressState extends Equatable {
  final int version;


  const AddressState({this.version});

  AddressState copyWith({
    int version
  }) {
    return AddressState(
        version: version ?? this.version,
    );
  }


  @override
  List<Object> get props => [version];

}



class AddressInitialState extends AddressState {

  const AddressInitialState({
    this.context,
    this.version,
  }):super(version: version);

  final BuildContext context;
  final  int version;

  @override
  List<Object> get props => [version];
}

class AddressCompleteState extends AddressState {

  const AddressCompleteState({
    this.context,
    this.version,
    this.locationDataList
  }):super(version: version);

  final BuildContext context;
  final int version;
  final List<LocationData> locationDataList;

  @override
  List<Object> get props => [version];
  get getLocationDataList => locationDataList;
}

class SetAddressCompleteState extends AddressState {

  const SetAddressCompleteState({
    this.context,
    this.version,
  }):super(version: version);

  final BuildContext context;
  final int version;


  @override
  List<Object> get props => [version];

}