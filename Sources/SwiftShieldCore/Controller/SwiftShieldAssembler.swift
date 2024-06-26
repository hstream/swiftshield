import Foundation

public enum SwiftSwiftAssembler {
    public static func generate(
        projectPath: String,
        scheme: String,
        modulesToIgnore: Set<String>,
        namesToIgnore: Set<String>,
        inputFiles: Set<String>,
        ignorePublic: Bool,
        dryRun: Bool,
        verbose: Bool,
        printSourceKitQueries: Bool,
        targetedModulesForObfuscation: Set<String>?
    ) -> SwiftShieldController {
        let logger = Logger(
            verbose: verbose,
            printSourceKit: printSourceKitQueries
        )

        let projectFile = File(path: projectPath)
        let taskRunner = TaskRunner()
        let infoProvider = SchemeInfoProvider(
            projectFile: projectFile,
            schemeName: scheme,
            taskRunner: taskRunner,
            logger: logger,
            modulesToIgnore: modulesToIgnore,
            targetedModulesForObfuscation: targetedModulesForObfuscation
        )

        let sourceKit = SourceKit(logger: logger)
        let obfuscator = SourceKitObfuscator(
            sourceKit: sourceKit,
            logger: logger,
            dataStore: .init(),
            namesToIgnore: namesToIgnore,
            inputFiles: inputFiles,
            ignorePublic: ignorePublic
        )

        let interactor = SwiftShieldInteractor(
            schemeInfoProvider: infoProvider,
            logger: logger,
            obfuscator: obfuscator
        )

        return SwiftShieldController(
            interactor: interactor,
            logger: logger,
            dryRun: dryRun
        )
    }
}
