part of 'EnterNumberBloc.dart';

class EnterNumberState extends Equatable {
  final int version;
   final MobileNumber mobileNumber;
  final FormzStatus status;


  const EnterNumberState({ this.version,this.mobileNumber = const MobileNumber.pure(),this.status});

  EnterNumberState copyWith({
    MobileNumber mobileNumber,
    FormzStatus status,
    int version
  }) {
    return EnterNumberState(
        version: version ?? this.version,
        mobileNumber: mobileNumber ?? this.mobileNumber,
        status: status ?? this.status
    );
  }


  @override
  List<Object> get props => [version];

}



class EnterNumberInitialState extends EnterNumberState {

  const EnterNumberInitialState({
    this.context,
    this.version,
    this.status
  }):super(version: version);

  final BuildContext context;
  final  int version;
  final FormzStatus status;

  @override
  List<Object> get props => [version];
}

class EnterNumberCompleteState extends EnterNumberState {

  const EnterNumberCompleteState({
    this.context,
    this.version,
    this.mobileNumber,
    this.formzStatus
  }):super(version: version,mobileNumber: mobileNumber,status: formzStatus);

  final BuildContext context;
  final int version;
  final MobileNumber mobileNumber;
  final FormzStatus formzStatus;

  @override
  List<Object> get props => [version];
}