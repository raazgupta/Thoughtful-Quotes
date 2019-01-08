//
//  ViewController.swift
//  Thoughtful Quotes
//
//  Created by Raj Gupta on 6/1/19.
//  Copyright © 2019 SoulfulMachine. All rights reserved.
//

import UIKit

class QuoteViewController: UIViewController {

    
    @IBOutlet weak var quoteTextLabel: UILabel!
    
    var showTranslation = false
    
    let quoteDict = [ "quote": "воображение важнее знания",
                      "author": "Albert Einstein",
                      "englishTranslation": "Imagination is more important than Knowledge",
                      "englishAuthor": "Albert Einstein"
                    ]
    
    let quoteAttributes = [NSAttributedString.Key.font: UIFont(name: "American Typewriter", size: 26.0)!]
    let authorAttributes = [NSAttributedString.Key.font: UIFont(name: "American Typewriter", size: 20.0)!]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        // Round the corners of the label
        quoteTextLabel?.layer.masksToBounds = true
        quoteTextLabel?.layer.cornerRadius = 20.0
        
        
        
        let quoteAttrString = NSMutableAttributedString(string: quoteDict["quote"]!, attributes: quoteAttributes)
        let authorAttrString = NSMutableAttributedString(string: quoteDict["author"]!, attributes: authorAttributes)
        
        quoteAttrString.append(NSAttributedString(string: "\n\n"))
        quoteAttrString.append(authorAttrString)
        
        quoteTextLabel?.attributedText = quoteAttrString
        
    }

    @IBAction func showTranslatedQuote(_ sender: UITapGestureRecognizer) {
        guard sender.view != nil else { return }
        
        if sender.state == .ended {
            
            showTranslation = !showTranslation
            
            let transitionOptions: UIView.AnimationOptions = [.transitionFlipFromRight]
            
            UIView.transition(with: sender.view!, duration: 1.0, options: transitionOptions, animations: {
                
                
                var quoteAttrString = NSMutableAttributedString(string: "")
                var authorAttrString = NSMutableAttributedString(string: "")
                if self.showTranslation {
                    quoteAttrString = NSMutableAttributedString(string: self.quoteDict["englishTranslation"]!, attributes: self.quoteAttributes)
                    authorAttrString = NSMutableAttributedString(string: self.quoteDict["englishAuthor"]!, attributes: self.authorAttributes)
                }
                else {
                    quoteAttrString = NSMutableAttributedString(string: self.quoteDict["quote"]!, attributes: self.quoteAttributes)
                    authorAttrString = NSMutableAttributedString(string: self.quoteDict["author"]!, attributes: self.authorAttributes)
                }
                
                quoteAttrString.append(NSAttributedString(string: "\n\n"))
                quoteAttrString.append(authorAttrString)
                
                self.quoteTextLabel?.attributedText = quoteAttrString
            })
            
        }
        
        
    }
    
    
}

