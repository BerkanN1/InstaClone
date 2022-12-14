//
//  SignInView.swift
//  Flexigram
//
//  Created by BERKAN NALBANT on 1.08.2021.
//

import SwiftUI

struct SignInView: View {
    
    @State private var email: String = ""
    @State private var password: String = ""
    
    @State private var error: String = ""
    @State private var showingAlert = false
    @State private var alertTitle:String = "Oh No 😢😢"
    
    
    func errorCheck() -> String? {
        
        if email.trimmingCharacters(in: .whitespaces).isEmpty || password.trimmingCharacters(in: .whitespaces).isEmpty {
            
            return "Please fill in a all fields"
        }
        
        return nil
    }
    
    func clear() {
        self.email = ""
        self.password = ""
    }
    
    
    func signIn(){
        if let error = errorCheck(){
            self.error = error
            self.showingAlert = true
            return
        }
        
        AuthService.signIn( email: email, password: password, onSucces: {
            (user) in
            self.clear()
        }){
            (errorMessage) in
            print("Error \(errorMessage)")
            self.error = errorMessage
            self.showingAlert = true
            return
        }
    }
    
    var body: some View {
        NavigationView{
        VStack(spacing:20){
            Image(systemName: "camera").font(.system(size: 60,weight: .black,design: .monospaced))
            VStack(alignment:.leading){
                Text("Welcome Back").font(.system(size: 32,weight: .heavy))
                Text("Sign In To Continue").font(.system(size: 16,weight: .medium))
            }
                FormField(value: $email, icon: "envelope.fill", placeholder: "Email")
                FormField(value: $password, icon: "lock.fill", placeholder: "password", isSecure: true)
                Button(action:signIn){
                    Text("Sign In").font(.title).modifier(ButtonModifier())
                }.alert(isPresented: $showingAlert){
                    Alert(title: Text(alertTitle), message: Text(error), dismissButton: .default(Text("OK")))
                }
            HStack{
                Text("New?")
                NavigationLink(destination:SignUpView()) {
                    Text("Create an Account").font(.system(size: 20,weight: .semibold))
                }
            }
        }.padding()
    }
    }


struct SignInView_Previews: PreviewProvider {
    static var previews: some View {
        SignInView()
    }
}

}
