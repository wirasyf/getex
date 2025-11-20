import 'package:get/get.dart';

import '../modules/auth/bindings/auth_binding.dart';
import '../modules/auth/screen/login_screen.dart';
import '../modules/auth/screen/register_screen.dart';
import '../modules/details/bindings/details_binding.dart';
import '../modules/details/screen/announcement.dart';
import '../modules/details/screen/detail_announcement.dart';
import '../modules/details/screen/detail_event.dart';
import '../modules/details/screen/details_family.dart';
import '../modules/details/screen/details_payment_history.dart';
import '../modules/details/screen/edit_family.dart';
import '../modules/details/screen/event.dart';
import '../modules/edit_password/bindings/change_password_binding.dart';
import '../modules/edit_password/bindings/reset_password_binding.dart';
import '../modules/edit_password/screen/edit_password_screen.dart';
import '../modules/edit_password/screen/new_password.dart';
import '../modules/edit_password/screen/reset_password.dart';
import '../modules/edit_password/screen/verification_email.dart';
import '../modules/edit_profile/bindings/edit_profile_binding.dart';
import '../modules/edit_profile/screen/edit_profile_view.dart';
import '../modules/faq/bindings/faq_binding.dart';
import '../modules/faq/screen/faq_screen.dart';
import '../modules/home/bindings/home_binding.dart';
import '../modules/home/screen/home_screen.dart';
import '../modules/input_personalization/bindings/input_personalization_binding.dart';
import '../modules/input_personalization/screen/input_personalization_screen.dart';
import '../modules/maps/bindings/edit_map_binding.dart';
import '../modules/maps/bindings/input_map_binding.dart';
import '../modules/maps/bindings/select_map_binding.dart';
import '../modules/maps/screen/edit_map_screen.dart';
import '../modules/maps/screen/input_map_screen.dart';
import '../modules/maps/screen/select_map_screen.dart';
import '../modules/notification/bindings/notification_binding.dart';
import '../modules/notification/screen/detail_notification.dart';
import '../modules/notification/screen/notification_screen.dart';
import '../modules/on_boarding/bindings/on_boarding_binding.dart';
import '../modules/on_boarding/screen/on_boarding_screen.dart';
import '../modules/payment/bindings/payment_binding.dart';
import '../modules/payment/screen/payment_history.dart';
import '../modules/payment/screen/payment_screen.dart';
import '../modules/profile/bindings/profile_binding.dart';
import '../modules/profile/screen/profile_screen.dart';
import '../modules/report/bindings/report_binding.dart';
import '../modules/report/screen/report_screen.dart';
import '../modules/report_dana/bindings/report_dana_binding.dart';
import '../modules/report_dana/screen/report_dana_screen.dart';
import '../modules/splash/bindings/splash_binding.dart';
import '../modules/splash/screen/splash_screen.dart';
import '../modules/terms/bindings/terms_binding.dart';
import '../modules/terms/screen/terms_screen.dart';
import '../modules/verification/bindings/verification_binding.dart';
import '../modules/verification/screen/pending_screen.dart';
import '../modules/verification/screen/verification_screen.dart';
import '../modules/verification/screen/verificationdone_screen.dart';

part 'app_routes.dart';

class AppPages {
  AppPages._();

  static final INITIAL = Routes.SPLASH;

  static final routes = [
    GetPage(
      name: _Paths.SPLASH,
      page: () => const SplashSmartScreen(),
      binding: SplashSmartBinding(),
    ),
    GetPage(
      name: _Paths.ON_BOARDING,
      page: () => const OnBoardingView(),
      binding: OnBoardingBinding(),
    ),
    GetPage(
      name: _Paths.HOME,
      page: () => const HomeView(),
      binding: HomeBinding(),
    ),
    GetPage(
      name: _Paths.PROFILE,
      page: () => const ProfileView(),
      binding: ProfileBinding(),
    ),
    GetPage(
      name: _Paths.LOGIN,
      page: () => const LoginView(),
      binding: AuthBinding(),
    ),
    GetPage(
      name: _Paths.REGISTER,
      page: () => const RegisterView(),
      binding: AuthBinding(),
    ),
    GetPage(
      name: _Paths.INPUT_PERSONALIZATION,
      page: () => const InputPersonalizationView(),
      binding: InputPersonalizationBinding(),
    ),
    GetPage(
      name: _Paths.VERIFICATION,
      page: () => const VerificationView(),
      binding: VerificationBinding(),
    ),
    GetPage(
      name: _Paths.VERIFICATIONDONE,
      page: () => const VerificationdoneView(),
      binding: VerificationBinding(),
    ),
    GetPage(
      name: _Paths.PENDING,
      page: () => const PendingView(),
      binding: VerificationBinding(),
    ),
    GetPage(
      name: _Paths.PAYMENT,
      page: () => const PaymentView(),
      binding: PaymentBinding(),
    ),
    GetPage(
      name: _Paths.REPORT,
      page: () => const ReportView(),
      binding: ReportBinding(),
    ),
    GetPage(
      name: Routes.INPUT_MAP,
      page: () => const InputMapView(),
      binding: InputMapBinding(),
    ),

    // SINKRONISASI: Rute ini membuat EditMapController baru
    GetPage(
      name: Routes.EDIT_MAP,
      page: () => const EditMapView(),
      binding: EditMapBinding(),
    ),

    // SINKRONISASI: Rute ini membuat SelectMapController baru
    GetPage(
      name: Routes.SELECT_MAP,
      page: () => const SelectMapView(),
      binding: SelectMapBinding(),
    ),
    GetPage(
      name: _Paths.EDIT_PROFILE,
      page: () => const EditProfileView(),
      binding: EditProfileBinding(),
    ),
    GetPage(name: _Paths.TERMS, page: TermsScreen.new, binding: TermsBinding()),
    GetPage(name: _Paths.FAQ, page: FaqScreen.new, binding: FaqBinding()),
    GetPage(
      name: _Paths.DETAILS_ANNOUNCEMENT,
      page: () => const DetailsAnnouncementPage(),
      binding: DetailsBinding(),
    ),
    GetPage(
      name: _Paths.DETAILS_EVENT,
      page: () => const DetailsEventPage(),
      binding: DetailsBinding(),
    ),
    GetPage(
      name: _Paths.ANNOUNCEMENT,
      page: () => const AnnouncementView(),
      binding: DetailsBinding(),
    ),
    GetPage(
      name: _Paths.EVENT,
      page: () => const EventView(),
      binding: DetailsBinding(),
    ),
    GetPage(
      name: _Paths.DETAILS_FAMILY,
      page: () => const DetailsFamily(),
      binding: DetailsBinding(),
    ),
    GetPage(
      name: _Paths.REPORT_DANA,
      page: () => const ReportDanaView(),
      binding: ReportDanaBinding(),
    ),
    GetPage(
      name: _Paths.PAYMENT_HISTORY,
      page: () => const RiwayatTransaksiPage(),
      binding: PaymentBinding(),
    ),
    GetPage(
      name: _Paths.NOTIFICATION,
      page: () => const NotificationView(),
      binding: NotificationBinding(),
    ),
    GetPage(
      name: _Paths.DETAILS_PAYMENT_HISTORY,
      page: DetailPaymentHistoryScreen.new,
      binding: PaymentBinding(),
    ),
    GetPage(
      name: _Paths.EDIT_PASSWORD,
      page: () => const EditPasswordView(),
      binding: ChangePasswordBinding(),
    ),
    GetPage(
      name: _Paths.VERIFICATION_EMAIL,
      page: () => const VerificationEmailView(),
      binding: ResetPasswordBinding(),
    ),
    GetPage(
      name: _Paths.RESET_PASSWORD,
      page: () => const ResetPasswordView(),
      binding: ResetPasswordBinding(),
    ),
    GetPage(
      name: _Paths.NEW_PASSWORD,
      page: () => const NewPasswordView(),
      binding: ResetPasswordBinding(),
    ),
    GetPage(
      name: _Paths.DETAIL_NOTIFICATION,
      page: () => const NotificationDetailView(),
      binding: NotificationBinding(),
    ),
    GetPage(
      name: _Paths.EDIT_FAMILY,
      page: () => const EditFamilyView(),
      binding: DetailsBinding(),
    ),
  ];
}
