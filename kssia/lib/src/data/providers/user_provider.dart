import 'dart:developer';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kssia/src/data/services/api_routes/user_api.dart';
import 'package:kssia/src/data/models/product_model.dart';
import 'package:kssia/src/data/models/user_model.dart';

import '../globals.dart';

class UserNotifier extends StateNotifier<AsyncValue<UserModel>> {
  final StateNotifierProviderRef<UserNotifier, AsyncValue<UserModel>> ref;

  UserNotifier(this.ref) : super(const AsyncValue.loading()) {
    _initializeUser();
  }

  /// Initializes the user when the notifier is first created
  Future<void> _initializeUser() async {
    if (mounted) {
      await _fetchUserDetails();
    }
  }

  /// Refresh user details by re-fetching them and updating the state
  Future<void> refreshUser() async {
    if (mounted) {
      state = const AsyncValue.loading(); // Set state to loading during refresh
      await _fetchUserDetails();
    }
  }

  /// Helper function to fetch user details and update the state
  Future<void> _fetchUserDetails() async {
    try {
      log('Fetching user details');
      final user = await ref.read(fetchUserDetailsProvider(token, id).future);
      state = AsyncValue.data(user ?? UserModel());
    } catch (e, stackTrace) {
      state = AsyncValue.error(e, stackTrace);
      log('Error fetching user details: $e');
      log(stackTrace.toString());
    }
  }

  void updateName({
    String? name,
  }) {

       state =
        state.whenData((user) => user.copyWith(name: name));

  }
  void updateAbbreviation({
    String? abbreviation,
  }) {

       state =
        state.whenData((user) => user.copyWith(abbreviation: abbreviation));

  }

  void updateVideos(List<Video> videos) {
    state = state.whenData((user) => user.copyWith(video: videos));
  }

  void removeVideo(Video videoToRemove) {
    state = state.whenData((user) {
      final updatedVideo =
          user.video!.where((video) => video != videoToRemove).toList();
      return user.copyWith(video: updatedVideo);
    });
  }

  void updateWebsite(List<Website> websites) {
    state = state.whenData((user) => user.copyWith(websites: websites));
    log('website count in updation ${websites.length}');
  }

  void removeWebsite(Website websiteToRemove) {
    state = state.whenData((user) {
      final updatedWebsites = user.websites!
          .where((website) => website != websiteToRemove)
          .toList();
      return user.copyWith(websites: updatedWebsites);
    });
  }

  void updatePhoneNumbers({
    String? personal,
    String? landline,
    String? companyPhoneNumber,
    String? whatsappNumber,
    String? whatsappBusinessNumber,
  }) {
    state = state.whenData((user) {
      final newPhoneNumbers = user.phoneNumbers?.copyWith(
            personal: personal ?? user.phoneNumbers?.personal,
            landline: landline ?? user.phoneNumbers?.landline,
            companyPhoneNumber:
                companyPhoneNumber ?? user.phoneNumbers?.companyPhoneNumber,
            whatsappNumber: whatsappNumber ?? user.phoneNumbers?.whatsappNumber,
            whatsappBusinessNumber: whatsappBusinessNumber ??
                user.phoneNumbers?.whatsappBusinessNumber,
          ) ??
          PhoneNumbers(
            personal: personal,
            landline: landline,
            companyPhoneNumber: companyPhoneNumber,
            whatsappNumber: whatsappNumber,
            whatsappBusinessNumber: whatsappBusinessNumber,
          );
      return user.copyWith(phoneNumbers: newPhoneNumbers);
    });
  }

  void updateBloodGroup(String? bloodGroup) {
    state = state.whenData((user) => user.copyWith(bloodGroup: bloodGroup));
  }

  void updateEmail(String? email) {
    state = state.whenData((user) => user.copyWith(email: email));
  }

  void updateDesignation(String? designation) {
    state = state.whenData((user) => user.copyWith(designation: designation));
  }

  void updateCompanyName(String? companyName) {
    state = state.whenData((user) => user.copyWith(companyName: companyName));
  }

  void updateCompanyEmail(String? companyEmail) {
    state = state.whenData((user) => user.copyWith(companyEmail: companyEmail));
  }

  void updateBusinessCategory(String? businessCategory) {
    state = state
        .whenData((user) => user.copyWith(businessCategory: businessCategory));
  }

  void updateSubCategory(String? subCategory) {
    state = state.whenData((user) => user.copyWith(subCategory: subCategory));
  }

  void updateBio(String? bio) {
    state = state.whenData((user) => user.copyWith(bio: bio));
  }

  void updateAddress(String? address) {
    state = state.whenData((user) => user.copyWith(address: address));
  }

  void updateIsActive(bool? isActive) {
    state = state.whenData((user) => user.copyWith(isActive: isActive));
  }

  void updateIsDeleted(bool? isDeleted) {
    state = state.whenData((user) => user.copyWith(isDeleted: isDeleted));
  }

  void updateSelectedTheme(String? selectedTheme) {
    state =
        state.whenData((user) => user.copyWith(selectedTheme: selectedTheme));
  }

  void updateCreatedAt(String? createdAt) {
    state = state.whenData((user) => user.copyWith(createdAt: createdAt));
  }

  void updateUpdatedAt(String? updatedAt) {
    state = state.whenData((user) => user.copyWith(updatedAt: updatedAt));
  }

  void updateCompanyAddress(String? companyAddress) {
    state =
        state.whenData((user) => user.copyWith(companyAddress: companyAddress));
  }

  void updateCompanyLogo(String? companyLogo) {
    state = state.whenData((user) => user.copyWith(companyLogo: companyLogo));
  }

  void updateProfilePicture(String? profilePicture) {
    state =
        state.whenData((user) => user.copyWith(profilePicture: profilePicture));
  }

  void updateAwards(List<Award> awards) {
    state = state.whenData((user) => user.copyWith(awards: awards));
  }

  void updateBrochure(List<Brochure> brochure) {
    state = state.whenData((user) => user.copyWith(brochure: brochure));
  }

  void updateCertificate(List<Certificate> certificates) {
    state = state.whenData((user) => user.copyWith(certificates: certificates));
  }

  void updateProduct(List<Product> products) {
    state = state.whenData((user) => user.copyWith(products: products));
  }

  void updateSocialMedia(
      List<SocialMedia> socialmedias, String platform, String newUrl) {
    if (platform != '') {
      final index =
          socialmedias.indexWhere((item) => item.platform == platform);

      if (index != -1) {
        final updatedSocialMedia = socialmedias[index].copyWith(url: newUrl);
        socialmedias[index] = updatedSocialMedia;
      } else {
        final newSocialMedia = SocialMedia(platform: platform, url: newUrl);
        socialmedias.add(newSocialMedia);
      }

      state =
          state.whenData((user) => user.copyWith(socialMedia: socialmedias));
    } else {
      state = state.whenData((user) => user.copyWith(socialMedia: []));
    }
    log('Updated Social Media $socialmedias');
  }

  void updateVideo(
    List<Video> videos,
  ) {
    state = state.whenData(
      (user) => user.copyWith(video: videos),
    );
  }

  void removeAward(Award awardToRemove) {
    state = state.whenData((user) {
      final updatedAwards =
          user.awards!.where((award) => award != awardToRemove).toList();
      return user.copyWith(awards: updatedAwards);
    });
  }

  void editAward(Award oldAward, Award updatedAward) {
  state = state.whenData((user) {
    final updatedAwards = user.awards!.map((award) {
      return award == oldAward ? updatedAward : award;
    }).toList();

    return user.copyWith(awards: updatedAwards);
  });
}


  void removeBrochure(Brochure brochureToRemove) {
    state = state.whenData((user) {
      final updatedBrochures = user.brochure!
          .where((brochure) => brochure != brochureToRemove)
          .toList();
      return user.copyWith(brochure: updatedBrochures);
    });
  }

  void removeCertificate(Certificate certificateToRemove) {
    state = state.whenData((user) {
      final updatedCertificate = user.certificates!
          .where((certificate) => certificate != certificateToRemove)
          .toList();
      return user.copyWith(certificates: updatedCertificate);
    });
  }

  void removeProduct(Product productToRemove) {
    state = state.whenData((user) {
      final updatedProducts = user.products!
          .where((product) => product != productToRemove)
          .toList();
      return user.copyWith(products: updatedProducts);
    });
  }

  void editWebsite(Website oldWebsite, Website newWebsite) {
    state = AsyncValue.data(state.value!.copyWith(
      websites: state.value!.websites!.map((w) => 
        w == oldWebsite ? newWebsite : w
      ).toList()
    ));
  }

  void editVideo(Video oldVideo, Video newVideo) {
    state = AsyncValue.data(state.value!.copyWith(
      video: state.value!.video!.map((v) =>
        v == oldVideo ? newVideo : v  
      ).toList()
    ));
  }

  void editProduct(Product oldProduct, Product newProduct) {
    state = AsyncValue.data(state.value!.copyWith(
      products: state.value!.products!.map((p) =>
        p == oldProduct ? newProduct : p
      ).toList()
    ));
  }

  void editCertificate(Certificate oldCertificate, Certificate newCertificate) {
    state = AsyncValue.data(state.value!.copyWith(
      certificates: state.value!.certificates!.map((c) => 
        c == oldCertificate ? newCertificate : c
      ).toList()
    ));
  }
}

final userProvider =
    StateNotifierProvider<UserNotifier, AsyncValue<UserModel>>((ref) {
  return UserNotifier(ref);
});
