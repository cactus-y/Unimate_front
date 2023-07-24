import SwiftUI

struct LeaderBoardView: View {
    public let RankUniversity = [
        "고려대",
        "KAIST",
        "POSTECH",
        "GIST",
        "한양대",
        "성균관대",
        "숙명여대"
    ]
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(alignment: .leading) {
                    ForEach(RankUniversity.indices, id: \.self) { index in
                        UniversityView(rank: index + 1, universityName: RankUniversity[index])
                    }
                }
                .navigationTitle("학교 순위")
            }
        }
    }
}

struct UniversityView: View {
    var rank: Int
    var universityName: String

    // State for likes counter
    @State private var likesCount = 0

    var body: some View {
        HStack {
            Text("\(rank)")
                .font(.largeTitle)
                .fontWeight(.bold)
                .frame(width: 60, alignment: .center) // Set a fixed frame and center alignment

            Spacer() // Provide some space

            Image(universityName)
                .resizable()
                .scaledToFit()
                .frame(width: 100, height: 100)

            Spacer() // Provide some space

            VStack {
                Button(action: {
                    likesCount += 1
                }) {
                    Image(systemName: "heart") // Using SF Symbols for a heart icon
                        .resizable()
                        .frame(width: 35, height: 35)
                        .foregroundColor(.red) // Color the heart icon red
                }

                Text("\(likesCount)")
                    .frame(width: 100, alignment: .center) // Set a fixed frame and center alignment
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
        ContentView()
    }
}
