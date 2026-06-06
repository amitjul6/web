import '../core/formulas.dart';
import 'enums.dart';

/// User profile. Identity fields come from Google sign-in; body stats from onboarding.
class Profile {
  final String? name;
  final String? email;
  final String? photoUrl;
  final Sex sex;
  final DateTime birthDate;
  final double heightCm;
  final double weightKg;
  final ActivityLevel activityLevel;
  final double? weightGoalKg;
  final UnitSystem unitSystem;

  const Profile({
    this.name,
    this.email,
    this.photoUrl,
    required this.sex,
    required this.birthDate,
    required this.heightCm,
    required this.weightKg,
    required this.activityLevel,
    this.weightGoalKg,
    this.unitSystem = UnitSystem.metric,
  });

  int get age => Formulas.ageFromBirthDate(birthDate);

  double get bmr => Formulas.bmr(
        sex: sex,
        weightKg: weightKg,
        heightCm: heightCm,
        ageYears: age,
      );

  double get tdee => Formulas.tdee(bmr: bmr, activity: activityLevel);

  Profile copyWith({
    String? name,
    String? email,
    String? photoUrl,
    Sex? sex,
    DateTime? birthDate,
    double? heightCm,
    double? weightKg,
    ActivityLevel? activityLevel,
    double? weightGoalKg,
    UnitSystem? unitSystem,
  }) {
    return Profile(
      name: name ?? this.name,
      email: email ?? this.email,
      photoUrl: photoUrl ?? this.photoUrl,
      sex: sex ?? this.sex,
      birthDate: birthDate ?? this.birthDate,
      heightCm: heightCm ?? this.heightCm,
      weightKg: weightKg ?? this.weightKg,
      activityLevel: activityLevel ?? this.activityLevel,
      weightGoalKg: weightGoalKg ?? this.weightGoalKg,
      unitSystem: unitSystem ?? this.unitSystem,
    );
  }

  Map<String, dynamic> toJson() => {
        'name': name,
        'email': email,
        'photoUrl': photoUrl,
        'sex': sex.name,
        'birthDate': birthDate.toIso8601String(),
        'heightCm': heightCm,
        'weightKg': weightKg,
        'activityLevel': activityLevel.name,
        'weightGoalKg': weightGoalKg,
        'unitSystem': unitSystem.name,
      };

  factory Profile.fromJson(Map<String, dynamic> j) => Profile(
        name: j['name'] as String?,
        email: j['email'] as String?,
        photoUrl: j['photoUrl'] as String?,
        sex: Sex.values.byName(j['sex'] as String),
        birthDate: DateTime.parse(j['birthDate'] as String),
        heightCm: (j['heightCm'] as num).toDouble(),
        weightKg: (j['weightKg'] as num).toDouble(),
        activityLevel: ActivityLevel.values.byName(j['activityLevel'] as String),
        weightGoalKg: (j['weightGoalKg'] as num?)?.toDouble(),
        unitSystem: UnitSystem.values.byName(
          (j['unitSystem'] as String?) ?? UnitSystem.metric.name,
        ),
      );
}
