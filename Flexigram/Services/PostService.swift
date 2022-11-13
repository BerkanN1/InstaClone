//
//  PostService.swift
//  Flexigram
//
//  Created by BERKAN NALBANT on 11.08.2021.
//

import Foundation
import Firebase
import FirebaseAuth
import FirebaseFirestore
import FirebaseStorage

class PostService{
    
    static var posts = AuthService.storeRoot.collection("posts")
    static var allPosts = AuthService.storeRoot.collection("allPosts")
    static var timeline = AuthService.storeRoot.collection("timeline")
    
    static func postsUserId(userId:String) ->DocumentReference {
        return posts.document(userId)
    }
    
    static func timelineUserId(userId:String) ->DocumentReference {
        return timeline.document(userId)
    }
    
    static func uploadPost(caption: String,imageData: Data,onSuccess: @escaping()->Void, onError: @escaping(_ errorMessage:String) ->Void){
        guard let userId = Auth.auth().currentUser?.uid  else {return}
        let postId = PostService.postsUserId(userId: userId).collection("posts").document().documentID
        let storagePostRef = StorageService.storagePostId(postId: postId)
        let metaData = StorageMetadata()
        metaData.contentType = "image/jpg"
        
        StorageService.savePostPhoto(user: userId, caption: caption, postId: postId, imageData: imageData, metadata: metaData, storagePostRef: storagePostRef, onSuccess: onSuccess, onError: onError)
    }
    
    static func loadUserPosts(userId:String,onSuccess:@escaping(_ posts:[PostModel])->Void){
        PostService.postsUserId(userId: userId).collection("posts").getDocuments{
            (snapshot,error) in
            guard let snap = snapshot else{
                print("Error")
                return
                
            }
            var posts = [PostModel]()
            
            for doc in snap.documents{
                let dict = doc.data()
                guard let decoder = try? PostModel.init(fromDictionary: dict)
                else{return
                    
                }
                posts.append(decoder)
            }
            onSuccess(posts)
        }
    }
}
