import 'package:flutter/material.dart';

/// A connectable health-data source shown on the Integrations screen.
enum HealthSource {
  healthConnect(
    'Health Connect',
    'Google Fit, Samsung Health & more (Android)',
    Icons.favorite,
  ),
  fitbit('Fitbit', 'Fitbit watches & bands (cloud)', Icons.watch),
  appleHealth('Apple Health', 'Apple Watch & iPhone (iOS)', Icons.phone_iphone);

  const HealthSource(this.label, this.subtitle, this.icon);
  final String label;
  final String subtitle;
  final IconData icon;
}
