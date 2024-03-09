import 'package:adapter/adapter.dart';
import 'package:get_it/get_it.dart';
import 'package:repository/repository.dart';
import 'package:service/service.dart';
import 'package:usecase/usecase.dart';

class DependencyContainer {
  static Future<void> init() async {
    final getIt = GetIt.instance;

    final settingsService = SharedPreferencesSettingsService();
    await settingsService.init();
    getIt.registerSingleton<SettingsService>(settingsService);

    final dataService = HiveDataService();
    await dataService.init();
    getIt.registerSingleton<DataService>(dataService);

    final gameRepository = GameRepositoryImpl(
      dataService: dataService,
      settingsService: settingsService,
    );
    await gameRepository.init();
    getIt.registerSingleton<GameRepository>(gameRepository);

    final chunkRepository = ChunkRepositoryImpl(dataService: dataService);
    await chunkRepository.init();
    getIt.registerSingleton<ChunkRepository>(chunkRepository);

    final planetSummaryRepository = PlanetSummaryRepositoryImpl(dataService: dataService);
    await planetSummaryRepository.init();
    getIt.registerSingleton<PlanetSummaryRepository>(planetSummaryRepository);

    final planetInfoRepository = PlanetInfoRepositoryImpl(dataService: dataService);
    await planetInfoRepository.init();
    getIt.registerSingleton<PlanetInfoRepository>(planetInfoRepository);

    final generateMapUseCase = GenerateMapUseCase(
      chunkRepository: chunkRepository,
      planetSummaryRepository: planetSummaryRepository,
    );
    await generateMapUseCase.init();
    getIt.registerSingleton<GenerateMapUseCase>(generateMapUseCase);

    final gameService = GameServiceImpl(
      gameRepository: gameRepository,
      generateMapUseCase: generateMapUseCase,
      chunkRepository: chunkRepository,
      planetSummaryRepository: planetSummaryRepository,
      planetInfoRepository: planetInfoRepository,
    );
    getIt.registerSingleton<GameService>(gameService);
  }
}
