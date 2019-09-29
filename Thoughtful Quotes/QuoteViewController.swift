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
    
    @IBOutlet weak var dayTextLabel: UILabel!
    
    @IBOutlet weak var settingsButton: UIButton!
    
    @IBOutlet weak var refreshButton: UIButton!
    
    @IBOutlet weak var translateButton: UIButton!
    
    var quoteModel = QuoteModel()
    
    /*
    private let quoteAttributes = [NSAttributedString.Key.font: UIFont(name: "American Typewriter", size: 30.0)!,                 NSAttributedString.Key.foregroundColor: UIColor(red: 0.003921568627, green: 0.2784313725, blue: 0.462745098, alpha: 1)]
    private let romajiAttributes = [NSAttributedString.Key.font: UIFont(name: "American Typewriter", size: 18.0)!,
                            NSAttributedString.Key.foregroundColor: UIColor(red: 0.003921568627, green: 0.2784313725, blue: 0.462745098, alpha: 1)]
    private let authorAttributes = [NSAttributedString.Key.font: UIFont(name: "American Typewriter", size: 20.0)!,
                            NSAttributedString.Key.foregroundColor: UIColor(red: 0.003921568627, green: 0.2784313725, blue: 0.462745098, alpha: 1)]
    */
    
    private let quoteAttributes = [NSAttributedString.Key.font: UIFont(name: "American Typewriter", size: 30.0)!,                 NSAttributedString.Key.foregroundColor: UIColor(red: 0, green: 0, blue: 0, alpha: 1)]
    private let romajiAttributes = [NSAttributedString.Key.font: UIFont(name: "American Typewriter", size: 18.0)!,
                                    NSAttributedString.Key.foregroundColor: UIColor(red: 0, green: 0, blue: 0, alpha: 1)]
    private let authorAttributes = [NSAttributedString.Key.font: UIFont(name: "American Typewriter", size: 20.0)!,
                                    NSAttributedString.Key.foregroundColor: UIColor(red: 0, green: 0, blue: 0, alpha: 1)]
 
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
        settingsButton?.layer.cornerRadius = 5.0
        refreshButton?.layer.cornerRadius = 5.0
        translateButton?.layer.cornerRadius = 5.0
        
        /*
        switch quoteModel.userLanguage {
        case .English:
            settingsButton?.setTitle("Settings", for: .normal)
            refreshButton?.setTitle("Refresh", for: .normal)
            translateButton?.setTitle("Translate", for: .normal)
        default:
            settingsButton?.setTitle("Einstellungen", for: .normal)
            refreshButton?.setTitle("Aktualisierung", for: .normal)
            translateButton?.setTitle("Übersetzung", for: .normal)
        }
 */
        
        settingsButton?.titleLabel?.adjustsFontSizeToFitWidth = true
        refreshButton?.titleLabel?.adjustsFontSizeToFitWidth = true
        translateButton?.titleLabel?.adjustsFontSizeToFitWidth = true
        quoteTextLabel?.adjustsFontSizeToFitWidth = true
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        
        // Present the settings screen when the user launches the app for the first time
        let launchedBefore = UserDefaults.standard.bool(forKey: "launchedBefore")
        if !launchedBefore {
            UserDefaults.standard.set(true, forKey: "launchedBefore")

            self.performSegue(withIdentifier: "showSettings", sender: nil)

            /*
            if let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "settingsVC") as? SettingsViewController {
                self.present(vc, animated: true, completion: nil)
                
            }
            */
        }
    }
    
    
    


    
    @objc private func refreshQuote() {
        
        quoteModel.refreshQuote()
        
        /*
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
        */
        
        updateQuoteLabel()
        
        // Set number of days that the user has seen the app
        switch quoteModel.userLanguage {
        case .English:
            dayTextLabel.text = "Day \(String(quoteModel.numDays))"
        case .Deutsch:
            dayTextLabel.text = "Tag \(String(quoteModel.numDays))"
        }
        
        checkTranslateButton()
        
    }

    @IBAction private func showTranslatedQuote(_ sender: UIGestureRecognizer) {
        guard sender.view != nil else { return }
        guard quoteModel.quoteDict != nil else { return }
        guard quoteModel.quoteDict!.quoteLanguage.rawValue != quoteModel.userLanguage.rawValue else { return }
        
        if sender.state == .ended {
            
            showTranslated(transitionView: sender.view!)
            
        }
    }
    
    
    @IBAction func pressTranslate(_ sender: UIButton) {
        guard quoteModel.quoteDict != nil else { return }
        guard quoteModel.quoteDict!.quoteLanguage.rawValue != quoteModel.userLanguage.rawValue else { return }
        
        showTranslated(transitionView: quoteTextLabel)
    }
    
    private func showTranslated(transitionView: UIView){
        quoteModel.showTranslation = !quoteModel.showTranslation
        
        let transitionOptions: UIView.AnimationOptions = [.transitionFlipFromRight]
        
        UIView.transition(with: transitionView, duration: 1.0, options: transitionOptions, animations: {
            
            self.updateQuoteLabel()
            
        })
    }
    
    private func updateQuoteLabel() {
        
        var quoteAttrString = NSMutableAttributedString(string: "")
        var romajiAttrString = NSMutableAttributedString(string: "")
        var authorAttrString = NSMutableAttributedString(string: "")
        
        
        if quoteModel.showTranslation {
            
            var translatedQuote = ""
            var translatedAuthor = ""
            switch quoteModel.userLanguage {
            case .English:
                translatedQuote = quoteModel.quoteDict!.englishTranslation
                translatedAuthor = quoteModel.quoteDict!.englishAuthor
            case .Deutsch:
                translatedQuote = quoteModel.quoteDict!.germanTranslation
                translatedAuthor = quoteModel.quoteDict!.germanAuthor
            }
            
            
            quoteAttrString = NSMutableAttributedString(string: translatedQuote, attributes: quoteAttributes)
            authorAttrString = NSMutableAttributedString(string: translatedAuthor, attributes: authorAttributes)
        }
        else {
            quoteAttrString = NSMutableAttributedString(string: quoteModel.quoteDict!.quote, attributes: quoteAttributes)
            romajiAttrString = NSMutableAttributedString(string: quoteModel.quoteDict!.romaji, attributes: romajiAttributes)
            authorAttrString = NSMutableAttributedString(string: quoteModel.quoteDict!.author, attributes: authorAttributes)
        }
        
        if romajiAttrString.string != "" {
            quoteAttrString.append(NSAttributedString(string: "\n\n"))
            quoteAttrString.append(romajiAttrString)
        }
        if authorAttrString.string != "" {
            quoteAttrString.append(NSAttributedString(string: "\n\n"))
            quoteAttrString.append(authorAttrString)
        }
        
        
        quoteTextLabel?.attributedText = quoteAttrString
    }
    
    
    @IBAction func showRandomQuote(_ sender: UIButton) {
        quoteModel.refreshQuote(refreshButtonPressed: true)
        //updateQuoteLabel()
        
        UIView.transition(with: quoteTextLabel, duration: 1.5, options: [.transitionCurlUp], animations: {self.updateQuoteLabel()}, completion: {finished in
            self.checkTranslateButton()
        })
        
    }
    
    private func checkTranslateButton(){
        // Check if Translate button needs to be shown
        if quoteModel.quotesDict != nil {
            if quoteModel.quoteDict!.quoteLanguage.rawValue != quoteModel.userLanguage.rawValue {
                translateButton.isHidden = false
            }
            else {
                translateButton.isHidden = true
            }
        }
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showSettings" {
            if let vc = segue.destination as? SettingsViewController {
                vc.quoteModel = quoteModel
            }
        }
    }
    
    
}

