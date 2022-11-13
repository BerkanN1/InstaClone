//
//  PostCardService.swift
//  Flexigram
//
//  Created by BERKAN NALBANT on 12.08.2021.
//

import Foundation
import Firebase
import SwiftUI

class PostCardService: ObservableObject {
    @Published var post: PostModel!
    @Published var isLiked = false
    
    func hasLikedPost(){
        isLiked = (post.likes["\(Auth.auth().currentUser!.uid)"] == true) ? true:false
    }
    func like(){
        post.likeCount += 1
        isLiked = true
        
        PostService.postsUserId(userId: post.ownerId).collection("posts").document(post.postId).updateData(["liCount": post.likeCount, "\(Auth.auth().currentUser!.uid)": true])
       
        PostService.allPosts.document(post.postId).updateData(["likeCount": post.likeCount,"\(Auth.auth().currentUser!.uid)": true])
        
        PostService.timelineUserId(userId: post.ownerId).collection("timeline").document(post.postId).updateData(["likeCount": post.likeCount,"\(Auth.auth().currentUser!.uid)": true])
    }
    
    func unlike(){
        post.likeCount -= 1
        isLiked = false
        
        PostService.postsUserId(userId: post.ownerId).collection("posts").document(post.postId).updateData(["liCount": post.likeCount, "\(Auth.auth().currentUser!.uid)": false])
       
        PostService.allPosts.document(post.postId).updateData(["likeCount": post.likeCount,"\(Auth.auth().currentUser!.uid)": false])
        
        PostService.timelineUserId(userId: post.ownerId).collection("timeline").document(post.postId).updateData(["likeCount": post.likeCount,"\(Auth.auth().currentUser!.uid)": false])
    }
}
