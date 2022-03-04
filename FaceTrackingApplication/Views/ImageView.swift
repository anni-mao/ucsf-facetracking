//
//  ImageView.swift
//  FaceTrackingApplication
//
//  Created by Anni Mao on 3/3/22.
//

import SwiftUI
import UIKit

struct ImageView: View {
//    var imageName: String

    var image: UIImage
    
    init(imageName: String) {
        let fM = LocalFileManager()
        image = fM.getImage(name: imageName)!
    }
    var body: some View {
        Image(uiImage: image)
        
    }
}

struct ImageView_Previews: PreviewProvider {
    static var previews: some View {
        ImageView(imageName: "imageName")
    }
}
