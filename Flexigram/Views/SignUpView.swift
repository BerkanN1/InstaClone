//
//  SignUpView.swift
//  Flexigram
//
//  Created by BERKAN NALBANT on 1.08.2021.
//

import SwiftUI

struct SignUpView: View {
    @State private var email: String = ""
    @State private var password: String = ""
    @State private var  username: String = ""
    @State private var profileImage: Image?
    @State private var pickedImage: Image?
    @State private var showActionSheet = false
    @State private var showImagePicker = false
    @State private var imageData: Data = Data()
    @State private var sourceType: UIImagePickerController.SourceType = .photoLibrary
    @State private var error: String = ""
    @State private var showingAlert = false
    @State private var alertTitle:String = "Oh No 😢😢"
    
    func loadImage(){
        guard let inputImage = pickedImage else{return}
        profileImage = inputImage
    }
    
    func errorCheck() -> String? {
        
        if email.trimmingCharacters(in: .whitespaces).isEmpty || password.trimmingCharacters(in: .whitespaces).isEmpty || username.trimmingCharacters(in: .whitespaces).isEmpty || imageData.isEmpty {
            
            return "Please fill in a all fields and provide in image"
        }
        
        return nil
    }
    
    func clear() {
        self.email = ""
        self.username = ""
        self.password = ""
        self.imageData = Data()
        self.profileImage = Image(systemName: "person.circle.fill")
    }
    
    func signUp(){
        if let error = errorCheck(){
            self.error = error
            self.showingAlert = true
            return
        }
        
        AuthService.signUp(usermane: username, email: email, password: password, imageData: imageData, onSucces: {
            (user) in
            self.clear()
        }){
            (errorMessage) in
            
            self.error = errorMessage
            self.showingAlert = true
            return
        }
    }

    var body: some View {
        ScrollView{
         VStack(spacing:20){
            Image(systemName: "camera").font(.system(size: 60,weight: .black,design: .monospaced))
            VStack(alignment:.leading){
                Text("Welcome").font(.system(size: 32,weight: .heavy))
                Text("Sign Up to Start").font(.system(size: 16,weight: .medium))
            }
            VStack{
                Group{
                    if profileImage != nil{
                        profileImage!.resizable()
                            .clipShape(Circle())
                            .frame(width: 100, height: 100)
                            .padding(.top,20)
                            .onTapGesture {
                                self.showActionSheet = true
                            }
                    }else{
                        Image(systemName: "person.circle.fill").resizable()
                            .clipShape(Circle())
                            .frame(width: 200, height: 200)
                            .padding(.top,20)
                            .onTapGesture {
                                self.showActionSheet = true
                            }
                    }
                }
            }
            
            
            Group{
                FormField(value: $username, icon: "person.fill", placeholder: "Username")
                FormField(value: $email, icon: "envelope.fill", placeholder: "Email")
                FormField(value: $password, icon: "lock.fill", placeholder: "password", isSecure: true)
            }
                Button(action:signUp){
                    Text("Sign Up").font(.title).modifier(ButtonModifier())
                }.alert(isPresented: $showingAlert){
                    Alert(title: Text(alertTitle), message: Text(error), dismissButton: .default(Text("OK")))
                }
    }.padding()
        }.sheet(isPresented: $showImagePicker,onDismiss: loadImage){
            ImagePicker(pickedImage: self.$pickedImage, showImagePicker: self.$showImagePicker, imageDate: self.$imageData)
        }.actionSheet(isPresented: $showActionSheet){
            ActionSheet(title: Text(""),buttons: [.default(Text("Choose A Photo")){
                self.sourceType = .photoLibrary
                self.showImagePicker = true
            },.default(Text("Take A Photo")){
                self.sourceType = .camera
                self.showImagePicker = true
            },.cancel()])
        }
    }

struct SignUpView_Previews: PreviewProvider {
    static var previews: some View {
        SignUpView()
    }
}
}
