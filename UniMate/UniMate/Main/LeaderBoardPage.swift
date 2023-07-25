import SwiftUI

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
        University(name: "숙명여대", likesCount: 0)
    ]

    var body: some View {
        NavigationView {
            ScrollView {
                VStack(alignment: .leading) {
                    ForEach(universities.sorted(by: { $0.likesCount > $1.likesCount }).indices, id: \.self) { index in
                        let university = universities.sorted(by: { $0.likesCount > $1.likesCount })[index]
                        UniversityView(rank: index + 1, university: self.$universities[self.getIndex(of: university)])
                    }
                }
                .navigationTitle("학교 순위")
            }
        }
    }
    
    private func getIndex(of university: University) -> Int {
        guard let index = universities.firstIndex(where: { $0.id == university.id }) else {
            fatalError("Index is out of range.")
        }
        return index
    }
}

struct UniversityView: View {
    var rank: Int
    @Binding var university: University

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
}

struct LeaderBoardView_Previews: PreviewProvider {
    static var previews: some View {
        LeaderBoardView()
    }
}
