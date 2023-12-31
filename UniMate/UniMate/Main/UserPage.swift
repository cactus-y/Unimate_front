import SwiftUI
import Firebase
import FirebaseDatabase
import FirebaseDatabaseSwift
import FirebaseStorage
import UIKit

struct UserView: View {
    @EnvironmentObject var appStateManager: AppStateManager
    
    @State private var userID: String = ""
    @State private var email: String = ""
    @State private var nickname: String = ""
    @State private var studentId: String = ""
    @State private var university: String = ""
    
    @State private var showingImagePicker = false
    @State private var inputImage: UIImage?
    @State private var image: Image?
    @State var isLogoutSuccess: Bool = false

    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 20) {
                    Image(uiImage: self.inputImage ?? UIImage(systemName: "person.circle.fill")!)
                        .resizable()
                        .frame(width: 200, height: 200)
                        .clipShape(Circle())
                        .overlay(Circle().stroke(Color.blue, lineWidth: 3))
                        .shadow(radius: 10)
                    .onTapGesture {
                        self.showingImagePicker = true
                    }
                    .padding()

                    UserDetailView(title: "이메일", detail: $email)
                    UserDetailView(title: "닉네임", detail: $nickname)
                    UserDetailView(title: "학번", detail: $studentId)
                    UserDetailView(title: "대학교", detail: $university)
                    
                    
                    
                }
                .padding()
                .onAppear {
                    loadUserData()
                }
                .sheet(isPresented: $showingImagePicker, onDismiss: loadImage) {
                    ImagePicker(image: self.$inputImage)
                }
                .navigationTitle("내 정보")
                .navigationBarTitleDisplayMode(.inline)
                .toolbar {
                    ToolbarItem(placement: .navigationBarTrailing) {
                        Button {
                            logout()
                        } label: {
                            Text("로그아웃")
                            
                        }
                        .onChange(of: appStateManager.isLoggedIn) { newValue in
                            if !newValue {
                                NavigationLink(destination:
                                                LoginView().environmentObject(appStateManager),
                                               isActive: .constant(true),
                                               label: {}
                                )
                            }
                            
                        }
                    }
                }
            }
        }
    }
    func uploadImage() {
        guard let inputImage = inputImage else { return }
        
        // Convert the UIImage to Data
        guard let imageData = inputImage.jpegData(compressionQuality: 0.5) else { return }

        // Create a storage reference
        let storageRef = Storage.storage().reference().child("userImages/\(self.userID).jpg")

        // Upload the image to Firebase Storage
        storageRef.putData(imageData, metadata: nil) { (_, error) in
            if let error = error {
                print("Error uploading image: \(error)")
                return
            }

            // Once the image is uploaded, get the download URL
            storageRef.downloadURL { (url, error) in
                if let error = error {
                    print("Error getting download URL: \(error)")
                    return
                }
                guard let url = url else {
                    print("URL is nil")
                    return
                }

                // Save the download URL to Firebase Database
                let db = Database.database(url: "https://unimate-16065-default-rtdb.asia-southeast1.firebasedatabase.app").reference().child("users").child(self.userID)
                db.updateChildValues(["imageURL": url.absoluteString]) { (error, _) in
                    if let error = error {
                        print("Error updating values in database: \(error)")
                    }
                }
            }
        }
    }

    func loadImage() {
        guard let inputImage = inputImage else { return }
        image = Image(uiImage: inputImage)
        uploadImage()
    }

    func loadUserData() {
        if let user = Auth.auth().currentUser {
            self.userID = user.uid
            self.email = user.email ?? ""
            
            let db = Database.database(url: "https://unimate-16065-default-rtdb.asia-southeast1.firebasedatabase.app").reference().child("users").child(self.userID)

            db.child("nickname").observeSingleEvent(of: .value) { snapshot in
                self.nickname = snapshot.value as? String ?? ""
            }

            db.child("studentId").observeSingleEvent(of: .value) { snapshot in
                self.studentId = snapshot.value as? String ?? ""
            }

            db.child("university").observeSingleEvent(of: .value) { snapshot in
                self.university = snapshot.value as? String ?? ""
            }
            
            // Load image URL
            db.child("imageURL").observeSingleEvent(of: .value) { snapshot in
                if let imageUrl = snapshot.value as? String {
                    // Assuming you have Kingfisher installed
                    let url = URL(string: imageUrl)
                    let data = try? Data(contentsOf: url!)
                    self.inputImage = UIImage(data: data!)
                }
            }
        }
    }

    
    func logout() {
//        Auth.auth().currentUser = nil
        try? Auth.auth().signOut()
        if Auth.auth().currentUser == nil {
            appStateManager.isLoggedIn = false
        }
    }
}

struct ImagePicker: UIViewControllerRepresentable {
    @Binding var image: UIImage?
    @Environment(\.presentationMode) var presentationMode

    func makeUIViewController(context: UIViewControllerRepresentableContext<ImagePicker>) -> UIImagePickerController {
        let picker = UIImagePickerController()
        picker.delegate = context.coordinator
        return picker
    }

    func updateUIViewController(_ uiViewController: UIImagePickerController, context: UIViewControllerRepresentableContext<ImagePicker>) {}

    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    class Coordinator: NSObject, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
        var parent: ImagePicker

        init(_ parent: ImagePicker) {
            self.parent = parent
        }

        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            if let uiImage = info[.originalImage] as? UIImage {
                parent.image = uiImage
            }

            parent.presentationMode.wrappedValue.dismiss()
        }
    }
}

struct UserDetailView: View {
    var title: String
    @Binding var detail: String

    var body: some View {
        VStack(alignment: .center, spacing: 10) {
            Text(title)
                .font(.headline)
            Text(detail)
        }
        .padding()
        .frame(width: 300)
        .background(Color(.secondarySystemBackground))
        .cornerRadius(10)
        .shadow(radius: 5)
    }
}

struct UserView_Previews: PreviewProvider {
    static var previews: some View {
        UserView()
    }
}
