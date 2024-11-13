import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:pixel_parade/models/stickers_model.dart';
import 'package:pixel_parade/network/session_manager/session_manager.dart';

import '../../../network/api_provider.dart';

part 'purchases_event.dart';
part 'purchases_state.dart';

class PurchasesBloc extends Bloc<PurchasesEvent, PurchasesState> {
  PurchasesBloc() : super(PurchasesInitial()) {
    on<PurchasesEvent>((event, emit) {
      // TODO: implement event handler
    });
  }

  getPurchasesFromStore() {}

  FutureOr<void> homeInitialFetchEvent(
      PurchasesInitial event, Emitter<PurchasesState> emit) async {
    // emit(GetPurchaseLoading());
    String? email = await SessionManager.getUserEmail();
    var posts = await ApiProvider.apiProvider.saveUserEmail(email ?? "");
    if (posts != null) {
      // emit(HomeLoaded(totalStickers: posts));
    } else {
      // emit(const HomeError("message"));
    }
  }
}
