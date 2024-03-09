enum GameImages {
  background,
  ship,
  shipParticle,
  check;

  String get path {
    switch (this) {
      case GameImages.background:
        return "background/0.png";

      case GameImages.ship:
        return "ship.png";

      case GameImages.shipParticle:
        return "ship_particle.png";

      case GameImages.check:
        return "check.png";
    }
  }
}
