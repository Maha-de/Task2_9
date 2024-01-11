part of 'ads_cubit.dart';

@immutable
abstract class AdsState {}

class AdsInitial extends AdsState {
  
}

class AdsLoaded extends AdsState{
  final List<Recipe> recipes;

  AdsLoaded(this.recipes);
}
