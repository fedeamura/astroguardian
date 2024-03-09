enum ShipAbility {
  rayLength,
  raySpeed,
  rayCount,
  bagSize;

  int get value {
    switch (this) {
      case ShipAbility.rayLength:
        return 1;
      case ShipAbility.raySpeed:
        return 2;
      case ShipAbility.rayCount:
        return 3;
      case ShipAbility.bagSize:
        return 4;
    }
  }

  String get displayName {
    switch (this) {
      case ShipAbility.rayLength:
        return "Ray length";
      case ShipAbility.raySpeed:
        return "Ray speed";
      case ShipAbility.rayCount:
        return "Ray count";
      case ShipAbility.bagSize:
        return "Bag size";
    }
  }

  String get description {
    switch (this) {
      case ShipAbility.rayLength:
        return "Determines the maximum distance from which you can attract space debris towards your ship.";
      case ShipAbility.raySpeed:
        return "Specifies the speed at which space debris is attracted towards your ship.";
      case ShipAbility.rayCount:
        return "Sets the maximum quantity of space debris you can attract simultaneously.";
      case ShipAbility.bagSize:
        return "Defines the size of your resource bag, determining the amount of space debris you can collect.";
    }
  }

  String get valueLabel {
    switch (this) {
      case ShipAbility.rayLength:
        return "Ray length";
      case ShipAbility.raySpeed:
        return "Attraction speed";
      case ShipAbility.rayCount:
        return "Meteorite count";
      case ShipAbility.bagSize:
        return "Capacity";
    }
  }
}
