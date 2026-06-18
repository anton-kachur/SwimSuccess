/// A strongly-typed data model representing a user entity fetched from the remote API.
/// 
/// This class encapsulates core user profile data and ensures full type safety,
/// preventing raw [Map] objects from leaking directly into the presentation layer.
class UserModel {
  final int id;
  final String name;
  final String username;
  final String email;
  final String phone;
  final String website;
  final Address address;
  final Company company;

  UserModel({
    required this.id,
    required this.name,
    required this.username,
    required this.email,
    required this.phone,
    required this.website,
    required this.address,
    required this.company,
  });

  /// Factory constructor to securely map raw dynamic JSON entries into an immutable [UserModel].
  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] as int,
      name: json['name'] as String,
      username: json['username'] as String,
      email: json['email'] as String,
      phone: json['phone'] as String,
      website: json['website'] as String,
      // Map complex nested sub-structures using their own domain model contract definitions
      address: Address.fromJson(json['address'] as Map<String, dynamic>),
      company: Company.fromJson(json['company'] as Map<String, dynamic>),
    );
  }
}

/// A structured sub-model representing the geo-location and address configuration of a user.
class Address {
  final String street;
  final String suite;
  final String city;
  final String zipcode;

  Address({
    required this.street,
    required this.suite,
    required this.city,
    required this.zipcode,
  });

  /// Factory constructor to safely parse nested address metadata maps.
  factory Address.fromJson(Map<String, dynamic> json) {
    return Address(
      street: json['street'] as String,
      suite: json['suite'] as String,
      city: json['city'] as String,
      zipcode: json['zipcode'] as String,
    );
  }
}

/// A structured sub-model encapsulating the workplace and business metrics of a user.
class Company {
  final String name;
  final String catchPhrase;
  final String bs;

  Company({
    required this.name,
    required this.catchPhrase,
    required this.bs,
  });

  /// Factory constructor to safely parse nested company target parameter sets.
  factory Company.fromJson(Map<String, dynamic> json) {
    return Company(
      name: json['name'] as String,
      catchPhrase: json['catchPhrase'] as String,
      bs: json['bs'] as String,
    );
  }
}

