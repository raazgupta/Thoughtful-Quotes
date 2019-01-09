//
//  QuoteModel.swift
//  Thoughtful Quotes
//
//  Created by Raj Gupta on 9/1/19.
//  Copyright © 2019 SoulfulMachine. All rights reserved.
//

import Foundation


class QuoteModel {
    
    var userLanguage = "German"
    
    var showTranslation = false
    
    var quoteDict: Dictionary<String,String>? = nil
    
    init() {
        quoteDict = getQuote()
    }
    
    private var quotesDict = [ 0 : ["quoteLanguage": "German",
                              "quote": "Fantasie ist wichtiger als Wissen",
                              "author": "Albert Einstein",
                              "englishTranslation": "Imagination is more important than Knowledge",
                              "englishAuthor": "Albert Einstein",
                              "germanTranslation": "Fantasie ist wichtiger als Wissen",
                              "germanAuthor": "Albert Einstein"],
                      1 : ["quoteLanguage": "English",
                             "quote": "Such is the nature of all things",
                             "author": "Raj Gupta",
                             "englishTranslation": "Such is the nature of all things",
                             "englishAuthor": "Raj Gupta",
                             "germanTranslation": "Das ist die Natur aller Dinge",
                             "germanAuthor": "Raj Gupta"],
                    2 : ["quoteLanguage": "Russian",
                           "quote": "Есть еще порох в пороховницах!",
                           "author": "Никола́й Го́голь",
                           "englishTranslation": "There is yet powder in the powder-flasks!",
                           "englishAuthor": "Nikolai Gogol",
                           "germanTranslation": "Es ist noch Pulver in den Pulverflaschen!",
                           "germanAuthor": "Nikolai Gogol"],
                    3 : ["quoteLanguage": "Japanese",
                           "quote": "猿も木から落ちる",
                           "author": "",
                           "englishTranslation": "Even a monkey can fall from a tree",
                           "englishAuthor": "",
                           "germanTranslation": "Sogar ein Affe kann von einem Baum fallen",
                           "germanAuthor": ""],
                    4 : ["quoteLanguage": "Bengali",
                           "quote": "চোখ মনের আয়না।",
                           "author": "",
                           "englishTranslation": "Eyes are the mirror of the mind",
                           "englishAuthor": "",
                           "germanTranslation": "Augen sind der Spiegel des Geistes",
                           "germanAuthor": ""]
    ]
    
    private func getQuote() -> Dictionary<String,String>? {
        let randomQuoteKey = quotesDict.keys.count.arc4random
        return quotesDict[randomQuoteKey]
    }
    
}

extension Int {
    var arc4random: Int{
        if self > 0 {
            return Int(arc4random_uniform(UInt32(self)))
        } else if self < 0 {
            return -Int(arc4random_uniform(UInt32(abs(self))))
        } else {
            return 0
        }
    }
}
