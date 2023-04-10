part of 'AddressBloc.dart';


abstract class AddressEvent extends Equatable {
  const AddressEvent();

  @override
  List<Object> get props => [];
}

class SaveAddressEvent extends AddressEvent {
  const SaveAddressEvent({this.context , this.address1 ,this.address2,this.address3,this.pincode,this.latitude,this.longitude , this.userid });

  final String address1;
  final String address2;
  final String address3;
  final String pincode;
  final String latitude;
  final String longitude;
  final String userid;
  final BuildContext context;



  @override
  List<Object> get props => [context];

}


class GetAddressList extends AddressEvent {
  const GetAddressList({this.context, this.userId });


  final String userId;
  final BuildContext context;



  @override
  List<Object> get props => [context];

}


class SetCurrentAddressEvent extends AddressEvent {
  const SetCurrentAddressEvent({this.context ,this.addid , this.userid });


  final String addid;
  final String userid;
  final BuildContext context;



  @override
  List<Object> get props => [context];

}
