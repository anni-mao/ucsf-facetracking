//
//  EndSessionView.swift
//  FaceTrackingApplication
//
//  Created by Anni Mao on 1/20/22.
//


//Count the number of photos get taken?
//Mainly to end session for a patient ID 
import SwiftUI

struct EndSessionView: View {
    
    var patientID: String
    
    
    
    var body: some View {
        //TODO: start and stop count of images
        VStack {
            
            Text("Please navigate to 'Camera' at the bottom right hand screen. Navigate back to end the session for the current patient.")
                .font(.title)
                .frame(maxWidth: .infinity, alignment: .center)
            
            Button(action: {
            //navigate back to start session
                
                
            }) {
                Text("End Session for Patient " + patientID)
                    .font(.title)
                    .fontWeight(.medium)
                    .foregroundColor(.white)
                    .padding()
                    .background(Color.blue)
                    .cornerRadius(15.0)
            }
        }
        
        
    }
}

//need to initiate count to start, count how many images are taken for this patient and only end when "End Session..." is clicked
func startCount() {
    
}


struct EndSessionView_Previews: PreviewProvider {
    static var previews: some View {
        EndSessionView(patientID: "348392843")
    }
}
