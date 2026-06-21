import 'package:flutter/material.dart';
import 'package:winemaker/app/router.dart';

enum TaskType {
  description,
  addingIngredients,
  timeNotification,
}

extension TaskTypeExtension on TaskType {
  String get routeName {
    switch (this) {
      case TaskType.description:
        return AppRoute.description;
      case TaskType.addingIngredients:
      case TaskType.timeNotification:
        throw UnimplementedError('No route for $this yet');
    }
  }

  IconData get icon {
    switch (this) {
      case TaskType.description:
        return Icons.description_outlined;
      case TaskType.addingIngredients:
        return Icons.add_circle_outline;
      case TaskType.timeNotification:
        return Icons.timer_outlined;
    }
  }
}
