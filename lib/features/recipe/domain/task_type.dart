import 'package:flutter/material.dart';
import 'package:winemaker/app/router.dart';

enum TaskType {
  calculations,
  description,
  addingIngredients,
  timeNotification,
  result,
}

extension TaskTypeExtension on TaskType {
  String get routeName {
    switch (this) {
      case TaskType.calculations:
        return AppRoute.calculations;
      case TaskType.description:
        return AppRoute.description;
      case TaskType.result:
        return AppRoute.result;
      case TaskType.timeNotification:
        return AppRoute.timeNotification;
      case TaskType.addingIngredients:
        return AppRoute.addingIngredients;
    }
  }

  IconData get icon {
    switch (this) {
      case TaskType.calculations:
        return Icons.science_outlined;
      case TaskType.description:
        return Icons.description_outlined;
      case TaskType.addingIngredients:
        return Icons.add_circle_outline;
      case TaskType.timeNotification:
        return Icons.timer_outlined;
      case TaskType.result:
        return Icons.rate_review_outlined;
    }
  }

  String get label {
    switch (this) {
      case TaskType.calculations:
        return 'Calculations';
      case TaskType.description:
        return 'Instructions';
      case TaskType.addingIngredients:
        return 'Add ingredients';
      case TaskType.timeNotification:
        return 'Wait';
      case TaskType.result:
        return 'Result';
    }
  }
}
