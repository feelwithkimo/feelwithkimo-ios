//
//  BreathingView.swift
//  feelwithkimo
//
//  Created by Ferdinand Lunardy on 21/10/25.
//
import SwiftUI

/// The main view that contains the breathing app content
struct BreathingView: View {
    /// Indicates whether to display the setup workflow
    @State var showSetup = false
    /// A configuration for managing the characteristics of breathing sound classification
    @State var appConfig = BreathingAppConfiguration()
    /// The runtime state that contains information about the strength of the detected breathing sounds
    @StateObject var breathingState = BreathDetectionManager()
    /// Optional completion callback
    var onCompletion: (() -> Void)?

    var body: some View {
        ZStack {
            if showSetup {
                SetupBreathingSoundsView(
                  querySoundOptions: { return Array(try BreathingSoundClassifier.getAllBreathingLabels()) },
                  selectedSounds: $appConfig.monitoredSounds,
                  doneAction: {
                    showSetup = false
                    breathingState.startDetection()
                  })
            } else {
                KimoBreathingGameView(
                    breathDetectionManager: breathingState,
                    config: $appConfig,
                    configureAction: { showSetup = true },
                    onCompletion: onCompletion)
            }
        }
        .onAppear {
            // Initialize with breathing sounds
            do {
                let breathingSounds = Array(try BreathingSoundClassifier.getAllBreathingLabels())
                appConfig.monitoredSounds = Set(breathingSounds.map { SoundIdentifierModel(labelName: $0) })
            } catch {
                print("Error loading breathing sounds: \(error)")
                // Use default breathing sounds
                appConfig.monitoredSounds = [
                    SoundIdentifierModel(labelName: "breathing"),
                    SoundIdentifierModel(labelName: "wind"),
                    SoundIdentifierModel(labelName: "blowing")
                ]
            }
        }
    }
}

/// A view for selecting breathing sounds to monitor
struct SetupBreathingSoundsView: View {
    /// A closure that queries the list of recognized breathing sounds
    let querySoundOptions: () throws -> [String]

    /// A message to display when `querySoundOptions` throws an error
    @State var querySoundsErrorMessage: String?

    /// A list of possible breathing sounds that a user selects in the app
    @State var soundOptions: Set<SoundIdentifierModel>

    /// A search string the app uses to filter the available sound options
    @State var soundSearchString = ""

    /// A binding to the set of sounds the app monitors when starting sound classification
    @Binding var selectedSounds: Set<SoundIdentifierModel>

    /// An action the app executes upon completing the setup
    var doneAction: () -> Void

    init(querySoundOptions: @escaping () throws -> [String],
         selectedSounds: Binding<Set<SoundIdentifierModel>>,
         doneAction: @escaping () -> Void) {
        self.querySoundOptions = querySoundOptions
        self._selectedSounds = selectedSounds
        self.doneAction = doneAction

        let soundOptions: Set<SoundIdentifierModel>
        let querySoundsErrorMessage: String?
        do {
            let soundLabels = try querySoundOptions()
            soundOptions = Set(soundLabels.map { SoundIdentifierModel(labelName: $0) })
            querySoundsErrorMessage = nil
        } catch {
            soundOptions = Set<SoundIdentifierModel>()
            querySoundsErrorMessage = "\(error)"
        }

        _soundOptions = State(initialValue: soundOptions)
        _querySoundsErrorMessage = State(initialValue: querySoundsErrorMessage)
    }

    /// Searches the provided sounds for those that satisfy the search string
    func search(sounds: Set<SoundIdentifierModel>, for string: String) -> Set<SoundIdentifierModel> {
        let result: Set<SoundIdentifierModel>
        if string == "" {
            result = sounds
        } else {
            result = sounds.filter {
                $0.displayName.lowercased().contains(string.lowercased())
            }
        }
        return result
    }

    /// A list of all sounds the app displays for user selection
    var displayedSoundOptions: [(SoundIdentifierModel, Bool)] {
        let optionsAfterSearch = search(sounds: soundOptions, for: soundSearchString)
        let optionsSorted = [SoundIdentifierModel](optionsAfterSearch).sorted(by: { $0.displayName < $1.displayName })
        return optionsSorted.map {
            ($0, selectedSounds.contains($0))
        }
    }

    /// Toggles whether an object is a member of a set
    static func toggleMembership<T>(member: T, set targetSet: inout Set<T>) {
        if targetSet.contains(member) {
            targetSet.remove(member)
        } else {
            targetSet.insert(member)
        }
    }

    /// A view that displays the content above the list of sound options
    var headerContent: some View {
        VStack {
            HStack {
                Spacer()
                Button("Selesai", action: doneAction)
                    .padding()
                    .accessibilityLabel("Selesai pengaturan deteksi napas")
            }
            Text("Pilih Suara Napas untuk Dideteksi")
                .font(.app(.title1, family: .primary))
                .frame(alignment: .leading)
                .accessibilityAddTraits(.isHeader)
            HStack {
                Button("Pilih Semua", action: { selectedSounds.formUnion(soundOptions) })
                    .padding()
                    .accessibilityLabel("Pilih semua suara napas")
                Button("Hapus Semua", action: { selectedSounds.removeAll() })
                    .padding()
                    .accessibilityLabel("Hapus semua pilihan suara napas")
            }.padding()
            HStack {
                Image(systemName: "magnifyingglass")
                TextField("Cari", text: $soundSearchString)
                    .accessibilityLabel("Cari suara napas")
                Button(action: { soundSearchString = "" }, label: {
                    Image(systemName: "x.circle.fill")
                      .foregroundStyle(Color.gray)
                      .opacity(soundSearchString == "" ? 0.0 : 1.0)
                })
                .accessibilityLabel("Hapus pencarian")
            }.padding()
        }
    }

    /// A view that displays a list of breathing sounds the system can detect
    var soundOptionsList: some View {
        List {
            ForEach(displayedSoundOptions, id: \.0) { soundAndSelectionStatus in
                Button(action: {
                    SetupBreathingSoundsView.toggleMembership(member: soundAndSelectionStatus.0, set: &selectedSounds)
                }, label: {
                    HStack {
                        Image(systemName: selectedSounds.contains(soundAndSelectionStatus.0)
                              ? "checkmark.circle.fill" : "circle")
                          .foregroundStyle(Color.blue)
                        Text(soundAndSelectionStatus.0.displayName)
                            .frame(alignment: .leading)
                    }
                })
                .accessibilityLabel("\(soundAndSelectionStatus.0.displayName), \(selectedSounds.contains(soundAndSelectionStatus.0) ? "dipilih" : "tidak dipilih")")
                .accessibilityAddTraits(.isButton)
            }
        }
    }

    var body: some View {
        ZStack {
            VStack {
                headerContent
                soundOptionsList
            }
            .blur(radius: querySoundsErrorMessage == nil ? 0.0 : 10.0)
            .disabled(querySoundsErrorMessage != nil)

            VStack {
                Text("Error: gagal memuat suara napas yang dikenali")
                    .multilineTextAlignment(.center)
                    .padding()
                Text(querySoundsErrorMessage ?? "")
                    .multilineTextAlignment(.center)
                    .padding()
                Button("Coba Lagi",
                       action: {
                           do {
                               let soundLabels = try querySoundOptions()
                               soundOptions = Set(soundLabels.map { SoundIdentifierModel(labelName: $0) })
                               querySoundsErrorMessage = nil
                           } catch {
                               querySoundsErrorMessage = "\(error)"
                           }
                       })
                .accessibilityLabel("Coba lagi memuat suara napas")
            }
            .opacity(querySoundsErrorMessage == nil ? 0.0 : 1.0)
            .disabled(querySoundsErrorMessage == nil)
        }
    }
}

#Preview {
    BreathingView()
}
