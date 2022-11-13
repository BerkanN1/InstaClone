//
//  ProfileService.swift
//  Flexigram
//
//  Created by BERKAN NALBANT on 12.08.2021.
//

import Foundation
import Firebase


class ProfileService:ObservableObject{
    @Published var posts: [PostModel] = []
    @Published var following = 0
    @Published var followers = 0
    
    static var following = AuthService.storeRoot.collection("following")
    static var followers = AuthService.storeRoot.collection("followers")
    
    static func followingCollections(userid:String)->CollectionReference{
        return following.document(userid).collection("following")
    }
    
    static func followersCollections(userid:String)->CollectionReference{
        return followers.document(userid).collection("followers")
    }
    
    func loadUserPosts(userId: String){
        PostService.loadUserPosts(userId: userId){
            (posts) in
            self.posts = posts
        }
        follows(userId: userId)
        followers(userId: userId)
    }
    func follows(userId:String){
        ProfileService.followingCollections(userid: userId).getDocuments{
            (querysnapshot,err) in
            if let doc = querysnapshot?.documents{
                self.following = doc.count
            }
        }
    }
    func followers(userId:String){
        ProfileService.followersCollections(userid: userId).getDocuments{
            (querysnapshot,err) in
            if let doc = querysnapshot?.documents{
                self.followers = doc.count
            }
        }
    }
}
