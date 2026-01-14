import Foundation
import SwiftCrossUI
import Vein
import VeinSCUI

typealias Recording = RecordingV1.Recording

enum RecordingV1: VersionedSchema {
    static var version: Vein.ModelVersion = .init(1, 0, 0)
    
    static var models: [any Vein.PersistentModel.Type] {
        [
            Recording.self
        ]
    }
    
    @Model
    final class Recording: Identifiable {
        typealias SchemaMigration = TestMigration
        
        static let schema = "recordings"
        
        @Field
        var name: String
        
        @LazyField
        var audio: Data?
        
        init(name: String, audio: Data) {
            self.name = name
            self.audio = audio
        }
    }
    
    struct TestMigration: ModelSchemaMigration {
        func prepare(in context: Vein.ManagedObjectContext) async throws {
            try await context.createSchema(Recording.schema)
                .id()
                .field("name", type: .string(required: true))
                .field("audio", type: .data(required: true))
                .run()
        }
    }
}

enum Migration: SchemaMigrationPlan {
    static var stages: [Vein.MigrationStage] = []
    
    static var schemas: [any Vein.VersionedSchema.Type] {
        [RecordingV1.self]
    }
}
