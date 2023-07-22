//
//  UnivInfoSignUpPage.swift
//  UniMate
//
//  Created by 유석원 on 2023/07/22.
//

import SwiftUI

struct UnivInfoSignUpView: View {
    //    @State var studentID: String = ""
        @State var universityName: String = ""
        
        @Binding var showModal: Bool
        
        @ObservedObject var studentID = NumbersOnly()
        
        var isNextButtonDisabled: Bool {
            // change the condition later
            [studentID.value, universityName].contains(where: \.isEmpty)
        }
        
        var body: some View {
            NavigationView {
                
                VStack(alignment: .leading,spacing: 15) {
                    Spacer()
                    
                    Text("학번 선택")
                        .font(.title)
                        .foregroundColor(.black)
                        .frame(alignment: .leading)
                        .padding(.horizontal)
                    
                    
                    TextField("StudentID",
                              text: $studentID.value,
                              prompt:
                                Text("연도 선택 (학번)").foregroundColor(Color(UIColor(hexCode: "665E5E")))
                    )
                    .multilineTextAlignment(TextAlignment.leading)
                    .keyboardType(.decimalPad)
                    .frame(alignment: .center)
                    .padding(15)
                    .background(Color(UIColor(hexCode: "DCD7D7")))
                    .cornerRadius(20)
                    .padding(.horizontal)
                    
                    
                    Text("학교 선택")
                        .font(.title)
                        .foregroundColor(.black)
                        .frame(alignment: .leading)
                        .padding(.horizontal)

                    
                    TextField("UniversityName",
                              text: $universityName,
                              prompt: Text("학교 이름을 검색하세요.").foregroundColor(Color(UIColor(hexCode: "665E5E")))
                    )
                    .multilineTextAlignment(TextAlignment.leading)
                    .frame(alignment: .center)
                    .padding(15)
                    .background(Color(UIColor(hexCode: "DCD7D7")))
                    .cornerRadius(20)
                    .padding(.horizontal)
                    
                    NavigationLink(destination: UserInfoSignUpView()) {
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
                    
                    
//                    Button {
//                        print("Move to phone number verification")
//                    } label: {
//                        Text("다음")
//                            .foregroundColor(.white)
//                    }
//                    .frame(height: 50)
//                    .frame(maxWidth: .infinity)
//                    .background(
//                        isNextButtonDisabled ?
//                        .gray :
//                        Color(UIColor(hexCode: "5E9AD0"))
//                    )
//                    .cornerRadius(20)
//                    .disabled(isNextButtonDisabled)
//                    .padding(EdgeInsets(top: 10, leading: 15, bottom: 0, trailing: 15))

                    
                    Spacer()
                }
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
