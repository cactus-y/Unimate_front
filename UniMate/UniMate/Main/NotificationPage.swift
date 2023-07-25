//
//  NotificationPage.swift
//  UniMate
//
//  Created by 유석원 on 2023/07/22.
//

import SwiftUI

struct NotificationView: View {
    var body: some View {
        NavigationView {
            VStack {
                NavigationLink(destination: PostDetailView()) {
                    HStack {
                        Image(systemName: "pencil.circle.fill")
                            .resizable()
                            .frame(width: 50, height: 50)
                            .foregroundColor(.black)
                            
                        VStack(alignment: .leading) {
                            Text("글 제목")
                                .foregroundColor(.black)
                            Text("댓글 내용 블라블라")
                                .multilineTextAlignment(.leading)
                                .lineLimit(2)
                                .foregroundColor(.black)
                            HStack {
                                Text("자유 게시판")
                                    .font(.system(size: 12))
                                    .foregroundColor(Color(UIColor(hexCode: "665E5E")))
                                Text("익명")
                                    .font(.system(size: 12))
                                    .foregroundColor(Color(UIColor(hexCode: "665E5E")))
                                Text("07/25 12:00")
                                    .font(.system(size: 12))
                                    .foregroundColor(Color(UIColor(hexCode: "665E5E")))
                            }
                        }
                        .padding(.horizontal, 10)
                        Spacer()
                    }
                    .padding(.horizontal)
                }
                
                Divider()
                
                NavigationLink(destination: PostDetailView()) {
                    HStack {
                        Image(systemName: "pencil.circle.fill")
                            .resizable()
                            .frame(width: 50, height: 50)
                            .foregroundColor(.black)
                            
                        VStack(alignment: .leading) {
                            Text("글 제목")
                                .foregroundColor(.black)
                            Text("댓글 내용 블라블라")
                                .multilineTextAlignment(.leading)
                                .lineLimit(2)
                                .foregroundColor(.black)
                            HStack {
                                Text("자유 게시판")
                                    .font(.system(size: 12))
                                    .foregroundColor(Color(UIColor(hexCode: "665E5E")))
                                Text("익명")
                                    .font(.system(size: 12))
                                    .foregroundColor(Color(UIColor(hexCode: "665E5E")))
                                Text("07/25 12:00")
                                    .font(.system(size: 12))
                                    .foregroundColor(Color(UIColor(hexCode: "665E5E")))
                            }
                        }
                        .padding(.horizontal, 10)
                        Spacer()
                    }
                    .padding(.horizontal)
                }
                Spacer()
            }
            .navigationTitle("알림")
            .navigationBarTitleDisplayMode(.inline)
        }
        .navigationBarBackButtonHidden()
    }
}

struct NotificationView_Previews: PreviewProvider {
    static var previews: some View {
        NotificationView()
    }
}
