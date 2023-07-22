import SwiftUI
import Firebase
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
    @State var name: String = ""
    @State var password: String = ""
    @State var showPassword: Bool = false
    @State var loginSuccess: Bool = false
    @State var errorMessage: String?

    var isSignInButtonDisabled: Bool {
        [name, password].contains(where: \.isEmpty)
    }
    
    var body: some View {
        NavigationView {
            VStack(alignment: .center, spacing: 15) {
                Spacer()

                Image("unimate_login_logo")
                    .aspectRatio(contentMode: .fit)

                Spacer()

                TextField("Name",
                          text: $name,
                          prompt: Text("아이디").foregroundColor(.black)
                )
                .padding(15)
                .background(Color(UIColor(hexCode: "DCD7D7")))
                .cornerRadius(20)
                .padding(.horizontal)

                Group {
                    if showPassword {
                        TextField("Password",
                                  text: $password,
                                  prompt: Text("비밀번호").foregroundColor(.black)

                        )
                    } else {
                        SecureField("Password",
                                    text: $password,
                                    prompt: Text("비밀번호").foregroundColor(.black)
                        )

                    }
                }
                .padding(15)
                .background(Color(UIColor(hexCode: "DCD7D7")))
                .cornerRadius(20)
                .padding(.horizontal)
                .overlay(
                    Button {
                        showPassword.toggle()
                    } label: {
                        Image(systemName: showPassword ? "eye.slash" : "eye")
                            .foregroundColor(.black)
                    }
                        .padding(25),
                    alignment: .trailing

                )
                
                Button {
                    login()
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
                    Color(UIColor(hexCode: "5E9AD0"))
                )
                .cornerRadius(20)
                .disabled(isSignInButtonDisabled)
                .padding(EdgeInsets(top: 10, leading: 15, bottom: 0, trailing: 15))

                VStack() {
                    Button {
                        register()
                        print("Move to sign up page")
                    } label: {
                        Text("Sign up")
                            .foregroundColor(.black)
                    }
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

                if loginSuccess {
                    NavigationLink(destination: NextView(), isActive: $loginSuccess) {
                        EmptyView()
                    }
                }
            }
        }
    }

    func login() {
        Auth.auth().signIn(withEmail: name, password: password) { result, error in
            if result != nil {
                loginSuccess = true
            } else {
                print(error.debugDescription)
            }
        }
    }

    func register() {
        Auth.auth().createUser(withEmail: name, password: password) { result, error in
            if error != nil {
                print(error!.localizedDescription)
            }
        }
    }
}

struct NextView: View {
    var body: some View {
        Text("This is the next view after login.")
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
    }
}
