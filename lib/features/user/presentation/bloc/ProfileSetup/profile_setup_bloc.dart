import 'package:bloc/bloc.dart';
import 'package:customer_e_commerce/features/user/domain/repositories/profile_repository.dart';

part 'profile_setup_event.dart';
part 'profile_setup_state.dart';

class ProfileSetupBloc extends Bloc<ProfileSetupEvent, ProfileSetupState> {
  final ProfileRepository profileRepository;
  ProfileSetupBloc({required this.profileRepository})
      : super(ProfileSetupInitial()) {
    on<SaveBasicInfoEvent>((event, emit) {
      emit(ProfileSetupLoading());
      try {
        profileRepository.saveBasicInfo(event.name, event.phone);
        emit(ProfileBasicInfoSaved());
      } catch (e) {
        rethrow;
      }
    });
    on<SaveAddressEvent>((event, emit) {
      emit(ProfileSetupLoading());
      try {
        profileRepository.saveAddress(event.house, event.buildingNo,
            event.landmark, event.state, event.zip, event.city);
        emit(ProfileSaved());
      } catch (e) {
        rethrow;
      }
    });
  }
}
