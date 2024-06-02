import Foundation
import Hummingbird
import SwiftyTailwind
import TSCBasic

func tailwind(_ app: some ApplicationProtocol) async throws {
    let resourceDirectory = try AbsolutePath(validating: app.directory.resourcesDirectory)
    let publicDirectory = try AbsolutePath(validating: app.directory.publicDirectory)
    
    let tailwind = SwiftyTailwind()
    
    try await tailwind.run(
        input: .init(validating: "Styles/app.css", relativeTo: resourceDirectory),
        output: .init(validating: "styles/app.generated.css", relativeTo: publicDirectory),
        options: .content("Resources/Templates/**/*.mustache")
    )
}

extension ApplicationProtocol {
    var directory: DefineWorkingDirectory {
        DefineWorkingDirectory.detect()
    }
}


struct DefineWorkingDirectory {
    var workingDirectory: String
    var resourcesDirectory: String
    var publicDirectory: String
    
    init(workingDirectory: String) {
        self.workingDirectory = workingDirectory + "/"
        self.resourcesDirectory = self.workingDirectory + "Resources/"
        self.publicDirectory = self.workingDirectory + "Public/"
    }
    
    static func detect() -> DefineWorkingDirectory {
        if let cwd = getcwd(nil, Int(PATH_MAX)) {
            defer { free(cwd) }
            return DefineWorkingDirectory(workingDirectory: String(cString: cwd))
        }
        return DefineWorkingDirectory(workingDirectory: "./")
    }
}
