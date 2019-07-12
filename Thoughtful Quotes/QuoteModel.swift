//
//  QuoteModel.swift
//  Thoughtful Quotes
//
//  Created by Raj Gupta on 9/1/19.
//  Copyright © 2019 SoulfulMachine. All rights reserved.
//

import Foundation

struct QuoteDict : Codable {
    let quoteLanguage : QuoteLanguage
    let quote: String
    let romaji: String
    let author: String
    let englishTranslation: String
    let englishAuthor: String
    let germanTranslation: String
    let germanAuthor: String
}

enum QuoteLanguage: String, Codable{
    case English = "English"
    case Deutsch = "Deutsch"
    case Russian = "Russian"
    case Japanese = "Japanese"
    case Bengali = "Bengali"
    case Hindi = "Hindi"
}

enum UserLanguage: String, Codable{
    case English = "English"
    case Deutsch = "Deutsch"
}

/*
extension UserLanguage: Codable {
    enum Key: CodingKey {
        case rawValue
    }
    enum CodingError: Error {
        case unknownValue
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: Key.self)
        let rawValue = try container.decode(String.self, forKey: .rawValue)
        switch rawValue {
        case "English": self = .English
        case "Deutsch": self = .Deutsch
        default: throw CodingError.unknownValue
        }
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: Key.self)
        switch self {
        case .English: try container.encode("English", forKey: .rawValue)
        case .Deutsch: try container.encode("Deutsch", forKey: .rawValue)
        }
    }
}
 */

class QuoteModel {
    
    var userLanguage = UserLanguage.English
    
    var numDays: Int = 0
    
    private var currentDate = Date()
    
    var showTranslation = false
    
    var quoteDict: QuoteDict? = nil
    
    var quotesDict: Dictionary<String, QuoteDict>? = nil
    
    init() {
        numDays = UserDefaults.standard.integer(forKey: "numDays")
        
        // Set the user language based on value in SystemDefault, if not set then it is set as English
        if let userLanguageString = UserDefaults.standard.string(forKey: "userLanguage") {
            switch userLanguageString {
            case "English": userLanguage = .English
            case "Deutsch": userLanguage = .Deutsch
            default: break
            }
        }
    }

    // Called when the user opens the app
    // If user has never opened the app before provide a random quote
    // If user has opened the app on the same day, provide the quote shown on before on that day
    // If user opens the app on a new day, then provide a new random quote
    // If all quotes have been shown to the user in the past, then remove history and show random quote
    func refreshQuote() {
        
        // Read data from JSON file and populate quotesDict if quotesDict is nil
        if quotesDict == nil {
            refreshQuotesDict()
        }
        
        updateDate()
        
        let formatter = DateFormatter()
        formatter.dateFormat = "MM.dd.yyyy"
        let dateString = formatter.string(from: currentDate)
        
        if var quoteDates = UserDefaults.standard.dictionary(forKey: "quoteDates") as? Dictionary<String,String> {
            // Check if quoteDates contains today's date, which means the user has already checked the app today
            // Else quoteDates does not contain today's date, which means the user is opening the app for the first time today
            // and we need to add a random quote to quoteDates
            
            /* For TESTING
            quoteDates = [ "01.08.2019":"0",
                           "01.11.2019":"3",
                           "01.10.2019":"1",
                           "01.09.2019":"2",
                           "01.07.2019":"4",
            ]
 */
            
            if let todayQuote = quoteDates[dateString] {
                if quotesDict != nil {
                    quoteDict = quotesDict![todayQuote]
                }
            }
            else {
                let randomQuote = getQuoteAndUpdateQuoteDates(quoteDatesDict: quoteDates)
                let quoteDates = randomQuote.1
                UserDefaults.standard.set(quoteDates, forKey: "quoteDates")
                
                quoteDict = randomQuote.0
                showTranslation = false
            }
            

            
        }
        else { // If UserDefaults does not contain quoteDates
            let randomQuote = getQuoteAndUpdateQuoteDates(quoteDatesDict: nil)
            let quoteDates = randomQuote.1
            UserDefaults.standard.set(quoteDates, forKey: "quoteDates")
            
            quoteDict = randomQuote.0
            showTranslation = false
        }
        
    }
    
    // Read data from JSON file and populate quotesDic
    func refreshQuotesDict(){
        
        // First check if internet downloaded file is available
        // Else check if local bundle file is available
        
        var internetFileFound = false
        var errorDecodingInternetFile = false
        
        if let documentDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).last {
            let fileURL = documentDirectory.appendingPathComponent("internetQuotes.json")
            do {
                if try fileURL.checkResourceIsReachable() {
                    internetFileFound = true
                    do {
                        let data = try Data(contentsOf: fileURL, options: .mappedIfSafe)
                        let decoder = JSONDecoder()
                        quotesDict = try decoder.decode(Dictionary<String,QuoteDict>.self, from: data)
                    }
                    catch {
                        print("Error decoding internetQuotes.json file")
                        errorDecodingInternetFile = true
                    }
                }
            }
            catch {
                print ("Unable to find internet file")
            }
        }
        if internetFileFound == false || errorDecodingInternetFile == true {
            if let path = Bundle.main.path(forResource: "quotes", ofType: "json") {
                do {
                    let data = try Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe)
                    let decoder = JSONDecoder()
                    quotesDict = try decoder.decode(Dictionary<String, QuoteDict>.self, from: data)
                    
                }
                catch {
                    print("Error decoding quotes.json file")
                }
            }
        }
    }
    
    
    
    
    private func updateDate() {
        
        currentDate = Date()
        
        // FOR TESTING
        //currentDate = Calendar.current.date(byAdding: .day, value: numDays, to: currentDate)!
    }
    
    
    
    private func getQuoteAndUpdateQuoteDates(quoteDatesDict:Dictionary<String,String>?) -> (QuoteDict?,Dictionary<String,String>?) {
        
        // As app is requesting new quote, user must be seeing app on new day
        // Update the numDay counter
        numDays = UserDefaults.standard.integer(forKey: "numDays")
        numDays += 1
        UserDefaults.standard.set(numDays, forKey: "numDays")
        
        
        let formatter = DateFormatter()
        formatter.dateFormat = "MM.dd.yyyy"
        let dateString = formatter.string(from: currentDate)
        
        if quotesDict != nil && quoteDatesDict != nil {
            
            // Check if number of elements in quotesDict equal to number of elements in quoteDates
            // This means the user has seen all the quotes
            // We need to reset quoteDates and start fresh
            if quotesDict!.count <= quoteDatesDict!.count {
                if let randomQuote = quotesDict?.randomElement() {
                    let quoteDates = [dateString: randomQuote.key]
                    return (randomQuote.value,quoteDates)
                }
            } else {
                // We need to remove the quotes from quotesDict that have been shown in the past before picking a random element
                var remainingQuotesDict = quotesDict
                for quoteKey in quoteDatesDict!.values {
                    remainingQuotesDict![quoteKey] = nil
                }
                if let randomQuote = remainingQuotesDict?.randomElement() {
                    var quoteDates = quoteDatesDict
                    quoteDates![dateString] = randomQuote.key
                    return (randomQuote.value,quoteDates)
                }
            }
        }
        else if quotesDict != nil && quoteDatesDict == nil {
            // This is the case when user has never seen any quotes before
            if let randomQuote = quotesDict?.randomElement() {
                let quoteDates = [dateString: randomQuote.key]
                return (randomQuote.value,quoteDates)
            }
        }
        return (nil,nil)
    }
    
}


