//
//  Meditation.swift
//  emoteen8
//
//  Created by Lana Purdy on 3/17/20.
//  Copyright © 2020 Lana Purdy. All rights reserved.
//

import SwiftUI
import VideoPlayer

class Meditation :  Identifiable, ObservableObject 
{
    @Published var title: String = ""
    @Published var contentUrl: String = ""
    @Published var thumbnailUrl: String = ""
    
    var ID: UUID = UUID()
    var created : Date? = nil
    
    init(_ title: String, _ thumbnailUrl: String)
    {
        self.title = title
        self.thumbnailUrl = thumbnailUrl
    }
    
    init(_ title: String, _ thumbnailUrl: String, _ contentUrl: String)
    {
        self.title = title
        self.thumbnailUrl = thumbnailUrl
        self.contentUrl = contentUrl
    }
    
    func save()
    {
        let record = EmoRecord(self.title, "Meditation", self.contentUrl, self.created!, Date())
        
        record.save()

    }
    
    static func load() -> [Meditation]
    {
        return [Meditation("Anger", "anger", "http://media.zendo.tools/emoteen/anger.m4v"),
                Meditation("Stress", "stress", "http://media.zendo.tools/emoteen/stress.m4v"),
                Meditation("Anxious", "anxious", "http://media.zendo.tools/emoteen/anxious.m4v"),
                Meditation("Blah", "blah", "http://media.zendo.tools/emoteen/blah.m4v"),
                Meditation("Sleepy", "sleepy", "http://media.zendo.tools/emoteen/sleepy.m4v"),
                Meditation("About", "about", "http://media.zendo.tools/emoteen/about.m4v")]
    }
     

}

struct MeditationView : View
{
    @ObservedObject var meditation: Meditation
    
    var body: some View
    {
  
        VStack
        {
            Image(meditation.thumbnailUrl).renderingMode(.original)
            Text(meditation.title).font(.largeTitle)
            Spacer(minLength: 33)
        }
    }
    
}

struct MeditationDetailView : View {

    @ObservedObject var meditation: Meditation
    @State private var play: Bool = true
    
    func getUrl() -> URL
    {
        return URL(string: meditation.contentUrl + "?now=" + Date().emoDate)!
    }
    
    var body: some View {
       
        ZStack {
        VStack
        {
            VideoPlayer(url: self.getUrl(), play: $play).autoReplay(true).onStateChanged { state in
                switch state {
                case .loading:
                    print("loading")
                case .playing(let totalDuration):
                    print(totalDuration)
                case .paused(let playProgress, let bufferProgress):
                   print(playProgress)
                case .error(let error):
                    print(error.description)
                }
            }.onDisappear() {
                self.play.toggle()
                self.save()
            }.onAppear() {
                self.meditation.created = Date()
            }.scaledToFill()
            
            
        }
        
        Button(action: {
            self.play.toggle()
            
        }) { Image(systemName: self.play ? "pause" : "play").resizable().frame(width: 33, height: 33, alignment: .center)
            .padding(.leading, 20)
            .padding(.trailing, 20)
        }
    
        }
        
    }
    
    
    func save()
    {
        meditation.save()
    }
}

struct Meditation_Previews: PreviewProvider {
    static var previews: some View {
        /*@START_MENU_TOKEN@*/Text("Hello, World!")/*@END_MENU_TOKEN@*/
    }
}
