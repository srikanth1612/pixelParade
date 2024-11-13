part of 'purchases_bloc.dart';

@immutable
class PurchasesEvent {}

class GetPurchaseHistory extends PurchasesEvent {}

class GetPurchaseLoading extends PurchasesEvent {}
