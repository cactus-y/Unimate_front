//
//  MessageDetailPage.swift
//  UniMate
//
//  Created by 유석원 on 2023/07/25.
//

import SwiftUI

struct MessageDetailView: View {
    @Environment(\.dismiss) private var dismiss
    
    @Binding var sender: String
    @Binding var messageContent: String
    
    
    var body: some View {
        NavigationView {
            VStack(alignment: .leading) {
                HStack {
                    Text(messageContent)
                        .padding(.horizontal)
                        .multilineTextAlignment(.leading)
                    Spacer()
                }
                
                Spacer()
            }
            .navigationTitle(sender)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    NavigationLink(destination: MessageCreateView()) {
                        Image(systemName: "pencil.line")
                    }
                }
                
                ToolbarItem(placement: .navigationBarLeading) {
                    Button {
                        dismiss()
                    } label: {
                        Image(systemName: "xmark")
                    }
                }
            }
        }
        .navigationBarBackButtonHidden()
    }
}

struct MessageDetailView_Previews: PreviewProvider {
    static var previews: some View {
        MessageDetailView(sender: Binding.constant("고려대학교"), messageContent: Binding.constant("Test content"))
    }
}
