//
//  ListPatientsView.swift
//  FaceTrackingApplication
//
//  Created by Anni Mao on 1/3/22.
//

import SwiftUI

struct ListPatientsView: View {
    var model = DBManager.globalDB
    @State var queryData = [String]()
    @State private var searchText = ""
    
    init() {
        //changed
        print("select")
        print(model)
        queryData = model.queryDB(sqlCommand: "SELECT DISTINCT Patient_ID FROM patients_table;")
        
    }
    

    var body: some View {
        NavigationView {
            List {
                ForEach(searchResults, id: \.self) { id in
                    NavigationLink(destination: PatientView(patientID: id, model: model)) {
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
                queryData = model.queryDB(sqlCommand: "SELECT DISTINCT Patient_ID FROM patients_table;")
            }
            .refreshable {
                queryData = model.queryDB(sqlCommand: "SELECT DISTINCT Patient_ID FROM patients_table;")
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
