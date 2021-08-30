class LoginModel {
  final String userName;
  final String password;

  LoginModel({required this.userName, required this.password});

  Map<String, dynamic> toJson() {
    Map<String, dynamic> data = new Map<String, dynamic>();
    data['username'] = this.userName;
    if (this.password != null) data['password'] = this.password;
    return data;
  }
}
