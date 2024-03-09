enum ConversationSpeaker {
  captainDash,
  shipBot,
  planetPresident;

  int get value {
    switch (this) {
      case ConversationSpeaker.captainDash:
        return 1;
      case ConversationSpeaker.shipBot:
        return 2;
      case ConversationSpeaker.planetPresident:
        return 3;
    }
  }
}
