//
//  ViewController.swift
//  Thoughtful Quotes
//
//  Created by Raj Gupta on 6/1/19.
//  Copyright © 2019 SoulfulMachine. All rights reserved.
//

import UIKit

class QuoteViewController: UIViewController {

    //let c = #colorLiteral(red: 0.003921568627, green: 0.2784313725, blue: 0.462745098, alpha: 1)
    
    @IBOutlet weak var quoteTextLabel: UILabel!
    
    var quoteModel = QuoteModel()
    
    let quoteAttributes = [NSAttributedString.Key.font: UIFont(name: "American Typewriter", size: 30.0)!,                 NSAttributedString.Key.foregroundColor: UIColor(red: 0.003921568627, green: 0.2784313725, blue: 0.462745098, alpha: 1)]
    let romajiAttributes = [NSAttributedString.Key.font: UIFont(name: "American Typewriter", size: 18.0)!,
                            NSAttributedString.Key.foregroundColor: UIColor(red: 0.003921568627, green: 0.2784313725, blue: 0.462745098, alpha: 1)]
    let authorAttributes = [NSAttributedString.Key.font: UIFont(name: "American Typewriter", size: 20.0)!,
                            NSAttributedString.Key.foregroundColor: UIColor(red: 0.003921568627, green: 0.2784313725, blue: 0.462745098, alpha: 1)]
    
    /*
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        // Add Observer to refresh quote when app is started or brought to foreground from background
        NotificationCenter.default.addObserver(self, selector: #selector(refreshQuote), name: UIApplication.willEnterForegroundNotification, object: nil)
        
        // Round the corners of the label
        quoteTextLabel?.layer.masksToBounds = true
        quoteTextLabel?.layer.cornerRadius = 20.0
        
    }
     */
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Add Observer to refresh quote when app is brought to foreground from background
        NotificationCenter.default.addObserver(self, selector: #selector(refreshQuote), name: UIApplication.willEnterForegroundNotification, object: nil)
        
        // Refresh Quote
        refreshQuote()
        
        // Round the corners of the label
        quoteTextLabel?.layer.masksToBounds = true
        quoteTextLabel?.layer.cornerRadius = 20.0
        
    }
    


    
    @objc private func refreshQuote() {
        
        quoteModel.refreshQuote()
        
        if let quoteDict = quoteModel.quoteDict {
            
            let quoteAttrString = NSMutableAttributedString(string: quoteDict.quote, attributes: quoteAttributes)
            let romajiAttrString = NSMutableAttributedString(string: quoteDict.romaji, attributes: romajiAttributes)
            let authorAttrString = NSMutableAttributedString(string: quoteDict.author, attributes: authorAttributes)
            
            quoteAttrString.append(NSAttributedString(string: "\n\n"))
            quoteAttrString.append(romajiAttrString)
            quoteAttrString.append(NSAttributedString(string: "\n\n"))
            quoteAttrString.append(authorAttrString)
            
            quoteTextLabel?.attributedText = quoteAttrString
        }
    }

    @IBAction func showTranslatedQuote(_ sender: UIGestureRecognizer) {
        guard sender.view != nil else { return }
        guard quoteModel.quoteDict != nil else { return }
        guard quoteModel.quoteDict?.quoteLanguage != quoteModel.userLanguage else { return }
        
        if sender.state == .ended {
            
            quoteModel.showTranslation = !quoteModel.showTranslation
            
            let transitionOptions: UIView.AnimationOptions = [.transitionFlipFromRight]
            
            UIView.transition(with: sender.view!, duration: 1.0, options: transitionOptions, animations: {
                
                
                var quoteAttrString = NSMutableAttributedString(string: "")
                var romajiAttrString = NSMutableAttributedString(string: "")
                var authorAttrString = NSMutableAttributedString(string: "")
                
                
                if self.quoteModel.showTranslation {
                    
                    var translatedQuote = ""
                    var translatedAuthor = ""
                    switch self.quoteModel.userLanguage {
                    case "English":
                        translatedQuote = self.quoteModel.quoteDict!.englishTranslation
                        translatedAuthor = self.quoteModel.quoteDict!.englishAuthor
                    case "German":
                        translatedQuote = self.quoteModel.quoteDict!.germanTranslation
                        translatedAuthor = self.quoteModel.quoteDict!.germanAuthor
                    default:
                        break
                    }
                    
                    /*
                    var translationLanguage = "englishTranslation"
                    var authorLanguage = "englishAuthor"
                    if self.quoteModel.userLanguage == "German" {
                        translationLanguage = "germanTranslation"
                        authorLanguage = "germanAuthor"
                    }
                    */
                    
                    quoteAttrString = NSMutableAttributedString(string: translatedQuote, attributes: self.quoteAttributes)
                    authorAttrString = NSMutableAttributedString(string: translatedAuthor, attributes: self.authorAttributes)
                }
                else {
                    quoteAttrString = NSMutableAttributedString(string: self.quoteModel.quoteDict!.quote, attributes: self.quoteAttributes)
                    romajiAttrString = NSMutableAttributedString(string: self.quoteModel.quoteDict!.romaji, attributes: self.romajiAttributes)
                    authorAttrString = NSMutableAttributedString(string: self.quoteModel.quoteDict!.author, attributes: self.authorAttributes)
                }
                
                quoteAttrString.append(NSAttributedString(string: "\n\n"))
                quoteAttrString.append(romajiAttrString)
                quoteAttrString.append(NSAttributedString(string: "\n\n"))
                quoteAttrString.append(authorAttrString)
                
                self.quoteTextLabel?.attributedText = quoteAttrString
            })
            
        }
        
        
    }
    
    
}

