enum TerrainRarity {
  normal,
  rare,
  ultra;

  int get itemMultiplier {
    switch (this) {
      case TerrainRarity.normal:
        return 1;
      case TerrainRarity.rare:
        return 2;
      case TerrainRarity.ultra:
        return 3;
    }
  }
}
