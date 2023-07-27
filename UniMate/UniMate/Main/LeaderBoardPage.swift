import SwiftUI
import FirebaseDatabase

struct University: Identifiable {
    var id = UUID()
    var name: String
    var likesCount: Int
}

struct LeaderBoardView: View {
    @State var universities = [
        University(name: "고려대", likesCount: 0),
        University(name: "KAIST", likesCount: 0),
        University(name: "POSTECH", likesCount: 0),
        University(name: "GIST", likesCount: 0),
        University(name: "한양대", likesCount: 0),
        University(name: "성균관대", likesCount: 0),
        University(name: "숙명여대", likesCount: 0),
        
    ]
    let ref = Database.database(url: "https://unimate-16065-default-rtdb.asia-southeast1.firebasedatabase.app").reference()

    var body: some View {
        NavigationView {
            ScrollView {
                VStack(alignment: .leading) {
                    ForEach(universities.sorted(by: { $0.likesCount > $1.likesCount }).indices, id: \.self) { index in
                        let university = universities.sorted(by: { $0.likesCount > $1.likesCount })[index]
                        UniversityView(rank: index + 1, university: self.$universities[self.getIndex(of: university.name)!])
                    }
                }
                .navigationTitle("학교 순위")
                .navigationBarTitleDisplayMode(.inline)
            }
        }
        .onAppear(perform: getLikesFromFirebase)
    }
    
    private func getIndex(of name: String) -> Int? {
        universities.firstIndex(where: { $0.name == name })
    }
    
    private func getLikesFromFirebase() {
        self.ref.child("universities").observe(.value, with: { (snapshot) in
            for child in snapshot.children.allObjects as! [DataSnapshot] {
                if let dictionary = child.value as? [String: AnyObject] {
                    let name = child.key
                    if let likesCount = dictionary["likesCount"] as? Int, let universityIndex = self.getIndex(of: name) {
                        universities[universityIndex].likesCount = likesCount
                    }
                }
            }
        })
    }
}

struct UniversityView: View {
    var rank: Int
    @Binding var university: University
    let ref = Database.database(url: "https://unimate-16065-default-rtdb.asia-southeast1.firebasedatabase.app").reference()

    var body: some View {
        HStack {
            Text("\(rank)")
                .font(.largeTitle)
                .fontWeight(.bold)
                .frame(width: 60, alignment: .center)

            Spacer()

            Image(university.name)
                .resizable()
                .scaledToFit()
                .frame(width: 100, height: 100)

            Spacer()

            VStack {
                Button(action: {
                    university.likesCount += 1
                    updateLikesInFirebase()
                }) {
                    Image(systemName: "heart")
                        .resizable()
                        .frame(width: 35, height: 35)
                        .foregroundColor(.red)
                }

                Text("\(university.likesCount)")
                    .frame(width: 100, alignment: .center)
            }
        }
        .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity)
        .background(Color(.secondarySystemBackground))
        .cornerRadius(10)
        .padding(.horizontal)
        .frame(width: 360,height: 110)
    }
    
    private func updateLikesInFirebase() {
        self.ref.child("universities").child(university.name).setValue(["likesCount": university.likesCount])
    }
}

struct LeaderBoardView_Previews: PreviewProvider {
    static var previews: some View {
        LeaderBoardView()
    }
}
