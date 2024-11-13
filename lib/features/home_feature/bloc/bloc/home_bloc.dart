import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:equatable/equatable.dart';
import 'package:pixel_parade/models/banner_model.dart';
import 'package:pixel_parade/models/stickers_model.dart';
import 'package:pixel_parade/network/api_provider.dart';
import 'package:pixel_parade/network/session_manager/session_manager.dart';

part 'home_event.dart';
part 'home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  HomeBloc() : super(HomeInitial()) {
    on<HomeInitialFetchEvent>(homeInitialFetchEvent);
  }

  FutureOr<void> homeInitialFetchEvent(
      HomeInitialFetchEvent event, Emitter<HomeState> emit) async {
    emit(HomeLoading());
    List<TotalStickers>? posts = await ApiProvider.apiProvider.getStickers();
    if (posts != null) {
      emit(HomeLoaded(totalStickers: posts));
    } else {
      emit(const HomeError("message"));
    }
  }
}

class BannerBloc extends Bloc<BannerEvent, BannerState> {
  BannerBloc() : super(BannerInitial()) {
    on<HomeBannerFetchEvent>(homeBannerFetch);
  }

  FutureOr<void> homeBannerFetch(
      HomeBannerFetchEvent event, Emitter<BannerState> emit) async {
    BannerModel? posts = await ApiProvider.apiProvider.getBanner();
    if (posts != null) {
      emit(BannerLoaded(bannerData: posts));
    } else {
      emit(const BannerError("message"));
    }
  }

  void createToken() async {
    String? token = await SessionManager.getToken();
    if (token == "") {
      ApiProvider.apiProvider.createToken();
    }
  }
}

class KeywordsBloc extends Bloc<KeywordsEvent, KeywordsState> {
  KeywordsBloc() : super(KeywordsInitial()) {
    on<KeywordsFetchEvent>(keywordsFetchEvent);
  }

  FutureOr<void> keywordsFetchEvent(
      KeywordsFetchEvent event, Emitter<KeywordsState> emit) async {
    List<String>? posts = await ApiProvider.apiProvider.getKeywords();
    if (posts != null) {
      emit(KeywordsLoaded(keywords: posts));
    } else {
      emit(const KeywordsError("message"));
    }
  }
}

class BottomBarBloc extends Bloc<BottomBarEvent, BottomBarState> {
  BottomBarBloc() : super(BottomBarInitial()) {
    on<BottomBarUpdateHomeEvent>(bottombarUpdateHome);
    on<BottomBarUpdateCategoriesEvent>(bottombarUpdateCategories);
    on<BottomBarUpdateCollectionEvent>(bottombarUpdateCollection);
  }

  FutureOr<void> bottombarUpdateHome(
      BottomBarUpdateHomeEvent event, Emitter<BottomBarState> emit) async {
    emit(const BottomBarNewIndexUpdate(0));
    emit(BottomBarValueUpdated());
  }

  FutureOr<void> bottombarUpdateCategories(BottomBarUpdateCategoriesEvent event,
      Emitter<BottomBarState> emit) async {
    emit(const BottomBarNewIndexUpdate(2));
    emit(BottomBarValueUpdated());
  }

  FutureOr<void> bottombarUpdateCollection(BottomBarUpdateCollectionEvent event,
      Emitter<BottomBarState> emit) async {
    emit(const BottomBarNewIndexUpdate(1));
    emit(BottomBarValueUpdated());
  }
}
