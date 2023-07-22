//
//  LoginPage.swift
//  UniMate
//
//  Created by 유석원 on 2023/07/21.
//

import SwiftUI

extension UIColor {
    convenience init(hexCode: String, alpha: CGFloat = 1.0) {
        var hexFormatted: String = hexCode.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines).uppercased()
        
        if hexFormatted.hasPrefix("#") {
            hexFormatted = String(hexFormatted.dropFirst())
        }
        
        assert(hexFormatted.count == 6, "Invalid hex code used.")
        
        var rgbValue: UInt64 = 0
        Scanner(string: hexFormatted).scanHexInt64(&rgbValue)
        
        self.init(red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
                  green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
                  blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
                  alpha: alpha
        )
    }
}

struct LoginView: View {
    @State var userEmail: String = ""
    @State var password: String = ""
    @State private var isPresented = false
    var isSignInButtonDisabled: Bool {
        [userEmail, password].contains(where: \.isEmpty)
    }
    
    var body: some View {
        VStack(alignment: .center, spacing: 15) {
            Spacer()
            
            Image("unimate_login_logo")
                .aspectRatio(contentMode: .fit)
            
            Spacer()
            
            TextField("UserEmail",
                      text: $userEmail,
                      prompt: Text("이메일").foregroundColor(Color(UIColor(hexCode: "665E5E")))
            )
            .padding(15)
            .background(Color(UIColor(hexCode: "DCD7D7")))
            .cornerRadius(20)
            .padding(.horizontal)
            
            
            SecureField("Password",
                        text: $password,
                        prompt: Text("비밀번호").foregroundColor(Color(UIColor(hexCode: "665E5E")))
            )
            
//            Group {
//                if showPassword {
//                    TextField("Password",
//                              text: $password,
//                              prompt: Text("비밀번호").foregroundColor(.black)
//
//                    )
//                } else {
//
//
//                }
//
//            }
            .padding(15)
            .background(Color(UIColor(hexCode: "DCD7D7")))
            .cornerRadius(20)
            .padding(.horizontal)
//            .overlay(
//
//                Button {
//                    showPassword.toggle()
//                } label: {
//                    Image(systemName: showPassword ? "eye.slash" : "eye")
//                        .foregroundColor(.black)
//                }
//                    .padding(25),
//                alignment: .trailing
//
//            )
            
            
            Button {
                print("do login action")
            } label: {
                Text("유니메이트 로그인")
                    .foregroundColor(.white)
            }
            .frame(height: 50)
            .frame(maxWidth: .infinity)
            .background(
                isSignInButtonDisabled ?
                .gray :
                Color(UIColor(hexCode: "70BBF9"))
            )
            .cornerRadius(20)
            .disabled(isSignInButtonDisabled)
            .padding(EdgeInsets(top: 10, leading: 15, bottom: 0, trailing: 15))
            
            VStack() {
                Button (action: {
                    self.isPresented.toggle()
                }
                
                , label: {
                    Text("Sign up")
                        .foregroundColor(.black)
                        .sheet(isPresented: $isPresented, onDismiss: {
                            print("Modal dismissed. State: \(self.isPresented)")
                        }, content: {
                            UnivInfoSignUpView(showModal: self.$isPresented)
                        })
                })
                .padding(5)
                
                Button {
                    print("Find id or password")
                } label: {
                    Text("Forgot ID or password?")
                        .foregroundColor(Color(UIColor(hexCode: "9F9B9B")))
                }
            }
            .frame(maxWidth: .infinity)
            .padding(.horizontal)
            
            
            
            Spacer()
            
            
        }
    }
}


struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
    }
}

