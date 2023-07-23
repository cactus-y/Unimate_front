//
//  UserInfoSignUpPage.swift
//  UniMate
//
//  Created by 유석원 on 2023/07/22.
//

import SwiftUI
import FirebaseDatabase

struct UserInfoSignUpView: View {
    @Environment(\.dismiss) private var dismiss
    
    @State var userNickname: String = ""
    @State var password: String = ""
    @State var passwordVerification: String = ""
    @State var showPasswordMismatchWarning: Bool = false
    @State var shakeButton: Bool = false
    @State private var passwordWarning: String? = nil
    
    var isNextButtonDisabled: Bool {
        if userNickname.isEmpty || password.isEmpty {
            return true
        }
        
        return password != passwordVerification
    }
    
    var body: some View {
        
        NavigationView {
            VStack(alignment: .leading,spacing: 15) {
                
                Text("닉네임")
                    .bold()
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
                    .bold()
                    .font(.title)
                    .foregroundColor(.black)
                    .frame(alignment: .leading)
                    .padding(.horizontal)
                
                SecureField("Password",
                            text: $password,
                            prompt: Text("비밀번호를 입력하세요.").foregroundColor(Color(UIColor(hexCode: "665E5E")))
                )
                .onChange(of: password) { newValue in
                    if newValue.count < 6 {
                        passwordWarning = "6자리 이상 입력해주세요"
                    } else {
                        passwordWarning = nil
                    }
                }
                .multilineTextAlignment(TextAlignment.leading)
                .frame(alignment: .center)
                .padding(15)
                .background(Color(UIColor(hexCode: "DCD7D7")))
                .cornerRadius(20)
                .padding(.horizontal)
                if let passwordWarning = passwordWarning {
                    Text(passwordWarning)
                        .foregroundColor(.red)
                        .padding(.horizontal)
                }
                Text("비밀번호 확인")
                    .bold()
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
                
                if showPasswordMismatchWarning {
                    Text("비밀번호 값이 일치하지 않습니다")
                        .foregroundColor(.red) // Change color to red
                        .padding()
                }
                
                
                NavigationLink(destination: UnivVerificationView(password:$password)) {

                    Text("다음")
                        .foregroundColor(.white)
                }
                .frame(height: 50)
                .frame(maxWidth: .infinity)
                .background(
                    Color(UIColor(hexCode: "70BBF9"))
                )
                .cornerRadius(20)
                .disabled(isNextButtonDisabled)
                .modifier(Shake(animatableData: CGFloat(shakeButton ? 0 : 1))) // Add this
                .onTapGesture {
                    if isNextButtonDisabled {
                        showPasswordMismatchWarning = true
                        withAnimation(.default) {
                            shakeButton.toggle()
                        }
                    }
                }
                .padding(EdgeInsets(top: 10, leading: 15, bottom: 0, trailing: 15))
                

                Spacer()
            }
            .padding(10)
            
            .navigationTitle("회원가입")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {

                //                ToolbarItem(placement: .cancellationAction) {
                //                    Button {
                //                        print("go back to univ info sign up page")
                //                        dismiss()
                //                    } label: {
                //                        HStack {
                //                            Image(systemName: "chevron.backward")
                //                            //                        Text("Back")
                //                        }
                //                    }
                //                }
                //            }
                
            }
            
        }
        .navigationBarBackButtonHidden(true)
    }
    
    struct Shake: GeometryEffect {
        var amount: CGFloat = 10
        var shakesPerUnit: CGFloat = 3
        var animatableData: CGFloat
        
        func effectValue(size: CGSize) -> ProjectionTransform {
            ProjectionTransform(CGAffineTransform(translationX: amount * sin(animatableData * .pi * shakesPerUnit), y: 0))
        }
    }
    
    struct UserInfo_Preview: PreviewProvider {
        static var previews: some View {
            UserInfoSignUpView()
        }

    }
}
