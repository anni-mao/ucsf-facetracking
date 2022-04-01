//
//  ImageVideoStorageSystem.swift
//  FaceTrackingApplication
//
//  Created by Anni Mao on 1/20/22.
//

import Foundation
import UIKit

//        //create directory
//        let directory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first
//        //append to directory URL to create unqiue path
//        let path = directory?.appendingPathComponent("\(name)")


//Notes: save image and save in sqldb 

class LocalFileManager: ObservableObject {
    //singleton method
    static let FM = LocalFileManager()
    var currPatientID:String = ""
    
    func setCurrID (patientID: String) {
        currPatientID = patientID 
    }
    
    func saveImage(image: UIImage, name: String) {
        print("save Image???")
        guard
            let data = image.jpegData(compressionQuality: 1.0),
        let path = getPathForImage(name: name) else {
            print("Unable to get image.")
            return
        }
        
        do {
            try data.write(to: path)
            print("Sucess saving image!")
        } catch let error {
            print("Error saving. \(error)")
        }
    }
    
    func getImage(name: String) -> UIImage? {
        guard
            let path = getPathForImage(name: name)?.path,
                FileManager.default.fileExists(atPath: path) else {
                    print("Error getting UIImage")
                    return nil
                }
        return UIImage(contentsOfFile: path)
    }
    
    
    func getPathForImage(name: String) -> URL? {
        guard
            let path = FileManager
                .default
                .urls(for: .documentDirectory, in: .userDomainMask)
                .first?
                .appendingPathComponent("\(name)") else {
                    print("Error getting path")
                    return nil
                }
        return path
    }
    
    func deleteImage(name: String) {
        guard
            let path = getPathForImage(name: name),
            FileManager.default.fileExists(atPath: path.path) else {
                print("Error getting UIImage")
                return
        }
        
        do {
            try FileManager.default.removeItem(at: path)
            print("Successfully deleted.")
        } catch let error {
            print("Error deleting image. \(error)")
        }
    }

    
    
}


//class FileManagerViewModel: ObservableObject {
//    @Published var image: UIImage? = nil
//    let imageName: String = "sample-image"
//    let manager = LocalFileManager.instance
//
//    func getImageFromFileManager() {
//        image = UIImage(named: imageName)
//    }
//
//}





