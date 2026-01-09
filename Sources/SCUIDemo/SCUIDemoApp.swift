import Foundation
import SwiftCrossUI
import Vein
import VeinSCUI
import DefaultBackend

@main
struct SCUIDemoApp: App {
    let modelContainer: ModelContainer
    
    init() {
        do {
            let containerPath = FileManager.default.urls(
                for: .applicationSupportDirectory,
                in: .userDomainMask
            ).first!
            
            let dbDir = containerPath.relativePath.replacingOccurrences(of: "%20", with: " ").appending("/VeinSCUI/BasicExample/InternalData")
            
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
            
            self.modelContainer = try ModelContainer(models: Recording.self, migration: Migration.self, at: dbPath)
        } catch {
            fatalError("failed to create model container: \(error.localizedDescription)")
        }
    }
    
    var body: some Scene {
        WindowGroup {
            VeinContainer {
                ContentView()
            }
            .modelContainer(modelContainer)
            .colorScheme(.dark)
        }
        .windowResizability(.contentSize)
    }
}
