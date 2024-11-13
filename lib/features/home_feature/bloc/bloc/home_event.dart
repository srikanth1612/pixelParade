part of 'home_bloc.dart';

@immutable
class HomeEvent {}

class HomeInitialFetchEvent extends HomeEvent {}

@immutable
class BannerEvent {}

class HomeBannerFetchEvent extends BannerEvent {}

@immutable
class KeywordsEvent {}

class KeywordsFetchEvent extends KeywordsEvent {}

@immutable
class BottomBarEvent {}

class BottomBarUpdateHomeEvent extends BottomBarEvent {}

class BottomBarUpdateCollectionEvent extends BottomBarEvent {}

class BottomBarUpdateCategoriesEvent extends BottomBarEvent {}