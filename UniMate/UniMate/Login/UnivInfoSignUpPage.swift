import SwiftUI
import Foundation
import FirebaseDatabase

struct UnivInfoSignUpView: View {
    @State var universityName: String = ""
    
    @Binding var showModal: Bool
    @State var isActive = false
    
    @ObservedObject var studentID = NumbersOnly()
    
    
    @State private var searchText = ""
    @State var selectedUniversity = ""
    
    
    var isNextButtonDisabled: Bool {
        [selectedUniversity].contains(where: \.isEmpty)
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
                    
                    Button(action: {
                        // saveTempData(studentID: studentID.value, university: selectedUniversity)
                        self.isActive = true
                    }) {
                        Text("다음")
                            .frame(maxWidth: .infinity, minHeight: 50)
                            .background(Color(UIColor(hexCode: "70BBF9")))
                            .foregroundColor(.white)
                            .cornerRadius(20)
                    }

                    .disabled(isNextButtonDisabled)
                    .padding(EdgeInsets(top: 10, leading: 15, bottom: 0, trailing: 15))
                    
                    NavigationLink(destination: UserInfoSignUpView(selectedUniversity: $selectedUniversity, studentID: Binding<String>(
                        get: { self.studentID.value },
                        set: { self.studentID.value = $0 }
                    )), isActive: $isActive) { EmptyView() }
                    
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
        
        
    }
    
}
