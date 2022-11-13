//
//  AuthService.swift
//  Flexigram
//
//  Created by BERKAN NALBANT on 8.08.2021.
//

import Foundation
import Firebase
import FirebaseAuth
import FirebaseStorage

class AuthService{
    static var storeRoot = Firestore.firestore()
    
    static func getUserId(userId: String) -> DocumentReference{
        return storeRoot.collection("users").document(userId)
    }
    
    static func signUp(usermane:String,email: String,password:String,imageData: Data ,onSucces: @escaping(_ user: User) -> Void,onError: @escaping(_ errorMessage: String) -> Void){
        Auth.auth().createUser(withEmail: email, password: password){
            (authData,error) in
            if error != nil {
                onError(error!.localizedDescription)
                return
            }
            guard let userId = authData?.user.uid else{return}
            let storageProfileUserId = StorageService.storageProfileId(userId: userId)
            let metadata = StorageMetadata()
            metadata.contentType = "image/jpg"
            StorageService.saveProfileImage(userId: userId, username: usermane, email: email, imageData:imageData , metaData: metadata, storageProfileImageRef: storageProfileUserId, onSucces: onSucces, onError: onError)
        }
    }
    
    static func signIn(email: String,password:String,onSucces: @escaping(_ user: User) -> Void,onError: @escaping(_ errorMessage: String) -> Void){
        Auth.auth().signIn(withEmail: email, password: password){
            (authData, error) in
            if error != nil {
                onError(error!.localizedDescription)
                return
            }
            guard let userId = authData?.user.uid else{return}
            let firestoreUserId = getUserId(userId: userId)
            firestoreUserId.getDocument{
                (document,error) in
                if let dict = document?.data(){
                    guard let decodeUser = try? User.init(fromDictionary: dict) else{return}
                    onSucces(decodeUser)
                }
            }
        }
    }
}
