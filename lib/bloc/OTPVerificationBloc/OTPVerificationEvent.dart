part of 'OTPVerificationBloc.dart';


abstract class OTPVerificationEvent extends Equatable {
  const OTPVerificationEvent();

  @override
  List<Object> get props => [];
}



class VerifyOTPEvent extends OTPVerificationEvent {
  const VerifyOTPEvent({ this.context  , this.mobileNumber, this.otpNumber});

  final String mobileNumber;
  final String otpNumber;
  final BuildContext context;


  @override
  List<Object> get props => [context];

}
