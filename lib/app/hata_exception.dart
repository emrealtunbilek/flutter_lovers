class Hatalar {
  static String goster(String hataKodu) {
    switch (hataKodu) {
      case 'ERROR_EMAIL_ALREADY_IN_USE':
        return "Bu mail adresi zaten kullanımda, lütfen farklı bir mail kullanınız";

      default:
        return "Bir hata olustu";
    }
  }
}
