class GivitUser {
  final String uid;
  final String email;
  final String password;
  final String fullName;
  final int phoneNumber;

  GivitUser(
      {this.email = '',
      this.password = '',
      this.fullName = '',
      this.phoneNumber = 0,
      this.uid = ''});
}
