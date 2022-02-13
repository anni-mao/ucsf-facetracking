//
//  ListPatientsView.swift
//  FaceTrackingApplication
//
//  Created by Anni Mao on 1/3/22.
//

import SwiftUI

struct ListPatientsView: View {
    var model:DBManager = DBManager()
//    var queryData:[String]?
    @State var queryData = [String]()
    @State private var searchText = ""
    
    init() {
        queryData = model.queryDB()
    }
    
    //TODO: add refresh capabilities 

    var body: some View {
        NavigationView {
            List {
                ForEach(searchResults, id: \.self) { id in
                         NavigationLink(destination: PatientView(patientID: id)) {

                             HStack {
                                 Text("ID: ")
                                     .font(.headline)
                                 Text(id)
                             }
                             

                         }
                         .padding(7)
                 }
                .padding()
            }
            .searchable(text: $searchText)
            .onAppear {
                queryData = model.queryDB()
            }
            .refreshable {
                queryData = model.queryDB()
            }
            .navigationTitle("Patients")
        }
        .accentColor(.black)
        .navigationViewStyle(StackNavigationViewStyle())
    }
    
    var searchResults: [String] {
            if searchText.isEmpty {
                return queryData
    
            } else {
                return queryData.filter { (id: String) -> Bool in return id.hasPrefix(searchText)
                    || searchText == "" }
            }
    }
}

struct ListPatientsView_Previews: PreviewProvider {
    static var previews: some View {
        ListPatientsView()
    }
}
