class User {
  int? id;
  String? name;
  String? city;
  String? address;
  String? country;
  String? age;
  String? cnic;
  int? updatedDate;
  int? createdDate;

  User(
      {this.id,
      this.name,
      this.city,
      this.address,
      this.country,
      this.age,
      this.cnic,
      this.updatedDate,
      this.createdDate});

  User.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    city = json['city'];
    address = json['address'];
    country = json['country'];
    age = json['age'];
    cnic = json['cnic'];
    updatedDate = json['updatedDate'];
    createdDate = json['createdDate'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['city'] = city;
    data['address'] = address;
    data['country'] = country;
    data['age'] = age;
    data['cnic'] = cnic;
    data['updatedDate'] = updatedDate;
    data['createdDate'] = createdDate;
    return data;
  }
}
