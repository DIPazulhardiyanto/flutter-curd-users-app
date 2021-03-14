class Validation {
  String validateName(String value) {
    if (value.isEmpty) {
      //JIKA VALUE KOSONG
      return 'Required *'; //MAKA PESAN DITAMPILKAN
    }
    return null;
  }
}
