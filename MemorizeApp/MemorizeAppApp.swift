//
//  MemorizeAppApp.swift
//  MemorizeApp
//
//  Created by Zeeshan Shakeel on 4/7/23.
//

import SwiftUI

@main
struct MemorizeAppApp: App {
    let game = EmojiMemoryGameVM()
    var body: some Scene {
        WindowGroup {
            EmojiMemoryGameView(gameViewModel: game)
        }
    }
}
