//
//  ContentView.swift
//  FaceTrackingApplication
//
//  Created by Anni Mao on 10/27/21.
//

import SwiftUI
import Camera_SwiftUI
import AVFoundation

//Queries database and lists patient ids
struct MainContentView: View {
    @State private var selection = 0
    
    init() {
        //TODO change this
        UITabBar.appearance().unselectedItemTintColor = UIColor(Color.blue)
    }
    
    var body: some View {
        //insert into local database
     
        TabView(selection: $selection) {
            StartSessionView()
            .tabItem {
                Image(systemName: "house.fill")
                Text("Home")
            }
            .tag(0)

            ListPatientsView()
                .tabItem {
                    Image(systemName: "person.crop.circle")
                    Text("Find Patients")
                }
                .tag(1)

            CameraView()
                .tabItem {
                    Image(systemName: "camera.fill")
                    Text("Camera")

                }
                .tag(2)

        }
        
        
    }
    
    
}

struct MainContentView_Previews: PreviewProvider {
    static var previews: some View {
            MainContentView()
        
    }
}


