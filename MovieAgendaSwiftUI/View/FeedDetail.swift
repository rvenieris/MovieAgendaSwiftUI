//
//  FeedTitle.swift
//  MovieAgendaSwiftUI
//
//  Created by Ricardo Venieris on 20/10/22.
//

import SwiftUI

struct FeedDetail: View {
    @Binding var item:MDB.Media
    
    var body: some View {
        
        VStack {
            Text("Sinopse".uppercased())
                .font(.headline.bold())
                .foregroundColor(.blue)
            
            Text(item.overview.wrapped)
                .padding(.top,7)
                .padding(.horizontal,20)
                .lineLimit(3)
                .foregroundColor(.gray)
                .multilineTextAlignment(.leading)
                .clipShape(RoundedRectangle(cornerRadius: 10))
        }
        .padding()
    }
}
