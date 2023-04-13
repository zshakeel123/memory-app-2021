//
//  ContentView.swift
//  MemorizeApp
//
//  Created by Zeeshan Shakeel on 4/7/23.
//

import SwiftUI

struct EmojiMemoryGameView: View {
    @ObservedObject var gameViewModel: EmojiMemoryGameVM
    
    @Namespace private var dealingNameSpace
    
    @State private var dealt = Set<Int>()
    
    var body: some View {
        ZStack (alignment: .center){
            VStack {
                gameBody
                HStack {
                    shuffle
                    Spacer()
                    restart
                }
                .padding(.horizontal)
            }
            deckBody
        }
        .padding()
    }
    
    private func deal(_ card: MemoryGameModel<String>.Card) {
        dealt.insert(card.id)
    }
    
    private func isUnDealt(_ card: MemoryGameModel<String>.Card) -> Bool {
        !dealt.contains(card.id)
    }
    
    private func dealAnimation(for card: MemoryGameModel<String>.Card) -> Animation {
        var delay = 0.0
        if let index = gameViewModel.cards.firstIndex(where: { $0.id == card.id }) {
            delay = Double(index) * (CardConstants.totalDealDuration / Double(gameViewModel.cards.count))
        }
        return Animation.easeOut(duration: CardConstants.dealDuration).delay(delay)
    }
    
    private func zIndex(of card: MemoryGameModel<String>.Card) -> Double {
        return -Double(gameViewModel.cards.firstIndex(where: { $0.id  == card.id}) ?? 0)
    }
        
    var gameBody: some View {
        AspectVGrid(items: gameViewModel.cards, aspectRatio: 2/3) { card in
            cardView(for: card)
        }
        .foregroundColor(CardConstants.color)
    }
    
    @ViewBuilder
    private func cardView(for card: MemoryGameModel<String>.Card) -> some View {
        if isUnDealt(card) || (card.isMatched && !card.isFaceUp) {
            //Rectangle().opacity(0.5)
            Color.clear
        } else {
            CardView(card:  card)
                .matchedGeometryEffect(id: card.id, in: dealingNameSpace)
                .padding(4)
                .transition(AnyTransition.asymmetric(insertion: .identity, removal: .opacity))
                .zIndex(zIndex(of: card))
                .onTapGesture {
                    withAnimation {
                        gameViewModel.choose(card)
                    }
                }
        }
    }
    
    var deckBody: some View {
        ZStack {
            ForEach (gameViewModel.cards.filter(isUnDealt)) { card in
                CardView(card: card)
                    .matchedGeometryEffect(id: card.id, in: dealingNameSpace)
                    .transition(AnyTransition.asymmetric(insertion: .opacity, removal: .identity))
                    .zIndex(zIndex(of: card))
            }
        }
        .frame(width: CardConstants.undealtWidth, height: CardConstants.undealtWidth)
        .foregroundColor(CardConstants.color)
        .onTapGesture {
            for card in gameViewModel.cards {
                withAnimation(dealAnimation(for: card)) {
                    deal(card)
                }
            }
        }
    }
    
    var shuffle: some View {
        Button("Shuffle") {
            withAnimation {
                gameViewModel.shuffle()
            }
        }
    }
    
    var restart: some View {
        Button("Restart") {
            withAnimation {
                dealt = []
                gameViewModel.restart()
            }
        }
    }
    
    private struct CardConstants {
        static let color = Color.green
        static let aspectRatio: CGFloat = 2/3
        static let dealDuration: Double = 0.5
        static let totalDealDuration: Double = 2
        static let unDealtHeight: CGFloat = 90
        static let undealtWidth = unDealtHeight * aspectRatio
    }
}

struct CardView: View {
    let card: MemoryGameModel<String>.Card
        
    var body: some View {
        
        GeometryReader { geometry in
            ZStack {
                Pie(
                    startAngle: Angle(degrees: 0-90),
                    endAngle: Angle(degrees: 110-90)).padding(5).opacity(0.5)
                Text(card.content)
                    .rotationEffect(Angle.degrees(card.isMatched ? 360 : 0))
                    .animation(Animation.linear(duration: 1).repeatForever(autoreverses: false))
                    .font(Font.system(size: DrawingConstants.fontSize))
                    .scaleEffect(scale(thatFits: geometry.size))
            }
            .cardify(isFaceUp: card.isFaceUp)
        }
    }
    
    private func scale(thatFits size: CGSize) -> CGFloat {
        min(size.width, size.height) / (DrawingConstants.fontSize / DrawingConstants.fontScale)
    }
    
    private func font(_ size: CGSize) -> Font {
        return Font.system(size: min(size.width, size.height) * DrawingConstants.fontScale)
    }
}

private struct DrawingConstants {
    static let fontScale: CGFloat = 0.5
    static let fontSize: CGFloat = 32
}




struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        let game = EmojiMemoryGameVM()
        game.choose(game.cards.first!)
        return EmojiMemoryGameView(gameViewModel: game)
    }
}
