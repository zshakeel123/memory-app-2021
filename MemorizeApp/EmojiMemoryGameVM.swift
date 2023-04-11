//
//  MemorizeGameViewModel.swift
//  MemorizeApp
//
//  Created by Zeeshan Shakeel on 4/8/23.
//

import SwiftUI

class EmojiMemoryGameVM : ObservableObject{
    
    private static let emojis = ["✈️","🚗","🚙","🚲","🚌","🚎","🚕","🏍","🛩","🛫","🛬","🛰","🚀","🚁","🚞","🚂","🚃","🚆","🚄","💺","🚊","🚉","🚈","🚝"]
    
    private static func createMemoryGame() -> MemoryGameModel<String> {
        return MemoryGameModel<String>(numberOfPairOfCards: 14) {
            pairIndex in
            
            return emojis[pairIndex]
        }
    }
    
    
    
    @Published private var model = createMemoryGame()
    
    var cards: Array<MemoryGameModel<String>.Card> {
        return model.cards
    }
    
    // MARK: = Intent(s)
    func choose(_ card: MemoryGameModel<String>.Card) {
        
        model.choose(card)
    }
}

