//
//  UnivVerificationPage.swift
//  UniMate
//
//  Created by 유석원 on 2023/07/22.
//

import SwiftUI

struct UnivVerificationView: View {
    @Environment(\.dismiss) private var dismiss
    
    @State var userEmail: String = ""
    
    var isEmailButtonDisabled: Bool {
        // change the condition later
        return userEmail.isEmpty
    }
    
    var body: some View {
        NavigationView {
            VStack(alignment: .leading, spacing: 15) {
                
                
                VStack(alignment: .leading, spacing: 10) {
                    Text("대학 이메일 인증하기")
                        .bold()
                        .font(.title)
                        .foregroundColor(.black)
                        .frame(alignment: .leading)
                        .padding(EdgeInsets(top: 30, leading: 0, bottom: 0, trailing: 0))
                        .padding(.horizontal)

                    
                    TextField("UserEmail",
                              text: $userEmail,
                              prompt: Text("이메일을 입력하세요.").foregroundColor(Color(UIColor(hexCode: "665E5E")))
                    )
                    
                    .multilineTextAlignment(TextAlignment.leading)
                    .frame(alignment: .center)
                    .padding(15)
                    .background(Color(UIColor(hexCode: "DCD7D7")))
                    .cornerRadius(20)
                    .padding(EdgeInsets(top: 15, leading: 0, bottom: 15, trailing: 0))
                    .padding(.horizontal)
                    
                    Button {
                        print("Send verification code")
                    } label: {
                        Text("인증 메일 발송하기")
                            .foregroundColor(.white)
                    }
                    .frame(height: 50)
                    .frame(maxWidth: .infinity)
                    .background(
                        Color(UIColor(hexCode: "70BBF9"))
                    )
                    .cornerRadius(20)
                    .disabled(isEmailButtonDisabled)
                    .padding(.horizontal)
                }
                .padding(10)
                
    
                
                VStack(alignment: .leading, spacing: 10) {
                    Text("유의사항")
                        .bold()
                        .font(.title)
                        .foregroundColor(.black)
                        .frame(alignment: .leading)
                        .padding(.horizontal)
                    
                    Text("ac.kr로 끝나는 이메일만 인증 할 수 있습니다.")
                        .padding(5)
                        .foregroundColor(.black)
                        .frame(alignment: .leading)
                        .padding(.horizontal)
                    
                    Text("메일이 도착하지 않는다면 스팸 메일함을 확인해주세요.")
                        .padding(5)
                        .foregroundColor(.black)
                        .multilineTextAlignment(.leading)
                        .padding(.horizontal)
                }
                .padding(10)
                
                
                
                
                
                Spacer()
            }
            .navigationTitle("회원가입")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button {
                        print("go back to user info sign up page")
                        dismiss()
                    } label: {
                        HStack {
                            Image(systemName: "chevron.backward")
    //                        Text("Back")
                        }
                    }
                }
            }
        }
        .navigationBarBackButtonHidden(true)
        
    }
}


struct UnivVerification_Preview: PreviewProvider {
    static var previews: some View {
        UnivVerificationView()
    }
}
