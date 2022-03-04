//
//  PatientView.swift
//  FaceTrackingApplication
//
//  Created by Anni Mao on 11/2/21.
//

import SwiftUI

func query(patientID: String, dbManager: DBManager) -> [[String?]] {
//    var model:DBManager = DBManager()
//    WHERE Patient_ID = " + patientID + ";"
    var queryNotes = dbManager.query2DB(sqlCommand: "SELECT Physician_notes FROM patients_table;")
    print("query notes:")
    print(queryNotes)
    
    var queryDates = dbManager.query2DB(sqlCommand: "SELECT createdate FROM patients_table;")
    print("query dates:")
    print(queryDates)
    
    return [queryDates, queryNotes]
}

func dict(queryD: [String?], queryN: [String?]) -> [String? : String?]{
    var dict = [String : String]()
    
    for (dates, notes) in zip(queryD, queryN) {
        dict[dates!] = notes!
        
    }
    return dict
}

struct PatientView: View {
    //TODO: integrate in db sql query
    //Obtain from SQLite Database
    var patientID:String
    var dbManager: DBManager
    @State private var searchText = ""
//    var model:DBManager = DBManager()
    
    @State var queryDates = [String?]()
    @State var queryNotes = [String?]()
    
    var dateToNote:[String?:String?]
    
    
    init(patientID: String, model:DBManager) {
        self.patientID = patientID
        self.dbManager = model
        var queries = query(patientID: patientID, dbManager: dbManager)
        self.queryNotes = queries[1]
        self.queryDates = queries[0]
        self.dateToNote = dict(queryD: queryDates, queryN: queryNotes)
        
    }
    
    
//    let dates:[String] = ["08/20/21", "10/14/21"]
//    let notes:[String] = ["Patient had trouble smiling.", "Patient's smile has improved."]
//
//    let dateToNote = [
//        "08/20/21" : "Patient had trouble smiling.",
//        "10/14/21" : "Patient's smile has improved."
//    ]


    
    var body: some View {

        VStack(alignment: .leading) {
            List {
                ForEach(searchResults, id: \.self) { d in
                    NavigationLink(destination: TestFolder_Views(patientID: patientID, date: d!, imagePath: "dummy_path")) {
                        VStack(alignment: .leading, spacing: 5) {
                            Text(d!)
                                .font(.title2)
                            Text(dateToNote[d!]! ?? "")
                        }
                  
                    }
                    
                }

                .padding()
            }
            .searchable(text: $searchText)
            .navigationTitle("Patient " + patientID)
            
        }
            
        
        
    }
    
    var searchResults: [String?] {
            if searchText.isEmpty {
                return queryDates
            } else {
                return queryDates.filter { (id: String?) -> Bool in return id!.hasPrefix(searchText)
                    || searchText == "" }
            }
    }
}


struct PatientView_Previews: PreviewProvider {
    static var previews: some View {
        PatientView(patientID: "00000", model: DBManager())
       
    }
}
