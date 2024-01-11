import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

import '../models/ad_model.dart';
import '../services/ads_repository.dart';

part 'ads_state.dart';

class AdsCubit extends Cubit<AdsState> {
  final AdsRepository adsRepository;
  List<Recipe> recipes = [];

  AdsCubit(this.adsRepository) : super(AdsInitial());

  List<Recipe> getAllAds(){
    adsRepository.getAllAds().then((value) {
      emit(AdsLoaded(recipes));
      this.recipes;
    });
    return recipes;
  }
}
