import Hummingbird
import Logging
import Mustache
import NIOCore

/// Application arguments protocol. We use a protocol so we can call
/// `buildApplication` inside Tests as well as in the App executable.
/// Any variables added here also have to be added to `App` in App.swift and
/// `TestArguments` in AppTest.swift
public protocol AppArguments {
    var hostname: String { get }
    var port: Int { get }
    var logLevel: Logger.Level? { get }
}

public func buildApplication(_ arguments: some AppArguments) async throws -> some ApplicationProtocol {
    let logger = {
        var logger = Logger(label: "tailwind")
        logger.logLevel = arguments.logLevel ?? .info
        return logger
    }()
    
    // Template library
    let library = try await MustacheLibrary(directory: "Resources/Templates")
    assert(library.getTemplate(named: "page") != nil)
    
    // Route
    let router = Router()
    router.middlewares.add(FileMiddleware())
    PagesController(mustacheLibrary: library).addRoutes(to: router)
    
    // Add health route
    router.get("/health") { _,_ -> HTTPResponse.Status in
        return .ok
    }
    
    let app = Application(
        router: router,
        configuration: .init(
            address: .hostname(arguments.hostname, port: arguments.port),
            serverName: "tailwind"
        ),
        logger: logger
    )
    
    try await tailwind(app)
    
    return app
}
