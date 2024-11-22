import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive/hive.dart';
import 'package:pixel_parade/categories.dart';
import 'package:pixel_parade/colletions.dart';
import 'package:pixel_parade/features/home_feature/UI/home.dart';

import '../bloc/bloc/home_bloc.dart';

class DashboardWidget extends StatefulWidget {
  const DashboardWidget({super.key});

  @override
  State<StatefulWidget> createState() => _DashboardWidget();
}

GlobalKey bottomNavigationKey = GlobalKey();

class _DashboardWidget extends State<DashboardWidget> {
  int _currentIndex = 0;

  var dashoardScreens = [HomeScreen(), MyCollection(), MyCategories()];

  @override
  void initState() {
    if (mounted) {
      context.read<BannerBloc>().createToken();
      callingRequiredFuncs();
    }
    super.initState();
  }

  callingRequiredFuncs() {
    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) {
        context.read<BannerBloc>().add(HomeBannerFetchEvent());
        context.read<HomeBloc>().add(HomeInitialFetchEvent());
        context.read<KeywordsBloc>().add(KeywordsFetchEvent());
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    return Scaffold(
        bottomNavigationBar: BlocListener<BottomBarBloc, BottomBarState>(
          listener: (context, state) {
            if (state is BottomBarNewIndexUpdate) {
              setState(() => _currentIndex = state.newValue);
            }
          },
          child: BottomNavigationBar(
            key: bottomNavigationKey,
            type: BottomNavigationBarType.fixed,
            currentIndex: _currentIndex,
            backgroundColor: colorScheme.surface,
            selectedItemColor: Colors.blue[300],
            unselectedItemColor: colorScheme.onSurface.withOpacity(.60),
            selectedLabelStyle: textTheme.bodySmall,
            unselectedLabelStyle: textTheme.bodySmall,
            onTap: (value) {
              if (value == 1) {
                context.read<HomeBloc>().add(HomeReload());
              }
              setState(() => _currentIndex = value);
            },
            items: const [
              BottomNavigationBarItem(
                label: 'Home',
                icon: Icon(Icons.home_outlined),
              ),
              BottomNavigationBarItem(
                label: 'Collections',
                icon: Icon(Icons.shopping_cart_checkout_sharp),
              ),
              BottomNavigationBarItem(
                label: 'Categories',
                icon: Icon(Icons.category_outlined),
              ),
            ],
          ),
        ),
        body: Container(
          child: BlocBuilder<HomeBloc, HomeState>(
            builder: (context, state) {
              if (state is HomeLoaded || state is HomeKeyWordsSearchLoaded) {
                return dashoardScreens[_currentIndex];
              } else {
                return Container();
              }
            },
          ),
        ));
  }
}
