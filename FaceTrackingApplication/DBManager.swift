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
    
   
    static let globalDB = DBManager()
    

    init() {
        let path = Bundle.main.path(forResource: "ft_database", ofType: "db")
        dbPath = path!
        copyDatabaseIfNeeded()
        openDB()
        
    }
    
    func openDB() {
//        let path = Bundle.main.path(forResource: "ft_database", ofType: "db")
//        print(path)
//        dbPath = path!
        print("new path:")
        print(dbPath)
        if sqlite3_open(dbPath, &db) == SQLITE_OK {
            print("Successfully opened connection to database!")
            print(db)
        } else {
            print("Unable to open database :(")
        }
    }
    
    
    func copyDatabaseIfNeeded() {
            // Move database file from bundle to documents folder
            
            let fileManager = FileManager.default
            
            let documentsUrl = fileManager.urls(for: .documentDirectory,
                                                        in: .userDomainMask)
            
            guard documentsUrl.count != 0 else {
                return // Could not find documents URL
            }
            
            let finalDatabaseURL = documentsUrl.first!.appendingPathComponent("ft_database.db")
        
            if !( (try? finalDatabaseURL.checkResourceIsReachable()) ?? false) {
                print("DB does not exist in documents folder")
                
                let documentsURL = Bundle.main.resourceURL?.appendingPathComponent("ft_database.db")
                
                do {
                      try fileManager.copyItem(atPath: (documentsURL?.path)!, toPath: finalDatabaseURL.path)
                      } catch let error as NSError {
                        print("Couldn't copy file to final location! Error:\(error.description)")
                }

            } else {
                print("Database file found at path: \(finalDatabaseURL.path)")
                dbPath = finalDatabaseURL.path
            }
        
        }
    
    //TODO fix to retrieve unique IDs
    // retrieving patient IDs for patient ID list
    //[String]? - was an optional
    func queryDB(sqlCommand: String) -> [String] {
        openDB()
        var gatheredInfo:[String] = [String]()
        //Patient_ID
        let selectStatementString = sqlCommand
        var selectStatementQuery: OpaquePointer?
        
        if db != nil {
            //prepare_v2 = compiles SQL statement to byte code
            print(db)
            if sqlite3_prepare_v2(db, selectStatementString, -1, &selectStatementQuery, nil) == SQLITE_OK {
                //step = runs compiled statement
                //check end row
                
                while sqlite3_step(selectStatementQuery) == SQLITE_ROW {
                    //0
                    let data = String(cString: sqlite3_column_text(selectStatementQuery, 0))
                    gatheredInfo.append(data)
                }
                sqlite3_reset(selectStatementQuery)
                //must ALWAYS finalize to delete compiled statement - avoids leaks
                sqlite3_finalize(selectStatementQuery)
            } else {
                let error_msg = String(cString: sqlite3_errmsg(db)!)
                print("error preparing select: \(error_msg)")
//                return ["ERROR"]
            }
        }
        
        sqlite3_close(db)
        return gatheredInfo
    }
    
    func query2DB(sqlCommand: String) -> [String] {
        openDB()
        var gatheredInfo:[String] = [String]()
        //Patient_ID
        let selectStatementString = sqlCommand
        var selectStatementQuery: OpaquePointer? = nil
        
        
        
        if db != nil {
            //prepare_v2 = compiles SQL statement to byte code
            if sqlite3_prepare_v2(db, selectStatementString, -1, &selectStatementQuery, nil) == SQLITE_OK {
                
                let type = sqlite3_column_type(selectStatementQuery, 3)
                print(type)
                //step = runs compiled statement
                //check end row
                while sqlite3_step(selectStatementQuery) == SQLITE_ROW {
                    guard let data = sqlite3_column_text(selectStatementQuery, 0) else  {
                        print("Query result is nil.")
                        return []
                    }
                    gatheredInfo.append(String(cString: data))
                    
                }
                sqlite3_reset(selectStatementQuery)
                //must ALWAYS finalize to delete compiled statement - avoids leaks
                sqlite3_finalize(selectStatementQuery)
            } else {
                let error_msg = String(cString: sqlite3_errmsg(db)!)
                print("error preparing select: \(error_msg)")
                return ["ERROR"]
            }
        }
        


        sqlite3_close(db)
        return gatheredInfo
    }
    
    //inserting into table from createsession (not the photo name or video name yet)
    func insertDB(patientID: String, date: String, exerciseType: String, notes: String) {
        openDB()
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
            sqlite3_bind_text(insertStatement, 6, parameters[5].utf8String, -1, nil)
            sqlite3_bind_text(insertStatement, 7, parameters[6].utf8String, -1, nil)

            
            if sqlite3_step(insertStatement) == SQLITE_DONE {
                print("Successfully inserted row!")
            } else {
                print("Could not insert row. Try again. ")
            
            }
            sqlite3_reset(insertStatement)
            sqlite3_finalize(insertStatement)
        
        }
        
        sqlite3_close(db)

    
    }
    
    
    func insertImage(patientID: String, date: String, imageName: String) {
        openDB()
//        let parameters = [patientID as NSString, "Img_Name" as NSString, exerciseType as NSString, notes as NSString, "95" as NSString, date as NSString, "Clinician" as NSString]
        let parameters = [patientID as NSString, imageName as NSString, date as NSString]
        print("parameters:")
        print(parameters)
      
        
        let insertStatementString = "INSERT INTO patients_table (Patient_ID, Patient_data, createdate) VALUES (?, ?, ?);"
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
//            sqlite3_bind_text(insertStatement, 3, parameters[2].utf8String, -1, nil)
//            sqlite3_bind_text(insertStatement, 4, parameters[3].utf8String, -1, nil)
//            sqlite3_bind_text(insertStatement, 5, parameters[4].utf8String, -1, nil)
            sqlite3_bind_text(insertStatement, 6, parameters[2].utf8String, -1, nil)
//            sqlite3_bind_text(insertStatement, 7, parameters[6].utf8String, -1, nil)

            
            if sqlite3_step(insertStatement) == SQLITE_DONE {
                print("Successfully inserted row!")
            } else {
                print("Could not insert row. Try again. ")
            
            }
            sqlite3_reset(insertStatement)
            sqlite3_finalize(insertStatement)
        
        }
        
        sqlite3_close(db)

    
    }
}

