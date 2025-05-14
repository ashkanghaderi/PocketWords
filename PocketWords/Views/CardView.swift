//
//  CardView.swift
//  PocketWords
//
//  Created by Ashkan Ghaderi on 2/24/1404 AP.
//

import SwiftUI

struct CardView: View {
    let card: WordCard
        @State private var flipped = false

        var body: some View {
            ZStack {
                RoundedRectangle(cornerRadius: 16)
                    .fill(flipped ? Color.blue : Color.white)
                    .shadow(radius: 8)
                    .frame(width: 300, height: 200)

                VStack {
                    if flipped {
                        Text(card.meaning)
                            .font(.title)
                            .foregroundColor(.white)
                            .rotation3DEffect(
                                .degrees(180),
                                axis: (x: 0.0, y: 1.0, z: 0.0)
                            )
                    } else {
                        Text(card.word)
                            .font(.largeTitle)
                            .foregroundColor(.black)
                    }
                }
            }
            .rotation3DEffect(
                .degrees(flipped ? 180 : 0),
                axis: (x: 0.0, y: 1.0, z: 0.0)
            )
            .animation(.default, value: flipped)
            .onTapGesture {
                flipped.toggle()
            }
        }
}
