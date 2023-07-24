//
//  BoardPage.swift
//  UniMate
//
//  Created by 유석원 on 2023/07/22.
//

import SwiftUI

struct BoardView: View {
    var body: some View {
        NavigationView {
            ScrollView {
                VStack (alignment: .leading){
                    HStack {
                        Text("BEST 게시판")
                        Spacer()
                        Button {
                            print("Go to BEST board")
                        } label: {
                            Image(systemName: "chevron.right")
                        }
                    }
                    .onTapGesture {
                        // give on tap gesture to entire hstack?
                        print("Go to BEST board?")
                    }
                    
                    Divider()
                        .background(Color.black)
                    
                    VStack(alignment: .leading) {
                        VStack(alignment: .leading) {
                            HStack {
                                Image(systemName: "person")
                                Text("익명")
                                    .bold()
                            }
                            Text("Title1")
                                .bold()
                            Text("Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book.")
                                .lineLimit(2)
                        }
                        
                        HStack {
                            Text("자유게시판")
                                .font(.system(size: 12))
                                .foregroundColor(Color(UIColor(hexCode: "665E5E")))
                            Spacer()
                            Label("3", systemImage: "hand.thumbsup")
                                .font(.system(size: 12))
                                .foregroundColor(.red)
                            Label("5", systemImage: "message")
                                .font(.system(size: 12))
                                .foregroundColor(.blue)
                        }
                        
                    }
                    .frame(alignment: .leading)
                    .padding(10)
                    
                    VStack(alignment: .leading) {
                        VStack(alignment: .leading) {
                            HStack {
                                Image(systemName: "person")
                                Text("익명")
                                    .bold()
                            }
                            Text("Title1")
                                .bold()
                            Text("Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book.")
                                .lineLimit(2)
                        }
                        
                        HStack {
                            Text("자유게시판")
                                .font(.system(size: 12))
                                .foregroundColor(Color(UIColor(hexCode: "665E5E")))
                            Spacer()
                            Label("3", systemImage: "hand.thumbsup")
                                .font(.system(size: 12))
                                .foregroundColor(.red)
                            Label("5", systemImage: "message")
                                .font(.system(size: 12))
                                .foregroundColor(.blue)
                        }
                        
                    }
                    .frame(alignment: .leading)
                    .padding(10)
                    
                    VStack(alignment: .leading) {
                        VStack(alignment: .leading) {
                            HStack {
                                Image(systemName: "person")
                                Text("익명")
                                    .bold()
                            }
                            Text("Title1")
                                .bold()
                            Text("Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book.")
                                .lineLimit(2)
                        }
                        
                        HStack {
                            Text("자유게시판")
                                .font(.system(size: 12))
                                .foregroundColor(Color(UIColor(hexCode: "665E5E")))
                            Spacer()
                            Label("3", systemImage: "hand.thumbsup")
                                .font(.system(size: 12))
                                .foregroundColor(.red)
                            Label("5", systemImage: "message")
                                .font(.system(size: 12))
                                .foregroundColor(.blue)
                        }
                        
                    }
                    .frame(alignment: .leading)
                    .padding(10)
                    
                    VStack(alignment: .leading) {
                        VStack(alignment: .leading) {
                            HStack {
                                Image(systemName: "person")
                                Text("익명")
                                    .bold()
                            }
                            Text("Title1")
                                .bold()
                            Text("Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book.")
                                .lineLimit(2)
                        }
                        
                        HStack {
                            Text("자유게시판")
                                .font(.system(size: 12))
                                .foregroundColor(Color(UIColor(hexCode: "665E5E")))
                            Spacer()
                            Label("3", systemImage: "hand.thumbsup")
                                .font(.system(size: 12))
                                .foregroundColor(.red)
                            Label("5", systemImage: "message")
                                .font(.system(size: 12))
                                .foregroundColor(.blue)
                        }
                        
                    }
                    .frame(alignment: .leading)
                    .padding(10)
                    
                    VStack(alignment: .leading) {
                        VStack(alignment: .leading) {
                            HStack {
                                Image(systemName: "person")
                                Text("익명")
                                    .bold()
                            }
                            Text("Title1")
                                .bold()
                            Text("Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book.")
                                .lineLimit(2)
                        }
                        
                        HStack {
                            Text("자유게시판")
                                .font(.system(size: 12))
                                .foregroundColor(Color(UIColor(hexCode: "665E5E")))
                            Spacer()
                            Label("3", systemImage: "hand.thumbsup")
                                .font(.system(size: 12))
                                .foregroundColor(.red)
                            Label("5", systemImage: "message")
                                .font(.system(size: 12))
                                .foregroundColor(.blue)
                        }
                        
                    }
                    .frame(alignment: .leading)
                    .padding(10)
                    
                    
                }
                .padding(10)
                .cornerRadius(10)
                .overlay(
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(Color(UIColor(hexCode: "969696")), lineWidth: 1)
                )
                .padding(.horizontal)
                
                VStack (alignment: .leading){
                    HStack {
                        Text("게시판 목록")
                    }
                
                    Divider()
                        .background(Color.black)
                    
                    HStack {
                        Text("자유 게시판")
                        Spacer()
                        Button {
                            print("Go to community board")
                        } label: {
                            Image(systemName: "chevron.right")
                        }
                    }
                    .padding(.vertical)
                    .onTapGesture {
                        // give on tap gesture to entire hstack?
                        print("Go to community board?")
                    }
                    
                    
                    
                    HStack {
                        Text("대학원 게시판")
                        Spacer()
                        Button {
                            print("Go to grad board")
                        } label: {
                            Image(systemName: "chevron.right")
                        }
                    }
                    .padding(.vertical)
                    .onTapGesture {
                        // give on tap gesture to entire hstack?
                        print("Go to grad board?")
                    }
                    
                    HStack {
                        Text("동아리 게시판")
                        Spacer()
                        Button {
                            print("Go to club board")
                        } label: {
                            Image(systemName: "chevron.right")
                        }
                    }
                    .padding(.vertical)
                    .onTapGesture {
                        // give on tap gesture to entire hstack?
                        print("Go to club board?")
                    }
                    
                    HStack {
                        Text("홍보 게시판")
                        Spacer()
                        Button {
                            print("Go to ad board")
                        } label: {
                            Image(systemName: "chevron.right")
                        }
                    }
                    .padding(.vertical)
                    .onTapGesture {
                        // give on tap gesture to entire hstack?
                        print("Go to ad board?")
                    }
                    
                    
                    
                }
                .padding(10)
                .cornerRadius(10)
                .overlay(
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(Color(UIColor(hexCode: "969696")), lineWidth: 1)
                )
                .padding(.vertical)
                .padding(.horizontal)
            }
            .navigationTitle("게시판")
            .navigationBarTitleDisplayMode(.inline)
            
            
            
            

        }
    }
}

struct BoardView_Previews: PreviewProvider {
    static var previews: some View {
        BoardView()
    }
}
