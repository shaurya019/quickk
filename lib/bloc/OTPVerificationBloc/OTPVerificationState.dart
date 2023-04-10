part of 'OTPVerificationBloc.dart';

class OTPVerificationState extends Equatable {
  final int version;
  const OTPVerificationState({this.version});

  @override
  List<Object> get props => [version];

}



class OTPVerificationInitialState extends OTPVerificationState {

  const OTPVerificationInitialState({
    this.context,
    this.version
  }):super(version: version);

  final BuildContext context;
  final  int version;

  @override
  List<Object> get props => [version];
}

class OTPVerificationCompleteState extends OTPVerificationState {

  const OTPVerificationCompleteState({
    this.context,
    this.version,
    this.isRegistered
  }):super(version: version);

  final BuildContext context;
  final int version;
  final bool isRegistered;


  @override
  List<Object> get props => [version];
}

class SendOTPCompleteState extends OTPVerificationState {

  const SendOTPCompleteState({
    this.context,
    this.version,
  }):super(version: version);

  final BuildContext context;
  final int version;


  @override
  List<Object> get props => [version];
}