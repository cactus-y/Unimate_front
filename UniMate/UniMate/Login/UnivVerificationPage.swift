//
//  UnivVerificationPage.swift
//  UniMate
//
//  Created by 유석원 on 2023/07/22.
//

import SwiftUI
import Foundation
import FirebaseAuth
import FirebaseDatabase
import UIKit

struct UnivVerificationView: View {
    @Environment(\.dismiss) private var dismiss
    
    @State var userEmail: String = ""
    @State var showAlert: Bool = false
    @Binding var password: String
    @Binding var selectedUniversity: String
    @Binding var studentID: String
    @Binding var userNickname: String
    @State private var message = ""
    
    
    var isEmailButtonDisabled: Bool {
        // change the condition later
        return userEmail.isEmpty || !isValidEmail(userEmail)
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
                    
                    
                    Button(action: {
                        if isValidEmail(userEmail){
                            register()
                        }
                        else{
                            showAlert = true
                        }
                    }) {
                        Text("인증 메일 발송하기")
                            .frame(maxWidth: .infinity, minHeight: 50)
                            .background(Color(UIColor(hexCode: "70BBF9")))
                            .foregroundColor(.white)
                            .cornerRadius(20)
                    }
                    .padding(.horizontal)
                    .alert(isPresented: $showAlert) {
                        Alert(title: Text("오류"), message: Text("올바르지 않은 이메일입니다."), dismissButton: .default(Text("확인")))
                    }

                    .alert(isPresented: $showAlert) { // Alert를 표시합니다.
                        Alert(title: Text("오류"), message: Text("올바르지 않은 이메일입니다.\n 교육용 이메일을 입력해주세요."), dismissButton: .default(Text("확인")))
                    }
                    Text(message)
                        .foregroundColor(.red)
                        .padding()
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
                    
                    Text("메일이 도착하지 않는다면 스팸 메일함을 \n확인해주세요.")
                        .padding(5)
                        .foregroundColor(.black)
                        .multilineTextAlignment(.leading)
                        .fixedSize(horizontal: false, vertical: true)
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
    func isValidEmail(_ email: String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@([A-Za-z0-9.-]+\\.[A-Za-z]{2,64})"
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        if emailTest.evaluate(with: email) {
            let domain = email.components(separatedBy: "@")[1]
            return allowedDomains.contains(domain) // allowedDomains를 사용합니다.
        }
        return false
    }
    func register() {
        Auth.auth().createUser(withEmail: userEmail, password: password) { authResult, error in
            if let error = error as NSError? {
                if error.domain == AuthErrorDomain {
                    switch error.code {
                    case AuthErrorCode.operationNotAllowed.rawValue:
                        // Indicates that email and password accounts are not enabled.
                        self.message = "계정이 활성화되지 않았습니다."
                    case AuthErrorCode.emailAlreadyInUse.rawValue:
                        // The email address is already in use by another account.
                        self.message = "다른 계정에서 사용 중입니다."
                    case AuthErrorCode.invalidEmail.rawValue:
                        // The email address is badly formatted.
                        self.message = "이메일 주소 형식이 잘못되었습니다."
                    case AuthErrorCode.weakPassword.rawValue:
                        // The password must be 6 characters long or more.
                        self.message = "비밀번호는 6자 이상이어야 합니다."
                    default:
                        // Another error occurred.
                        self.message = "오류가 발생했습니다: \(error.localizedDescription)"
                    }
                } else {
                    self.message = "오류가 발생했습니다: \(error.localizedDescription)"
                }
                return
            }

            if let authResult = authResult {
                authResult.user.sendEmailVerification { error in
                    if let error = error {
                        self.message = "오류가 발생했습니다: \(error)"
                        return
                    }
                    // 이메일 확인 메시지가 성공적으로 전송되었습니다.
                    self.message = "이메일 확인 메시지가 전송되었습니다."
                    
                    let db = Database.database(url: "https://unimate-16065-default-rtdb.asia-southeast1.firebasedatabase.app").reference()

                    // Data to be stored
                    let userData: [String: Any] = [
                        "university": self.selectedUniversity,
                        "studentId": self.studentID,
                        "nickname": self.userNickname
                    ]

                    db.child("users").child(authResult.user.uid).setValue(userData) { error, _ in
                        if let error = error {
                            print("Data could not be saved: \(error).")
                        } else {
                            print("Data saved successfully!")
                        }
                    }
                }
            }
        }
    }

    
    
    struct UnivVerification_Preview: PreviewProvider {
        static var previews: some View {
            UnivVerificationView(password: .constant(""),selectedUniversity: .constant(""),studentID: .constant(""),userNickname: .constant(""))
        }
    }
}
