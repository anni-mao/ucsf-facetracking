//
//  PatientView.swift
//  FaceTrackingApplication
//
//  Created by Anni Mao on 11/2/21.
//

import SwiftUI

func query(patientID: String, db: DBManager, num: Int) -> [String] {
//    var model:DBManager = DBManager()
//    WHERE Patient_ID = " + patientID + ";"
    if (num == 0) {
        var queryDates = db.query2DB(sqlCommand: "SELECT createdate FROM patients_table WHERE Patient_ID = " + patientID + ";")
        return queryDates
    } else {
        var queryNotes = db.query2DB(sqlCommand: "SELECT Physician_notes FROM patients_table WHERE Patient_ID = " + patientID + ";")
        return queryNotes
    }
    
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
    
    var queryDates = [String]()
    var queryNotes = [String]()
//    var dateToNote:[String?:String?]
    
    
    init(patientID: String, model:DBManager) {
        self.patientID = patientID
        self.dbManager = model
        self.queryDates = query(patientID: patientID, db: dbManager, num: 0)
        
        
        self.queryNotes = query(patientID: patientID, db: dbManager, num: 1)
//        = queries[0]
        
        print(queryDates)
//        print(queries)
        print(self.queryDates)
//        self.dateToNote = dict(queryD: queryDates, queryN: queryNotes)
        
    }
    



    
    var body: some View {

        VStack(alignment: .leading) {
            List {
                ForEach(searchResults, id: \.self) { d in
                    // imagePath: "dummy_path"
                    NavigationLink(destination: TestFolder_Views(patientID: patientID, date: d!)) {
                        VStack(alignment: .leading, spacing: 5) {
                            Text(d!)
                                .font(.title3)
                            
//                            Text(dateToNote[d!]! ?? "")
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
                print(queryDates)
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
