//
//  MessagePage.swift
//  UniMate
//
//  Created by 유석원 on 2023/07/22.
//

import SwiftUI

struct MessageView: View {
    var body: some View {
        NavigationView {
            ScrollView {
                NavigationLink(destination: MessageDetailView(sender: Binding.constant("나"), messageContent: Binding.constant("나 지금 배고파"))) {
                    VStack(alignment: .leading) {
                        Text("보낸 쪽지")
                            .foregroundColor(.black)
                        HStack {
                            Image(systemName: "person")
                                .foregroundColor(.black)
                            Text("고려대학교")
                                .foregroundColor(.black)
                            Spacer()
                        }
                        Text("나 지금 되게 배고파")
                            .multilineTextAlignment(.leading)
                            .lineLimit(2)
                            .foregroundColor(.black)
                    }
                    .padding(.horizontal, 5)
                    .border(Color.black, width: 0.2)
                    .background(.white)
                }
                
                NavigationLink(destination: MessageDetailView(sender: Binding.constant("고려대학교"), messageContent: Binding.constant("저랑 태평소 먹으러 가실래요"))) {
                    VStack(alignment: .leading) {
                        Text("받은 쪽지")
                            .foregroundColor(.black)
                        HStack {
                            Image(systemName: "person")
                                .foregroundColor(.black)
                            Text("고려대학교")
                                .foregroundColor(.black)
                            Spacer()
                        }
                        Text("너 지금 뭐하는거야.")
                            .multilineTextAlignment(.leading)
                            .lineLimit(2)
                            .foregroundColor(.black)
                    }
                    .padding(.horizontal, 5)
                    .border(Color.black, width: 0.2)
                    .background(Color(UIColor(hexCode: "9E9E9E")))
                }
                
                
                NavigationLink(destination: MessageDetailView(sender: Binding.constant("한양대학교"), messageContent: Binding.constant("alkdsjflksajdhlfk"))) {
                    VStack(alignment: .leading) {
                        Text("받은 쪽지")
                            .foregroundColor(.black)
                        HStack {
                            Image(systemName: "person")
                                .foregroundColor(.black)
                            Text("한양대학교")
                                .foregroundColor(.black)
                            Spacer()
                        }
                        Text("alkdsjflksajdhlfk")
                            .multilineTextAlignment(.leading)
                            .lineLimit(2)
                            .foregroundColor(.black)
                    }
                    .padding(.horizontal, 5)
                    .border(Color.black, width: 0.2)
                    .background(Color(UIColor(hexCode: "9E9E9E")))
                }
                
                
                Spacer()
            }
            .navigationTitle("쪽지함")
            .navigationBarTitleDisplayMode(.inline)
        }
        .navigationBarBackButtonHidden()
    }
}

struct MessageView_Previews: PreviewProvider {
    static var previews: some View {
        MessageView()
    }
}
