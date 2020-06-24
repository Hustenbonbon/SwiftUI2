import Foundation
import ApolloCodegenLib

print("Loading path")

let parentFolderOfScriptFile = FileFinder.findParentFolder()
let sourceRootURL = parentFolderOfScriptFile
    .deletingLastPathComponent() // Result: Sources folder
    .deletingLastPathComponent() // Result: Codegen folder
    .deletingLastPathComponent() // Result: MyProject source root folder

let cliFolderURL = sourceRootURL
    .appendingPathComponent("Codegen")
    .appendingPathComponent("ApolloCLI")

let endpoint = URL(string: "https://graphql-pokemon.now.sh/")!

let output = sourceRootURL
    .appendingPathComponent("rumspielprojekt")

try FileManager
    .default
    .apollo_createFolderIfNeeded(at: output)

let options = ApolloSchemaOptions(endpointURL: endpoint,
                                  outputFolderURL: output)

do {
    try ApolloSchemaDownloader.run(with: cliFolderURL,
                                   options: options)
} catch {
    exit(1)
}

let genOptions = ApolloCodegenOptions(targetRootURL: output)

do {
    try ApolloCodegen.run(from: output,
                          with: cliFolderURL,
                          options: genOptions)
} catch {
    exit(1)
}


