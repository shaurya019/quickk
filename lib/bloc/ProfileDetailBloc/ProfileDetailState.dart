part of 'ProfileDetailBloc.dart';

class ProfileDetailState extends Equatable {
  final int version;
  final FirstName firstName;
  final LastName lastName;
  final Email email;
  final FormzStatus status;


  const ProfileDetailState({ this.version,this.firstName = const FirstName.pure(),this.lastName = const LastName.pure(),this.email = const Email.pure(),this.status});

  ProfileDetailState copyWith({
    int version,
    FormzStatus status,
    FirstName firstName,
    LastName lastName,
    Email email,


  }) {
    return ProfileDetailState(
        version: version ?? this.version,
        status: status ?? this.status,
        email: email ?? this.email,
        firstName: firstName ?? this.firstName,
        lastName: lastName ?? this.lastName
    );
  }


  @override
  List<Object> get props => [version];

}



class ProfileDetailInitialState extends ProfileDetailState {

  const ProfileDetailInitialState({
    this.context,
    this.version,

  }):super(version: version);

  final BuildContext context;
  final  int version;


  @override
  List<Object> get props => [version];
}

class ProfileDetailCompleteState extends ProfileDetailState {

  const ProfileDetailCompleteState({
    this.context,
    this.version,
  }):super(version: version);

  final BuildContext context;
  final int version;


  @override
  List<Object> get props => [version];
}

class DocumentCompleteState extends ProfileDetailState {

  const DocumentCompleteState({
    this.context,
    this.version,
  }):super(version: version);

  final BuildContext context;
  final int version;


  @override
  List<Object> get props => [version];
}