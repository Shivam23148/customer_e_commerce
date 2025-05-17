import 'package:bloc/bloc.dart';
import 'package:customer_e_commerce/core/di/service_locator.dart';
import 'package:customer_e_commerce/features/user/data/models/profile_models.dart';
import 'package:customer_e_commerce/features/user/domain/repositories/auth_repository.dart';
import 'package:customer_e_commerce/features/user/domain/repositories/profile_repository.dart';
part 'profile_event.dart';
part 'profile_state.dart';

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  final ProfileRepository profileRepository =
      serviceLocator<ProfileRepository>();
  final AuthRepository authRepository = serviceLocator<AuthRepository>();
  ProfileBloc() : super(ProfileInitial()) {
    on<FetchProfileDataEvent>((event, emit) async {
      try {
        final profileData = await profileRepository.getProfile();
        emit(ProfileLoadedState(profileData));
      } catch (e) {
        emit(ProfileErrorMessage(message: "Failed to fetch Profile Data!"));
        throw Exception("Fetch profile data error : $e");
      }
    });
    on<ProfileResetEvent>((event, emit) {
      emit(ProfileInitial());
    });
    on<EditProfileDataEvent>((event, emit) async {
      emit(ProfileLoadingState());
      try {
        await profileRepository.editProfile(event.firstName, event.lastName);

        emit(ProfileEditedState());
      } catch (e) {
        emit(ProfileErrorMessage(message: "Failed to update Name"));
        throw Exception("Update profile error : $e");
      }
    });
    on<VerifyPasswordEvent>((event, emit) async {
      emit(ProfileLoadingState());
      try {
        await authRepository.verifyCurrentPassword(event.oldPassword);
        emit(CurrentPasswordVerified());
      } catch (e) {
        emit(ProfileErrorMessage(message: "Failed to verify password!"));
        print("Update Verify Password Error : $e");
      }
    });
    on<UpdatePasswordWithNew>((event, emit) async {
      emit(ProfileLoadingState());
      try {
        await authRepository.updatePasswordCredential(
            event.currentP, event.newP);
        await profileRepository.updatePassword(event.newP);
        emit(UpdatePasswordSuccess());
      } catch (e) {
        emit(ProfileErrorMessage(message: "Failed to update Password!"));
        print("Update Password Error : $e");
      }
    });
    on<UpdatePhoneEvent>((event, emit) async {
      emit(ProfileLoadingState());
      try {
        await profileRepository.updatePhone(event.newPhone);
        emit(PhoneUpdatedState());
      } catch (e) {
        emit(ProfileErrorMessage(message: "Failed to update phone!"));
      }
    });
    on<LogoutEvent>((event, emit) async {
      try {
        await authRepository.logout();
        emit(LogoutSuccessfullState());
      } catch (e) {
        emit(ProfileErrorMessage(message: "Failed to log out!"));
      }
    });
  }
  Stream<Profile> profileStream() {
    return profileRepository.profileStream();
  }
}
