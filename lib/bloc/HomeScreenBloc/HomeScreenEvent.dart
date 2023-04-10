part of 'HomeScreenBloc.dart';


abstract class HomeScreenEvent extends Equatable {
  const HomeScreenEvent();

  @override
  List<Object> get props => [];
}

class GetCategoryList extends HomeScreenEvent {

  const GetCategoryList({this.context});


  final BuildContext context;



  @override
  List<Object> get props => [context];

}

class HomeDataList extends HomeScreenEvent {

  const HomeDataList({this.context,this.userId});


  final BuildContext context;
  final String userId;



  @override
  List<Object> get props => [context];

}


class HomeSliderList extends HomeScreenEvent {

  const HomeSliderList({this.context});


  final BuildContext context;



  @override
  List<Object> get props => [context];

}

class GetUserData extends HomeScreenEvent {

  const GetUserData({this.context,this.userId});


  final BuildContext context;
  final String userId;



  @override
  List<Object> get props => [context];

}

