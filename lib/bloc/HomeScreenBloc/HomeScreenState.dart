part of 'HomeScreenBloc.dart';

class HomeScreenState extends Equatable {
  final int version;

  const HomeScreenState({ this.version});

  HomeScreenState copyWith({
    int version
  }) {
    return HomeScreenState(
        version: version ?? this.version,
    );
  }


  @override
  List<Object> get props => [version];

}



class HomeScreenInitialState extends HomeScreenState {

  const HomeScreenInitialState({
    this.context,
    this.version,
  }):super(version: version);

  final BuildContext context;
  final  int version;

  @override
  List<Object> get props => [version];
}

class HomeScreenCompleteState extends HomeScreenState {

  const HomeScreenCompleteState({
    this.context,
    this.version,
    this.categoryDataList
  }):super(version: version);

  final BuildContext context;
  final int version;
  final List<CategoryData> categoryDataList;


  @override
  List<Object> get props => [version];
  get getCategoryList => categoryDataList;
}


class HomeDataListCompleteState extends HomeScreenState {

  const HomeDataListCompleteState({
    this.context,
    this.version,
    this.topProductDataList,
    this.offerDataList,
    this.recomProductDataList
  }):super(version: version);

  final BuildContext context;
  final int version;
  final List<ProductData> topProductDataList;
  final List<OfferData> offerDataList;
  final List<ProductData> recomProductDataList;


  @override
  List<Object> get props => [version];
  get getTopProductDataList => topProductDataList;
  get getOfferDataList => offerDataList;
  get getRecomProductDataList => recomProductDataList;
}

class HomeSliderCompleteState extends HomeScreenState {

  const HomeSliderCompleteState({
    this.context,
    this.version,
    this.sliderDataList
  }):super(version: version);

  final BuildContext context;
  final int version;
  final List<SliderData> sliderDataList;


  @override
  List<Object> get props => [version];
  get getSliderDataList => sliderDataList;
}


class GetUserDataCompleteState extends HomeScreenState {

  const GetUserDataCompleteState({
    this.context,
    this.version,
    this.userData
  }):super(version: version);

  final BuildContext context;
  final int version;
  final UserData userData;


  @override
  List<Object> get props => [version];
  get getUserData => userData;
}
