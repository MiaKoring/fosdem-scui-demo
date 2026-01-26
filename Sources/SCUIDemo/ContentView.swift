import Foundation
import SwiftCrossUI
import Vein
import VeinSCUI

struct ContentView: View {
    @Query
    var recordings: [Recording]
    @Environment(\.modelContext) var context
    @State var isRecording = false
    
    var body: some View {
        VStack(spacing: 16) {
            ZStack {
                Circle().fill(.red).frame(width: 60)
                Circle().fill(.black).frame(width: 50)
                
                if !isRecording {
                    Circle().fill(.red).frame(width: 40)
                } else {
                    RoundedRectangle(cornerRadius: 5)
                        .fill(.red).frame(width: 25, height: 25)
                }
            }
            .onTapGesture(perform: recordButtonTapped)
            
            VStack(spacing: 4) {
                Text("Recorder").font(.headline)
                Text("Press to start").font(.footnote).foregroundColor(.gray)
            }
            
            ScrollView {
                ForEach(recordings) { recording in
                    HStack(spacing: 10) {
                        Text(recording.name)
                        Button("Play") {}
                    }
                }
            }
        }
        .frame(width: 220, height: 400)
        .padding(24)
        .background(Color.black.opacity(0.8))
        .cornerRadius(20)
    }
    
    func recordButtonTapped() {
        isRecording.toggle()
        if !isRecording {
            let formatter = DateFormatter()
            formatter.dateFormat = "HH:mm dd.MM"
            try? context.insert(
                Recording(
                    name: "Recording \(formatter.string(from: .now))",
                    audio: Data()
                )
            )
            try? context.save()
        }
    }
}


