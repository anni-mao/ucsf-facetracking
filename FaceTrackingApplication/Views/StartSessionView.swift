//
//  StartSessionView.swift
//  FaceTrackingApplication
//
//  Created by Anni Mao on 1/6/22.
//

import SwiftUI

struct StartSessionView: View {
    @State var patientID = ""
    let date = Date()
    // Create Date Formatter
    let dateFormatter = DateFormatter()
    var presentDate = Text(Date.now, format: .dateTime.day().month().year())
    @State var notes = ""
    @State var isExpanded = false
    let exerciseList:[String] = ["A", "B", "C", "D", "E", "F", "G"]
    @State var selectedExercise = "Select Exercise Type"
    @State var autoDate = ""
    
    init() {
        dateFormatter.dateStyle = .long
        self._autoDate = State(wrappedValue: dateFormatter.string(from: date)) // _editedValue is State<String>
    }

    var body: some View {
        NavigationView {

            VStack (spacing: 20){
                Text("Please enter the following...")
                    .font(.title2)
                    .fontWeight(.medium)
                    .frame(maxWidth: .infinity, alignment: .leading)

                Text("Patient ID")
                    .font(.title)
                    .fontWeight(.medium)
                    .frame(maxWidth: .infinity, alignment: .leading)
                
                TextField("Enter the Patient ID...",text: $patientID)
                    .padding()
                    .background(Color(hue: 1.0, saturation: 0.0, brightness: 0.835))
                    .cornerRadius(10.0)
                    .padding(.bottom, 20)
                
                Text("Date")
                    .font(.title)
                    .fontWeight(.medium)
                    .frame(maxWidth: .infinity, alignment: .leading)
                
                
                TextField("", text: $autoDate)
                    .padding()
                    .background(Color(hue: 1.0, saturation: 0.0, brightness: 0.835))
                //                    .frame(width: 350.0, height: 50.0)
                    .cornerRadius(10.0)
                    .padding(.bottom, 20)
                
                
                Text("Exercise")
                    .font(.title)
                    .fontWeight(.medium)
                    .frame(maxWidth: .infinity, alignment: .leading)
                //create drop down menu
                
                
                DisclosureGroup("\(selectedExercise)", isExpanded: $isExpanded) {
                    //                        ScrollView {
                    //
                    //                        }
                    VStack {
                        ForEach(0..<exerciseList.count) { i in
                            Text(exerciseList[i])
                                .font(.title3)
                                .padding()
                                .onTapGesture {
                                    self.selectedExercise = exerciseList[i]
                                    withAnimation {
                                        self.isExpanded.toggle()
                                    }
                                    
                                }
                        }
                        
                        
                    }
                    
                }
                .accentColor(.black)
                .font(.title3)
                .padding(.all)
                .foregroundColor(.black)
                .background(Color(hue: 1.0, saturation: 0.0, brightness: 0.835))
                
                .cornerRadius(10.0)
                
                
                Text("Notes")
                    .font(.title)
                    .fontWeight(.medium)
                    .frame(maxWidth: .infinity, alignment: .leading)
                
                TextField("Enter notes (optional)...",text: $notes)
                    .padding()
                    .background(Color(hue: 1.0, saturation: 0.0, brightness: 0.835))
                    .cornerRadius(10.0)
                    .padding(.bottom, 20)
                
                
                
                NavigationLink(destination: EndSessionView(patientID: self.patientID)) {
                    Text("Create Session")
                        .font(.title)
                        .fontWeight(.medium)
                        .foregroundColor(.white)
                        .padding()
                        .frame(width: 250, height: 60)
                        .background(Color.blue)
                        .cornerRadius(15.0)
                }
                .simultaneousGesture(TapGesture().onEnded{
                    let model:DBManager = DBManager()
                    let insertDate = dateFormatter.string(from: date)
                    model.insertDB(patientID: self.patientID, date: insertDate, exerciseType: self.selectedExercise, notes: self.notes)
                })
                
        
                
                
            }
            .offset(y: -80)
            .padding(.all)
            .navigationTitle("Start Session")
            
        }
        //for ipad orientation
        .navigationViewStyle(StackNavigationViewStyle())
    }
}

struct StartSessionView_Previews: PreviewProvider {
    static var previews: some View {
        StartSessionView()
    }
}
