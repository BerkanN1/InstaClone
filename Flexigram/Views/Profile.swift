//
//  Profile.swift
//  Flexigram
//
//  Created by BERKAN NALBANT on 9.08.2021.
//

import SwiftUI
import SDWebImageSwiftUI
import FirebaseAuth

struct Profile: View {
    @EnvironmentObject var session: SessionStore
    @State private var selection = 1
    @ObservedObject var profileService = ProfileService()
    
    let threeColumns = [GridItem(),GridItem(),GridItem()]

    var body: some View {
        ScrollView{
        VStack{
            ProfileHeader(user: self.session.session, postsCount: profileService.posts.count,following: $profileService.following,followers: $profileService.followers)
            Button(action:{}){
                Text("Edit Profile").font(.title).modifier(ButtonModifier())
            }.padding(.horizontal)
            Picker("",selection:$selection){
                Image(systemName: "circle.grid.2x2.fill").tag(0)
                Image(systemName: "person.circle").tag(1)
            }.pickerStyle(SegmentedPickerStyle()).padding(.horizontal)
            
            if selection == 0{
                LazyVGrid(columns: threeColumns){
                    ForEach(self.profileService.posts, id:\.postId){
                        (post) in
                       
                        WebImage(url: URL(string: post.mediaUrl)!)
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(width: UIScreen.main.bounds.width/3, height: UIScreen.main.bounds.height/3)
                            .clipped()
                    }
                }
            }else
            if (self.session.session == nil){
                Text("")
            } else {
                ScrollView{
                    
                    VStack{
                        ForEach(self.profileService.posts,id:\.postId){
                            (post) in
                            PostCardImage(post: post)
                            PostCard(post: post)
                        }
                    }
                    
                }
            }
            
        }
        }
        .navigationTitle("Profile")
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarItems(leading: Button(action:{}){
            Image(systemName: "person.fill")
        }, trailing: Button(action:{
            self.session.logout()
        }){
            Image(systemName: "arrow.right.circle.fill")
    })
        .onAppear{
            self.profileService.loadUserPosts(userId: Auth.auth().currentUser!.uid)
        }
}


    
    
    
    
    
    
    
struct Profile_Previews: PreviewProvider {
    static var previews: some View {
        Profile()
    }
}
}
