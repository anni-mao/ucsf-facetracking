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
    
    //Open database connection 
    init() {
        let path = Bundle.main.path(forResource: "ft_database", ofType: "db")
        print(path)
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
        //Patient_ID
        let selectStatementString = "SELECT Patient_ID FROM patients_table;"
        var selectStatementQuery: OpaquePointer?
        
        if db != nil {
            //prepare_v2 = compiles SQL statement to byte code
            if sqlite3_prepare_v2(db, selectStatementString, -1, &selectStatementQuery, nil) == SQLITE_OK {
                //step = runs compiled statement
                //check end row
                while sqlite3_step(selectStatementQuery) == SQLITE_ROW {
                    //String(sqlite3_column_int(selectStatementQuery, 0))
                    let data = String(cString: sqlite3_column_text(selectStatementQuery, 0))
                    gatheredInfo.append(data)
                    //added
//                    let data1 = String(sqlite3_column_int(selectStatementQuery, 1))
//                    gatheredInfo.append(data1)
//                    let data2 = String(sqlite3_column_int(selectStatementQuery, 2))
//                    gatheredInfo.append(data2)
                }
                //must ALWAYS finalize to delete compiled statement - avoids leaks
                sqlite3_finalize(selectStatementQuery)
            } else {
                let error_msg = String(cString: sqlite3_errmsg(db)!)
                print("error preparing select: \(error_msg)")
                return nil
            }
        }
        
        //Testing for search bar
        
//        gatheredInfo.append("352638273")
//        gatheredInfo.append("234348039")
        sqlite3_close(db)
        return gatheredInfo
    }
    
    //inserting into table from createsession (not the photo name or video name yet)
    func insertDB(patientID: String, date: String, exerciseType: String, notes: String) {
        
        let parameters = [patientID, "Image_label", exerciseType, notes, "Program_score", date, "C"]
        print("parameters:")
        print(parameters)
      
        
        let insertStatementString = "INSERT INTO patients_table (Patient_ID, Patient_data, Exercise_type, Physician_notes, Program_score, createdate, users_id) VALUES (?, ?, ?, ?, ?, ?, ?);"
        var insertStatementQuery: OpaquePointer?
    
        
        if db != nil {
            //preparing the query
           if sqlite3_prepare(db, insertStatementString, -1, &insertStatementQuery, nil) != SQLITE_OK{
               let errmsg = String(cString: sqlite3_errmsg(db)!)
               print("error preparing insert: \(errmsg)")
               return
           }
            var index:Int32 = 1
            for p in parameters {
                if sqlite3_bind_text(insertStatementQuery, index, p, -1, nil) != SQLITE_OK{
                    let errmsg = String(cString: sqlite3_errmsg(db)!)
                    print("failure binding name: \(errmsg)")
                    return
                }
                //executing the query to insert values
                if sqlite3_step(insertStatementQuery) != SQLITE_DONE {
                    let errmsg = String(cString: sqlite3_errmsg(db)!)
                    print("failure inserting: \(errmsg)")
                    print(p)
                    return
                }
                print("Successfully inserted row into database!")
                index += 1
                sqlite3_reset(insertStatementQuery)
            }
//            Finalize when ending procedure
            sqlite3_finalize(insertStatementQuery)
        
        }
        
        sqlite3_close(db)
        
        
        let path = Bundle.main.path(forResource: "ft_database", ofType: "db")
        dbPath = path!
        if sqlite3_open(path, &db) == SQLITE_OK {
            print("Successfully opened connection to database!")
        } else {
            print("Unable to open database :(")
        }
    
        

        print(queryDB())
    }
}

