//
//  TestFolder Views.swift
//  FaceTrackingApplication
//
//  Created by Anni Mao on 11/3/21.
//

import SwiftUI

struct TestFolder_Views: View {
    var patientID:String
    var date:String
    var body: some View {
        //Pass in date and patient ID 
        //Somehow access photo library/documents to import photos?
        Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
    }
}



struct TestFolder_Views_Previews: PreviewProvider {
    static var previews: some View {
        TestFolder_Views(patientID: "000000", date: "10/01/21")
    }
}
