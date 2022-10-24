//
//  FeedTitle.swift
//  MovieAgendaSwiftUI
//
//  Created by Ricardo Venieris on 20/10/22.
//

import SwiftUI

struct FeedTitle: View {
    
    
    var body: some View {
        VStack {
            Image(systemName: "globe")
                .imageScale(.large)
                .foregroundColor(.accentColor)
                .font(.title)
                .fontWeight(.medium)
            Text("Hello, world!")
                .font(.title)
            Text("Valor: ")
                .font(.title)
                .fontWeight(.heavy)
                .foregroundColor(Color.blue)
                .multilineTextAlignment(.center)
            
        }
        .padding()
    }
}
