/// A connectable health-data source shown on the Integrations screen.
enum HealthSource {
  healthConnect(
    'Health Connect',
    'Google Fit, Samsung Health & more (Android)',
    '🟢',
  ),
  fitbit('Fitbit', 'Fitbit watches & bands (cloud)', '⌚'),
  appleHealth('Apple Health', 'Apple Watch & iPhone (iOS)', '🍎');

  const HealthSource(this.label, this.subtitle, this.icon);
  final String label;
  final String subtitle;
  final String icon;
}
