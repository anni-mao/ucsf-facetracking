//
//  ImageVideoStorageSystem.swift
//  FaceTrackingApplication
//
//  Created by Anni Mao on 1/20/22.
//

import Foundation
import UIKit

func saveImageVideoDocumentDirectory(dataName: String) {
    let fileManager = FileManager.default
    
    let paths = (NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as NSString).appendingPathComponent(dataName)
    
    print(paths)
    
    let image = UIImage(named: dataName)
    
    let imageData =  image!.jpegData(compressionQuality: 0.5)
    fileManager.createFile(atPath: paths as String, contents: imageData, attributes: nil)
}
