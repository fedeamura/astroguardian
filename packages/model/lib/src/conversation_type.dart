import 'package:model/model.dart';

enum ConversationType {
  tutorialInit,
  tutorialPlanetFound,
  tutorialBagFull,
  tutorialRecycle,
  tutorialLevelUp,
  tutorialImproveShip,
  tutorialPlanetCompleted,
  tutorialStartAdventure;

  int get value {
    switch (this) {
      case ConversationType.tutorialInit:
        return 1;
      case ConversationType.tutorialPlanetFound:
        return 2;
      case ConversationType.tutorialBagFull:
        return 3;
      case ConversationType.tutorialRecycle:
        return 4;
      case ConversationType.tutorialLevelUp:
        return 5;
      case ConversationType.tutorialImproveShip:
        return 7;
      case ConversationType.tutorialStartAdventure:
        return 8;
      case ConversationType.tutorialPlanetCompleted:
        return 9;
    }
  }

  bool get once {
    switch (this) {
      case ConversationType.tutorialInit:
        return true;
      case ConversationType.tutorialPlanetFound:
        return true;
      case ConversationType.tutorialBagFull:
        return true;
      case ConversationType.tutorialRecycle:
        return true;
      case ConversationType.tutorialLevelUp:
        return true;
      case ConversationType.tutorialImproveShip:
        return true;
      case ConversationType.tutorialPlanetCompleted:
        return true;
      case ConversationType.tutorialStartAdventure:
        return true;
    }
  }

  List<ConversationData> get data {
    switch (this) {
      case ConversationType.tutorialInit:
        return _tutorialInitData;
      case ConversationType.tutorialPlanetFound:
        return _tutorialPlanetFound;
      case ConversationType.tutorialBagFull:
        return _tutorialBagFull;
      case ConversationType.tutorialRecycle:
        return _tutorialRecycle;
      case ConversationType.tutorialLevelUp:
        return _tutorialLevelUp;
      case ConversationType.tutorialImproveShip:
        return _tutorialImproveShip;
      case ConversationType.tutorialPlanetCompleted:
        return _tutorialPlanetCompleted;
      case ConversationType.tutorialStartAdventure:
        return _tutorialStartAdventure;
    }
  }

  String get hint {
    switch (this) {
      case ConversationType.tutorialInit:
        return "Follow the yellow indicator";
      case ConversationType.tutorialPlanetFound:
        return "Collect space junk";
      case ConversationType.tutorialBagFull:
        return "Tap on the ship to recycle";
      case ConversationType.tutorialRecycle:
        return "Fill the data bar";
      case ConversationType.tutorialLevelUp:
        return "Upgrade the ship from the menu";
      case ConversationType.tutorialImproveShip:
        return "Collect all the space junk";
      case ConversationType.tutorialPlanetCompleted:
        return "";
      case ConversationType.tutorialStartAdventure:
        return "";
    }
  }

  List<ConversationData> get _tutorialInitData {
    return [
      ConversationData(
        speaker: ConversationSpeaker.shipBot,
        messages: [
          "Hello Captain Dash! It's been a while since I've seen you around. What exciting adventures do you have in mind for today?",
        ],
      ),
      ConversationData(
        speaker: ConversationSpeaker.captainDash,
        messages: [
          "Hey Dartina! Honestly, not much comes to mind... any suggestions?",
        ],
      ),
      ConversationData(
        speaker: ConversationSpeaker.shipBot,
        messages: [
          "I'm detecting a signal from an unknown planet. What do you say we go check out what's happening? Just follow the yellow indicator",
        ],
      ),
    ];
  }

  List<ConversationData> get _tutorialPlanetFound {
    return [
      ConversationData(
        speaker: ConversationSpeaker.shipBot,
        messages: [
          "We found the planet Captain Dash!",
          "Do you see that interference? It's very strange",
          "I am going to try to communicate with the planet",
          "...",
          "We established connection!",
        ],
      ),
      ConversationData(
        speaker: ConversationSpeaker.planetPresident,
        messages: [
          "Good morning Captain Dash. Glad you could make it",
          "As you can see, our planet is covered with space debris",
          "Space debris can cause collisions, disrupt telecommunications, generate more waste, and endanger manned missions",
          "Also generates that annoying interference in the sensors of the ships",
          "Could you help us remove all that space debris?"
        ],
      ),
      ConversationData(
        speaker: ConversationSpeaker.captainDash,
        messages: [
          "Of course! Although I can't think of a good way to do it... Can you think of something, Dartina?",
        ],
      ),
      ConversationData(
        speaker: ConversationSpeaker.shipBot,
        messages: [
          "Our ship is equipped with an attractor beam. I just configured it to be able to attract the space debris and store it in our cargo hold",
          "Press the blue button to activate it"
        ],
      ),
    ];
  }

  List<ConversationData> get _tutorialBagFull {
    return [
      ConversationData(
        speaker: ConversationSpeaker.shipBot,
        messages: [
          "It seems the ship's cargo hold is full. We won't be able to collect more space debris until we find a way to get rid of it",
        ],
      ),
      ConversationData(
        speaker: ConversationSpeaker.captainDash,
        messages: [
          "We can't just toss it out there! What could we do?",
        ],
      ),
      ConversationData(
        speaker: ConversationSpeaker.shipBot,
        messages: [
          "How about we recycle it? The ship has a powerful compactor. Just tap on the ship and I'll take care of activating the necessary procedures",
        ],
      ),
    ];
  }

  List<ConversationData> get _tutorialRecycle {
    return [
      ConversationData(
        speaker: ConversationSpeaker.shipBot,
        messages: [
          "That worked perfectly! All the trash has been recycled",
          "By recycling space debris, I gather data and I have a theory that if we collect enough, we might be able to use it somehow on the ship",
          "I'll add an indicator for the cargo hold capacity and another one for the amount of data collected",
          "Let's try to fill up that data bar!",
        ],
      ),
    ];
  }

  List<ConversationData> get _tutorialLevelUp {
    return [
      ConversationData(
        speaker: ConversationSpeaker.shipBot,
        messages: [
          "Great news, Captain Dash. By recycling the space debris, I managed to gather enough data to upgrade our ship",
          "From the menu, you can spend your experience points to upgrade the ship",
        ],
      ),
    ];
  }

  List<ConversationData> get _tutorialImproveShip {
    return [
      ConversationData(
        speaker: ConversationSpeaker.shipBot,
        messages: [
          "The ship is working much better now!",
          "How about we finish helping the President and collect all the space junk orbiting the planet",
        ],
      ),
    ];
  }

  List<ConversationData> get _tutorialPlanetCompleted {
    return [
      ConversationData(
        speaker: ConversationSpeaker.shipBot,
        messages: [
          "You did it, Captain Dash! We've collected all the space junk from the planet",
          "...",
          "I'm receiving a new communication from the planet.",
          "...",
        ],
      ),
      ConversationData(
        speaker: ConversationSpeaker.planetPresident,
        messages: [
          "Thank you so much for the help, Captain Dash. I don't know what we would have done without you",
          "Now the planet won't have problems with space junk, which can cause collisions, disrupt telecommunications, generate more waste, and endanger manned missions. Plus, the planet looks much more beautiful now!",
        ],
      ),
      ConversationData(
        speaker: ConversationSpeaker.captainDash,
        messages: [
          "It has been a true honor to help you, President",
        ],
      ),
    ];
  }

  List<ConversationData> get _tutorialStartAdventure {
    return [
      ConversationData(
        speaker: ConversationSpeaker.shipBot,
        messages: [
          "Hey Captain Dash... that was more fun than I thought it would be",
        ],
      ),
      ConversationData(
        speaker: ConversationSpeaker.captainDash,
        messages: [
          "You're right, Dartina, I've really enjoyed it",
        ],
      ),
      ConversationData(
        speaker: ConversationSpeaker.shipBot,
        messages: [
          "How about we explore the cosmos in search of planets to help?",
          "Just head in any direction. Space is a vast place, I'm sure we'll find planets in no time",
        ],
      ),
      ConversationData(
        speaker: ConversationSpeaker.captainDash,
        messages: [
          "Let's go!",
        ],
      ),
    ];
  }
}
