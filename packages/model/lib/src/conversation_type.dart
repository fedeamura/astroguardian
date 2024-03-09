import 'package:model/model.dart';

enum ConversationType {
  tutorialInit,
  tutorialMapLimit,
  tutorialPlanetFound,
  tutorialBagFull,
  tutorialRecycle,
  tutorialLevelUp,
  tutorialImproveShip,
  tutorialSatellitesCompleted,
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
      case ConversationType.tutorialSatellitesCompleted:
        return 6;
      case ConversationType.tutorialImproveShip:
        return 7;
      case ConversationType.tutorialStartAdventure:
        return 8;
      case ConversationType.tutorialPlanetCompleted:
        return 9;
      case ConversationType.tutorialMapLimit:
        return 10;
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
      case ConversationType.tutorialSatellitesCompleted:
        return true;
      case ConversationType.tutorialPlanetCompleted:
        return true;
      case ConversationType.tutorialStartAdventure:
        return true;
      case ConversationType.tutorialMapLimit:
        return false;
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
      case ConversationType.tutorialSatellitesCompleted:
        return _tutorialSatellitesCompleted;
      case ConversationType.tutorialPlanetCompleted:
        return _tutorialPlanetCompleted;
      case ConversationType.tutorialStartAdventure:
        return _tutorialStartAdventure;
      case ConversationType.tutorialMapLimit:
        return _tutorialMapLimit;
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
          "Encontraste el planeta. Veamos si podemos comunicarnos con ellos",
          "...",
          "Establecimos conneccion!",
        ],
      ),
      ConversationData(
        speaker: ConversationSpeaker.planetPresident,
        messages: [
          "Buen dia capitan! Necesitamos tu ayuda",
          "Como podras ver nuestro planeta se encuentra cubierto de basura espacial",
          "La basura espacial nos perjudica ya que nos quita visibilidad, puede ocasionar problemas en nuestros satelites salientes y generate ruido",
          "Si no es mucha molestia podrias recolectar esa basura por nosotros?"
        ],
      ),
      ConversationData(
        speaker: ConversationSpeaker.captainDash,
        messages: [
          "Por supuesto que si! Aunque no se me ocurre muy bien como hacerlo... Se te ocurre algo Dartina?",
        ],
      ),
      ConversationData(
        speaker: ConversationSpeaker.shipBot,
        messages: [
          "Nuestra nave esta equipada con un rayo atractor. Acabo de configurarlo para poder atraer la basura espacial y almacenarla en nuestra bodega",
          "Que tal si intentas hacerlo?",
          "Presiona el boton azul para activarlo"
        ],
      ),
    ];
  }

  List<ConversationData> get _tutorialBagFull {
    return [
      ConversationData(
        speaker: ConversationSpeaker.shipBot,
        messages: [
          "Al parecer la bodega de la nave esta llena. No podras recoger mas basura espacial hasta que nos deshagamos de ella de alguna forma",
        ],
      ),
      ConversationData(
        speaker: ConversationSpeaker.captainDash,
        messages: ["Pero no podemos tirarla por ahi! Que podriamos hacer?"],
      ),
      ConversationData(
        speaker: ConversationSpeaker.shipBot,
        messages: [
          "Que te parece si la reciclamos? La nave cuenta con un potente compactador. Solo tienes que tocar sobre la nave y yo me encargare de activar los procedimientos necesarios.",
        ],
      ),
    ];
  }

  List<ConversationData> get _tutorialRecycle {
    return [
      ConversationData(
        speaker: ConversationSpeaker.shipBot,
        messages: [
          "Eso ha funcionado a la perfeccion! Toda la basura fue reciclada",
          "Al reciclar basura espacial obtengo datos y tengo la teoria que si juntas suficientes podremos utilizarlos en la nave de alguna forma",
          "Te agregare un indicador de la capacidad de la bodega y otro con la cantidad de datos recopilados",
          "Intenta llenar la barra de datos!"
        ],
      ),
    ];
  }

  List<ConversationData> get _tutorialLevelUp {
    return [
      ConversationData(
        speaker: ConversationSpeaker.shipBot,
        messages: [
          "Tengo buenas noticias capitan. Al reciclar la basura espacial, consegui datos suficientes como para mejorar nuestra nave",
          "Porque no pruebas mejorar la nave desde tu menu?"
        ],
      ),
    ];
  }

  List<ConversationData> get _tutorialImproveShip {
    return [
      ConversationData(
        speaker: ConversationSpeaker.shipBot,
        messages: [
          "Veo que haz logrado mejorar la nave!",
          "Que te parece si terminamos de ayudar a la presidente y recolectamos toda la basura espacial que orbita el planeta?"
        ],
      ),
    ];
  }

  List<ConversationData> get _tutorialSatellitesCompleted {
    return [
      ConversationData(
        speaker: ConversationSpeaker.shipBot,
        messages: [
          "Lo lograste Capitan Dash! Que hermoso se ve el planeta sin toda esa basura espacial y esa interferencia",
          "Guardare los datos del planeta por su luego quieres revisarlos desde el menu",
        ],
      ),
    ];
  }

  List<ConversationData> get _tutorialPlanetCompleted {
    return [
      ConversationData(
        speaker: ConversationSpeaker.shipBot,
        messages: [
          "Estoy recibiendo una nueva comunicacion desde el planeta",
          "...",
        ],
      ),
      ConversationData(
        speaker: ConversationSpeaker.planetPresident,
        messages: [
          "Muchas gracias por la ayuda Capitan Dash. No se que habriamos hecho sin ti",
          "Ahora nuestro planeta ya no tiene riesgos de colisiones por la basura espacial, y no tendremos dificultades para que nuestras naves salgan a la orbita",
          "Ademas que se aprecia mucho mejor nuestro hermoso planeta sin toda esa basura orbitando, no te parece?",
        ],
      ),
      ConversationData(
        speaker: ConversationSpeaker.captainDash,
        messages: ["Por supuesto que si! Ha sido un honor ayudarla"],
      ),
    ];
  }

  List<ConversationData> get _tutorialStartAdventure {
    return [
      ConversationData(
        speaker: ConversationSpeaker.shipBot,
        messages: ["Oye capitan... eso ha sido mas divertido de lo que pensaba"],
      ),
      ConversationData(
        speaker: ConversationSpeaker.captainDash,
        messages: ["Tienes razon Dartina, lo he disfrutado mucho"],
      ),
      ConversationData(
        speaker: ConversationSpeaker.shipBot,
        messages: [
          "Que te parece si exploramos el cosmos en busca de planetas a los que ayudar?",
          "Simplemente dirigete hacia cualquier direccion. El espacio es un lugar inmenso, dudo que tardemos mucho en encotrar nuevos planetas",
        ],
      ),
      ConversationData(
        speaker: ConversationSpeaker.captainDash,
        messages: ["En marcha!"],
      ),
    ];
  }

  List<ConversationData> get _tutorialMapLimit {
    return [
      ConversationData(
        speaker: ConversationSpeaker.shipBot,
        messages: [
          "Capitan! Te estas alejando mucho de la señal. Recuerda que ibamos a investigar que sucede",
          "Recuerda seguir el indicador amarillo",
        ],
      ),
    ];
  }
}
