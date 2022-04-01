//
//  TestFolder Views.swift
//  FaceTrackingApplication
//
//  Created by Anni Mao on 11/3/21.
//

import SwiftUI

struct PullImage_Views: View {
    var patientID:String
    var date:String
    var imageNames:[String]
    var UIImages:[UIImage] = [UIImage]()
    
    
    init(pID:String, d:String) {
        self.patientID = pID
        self.date = d
        let db = DBManager.globalDB
        self.imageNames = db.query2DB(sqlCommand: "SELECT Patient_data FROM patients_table WHERE Patient_ID = " + patientID + " AND createdate IS NOT NULL AND Patient_data IS NOT NULL AND users_id IS NULL;")
        print("Image Names")
        print(imageNames)
        let fM = LocalFileManager.FM
        for name in self.imageNames {
            self.UIImages.append(fM.getImage(name: name)!)
            
        }
        print("UIImages")
        print(UIImages)
        
    }

//    var imagePath:String
    var body: some View {
        //Pass in date and patient ID 
        //Somehow access photo library/documents to import photos?
        VStack {
            ForEach(UIImages, id: \.self) { img in
                Image(uiImage: img)
                    .resizable()

            }

        }
        
        
        
    }
}



struct PullImage_Views_Previews: PreviewProvider {
    static var previews: some View {
//        /, imagePath: " "
        PullImage_Views(pID: "000000", d: "10/01/21")
    }
}
