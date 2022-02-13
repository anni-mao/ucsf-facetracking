//
//  PatientView.swift
//  FaceTrackingApplication
//
//  Created by Anni Mao on 11/2/21.
//

import SwiftUI

struct PatientView: View {
    
    var patientID:String
    @State private var searchText = ""
    //TODO: integrate in db sql query 
    //Obtain from SQLite Database
    let dates:[String] = ["08/20/21", "10/14/21"]
    let notes:[String] = ["Patient had trouble smiling.", "Patient's smile has improved."]
    
    let dateToNote = [
        "08/20/21" : "Patient had trouble smiling.",
        "10/14/21" : "Patient's smile has improved."
    ]


    
    var body: some View {

        VStack(alignment: .leading) {
            List {
                ForEach(searchResults, id: \.self) { d in
                    NavigationLink(destination: TestFolder_Views(patientID: patientID, date: d)) {
                        VStack(alignment: .leading, spacing: 5) {
                            Text(d)
                                .font(.title2)
                            Text(dateToNote[d] ?? "")
                        }
                  
                    }
                    
                }

                .padding()
            }
            .searchable(text: $searchText)
            .navigationTitle("Patient " + patientID)
            
        }
            
        
        
    }
    
    var searchResults: [String] {
            if searchText.isEmpty {
                return dates
            } else {
                return dates.filter { (id: String) -> Bool in return id.hasPrefix(searchText)
                    || searchText == "" }
            }
    }
}


struct PatientView_Previews: PreviewProvider {
    static var previews: some View {
            PatientView(patientID: "00000")
       
    }
}
