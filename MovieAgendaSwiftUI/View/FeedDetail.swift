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
            FeedCover(url: item.posterURL, title: item.wrappedTitle).padding(.bottom)
            
            Text("Sinopse".uppercased())
                .font(.headline.bold())
                .foregroundColor(.blue)
            
        ScrollView {
            Text(item.overview.wrapped)
                .padding(.top,7)
                .padding(.horizontal,20)
                .lineLimit(.max)
                .foregroundColor(.gray)
                .multilineTextAlignment(.leading)
                .clipShape(RoundedRectangle(cornerRadius: 10))
        }
            Spacer()
        }
        .padding()
    }
}

struct FeedFeedDetail_Previews: PreviewProvider {
    @State static var item:MDB.Media = localMovieList[0]
    static var previews: some View {
        FeedDetail(item: $item)
    }
}
