import Foundation
import SwiftCrossUI
import Vein
import VeinSCUI
import DefaultBackend

#if canImport(SwiftBundlerRuntime)
import SwiftBundlerRuntime
#endif

@main
@HotReloadable
struct SCUIDemoApp: App {
    let modelContainer: ModelContainer
    
    init() {
        do {
            let containerPath = FileManager.default.urls(
                for: .applicationSupportDirectory,
                in: .userDomainMask
            ).first!
            
            let dbDir = containerPath.relativePath.replacingOccurrences(of: "%20", with: " ").appending("/VeinSCUI/fosdem-scui-demo/InternalData")
            
            let dbPath = dbDir.appending("/db.sqlite3")
            
            print(dbPath)
            
            try FileManager.default.createDirectory(
                atPath: dbDir,
                withIntermediateDirectories: true
            )
            
            if !FileManager.default.fileExists(atPath: dbPath) {
                FileManager.default.createFile(
                    atPath: dbPath,
                    contents: nil
                )
            }
            
            self.modelContainer = try ModelContainer(RecordingV1.self, migration: Migration.self, at: dbPath)
        } catch {
            fatalError("failed to create model container: \(error.localizedDescription)")
        }
    }
    
    var body: some Scene {
        WindowGroup {
            #hotReloadable {
                VeinContainer {
                    ContentView()
                }
                .modelContainer(modelContainer)
                .colorScheme(.dark)
            }
        }
        #if !canImport(UIKit)
            .windowResizability(.contentSize)
        #else
            .defaultSize(width: 100, height: 300)
        #endif
    }
}

public struct AlternativeContainer<Content: View>: View {
    @State private var isInitialized: Bool = false
    private let content: () -> Content
    
    public init(@ViewBuilder content: @escaping () -> Content ) {
        self.content = content
    }
    
    public var body: some View {
        if isInitialized {
            content()
        } else {
            ProgressView()
                .task {
                    try? await Task.sleep(for: .seconds(1))
                    isInitialized = true
                }
        }
    }
}
