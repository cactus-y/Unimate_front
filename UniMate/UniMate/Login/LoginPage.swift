import SwiftUI
import FirebaseAuth

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
    @State var showPassword: Bool = false
    @State var loginSuccess: Bool = false
    @State var errorMessage: String?
    @State private var isPresented = false
    var isSignInButtonDisabled: Bool {
        [userEmail, password].contains(where: \.isEmpty)
    }
    
    var body: some View {
        NavigationView {
            VStack(alignment: .center, spacing: 15) {
                Spacer()

                Image("unimate_login_logo")
                    .aspectRatio(contentMode: .fit)

                Spacer()

                TextField("Name",
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
                

//                Group {
//                    if showPassword {
//                        TextField("Password",
//                                  text: $password,
//                                  prompt: Text("비밀번호").foregroundColor(Color(UIColor(hexCode: "665E5E")))
//
//                        )
//                    } else {
//
//
//                    }
//                }
                .padding(15)
                .background(Color(UIColor(hexCode: "DCD7D7")))
                .cornerRadius(20)
                .padding(.horizontal)
//                .overlay(
//                    Button {
//                        showPassword.toggle()
//                    } label: {
//                        Image(systemName: showPassword ? "eye.slash" : "eye")
//                            .foregroundColor(.black)
//                    }
//                        .padding(25),
//                    alignment: .trailing
//
//                )
                if let errorMessage = errorMessage {
                                    Text(errorMessage)
                                        .foregroundColor(.red)
                }
                
                Button {
                    print("do login action")
                    login()
                } label: {
                    Text("유니메이트 로그인")
                        .foregroundColor(.white)
                }
                .frame(height: 50)
                .frame(maxWidth: .infinity)
                .background(
                    Color(UIColor(hexCode: "70BBF9"))
                )
                .cornerRadius(20)
                .disabled(isSignInButtonDisabled)
                .padding(EdgeInsets(top: 10, leading: 15, bottom: 0, trailing: 15))

                VStack() {
                    Button (action: {
                        self.isPresented.toggle()
                    }, label: {
                        Text("회원가입")
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
                        Text("비밀번호 찾기")
                            .foregroundColor(Color(UIColor(hexCode: "9F9B9B")))
                    }
                }
                .frame(maxWidth: .infinity)
                .padding(.horizontal)

                Spacer()

                if loginSuccess {
                    NavigationLink(destination: MainTabView(), isActive: self.$loginSuccess, label: {})
                }
            }
        }
    }

    func login() {
        Auth.auth().signIn(withEmail: userEmail, password: password) { authResult, error in
            if let error = error as NSError? {
                switch error.code {
                case AuthErrorCode.wrongPassword.rawValue:
                    errorMessage = "비밀번호가 틀렸습니다."
                case AuthErrorCode.invalidEmail.rawValue:
                    errorMessage = "이메일 형식이 유효하지 않습니다."
                case AuthErrorCode.userNotFound.rawValue:
                    errorMessage = "해당 이메일로 등록된 계정이 없습니다."
                case AuthErrorCode.accountExistsWithDifferentCredential.rawValue:
                    errorMessage = "이 이메일은 이미 다른 인증 수단으로 사용 중입니다."
                default:
                    errorMessage = "알 수 없는 오류가 발생했습니다. 오류: \(error.localizedDescription)"
                }
            } else if authResult?.user != nil {
                loginSuccess = true
                errorMessage =  nil
            } else {
                errorMessage = "로그인에 실패했습니다. 잠시 후 다시 시도해주세요."
            }
        }
    }


    func register() {
        Auth.auth().createUser(withEmail: userEmail, password: password) { result, error in
            if error != nil {
                print(error!.localizedDescription)
            }
        }
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
    }
}
