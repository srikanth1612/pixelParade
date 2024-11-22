part of 'home_bloc.dart';

@immutable
abstract class HomeState extends Equatable {
  const HomeState();

  @override
  List<Object?> get props => [];
}

/// Home stickers states

class HomeInitial extends HomeState {}

class HomeLoading extends HomeState {}

class HomeLoaded extends HomeState {
  final List<TotalStickers> totalStickers;
  const HomeLoaded({required this.totalStickers});
}

class HomeKeyWordsSearchLoaded extends HomeState {
  final List<TotalStickers> totalStickers;
  const HomeKeyWordsSearchLoaded({required this.totalStickers});
}

class HomeReloadOriginal extends HomeState {}

class HomeError extends HomeState {
  final String? message;
  const HomeError(this.message);
}

class HomeAdditionalStickersLoaded extends HomeState {}

class HomeAdditionStickersError extends HomeState {}

@immutable
abstract class BannerState extends Equatable {
  const BannerState();

  @override
  List<Object?> get props => [];
}

class BannerInitial extends BannerState {}

/// Banner reloaded states
class BannerLoaded extends BannerState {
  final BannerModel bannerData;
  const BannerLoaded({required this.bannerData});
}

class BannerError extends BannerState {
  final String? message;
  const BannerError(this.message);
}

@immutable
abstract class KeywordsState extends Equatable {
  const KeywordsState();

  @override
  List<Object?> get props => [];
}

class KeywordsInitial extends KeywordsState {}

/// Keywords reloaded states
class KeywordsLoaded extends KeywordsState {
  final List<String> keywords;
  const KeywordsLoaded({required this.keywords});
}

class KeywordsError extends KeywordsState {
  final String? message;
  const KeywordsError(this.message);
}

@immutable
abstract class BottomBarState extends Equatable {
  const BottomBarState();

  @override
  List<Object?> get props => [];
}

class BottomBarInitial extends BottomBarState {}

class BottomBarNewIndexUpdate extends BottomBarState {
  final int newValue;
  const BottomBarNewIndexUpdate(this.newValue);
}

class BottomBarValueUpdated extends BottomBarState {}
