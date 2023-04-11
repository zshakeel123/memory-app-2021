//
//  ContentView.swift
//  MemorizeApp
//
//  Created by Zeeshan Shakeel on 4/7/23.
//

import SwiftUI

struct EmojiMemoryGameView: View {
    @ObservedObject var gameViewModel: EmojiMemoryGameVM
    
    var body: some View {
        AspectVGrid(items: gameViewModel.cards, aspectRatio: 2/3) { card in
            cardView(for: card)
        }
        .foregroundColor(.red)
        .padding(.horizontal)
    }
    
    @ViewBuilder
    private func cardView(for card: MemoryGameModel<String>.Card) -> some View {
        if card.isMatched && !card.isFaceUp {
            Rectangle().opacity(0.5)
        } else {
            CardView(card: card)
                .padding(4)
                .onTapGesture {
                    gameViewModel.choose(card)
                }
        }
    }
}

struct CardView: View {
    let card: MemoryGameModel<String>.Card
        
    var body: some View {
        
        GeometryReader { geometry in
            ZStack {
                let shape = RoundedRectangle(cornerRadius: DrawingConstants.cornerRadius)
                if card.isFaceUp {
                    shape.fill().foregroundColor(.white)
                    shape.strokeBorder(lineWidth: DrawingConstants.lineWidth)
                    Text(card.content).font(font(geometry.size))
                } else if card.isMatched {
                    shape.opacity(0.5)
                } else {
                    shape.fill()
                }
            }
        }
    }
    
    private func font(_ size: CGSize) -> Font {
        return Font.system(size: min(size.width, size.height) * DrawingConstants.fontScale)
    }
}

private struct DrawingConstants {
    static let cornerRadius: CGFloat = 10.0
    static let lineWidth: CGFloat = 3.0
    static let fontScale: CGFloat = 0.75
}




struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        let game = EmojiMemoryGameVM()
        EmojiMemoryGameView(gameViewModel: game)
    }
}
