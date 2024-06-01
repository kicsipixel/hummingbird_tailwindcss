import Hummingbird
import SwiftyTailwind
import TSCBasic

func tailwind(_ app: some ApplicationProtocol) async throws {
    let resourceDirectory = try AbsolutePath(validating: "/Users/sztoth/Development/Hummingbird/tailwind/Resources")
    let publicDirectory = try AbsolutePath(validating: "/Users/sztoth/Development/Hummingbird/tailwind/Public/")
    
    let tailwind = SwiftyTailwind()
    
  try await tailwind.run(
    input: .init(validating: "Styles/app.css", relativeTo: resourceDirectory),
    output: .init(validating: "styles/app.generated.css", relativeTo: publicDirectory),
    options: .content("Resources/Templates/**/*.mustache")
  )
}
