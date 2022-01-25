//
//  DBManager.swift
//  FaceTrackingApplication
//
//  Created by Anni Mao on 10/27/21.
//

import Foundation
import SQLite3
import SwiftUI

class DBManager: ObservableObject, Identifiable {
    
    var dbPath:String
    var db: OpaquePointer?
    
    init() {
        let path = Bundle.main.path(forResource: "ft_database", ofType: "db")
        
        dbPath = path!
        if sqlite3_open(path, &db) == SQLITE_OK {
            print("Successfully opened connection to database!")
        } else {
            print("Unable to open database :(")
        }
    }
    
    //TODO fix to retrieve unique IDs
    // retrieving patient IDs for patient ID list 
    func queryDB() -> [String]? {
        var gatheredInfo:[String] = [String]()
        
        let selectStatementString = "SELECT Patient_ID FROM patients_table;"
        var selectStatementQuery: OpaquePointer?
        
        if db != nil {
            if sqlite3_prepare_v2(db, selectStatementString, -1, &selectStatementQuery, nil) == SQLITE_OK {
                while sqlite3_step(selectStatementQuery) == SQLITE_ROW {
                    let data = String(sqlite3_column_int(selectStatementQuery, 0))
                    gatheredInfo.append(data)
                }
                sqlite3_finalize(selectStatementQuery)
            } else {
                let error_msg = String(cString: sqlite3_errmsg(db)!)
                print("error preparing select: \(error_msg)")
                return nil
            }
        }
        
        //Testing for search bar
        
        gatheredInfo.append("352638273")
        gatheredInfo.append("234348039")
        return gatheredInfo
    }
    
    //inserting into table from createsession (not the photo name or video name yet)
    func insertDB(patientID: String, date: String, exerciseType: String, notes: String) {
        
//        let selectStatementString = "INSERT INTO patients_table (Patient_ID, Exercise_type, Physician_notes, createdate) VALUES (" + patientID + ", " + exerciseType + ", " + notes + ", " + date + ");"
        let parameters = [patientID, "Image_label", exerciseType, notes, "Program_score", date, "C"]
      
        //(Database_index, Patient_ID, Patient_data, Exercise_type, Physician_notes, Program_score, createdate, users_id)
        let selectStatementString = "INSERT INTO patients_table (Patient_ID, Patient_data, Exercise_type, Physician_notes, Program_score, createdate, users_id) VALUES (?, ?, ?, ?, ?, ?, ?)"
        var selectStatementQuery: OpaquePointer?
        
        if db != nil {
            //preparing the query
           if sqlite3_prepare(db, selectStatementString, -1, &selectStatementQuery, nil) != SQLITE_OK{
               let errmsg = String(cString: sqlite3_errmsg(db)!)
               print("error preparing insert: \(errmsg)")
               return
           }
            var index:Int32 = 1
            for p in parameters {
                if sqlite3_bind_text(selectStatementQuery, index, p, -1, nil) != SQLITE_OK{
                    let errmsg = String(cString: sqlite3_errmsg(db)!)
                    print("failure binding name: \(errmsg)")
                    return
                }
                index += 1
            }
            
            //executing the query to insert values
            if sqlite3_step(selectStatementQuery) != SQLITE_DONE {
                let errmsg = String(cString: sqlite3_errmsg(db)!)
                print("failure inserting hero: \(errmsg)")
                return
            } else {
                print("Successfully inserted into database!")
            }
            sqlite3_finalize(selectStatementQuery)
        }
    }
}

