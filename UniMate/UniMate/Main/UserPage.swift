import SwiftUI
import Firebase
import UIKit

struct UserView: View {
    @State private var userID: String = ""
    @State private var email: String = ""
    @State private var nickname: String = ""
    @State private var studentId: String = ""
    @State private var university: String = ""
    
    @State private var showingImagePicker = false
    @State private var inputImage: UIImage?
    @State private var image: Image?

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
            }
        }
    }

    func loadImage() {
        guard let inputImage = inputImage else { return }
        image = Image(uiImage: inputImage)
        // 이 시점에서 inputImage를 Firebase에 업로드하면 됩니다.
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
