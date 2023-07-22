import SwiftUI
import Foundation
import FirebaseDatabase

struct UnivInfoSignUpView: View {
    @State var universityName: String = ""
    
    @Binding var showModal: Bool
    
    @ObservedObject var studentID = NumbersOnly()
    
    
    @State private var searchText = ""
    @State private var selectedUniversity = ""
    
    
    var isNextButtonDisabled: Bool {
        [studentID.value, selectedUniversity].contains(where: \.isEmpty)
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 15) {
            NavigationView {
                VStack(alignment: .leading,spacing: 15) {
                    Text("학번 선택")
                        .bold()
                        .font(.title)
                        .foregroundColor(.black)
                        .frame(alignment: .leading)
                        .padding(.horizontal)
                    
                    Picker("연도 선택 (학번)", selection: $studentID.value) {
                        ForEach((02...23).reversed(), id: \.self) { year in
                            Text("\(year)").tag("\(year)")
                        }
                    }
                    .frame(alignment: .center)
                    .padding(15)
                    .background(Color(UIColor(hexCode: "DCD7D7")))
                    .cornerRadius(20)
                    .padding(.horizontal)
                    
                    Text("학교 선택")
                        .bold()
                        .font(.title)
                        .foregroundColor(.black)
                        .frame(alignment: .leading)
                        .padding(.horizontal)
                    VStack{
                        
                        TextField("UniversityName",
                                  text: $selectedUniversity,
                                  prompt: Text("학교 이름을 검색하세요.")
                            .foregroundColor(Color(UIColor(hexCode: "665E5E")))
                        )
                        .onChange(of: selectedUniversity) { newValue in
                            self.searchText = newValue
                        }
                        .onTapGesture {
                            self.searchText = "" // Reset search text when TextField is tapped
                        }
                        .multilineTextAlignment(TextAlignment.leading)
                        .frame(alignment: .center)
                        .padding(15)
                        .background(Color(UIColor(hexCode: "DCD7D7")))
                        .cornerRadius(20)
                        .padding(.horizontal)
                        
                        
                        ScrollView {
                            ForEach(universities.filter({ searchText.isEmpty ? false : $0.contains(searchText) }), id: \.self) { university in
                                Text(university)
                                    .onTapGesture {
                                        self.selectedUniversity = university // Set the selected university when a list item is tapped
                                        self.searchText = university // Update the search text to display the selected university in the list
                                    }
                                    .padding()
                                    .background(Color.white) // Set item background color
                                    .cornerRadius(10)
                            }
                        }
                        .frame(maxHeight: 200) // Set a maximum height for your list
                        .background(Color.white) // Set ScrollView background color
                    }
                    
                    Spacer()
                    
                    NavigationLink(destination: UserInfoSignUpView()) {
                        Text("다음")
                            .foregroundColor(.white)
                            .frame(height: 50)
                            .frame(maxWidth: .infinity)
                            .background(
                                Color(UIColor(hexCode: "70BBF9"))
                            )
                            .cornerRadius(20)
                    }
                    .disabled(isNextButtonDisabled)
                    .padding(EdgeInsets(top: 10, leading: 15, bottom: 0, trailing: 15))
                }
                .padding(10)
                .navigationTitle("회원가입")
                .navigationBarTitleDisplayMode(.inline)
                .toolbar {
                    ToolbarItem(placement: .primaryAction) {
                        Button(action: {
                            self.showModal = false
                        }, label: {
                            Image(systemName: "xmark").foregroundColor(.black)
                        })
                    }
                }
            }
        }
    }
    let ref = Database.database().reference()
    
    func saveTempData(studentID: String, university: String) {
        // Unique key 생성
        let key = ref.child("temporary").childByAutoId().key
        
        // 키를 이용하여 데이터 저장
        ref.child("temporary").child(key!).setValue(["studentID": studentID, "university": university]) { error, _ in
            if let error = error {
                print("Data could not be saved: \(error).")
            } else {
                print("Data saved successfully!")
            }
        }
    }
}
