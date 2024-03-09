enum TerrainType {
  none,
  dirt,
  energy,
  asterium,
  ferronite,
  plasmatite,
  quartzion,
  starlume,
  vortexite;

  bool get isNone => this == none;

  bool get isEnergy => this == energy;

  bool get canBeConsumed {
    if (this == TerrainType.none) return false;
    return true;
  }

  int get maxHealth {
    switch (this) {
      case TerrainType.none:
        return -1;
      case TerrainType.dirt:
        return 3;
      case TerrainType.energy:
        return 3;
      case TerrainType.asterium:
        return 4;
      case TerrainType.ferronite:
        return 4;
      case TerrainType.plasmatite:
        return 5;
      case TerrainType.quartzion:
        return 5;
      case TerrainType.starlume:
        return 6;
      case TerrainType.vortexite:
        return 6;
    }
  }

  int get minItems {
    switch (this) {
      case TerrainType.none:
        return 0;
      case TerrainType.dirt:
        return 1;
      case TerrainType.energy:
        return 1;
      case TerrainType.asterium:
        return 1;
      case TerrainType.ferronite:
        return 1;
      case TerrainType.plasmatite:
        return 1;
      case TerrainType.quartzion:
        return 1;
      case TerrainType.starlume:
        return 1;
      case TerrainType.vortexite:
        return 1;
    }
  }

  int get maxItems {
    switch (this) {
      case TerrainType.none:
        return 0;
      case TerrainType.dirt:
        return 4;
      case TerrainType.energy:
        return 3;
      case TerrainType.asterium:
        return 3;
      case TerrainType.ferronite:
        return 3;
      case TerrainType.plasmatite:
        return 3;
      case TerrainType.quartzion:
        return 3;
      case TerrainType.starlume:
        return 2;
      case TerrainType.vortexite:
        return 2;
    }
  }

  int get price {
    switch (this) {
      case TerrainType.none:
        return 0;
      case TerrainType.dirt:
        return 1;
      case TerrainType.energy:
        return 2;
      case TerrainType.asterium:
        return 3;
      case TerrainType.ferronite:
        return 3;
      case TerrainType.plasmatite:
        return 4;
      case TerrainType.quartzion:
        return 4;
      case TerrainType.starlume:
        return 7;
      case TerrainType.vortexite:
        return 10;
    }
  }
}
