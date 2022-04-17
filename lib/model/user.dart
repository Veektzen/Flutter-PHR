final String tableUsers = 'users';

class UserFields {
  static final List<String> values = [
    // all fields
    id, name, surname, birthdate, gender, weight, username, password, email
  ];

  static final String id = '_id';
  static final String name = 'name';
  static final String surname = 'surname';
  static final String birthdate = 'birthdate';
  static final String gender = 'gender';
  static final String weight = 'weight';
  static final String username = 'username';
  static final String password = 'password';
  static final String email = 'email';
}

class User {
  final int id;
  final String name;
  final String surname;
  final DateTime birthdate;
  final String gender;
  final int weight;
  final String username;
  final String password;
  final String email;

  const User({
    this.id,
    this.name,
    this.surname,
    this.birthdate,
    this.gender,
    this.weight,
    this.username,
    this.password,
    this.email,
  });

  User copy({
    int id,
    String name,
    String surname,
    DateTime birthdate,
    String gender,
    int weight,
    String username,
    String password,
    String email,
  }) =>
      User(
        id: id ?? this.id,
        name: name ?? this.name,
        surname: surname ?? this.surname,
        birthdate: birthdate ?? this.birthdate,
        gender: gender ?? this.gender,
        weight: weight ?? this.weight,
        username: username ?? this.username,
        password: password ?? this.password,
        email: email ?? this.email,
      );

  static User fromMap(Map<String, Object> map) => User(
        id: map[UserFields.id] as int,
        name: map[UserFields.name] as String,
        surname: map[UserFields.surname] as String,
        birthdate: DateTime.parse(map[UserFields.birthdate] as String),
        gender: map[UserFields.gender] as String,
        weight: map[UserFields.weight] as int,
        username: map[UserFields.username] as String,
        password: map[UserFields.password] as String,
        email: map[UserFields.email] as String,
      );

  Map<String, Object> toMap() => {
        UserFields.id: id,
        UserFields.name: name,
        UserFields.surname: surname,
        UserFields.birthdate: birthdate.toString(),
        UserFields.gender: gender,
        UserFields.weight: weight,
        UserFields.username: username,
        UserFields.password: password,
        UserFields.email: email,
      };
  int getId() {
    return id;
  }

  String getName() {
    return name;
  }

  String getSurname() {
    return surname;
  }

  DateTime getBirthdate() {
    return birthdate;
  }

  String getGender() {
    return gender;
  }

  int getWeight() {
    return weight;
  }

  String getUsername() {
    return username;
  }

  String getPassword() {
    return password;
  }

  String getEmail() {
    return email;
  }
}
