part of 'purchases_bloc.dart';

@immutable
class PurchasesState extends Equatable {
  const PurchasesState();

  @override
  List<Object?> get props => [];
}

class PurchasesInitial extends PurchasesState {}



// /// Banner reloaded states
// final class BannerLoaded extends BannerState {
//   final BannerModel bannerData;
//   const BannerLoaded({required this.bannerData});
// }

// final class BannerError extends BannerState {
//   final String? message;
//   const BannerError(this.message);
// }
