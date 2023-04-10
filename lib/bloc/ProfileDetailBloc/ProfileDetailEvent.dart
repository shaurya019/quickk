part of 'ProfileDetailBloc.dart';


abstract class ProfileDetailEvent extends Equatable {
  const ProfileDetailEvent();

  @override
  List<Object> get props => [];
}

class SaveProfileDetailEvent extends ProfileDetailEvent {
  const SaveProfileDetailEvent({this.context  , this.firstName,this.lastName,this.emailId,this.mobileNumber,this.prefx,this.userType});

  final String firstName;
  final String lastName;
  final String emailId;
  final String mobileNumber;
  final String prefx;
  final String userType;
  final BuildContext context;



  @override
  List<Object> get props => [context];

}


class FirstNameChanged extends ProfileDetailEvent {
  const FirstNameChanged({this.firstName});

  final String firstName;

  @override
  List<Object> get props => [firstName];
}

class LastNameChanged extends ProfileDetailEvent {
  const LastNameChanged({this.lastName});

  final String lastName;

  @override
  List<Object> get props => [lastName];
}

class EmailChanged extends ProfileDetailEvent {
  const EmailChanged({this.email});

  final String email;

  @override
  List<Object> get props => [email];
}


class EditProfileDetailEvent extends ProfileDetailEvent {
  const EditProfileDetailEvent({this.context  , this.firstName,this.lastName,this.emailId,this.prefx,this.userId,this.imageFile});

  final String firstName;
  final String lastName;
  final String emailId;
  final String prefx;
  final String userId;
  final File imageFile;
  final BuildContext context;



  @override
  List<Object> get props => [context];

}


class DocumentUploadEvent extends ProfileDetailEvent {
  const DocumentUploadEvent({this.context , this.imageFile,this.documentFile,this.documentId1,this.documentId2,this.userId});

  final File imageFile;
  final File documentFile;
  final String documentId1;
  final String documentId2;
  final String userId;
  final BuildContext context;



  @override
  List<Object> get props => [context];

}