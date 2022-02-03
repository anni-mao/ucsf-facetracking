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
                    let data = String(cString: sqlite3_column_text(selectStatementQuery, 0))
                    gatheredInfo.append(data)
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
        
        let parameters = [patientID as NSString, "Img_Name" as NSString, exerciseType as NSString, notes as NSString, "95" as NSString, date as NSString, "Clinician" as NSString]
        print("parameters:")
        print(parameters)
      
        
        let insertStatementString = "INSERT INTO patients_table (Patient_ID, Patient_data, Exercise_type, Physician_notes, Program_score, createdate, users_id) VALUES (?, ?, ?, ?, ?, ?, ?);"
        var insertStatement: OpaquePointer?
    
        
        if db != nil {
            //preparing the query
           if sqlite3_prepare(db, insertStatementString, -1, &insertStatement, nil) != SQLITE_OK{
               let errmsg = String(cString: sqlite3_errmsg(db)!)
               print("error preparing insert: \(errmsg)")
               return
           }
//            parameters[0].withCString { p1 in
//                print(type(of: p1))
//                sqlite3_bind_text(insertStatement, 1, p1, -1, nil)
//            }

            sqlite3_bind_text(insertStatement, 1, parameters[0].utf8String, -1, nil)
            sqlite3_bind_text(insertStatement, 2, parameters[1].utf8String, -1, nil)
            sqlite3_bind_text(insertStatement, 3, parameters[2].utf8String, -1, nil)
            sqlite3_bind_text(insertStatement, 4, parameters[3].utf8String, -1, nil)
            sqlite3_bind_text(insertStatement, 5, parameters[4].utf8String, -1, nil)
//            sqlite3_bind_int(insertStatement, 4, programScore)
            sqlite3_bind_text(insertStatement, 6, parameters[5].utf8String, -1, nil)
            sqlite3_bind_text(insertStatement, 7, parameters[6].utf8String, -1, nil)
            
            print(type(of: parameters[4]))
            print(type(of: parameters[5]))
            
            if sqlite3_step(insertStatement) == SQLITE_DONE {
                print("Successfully inserted row!")
            } else {
                print("Could not insert row. Try again. ")
            }
 
            sqlite3_finalize(insertStatement)
        
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

