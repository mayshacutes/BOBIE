enum MascotGender { boy, girl }

class AppUser {
  final String nis;
  final String password;
  final String name;
  final MascotGender gender;

  const AppUser({
    required this.nis,
    required this.password,
    required this.name,
    required this.gender,
  });
}

const List<AppUser> dummyUsers = [
  AppUser(nis: 'Ilma3', password: 'ITDP3', name: 'Ilma', gender: MascotGender.girl),
  AppUser(nis: 'Dimas1', password: 'ITDP1', name: 'Dimas', gender: MascotGender.boy),
];

AppUser? findUser(String nis, String password) {
  for (final user in dummyUsers) {
    final sameNis = user.nis.toLowerCase() == nis.toLowerCase();
    final samePassword = user.password == password;
    if (sameNis && samePassword) return user;
  }
  return null;
}
