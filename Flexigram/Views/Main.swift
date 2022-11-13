//
//  Main.swift
//  Flexigram
//
//  Created by BERKAN NALBANT on 9.08.2021.
//

import SwiftUI
import FirebaseAuth

struct Main: View {
 

    @EnvironmentObject var session : SessionStore
   @ObservedObject var profileService = ProfileService()

   var body: some View {
       ScrollView{
           
           VStack{
               ForEach(self.profileService.posts,id:\.postId){
                   (post) in
                   PostCardImage(post: post)
                   PostCard(post: post)
               }
           }
           
       }.navigationTitle("")
       .navigationBarHidden(true)
       .onAppear{
           self.profileService.loadUserPosts(userId: Auth.auth().currentUser!.uid)
       }
   }

}
 
