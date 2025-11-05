//
//  Library.swift
//  CapsuleMusic
//
//  Created by Славка Корн on 18.10.2025.
//

import SwiftUI
import URLImage

struct Library: View {
    
    @State var tracks = UserDefaults.standard.savedTracks()
    @State private var showingAlert = false
    @State private var track: SearchViewModel.Cell?
    @State private var selectedTrackId: String?
    @State private var nowPlayingTrackId: String?
    
    var tabBarDelegate: MainTabBarControllerDelegate?
    
    var body: some View {
        NavigationView {
            GeometryReader { geometry in
                VStack {
                    HStack(spacing: 20) {
                        Button(action: {
                            if !self.tracks.isEmpty {
                                let firstTrack = self.tracks[0]
                                self.track = firstTrack
                                self.nowPlayingTrackId = firstTrack.id
                                self.selectedTrackId = nil
                                self.tabBarDelegate?.maximizeTrackDetailController(viewModel: firstTrack)
                            } else {
                                print("Массив tracks пустой")
                            }
                        }, label: {
                            Image(systemName: "play.fill")
                                .frame(width: (geometry.size.width - 32 - 20) / 2, height: 50)
                                .accentColor(Color.init(#colorLiteral(red: 0.9921568627, green: 0.1764705882, blue: 0.3333333333, alpha: 1)))
                                .background(Color.init(#colorLiteral(red: 0.9531342387, green: 0.9490900636, blue: 0.9562709928, alpha: 1)))
                                .cornerRadius(10)
                        })
                        Button(action: {
                            self.tracks = UserDefaults.standard.savedTracks()
                            self.selectedTrackId = nil
                            self.nowPlayingTrackId = nil
                        }, label: {
                            Image(systemName: "arrow.2.circlepath")
                                .frame(width: (geometry.size.width - 32 - 20) / 2, height: 50)
                                .accentColor(Color.init(#colorLiteral(red: 0.9921568627, green: 0.1764705882, blue: 0.3333333333, alpha: 1)))
                                .background(Color.init(#colorLiteral(red: 0.9531342387, green: 0.9490900636, blue: 0.9562709928, alpha: 1)))
                                .cornerRadius(10)
                        })
                    }
                    .padding()
                    .frame(height: 50)
                    
                    Divider()
                        .padding(.horizontal, 16)
                    
                    List {
                        ForEach(tracks) { track in
                            VStack(spacing: 0) {
                                HStack(alignment: .center) {
                                    LibraryCell(cell: track)
                                    Spacer()
                                }
                                .padding(.horizontal, 16)
                                .padding(.vertical, 12)
                                .frame(maxWidth: .infinity)
                    
                                .background(
                                    nowPlayingTrackId == track.id ? Color.gray.opacity(0.3) : Color.white
                                )
                                
                                Rectangle()
                                    .fill(Color.gray.opacity(0.3))
                                    .frame(height: 0.5)
                                    .padding(.leading, 16)
                            }
                            .listRowInsets(EdgeInsets())
                            .background(Color.white)
                            .contentShape(Rectangle())
                            .onTapGesture {
                                selectedTrackId = track.id
                                
                                // Сбрасываем через короткое время для анимации нажатия
                                DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                                    selectedTrackId = nil
                                }
                                
                                let keyWindow = UIApplication.shared.connectedScenes
                                    .filter({$0.activationState == .foregroundActive})
                                    .map({$0 as? UIWindowScene})
                                    .compactMap({$0})
                                    .first?.windows
                                    .filter({$0.isKeyWindow}).first
                                let tabBarVC = keyWindow?.rootViewController as? MainTabBarController
                                tabBarVC?.trackDetailView.delegate = self
                                
                                self.track = track
                                self.nowPlayingTrackId = track.id
                                self.tabBarDelegate?.maximizeTrackDetailController(viewModel: track)
                            }
                            .onLongPressGesture {
                                print("Pressed!")
                                self.track = track
                                self.showingAlert = true
  
                                selectedTrackId = track.id
                            }
                        }
                        .onDelete(perform: delete)
                    }
                    .listStyle(PlainListStyle())
                    .onAppear {
                        UITableView.appearance().separatorStyle = .none
                    }
                }
                .background(Color.white)
            }
            .actionSheet(isPresented: $showingAlert, content: {
                ActionSheet(title: Text("Are you sure you want to delete this track?"), buttons: [
                    .destructive(Text("Delete"), action: {
                        print("Deleting: \(self.track?.trackName ?? "")")
                        if let trackToDelete = self.track {
                            self.delete(track: trackToDelete)
                        }
                        selectedTrackId = nil
                        nowPlayingTrackId = nil
                    }),
                    .cancel({
                        selectedTrackId = nil
                    })
                ])
            })
            .navigationBarTitle("Library")
        }
        .onChange(of: track) { oldTrack, newTrack in
            nowPlayingTrackId = newTrack?.id
        }
    }
    
    func delete(at offsets: IndexSet) {
        tracks.remove(atOffsets: offsets)
        if let savedData = try? NSKeyedArchiver.archivedData(withRootObject: tracks, requiringSecureCoding: false) {
            let defaults = UserDefaults.standard
            defaults.set(savedData, forKey: UserDefaults.favouriteTrackKey)
        }
        // Сбрасываем состояния если удалили текущий трек
        if let deletedTrackId = selectedTrackId, !tracks.contains(where: { $0.id == deletedTrackId }) {
            selectedTrackId = nil
            nowPlayingTrackId = nil
        }
    }
    
    func delete(track: SearchViewModel.Cell) {
        let index = tracks.firstIndex(of: track)
        guard let myIndex = index else { return }
        tracks.remove(at: myIndex)
        if let savedData = try? NSKeyedArchiver.archivedData(withRootObject: tracks, requiringSecureCoding: false) {
            let defaults = UserDefaults.standard
            defaults.set(savedData, forKey: UserDefaults.favouriteTrackKey)
        }

        selectedTrackId = nil
        nowPlayingTrackId = nil
    }
}

struct LibraryCell: View {
    
    var cell: SearchViewModel.Cell
    
    var body: some View {
        HStack {
            AsyncImage(url: URL(string: cell.iconUrlString ?? "")) { phase in
                if let image = phase.image {
                    image
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                } else if phase.error != nil {
                    Rectangle()
                        .fill(Color.gray)
                } else {
                    ProgressView()
                }
            }
            .frame(width: 60, height: 60)
            .cornerRadius(2)
            
            VStack(alignment: .leading) {
                Text("\(cell.trackName)")
                    .font(.body)
                Text("\(cell.artistName)")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
        }
    }
}


struct Library_Previews: PreviewProvider {
    static var previews: some View {
        Library()
    }
}

extension Library: TrackMovingDelegate {
    func moveBackForPreviousTrack() -> SearchViewModel.Cell? {
        let index = tracks.firstIndex(of: track!)
        guard let myIndex = index else { return nil }
        var nextTrack: SearchViewModel.Cell
        if myIndex - 1 == -1 {
            nextTrack = tracks[tracks.count - 1]
        } else {
            nextTrack = tracks[myIndex - 1]
        }
        self.track = nextTrack
        return nextTrack
    }
    
    func moveForwardForPreviousTrack() -> SearchViewModel.Cell? {
        let index = tracks.firstIndex(of: track!)
        guard let myIndex = index else { return nil }
        var nextTrack: SearchViewModel.Cell
        if myIndex + 1 == tracks.count {
            nextTrack = tracks[0]
        } else {
            nextTrack = tracks[myIndex + 1]
        }
        self.track = nextTrack
        return nextTrack
    }
}
