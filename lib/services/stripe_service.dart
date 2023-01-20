import 'dart:convert';

import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:http/http.dart' as http;

class StripeService {
  StripeService._privateConstructor();

  static final StripeService _instance = StripeService._privateConstructor();

  factory StripeService() => _instance;

  String apiKey =
      'pk_test_51LbS2ML9K8E9sOnYw1fp1MenGr5O1oen8kE9yfVQ8pGggxQ3c8IQk1erzkKOKB6VVqYICEfZuppIq3tfelMu9RBu00nCvW6zeY';

  void init() {
    Stripe.publishableKey = apiKey;
  }
}
