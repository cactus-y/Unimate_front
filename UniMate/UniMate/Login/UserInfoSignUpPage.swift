//
//  UserInfoSignUpPage.swift
//  UniMate
//
//  Created by 유석원 on 2023/07/22.
//

import SwiftUI

struct UserInfoSignUpView: View {
    @Environment(\.dismiss) private var dismiss
    
    @State var userNickname: String = ""
    @State var password: String = ""
    @State var passwordVerification: String = ""
    @State private var isNextPagePresented: Bool = false
    
    var isNextButtonDisabled: Bool {
        if userNickname.isEmpty || password.isEmpty {
            return true
        }
        
        return password != passwordVerification
    }
    
    var body: some View {
        NavigationView {
            VStack(alignment: .leading,spacing: 15) {
                Spacer()
                Text("닉네임")
                    .font(.title)
                    .foregroundColor(.black)
                    .frame(alignment: .leading)
                    .padding(.horizontal)
                
                TextField("UserName",
                          text: $userNickname,
                          prompt: Text("닉네임을 입력하세요.").foregroundColor(Color(UIColor(hexCode: "665E5E")))
                )
                .multilineTextAlignment(TextAlignment.leading)
                .frame(alignment: .center)
                .padding(15)
                .background(Color(UIColor(hexCode: "DCD7D7")))
                .cornerRadius(20)
                .padding(.horizontal)
                
                Text("비밀번호")
                    .font(.title)
                    .foregroundColor(.black)
                    .frame(alignment: .leading)
                    .padding(.horizontal)
                
                SecureField("Password",
                            text: $password,
                            prompt: Text("비밀번호를 입력하세요.").foregroundColor(Color(UIColor(hexCode: "665E5E")))
                )
                .multilineTextAlignment(TextAlignment.leading)
                .frame(alignment: .center)
                .padding(15)
                .background(Color(UIColor(hexCode: "DCD7D7")))
                .cornerRadius(20)
                .padding(.horizontal)
                
                Text("비밀번호 확인")
                    .font(.title)
                    .foregroundColor(.black)
                    .frame(alignment: .leading)
                    .padding(.horizontal)
    
                SecureField("PasswordVerification",
                            text: $passwordVerification,
                            prompt: Text("비밀번호를 입력하세요.").foregroundColor(Color(UIColor(hexCode: "665E5E")))
                )
                .multilineTextAlignment(TextAlignment.leading)
                .frame(alignment: .center)
                .padding(15)
                .background(Color(UIColor(hexCode: "DCD7D7")))
                .cornerRadius(20)
                .padding(.horizontal)
                
                NavigationLink(destination: UnivVerificationView()) {
                    Text("다음")
                        .foregroundColor(.white)
                }
                .frame(height: 50)
                .frame(maxWidth: .infinity)
                .background(
                    isNextButtonDisabled ?
                    .gray :
                    Color(UIColor(hexCode: "70BBF9"))
                )
                .cornerRadius(20)
                .disabled(isNextButtonDisabled)
                .padding(EdgeInsets(top: 10, leading: 15, bottom: 0, trailing: 15))
                
                
                Spacer()
            }
        }
        .navigationBarBackButtonHidden(true)
        .navigationTitle("회원가입")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button {
                    print("go back to univ info sign up page")
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
}
