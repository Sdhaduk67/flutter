// Copyright 2014 The Flutter Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'dart:async';

import 'package:args/args.dart';
import 'package:collection/collection.dart';
import 'package:meta/meta.dart';
import 'package:package_config/package_config.dart';

import '../base/common.dart';
import '../base/file_system.dart';
import '../base/logger.dart';
import '../base/os.dart';
import '../base/platform.dart';
import '../base/process.dart';
import '../build_info.dart';
import '../bundle.dart' as bundle;
import '../cache.dart';
import '../device.dart';
import '../globals.dart' as globals;
import '../isolated/resident_web_runner.dart';
import '../project.dart';
import '../resident_runner.dart';
import '../runner/flutter_command.dart';
<<<<<<< HEAD
=======
import '../runner/flutter_command_runner.dart';
import '../web/web_device.dart';
import '../widget_preview/analytics.dart';
import '../widget_preview/dependency_graph.dart';
import '../widget_preview/dtd_services.dart';
>>>>>>> d693b4b9dbac2acd4477aea4555ca6dcbea44ba2
import '../widget_preview/preview_code_generator.dart';
import '../widget_preview/preview_detector.dart';
import '../widget_preview/preview_manifest.dart';
import '../widget_preview/preview_pubspec_builder.dart';
import 'create_base.dart';

class WidgetPreviewCommand extends FlutterCommand {
  WidgetPreviewCommand({
    required bool verboseHelp,
    required Logger logger,
    required FileSystem fs,
    required FlutterProjectFactory projectFactory,
    required Cache cache,
    required Platform platform,
    required ShutdownHooks shutdownHooks,
    required OperatingSystemUtils os,
<<<<<<< HEAD
=======
    required ProcessManager processManager,
    required Artifacts artifacts,
    @visibleForTesting WidgetPreviewDtdServices? dtdServicesOverride,
>>>>>>> d693b4b9dbac2acd4477aea4555ca6dcbea44ba2
  }) {
    addSubcommand(
      WidgetPreviewStartCommand(
        verbose: verboseHelp,
        logger: logger,
        fs: fs,
        projectFactory: projectFactory,
        cache: cache,
        platform: platform,
        shutdownHooks: shutdownHooks,
        os: os,
<<<<<<< HEAD
=======
        processManager: processManager,
        artifacts: artifacts,
        dtdServicesOverride: dtdServicesOverride,
>>>>>>> d693b4b9dbac2acd4477aea4555ca6dcbea44ba2
      ),
    );
    addSubcommand(
      WidgetPreviewCleanCommand(logger: logger, fs: fs, projectFactory: projectFactory),
    );
  }

  @override
  String get description => 'Manage the widget preview environment.';

  @override
  String get name => 'widget-preview';

  @override
  String get category => FlutterCommandCategory.tools;

  // TODO(bkonyi): show when --verbose is not provided when this feature is
  // ready to ship.
  @override
  bool get hidden => true;

  @override
  Future<FlutterCommandResult> runCommand() async => FlutterCommandResult.fail();
}

abstract base class WidgetPreviewSubCommandBase extends FlutterCommand {
  FileSystem get fs;
  Logger get logger;
  FlutterProjectFactory get projectFactory;

  FlutterProject getRootProject() {
    final ArgResults results = argResults!;
    final Directory projectDir;
    if (results.rest case <String>[final String directory]) {
      projectDir = fs.directory(directory);
      if (!projectDir.existsSync()) {
        throwToolExit('Could not find ${projectDir.path}.');
      }
    } else if (results.rest.length > 1) {
      throwToolExit('Only one directory should be provided.');
    } else {
      projectDir = fs.currentDirectory;
    }
    return validateFlutterProjectForPreview(projectDir);
  }

  FlutterProject validateFlutterProjectForPreview(Directory directory) {
    logger.printTrace('Verifying that ${directory.path} is a Flutter project.');
    final FlutterProject flutterProject = projectFactory.fromDirectory(directory);
    if (!flutterProject.dartTool.existsSync()) {
      throwToolExit('${flutterProject.directory.path} is not a valid Flutter project.');
    }
    return flutterProject;
  }
}

final class WidgetPreviewStartCommand extends WidgetPreviewSubCommandBase with CreateBase {
  WidgetPreviewStartCommand({
    this.verbose = false,
    required this.logger,
    required this.fs,
    required this.projectFactory,
    required this.cache,
    required this.platform,
    required this.shutdownHooks,
    required this.os,
<<<<<<< HEAD
=======
    required this.processManager,
    required this.artifacts,
    @visibleForTesting WidgetPreviewDtdServices? dtdServicesOverride,
>>>>>>> d693b4b9dbac2acd4477aea4555ca6dcbea44ba2
  }) {
    if (dtdServicesOverride != null) {
      _dtdService = dtdServicesOverride;
    }
    addPubOptions();
    argParser
      ..addFlag(
        kLaunchPreviewer,
        defaultsTo: true,
        help: 'Launches the widget preview environment.',
        // Should only be used for testing.
        hide: !verbose,
      )
      ..addFlag(kHeadless, help: 'Launches Chrome in headless mode for testing.', hide: !verbose)
      ..addOption(
        kWidgetPreviewScaffoldOutputDir,
        help:
            'Generated the widget preview environment scaffolding at a given location '
            'for testing purposes.',
      );
  }

  static const kWidgetPreviewScaffoldName = 'widget_preview_scaffold';
  static const kLaunchPreviewer = 'launch-previewer';
  static const kHeadless = 'headless';
  static const kWidgetPreviewScaffoldOutputDir = 'scaffold-output-dir';

<<<<<<< HEAD
=======
  /// Environment variable used to pass the DTD URI to the widget preview scaffold.
  static const kWidgetPreviewDtdUriEnvVar = 'WIDGET_PREVIEW_DTD_URI';

  @visibleForTesting
  static const kBrowserNotFoundErrorMessage =
      'Failed to locate browser. Make sure you are using an up-to-date Chrome or Edge.';

>>>>>>> d693b4b9dbac2acd4477aea4555ca6dcbea44ba2
  @override
  Future<Set<DevelopmentArtifact>> get requiredArtifacts async => const <DevelopmentArtifact>{
    // Ensure the Flutter Web SDK is installed.
    DevelopmentArtifact.web,
  };

  @override
  String get description => 'Starts the widget preview environment.';

  @override
  String get name => 'start';

  final bool verbose;

  @override
  final FileSystem fs;

  @override
  final Logger logger;

  @override
  final FlutterProjectFactory projectFactory;

  final Cache cache;

  final Platform platform;

  final ShutdownHooks shutdownHooks;

  final OperatingSystemUtils os;

<<<<<<< HEAD
=======
  final ProcessManager processManager;

  final Artifacts artifacts;

  late final previewAnalytics = WidgetPreviewAnalytics(analytics: analytics);

>>>>>>> d693b4b9dbac2acd4477aea4555ca6dcbea44ba2
  late final FlutterProject rootProject = getRootProject();

  late final _previewPubspecBuilder = PreviewPubspecBuilder(
    logger: logger,
    verbose: verbose,
    offline: offline,
    rootProject: rootProject,
    previewManifest: _previewManifest,
  );

  late final _previewDetector = PreviewDetector(
    platform: platform,
    previewAnalytics: previewAnalytics,
    projectRoot: rootProject.directory,
    logger: logger,
    fs: fs,
    onChangeDetected: onChangeDetected,
    onPubspecChangeDetected: _previewPubspecBuilder.onPubspecChangeDetected,
  );

  late final PreviewCodeGenerator _previewCodeGenerator;
  late final _previewManifest = PreviewManifest(
    logger: logger,
    rootProject: rootProject,
    fs: fs,
    cache: cache,
  );

<<<<<<< HEAD
=======
  late var _dtdService = WidgetPreviewDtdServices(
    logger: logger,
    shutdownHooks: shutdownHooks,
    onHotRestartPreviewerRequest: onHotRestartRequest,
    dtdLauncher: DtdLauncher(logger: logger, artifacts: artifacts, processManager: processManager),
  );

>>>>>>> d693b4b9dbac2acd4477aea4555ca6dcbea44ba2
  /// The currently running instance of the widget preview scaffold.
  ResidentRunner? _widgetPreviewApp;

  @override
  Future<FlutterCommandResult> runCommand() async {
    // Start the timer tracking how long it takes to launch the preview environment.
    previewAnalytics.initializeLaunchStopwatch();

    final String? customPreviewScaffoldOutput = stringArg(kWidgetPreviewScaffoldOutputDir);
    final Directory widgetPreviewScaffold = customPreviewScaffoldOutput != null
        ? fs.directory(customPreviewScaffoldOutput)
        : rootProject.widgetPreviewScaffold;

    // Check to see if a preview scaffold has already been generated. If not,
    // generate one.
    final bool generateScaffoldProject =
        customPreviewScaffoldOutput != null || _previewManifest.shouldGenerateProject();
    // TODO(bkonyi): can this be moved?
    widgetPreviewScaffold.createSync();
    fs.currentDirectory = widgetPreviewScaffold;

    if (generateScaffoldProject) {
      // WARNING: this log message is used by test/integration.shard/widget_preview_test.dart
      logger.printStatus(
        'Creating widget preview scaffolding at: ${widgetPreviewScaffold.absolute.path}',
      );
      await generateApp(
        <String>['app', kWidgetPreviewScaffoldName],
        widgetPreviewScaffold,
        createTemplateContext(
          organization: 'flutter',
          projectName: kWidgetPreviewScaffoldName,
          titleCaseProjectName: 'Widget Preview Scaffold',
          flutterRoot: Cache.flutterRoot!,
          dartSdkVersionBounds: '^${cache.dartSdkBuild}',
          web: true,
        ),
        overwrite: true,
        generateMetadata: false,
        printStatusWhenWriting: verbose,
      );
      if (customPreviewScaffoldOutput != null) {
        return FlutterCommandResult.success();
      }
      _previewManifest.generate();

      // Make the analytics instance aware that we generated the widget preview scaffold as part of
      // launching the previewer.
      previewAnalytics.generatedProject();
    }

    // WARNING: this access of widgetPreviewScaffoldProject needs to happen
    // after we generate the scaffold project as invoking the getter triggers
    // lazy initialization of the preview scaffold's FlutterManifest before
    // the scaffold project's pubspec has been generated.
    _previewCodeGenerator = PreviewCodeGenerator(
      widgetPreviewScaffoldProject: rootProject.widgetPreviewScaffoldProject,
      fs: fs,
    );

    if (generateScaffoldProject || _previewManifest.shouldRegeneratePubspec()) {
      if (!generateScaffoldProject) {
        logger.printStatus(
          'Detected changes in pubspec.yaml. Regenerating pubspec.yaml for the '
          'widget preview scaffold.',
        );
      }
      await _previewPubspecBuilder.populatePreviewPubspec(rootProject: rootProject);
    }

    shutdownHooks.addShutdownHook(() async {
      await _widgetPreviewApp?.exitApp();
      await _previewDetector.dispose();
    });

<<<<<<< HEAD
    if (boolArg(kLaunchPreviewer)) {
      shutdownHooks.addShutdownHook(() async {
        await _widgetPreviewApp?.stop();
      });
      _widgetPreviewApp = await runPreviewEnvironment(
        widgetPreviewScaffoldProject: rootProject.widgetPreviewScaffoldProject,
      );
      final int result = await _widgetPreviewApp!.runner.waitForAppToFinish();
      if (result != 0) {
        throwToolExit('Failed to launch the widget previewer.', exitCode: result);
      }
=======
    final PreviewDependencyGraph graph = await _previewDetector.initialize();
    _previewCodeGenerator.populatePreviewsInGeneratedPreviewScaffold(graph);

    await configureDtd();
    final int result = await runPreviewEnvironment(
      widgetPreviewScaffoldProject: rootProject.widgetPreviewScaffoldProject,
    );
    if (result != 0) {
      throwToolExit('Failed to launch the widget previewer.', exitCode: result);
>>>>>>> d693b4b9dbac2acd4477aea4555ca6dcbea44ba2
    }

    return FlutterCommandResult.success();
  }

  void onChangeDetected(PreviewDependencyGraph previews) {
    _previewCodeGenerator.populatePreviewsInGeneratedPreviewScaffold(previews);
    logger.printStatus('Triggering reload based on change to preview set: $previews');
    _widgetPreviewApp?.restart();
  }

  void onHotRestartRequest() {
    logger.printStatus('Triggering restart based on request from preview environment.');
    _widgetPreviewApp?.restart(fullRestart: true);
  }

<<<<<<< HEAD
  /// Builds the application binary for the widget preview scaffold the first
  /// time the widget preview command is run.
  ///
  /// The resulting binary is used to speed up subsequent widget previewer launches
  /// by acting as a basic scaffold to load previews into using hot reload / restart.
  Future<void> initialBuild({required FlutterProject widgetPreviewScaffoldProject}) async {
    // TODO(bkonyi): handle error case where desktop device isn't enabled.
    await widgetPreviewScaffoldProject.ensureReadyForPlatformSpecificTooling(
      releaseMode: false,
      linuxPlatform: platform.isLinux && !isWeb,
      macOSPlatform: platform.isMacOS && !isWeb,
      windowsPlatform: platform.isWindows && !isWeb,
      webPlatform: isWeb,
    );

    // Generate initial package_config.json, otherwise the build will fail.
    await pub.get(
      context: PubContext.create,
      project: widgetPreviewScaffoldProject,
      offline: offline,
      outputMode: PubOutputMode.summaryOnly,
    );

    if (isWeb) {
      return;
    }

    // WARNING: this log message is used by test/integration.shard/widget_preview_test.dart
    logger.printStatus('Performing initial build of the Widget Preview Scaffold...');

    final BuildInfo buildInfo = BuildInfo(
      BuildMode.debug,
      null,
      treeShakeIcons: false,
      packageConfigPath: widgetPreviewScaffoldProject.packageConfig.path,
    );

    if (platform.isMacOS) {
      await buildMacOS(
        flutterProject: widgetPreviewScaffoldProject,
        buildInfo: buildInfo,
        verboseLogging: false,
      );
    } else if (platform.isLinux) {
      await buildLinux(
        widgetPreviewScaffoldProject.linux,
        buildInfo,
        targetPlatform:
            os.hostPlatform == HostPlatform.linux_x64
                ? TargetPlatform.linux_x64
                : TargetPlatform.linux_arm64,
        logger: logger,
      );
    } else if (platform.isWindows) {
      await buildWindows(
        widgetPreviewScaffoldProject.windows,
        buildInfo,
        os.hostPlatform == HostPlatform.windows_x64
            ? TargetPlatform.windows_x64
            : TargetPlatform.windows_arm64,
      );
    } else {
      throw UnimplementedError();
    }
    // WARNING: this log message is used by test/integration.shard/widget_preview_test.dart
    logger.printStatus('Widget Preview Scaffold initial build complete.');
  }

  /// Returns the path to a prebuilt widget_preview_scaffold application binary.
  String prebuiltApplicationBinaryPath({required FlutterProject widgetPreviewScaffoldProject}) {
    assert(platform.isLinux || platform.isMacOS || platform.isWindows);
    String path;
    if (platform.isMacOS) {
      path = fs.path.join(
        getMacOSBuildDirectory(),
        'Build/Products/Debug/widget_preview_scaffold.app',
      );
    } else if (platform.isLinux) {
      path = fs.path.join(
        getLinuxBuildDirectory(
          os.hostPlatform == HostPlatform.linux_x64
              ? TargetPlatform.linux_x64
              : TargetPlatform.linux_arm64,
        ),
        'debug/bundle/widget_preview_scaffold',
      );
    } else if (platform.isWindows) {
      path = fs.path.join(
        getWindowsBuildDirectory(
          os.hostPlatform == HostPlatform.windows_x64
              ? TargetPlatform.windows_x64
              : TargetPlatform.windows_arm64,
        ),
        'runner/Debug/widget_preview_scaffold.exe',
      );
    } else {
      throw StateError('Unknown OS');
    }
    path = fs.path.join(widgetPreviewScaffoldProject.directory.path, path);
    if (fs.typeSync(path) == FileSystemEntityType.notFound) {
      logger.printStatus(fs.currentDirectory.toString());
      throw StateError('Could not find prebuilt application binary at $path.');
    }
    return path;
  }

  Future<AppInstance> runPreviewEnvironment({
    required FlutterProject widgetPreviewScaffoldProject,
  }) async {
    final AppInstance app;
=======
  /// Configures the Dart Tooling Daemon connection.
  ///
  /// If --dtd-uri is provided, the existing DTD instance will be used. If the tool fails to
  /// connect to this URI, it will start its own DTD instance.
  ///
  /// If --dtd-uri is not provided, a DTD instance managed by the tool will be started.
  Future<void> configureDtd() async {
    final String? existingDtdUriStr = stringArg(FlutterGlobalOptions.kDtdUrl, global: true);
    Uri? existingDtdUri;
    try {
      if (existingDtdUriStr != null) {
        existingDtdUri = Uri.parse(existingDtdUriStr);
      }
    } on FormatException {
      logger.printWarning('Failed to parse value of --dtd-uri: $existingDtdUriStr.');
    }
    if (existingDtdUri == null) {
      logger.printTrace('Launching a fresh DTD instance...');
      await _dtdService.launchAndConnect();
    } else {
      logger.printTrace('Connecting to existing DTD instance at: $existingDtdUri...');
      await _dtdService.connect(dtdWsUri: existingDtdUri);
    }
  }

  Future<int> runPreviewEnvironment({required FlutterProject widgetPreviewScaffoldProject}) async {
>>>>>>> d693b4b9dbac2acd4477aea4555ca6dcbea44ba2
    try {
      // Since the only target supported by the widget preview scaffold is the web
      // device, only a single web device should be returned.
      final List<Device> devices = await deviceManager!.getDevices(
        filter: DeviceDiscoveryFilter(
          supportFilter: DeviceDiscoverySupportFilter.excludeDevicesUnsupportedByFlutterOrProject(
            flutterProject: widgetPreviewScaffoldProject,
          ),
          deviceConnectionInterface: DeviceConnectionInterface.attached,
        ),
      );
      if (devices.isEmpty) {
        throwToolExit(kBrowserNotFoundErrorMessage);
      }
      final Device device;
      if (devices.length > 1) {
        // Prefer Google Chrome as the target browser.
        device =
            devices.firstWhereOrNull((device) => device is GoogleChromeDevice) ?? devices.first;

        logger.printTrace(
          'Detected ${devices.length} web devices (${devices.map((e) => e.displayName).join(', ')}). '
          'Defaulting to ${device.displayName}.',
        );
      } else {
        device = devices.single;
      }

      // WARNING: this log message is used by test/integration.shard/widget_preview_test.dart
      logger.printStatus('Launching the Widget Preview Scaffold on ${device.displayName}...');

<<<<<<< HEAD
      app = await Daemon.createMachineDaemon().appDomain.startApp(
        device,
        widgetPreviewScaffoldProject.directory.path,
        bundle.defaultMainPath,
        kEmptyRoute, // route
        DebuggingOptions.enabled(
          BuildInfo(
            BuildMode.debug,
            null,
            treeShakeIcons: false,
            extraFrontEndOptions:
                isWeb ? <String>['--dartdevc-canary', '--dartdevc-module-format=ddc'] : null,
            packageConfigPath: widgetPreviewScaffoldProject.packageConfig.path,
            packageConfig: PackageConfig.parseBytes(
              widgetPreviewScaffoldProject.packageConfig.readAsBytesSync(),
              widgetPreviewScaffoldProject.packageConfig.uri,
            ),
=======
      final debuggingOptions = DebuggingOptions.enabled(
        BuildInfo(
          BuildMode.debug,
          null,
          treeShakeIcons: false,
          // Provide the DTD connection information directly to the preview scaffold.
          // This could, in theory, be provided via a follow up call to a service extension
          // registered by the preview scaffold, but there's some uncertainty around how service
          // extensions will work with Flutter web embedded in VSCode without a Chrome debugger
          // connection.
          dartDefines: <String>['$kWidgetPreviewDtdUriEnvVar=${_dtdService.dtdUri}'],
          packageConfigPath: widgetPreviewScaffoldProject.packageConfig.path,
          packageConfig: PackageConfig.parseBytes(
            widgetPreviewScaffoldProject.packageConfig.readAsBytesSync(),
            widgetPreviewScaffoldProject.packageConfig.uri,
>>>>>>> d693b4b9dbac2acd4477aea4555ca6dcbea44ba2
          ),
          // Don't try and download canvaskit from the CDN.
          useLocalCanvasKit: true,
          webEnableHotReload: true,
        ),
        webEnableExposeUrl: false,
        webRunHeadless: boolArg(kHeadless),
      );
      final String target = bundle.defaultMainPath;
      final FlutterDevice flutterDevice = await FlutterDevice.create(
        device,
        target: target,
        buildInfo: debuggingOptions.buildInfo,
        platform: platform,
      );

      if (boolArg(kLaunchPreviewer)) {
        final appStarted = Completer<void>();
        _widgetPreviewApp = ResidentWebRunner(
          flutterDevice,
          target: target,
          debuggingOptions: debuggingOptions,
          analytics: analytics,
          flutterProject: widgetPreviewScaffoldProject,
          fileSystem: fs,
          logger: logger,
          terminal: globals.terminal,
          platform: platform,
          outputPreferences: globals.outputPreferences,
          systemClock: globals.systemClock,
        );
        unawaited(_widgetPreviewApp!.run(appStartedCompleter: appStarted));
        await appStarted.future;
      }
    } on Exception catch (error) {
      throwToolExit(error.toString());
    }

    // WARNING: this log message is used by test/integration.shard/widget_preview_test.dart
    logger.printStatus('Done loading previews.');

    // Send an analytics event reporting how long it took for the widget previewer to start.
    previewAnalytics.reportLaunchTiming();

<<<<<<< HEAD
  /// Maps asset URIs to relative paths for the widget preview project to
  /// include.
  @visibleForTesting
  static Uri transformAssetUri(Uri uri) {
    // Assets provided by packages always start with 'packages' and do not
    // require their URIs to be updated.
    if (uri.path.startsWith('packages')) {
      return uri;
    }
    // Otherwise, the asset is contained within the root project and needs
    // to be referenced from the widget preview scaffold project's pubspec.
    return Uri(path: '../../${uri.path}');
  }

  @visibleForTesting
  static AssetsEntry transformAssetsEntry(AssetsEntry asset) {
    return AssetsEntry(
      uri: transformAssetUri(asset.uri),
      flavors: asset.flavors,
      transformers: asset.transformers,
    );
  }

  @visibleForTesting
  static FontAsset transformFontAsset(FontAsset asset) {
    return FontAsset(transformAssetUri(asset.assetUri), weight: asset.weight, style: asset.style);
  }

  @visibleForTesting
  static DeferredComponent transformDeferredComponent(DeferredComponent component) {
    return DeferredComponent(
      name: component.name,
      // TODO(bkonyi): verify these library paths are always package: paths from the parent project.
      libraries: component.libraries,
      assets: component.assets.map(transformAssetsEntry).toList(),
    );
  }

  @visibleForTesting
  FlutterManifest buildPubspec({
    required FlutterManifest rootManifest,
    required FlutterManifest widgetPreviewManifest,
  }) {
    final List<AssetsEntry> assets = rootManifest.assets.map(transformAssetsEntry).toList();

    final List<Font> fonts = <Font>[
      ...widgetPreviewManifest.fonts,
      ...rootManifest.fonts.map((Font font) {
        return Font(font.familyName, font.fontAssets.map(transformFontAsset).toList());
      }),
    ];

    final List<Uri> shaders = rootManifest.shaders.map(transformAssetUri).toList();

    final List<DeferredComponent>? deferredComponents =
        rootManifest.deferredComponents?.map(transformDeferredComponent).toList();

    return widgetPreviewManifest.copyWith(
      logger: logger,
      assets: assets,
      fonts: fonts,
      shaders: shaders,
      deferredComponents: deferredComponents,
    );
  }

  Future<void> _populatePreviewPubspec({required FlutterProject rootProject}) async {
    final FlutterProject widgetPreviewScaffoldProject = rootProject.widgetPreviewScaffoldProject;

    // Overwrite the pubspec for the preview scaffold project to include assets
    // from the root project.
    widgetPreviewScaffoldProject.replacePubspec(
      buildPubspec(
        rootManifest: rootProject.manifest,
        widgetPreviewManifest: widgetPreviewScaffoldProject.manifest,
      ),
    );

    // Adds a path dependency on the parent project so previews can be
    // imported directly into the preview scaffold.
    const String pubAdd = 'add';
    await pub.interactively(
      <String>[
        pubAdd,
        if (offline) '--offline',
        '--directory',
        widgetPreviewScaffoldProject.directory.path,
        // Ensure the path using POSIX separators, otherwise the "path_not_posix" check will fail.
        '${rootProject.manifest.appName}:{"path":${rootProject.directory.path.replaceAll(r"\", "/")}}',
      ],
      context: PubContext.pubAdd,
      command: pubAdd,
      touchesPackageConfig: true,
    );

    // Adds a dependency on flutter_lints, which is referenced by the
    // analysis_options.yaml generated by the 'app' template.
    await pub.interactively(
      <String>[
        pubAdd,
        if (offline) '--offline',
        '--directory',
        widgetPreviewScaffoldProject.directory.path,
        'flutter_lints',
        'stack_trace',
      ],
      context: PubContext.pubAdd,
      command: pubAdd,
      touchesPackageConfig: true,
    );

    // Generate package_config.json.
    await pub.get(
      context: PubContext.create,
      project: widgetPreviewScaffoldProject,
      offline: offline,
      outputMode: PubOutputMode.summaryOnly,
    );

    maybeAddFlutterGenToPackageConfig(rootProject: rootProject);
    _previewManifest.updatePubspecHash();
  }

  /// Manually adds an entry for package:flutter_gen to the preview scaffold's
  /// package_config.json if the target project makes use of localization.
  ///
  /// The Flutter Tool does this when running a Flutter project with
  /// localization instead of modifying the user's pubspec.yaml to depend on it
  /// as a path dependency. Unfortunately, the preview scaffold still needs to
  /// add it directly to its package_config.json as the generated package name
  /// isn't actually flutter_gen, which pub doesn't really like, and using the
  /// actual package name will break applications which import
  /// package:flutter_gen.
  @visibleForTesting
  void maybeAddFlutterGenToPackageConfig({required FlutterProject rootProject}) {
    // TODO(matanlurey): Remove this once flutter_gen is removed.
    //
    // This is actually incorrect logic; the presence of a `generate: true`
    // does *NOT* mean that we need to add `flutter_gen` to the package config,
    // and never did, but the name of the manifest field was labeled and
    // described incorrectly.
    //
    // Tracking removal: https://github.com/flutter/flutter/issues/102983.
    if (!rootProject.manifest.generateLocalizations) {
      return;
    }
    final FlutterProject widgetPreviewScaffoldProject = rootProject.widgetPreviewScaffoldProject;
    final File packageConfig = widgetPreviewScaffoldProject.packageConfig;
    final String previewPackageConfigPath = packageConfig.path;
    if (!packageConfig.existsSync()) {
      throw StateError(
        "Could not find preview project's package_config.json at "
        '$previewPackageConfigPath',
      );
    }
    final Map<String, Object?> packageConfigJson =
        json.decode(packageConfig.readAsStringSync()) as Map<String, Object?>;
    (packageConfigJson['packages'] as List<dynamic>?)!.cast<Map<String, String>>().add(
      flutterGenPackageConfigEntry,
    );
    packageConfig.writeAsStringSync(json.encode(packageConfigJson));
    logger.printStatus('Added flutter_gen dependency to $previewPackageConfigPath');
=======
    // If _widgetPreviewApp is null --no-launch-previewer was provided so return success.
    return _widgetPreviewApp?.waitForAppToFinish() ?? 0;
>>>>>>> d693b4b9dbac2acd4477aea4555ca6dcbea44ba2
  }
}

final class WidgetPreviewCleanCommand extends WidgetPreviewSubCommandBase {
  WidgetPreviewCleanCommand({required this.fs, required this.logger, required this.projectFactory});

  @override
  String get description => 'Cleans up widget preview state.';

  @override
  String get name => 'clean';

  @override
  final FileSystem fs;

  @override
  final Logger logger;

  @override
  final FlutterProjectFactory projectFactory;

  @override
  Future<FlutterCommandResult> runCommand() async {
    final Directory widgetPreviewScaffold = getRootProject().widgetPreviewScaffold;
    if (widgetPreviewScaffold.existsSync()) {
      final String scaffoldPath = widgetPreviewScaffold.path;
      logger.printStatus('Deleting widget preview scaffold at $scaffoldPath.');
      widgetPreviewScaffold.deleteSync(recursive: true);
    } else {
      logger.printStatus('Nothing to clean up.');
    }
    return FlutterCommandResult.success();
  }
}
