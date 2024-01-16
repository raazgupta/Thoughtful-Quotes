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
    
    @IBOutlet weak var shareButton: UIButton!
    
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
        shareButton?.layer.cornerRadius = 5.0
        
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
        if UIDevice.current.userInterfaceIdiom == .phone {
            if #available(iOS 13.0, *) {
                if let settingsImage = UIImage(systemName: "gear") {
                    settingsButton.setImage(settingsImage, for: .normal)
                    settingsButton.setTitle("", for: .normal)
                    settingsButton.imageView?.contentMode = .scaleAspectFit
                    settingsButton.tintColor = UIColor.black
                }
                if let refreshImage = UIImage(systemName: "arrow.clockwise") {
                    refreshButton.setImage(refreshImage, for: .normal)
                    refreshButton.setTitle("", for: .normal)
                    refreshButton.imageView?.contentMode = .scaleAspectFit
                    refreshButton.tintColor = UIColor.black
                }
                if let shareImage = UIImage(systemName: "square.and.arrow.up") {
                    shareButton.setImage(shareImage, for: .normal)
                    shareButton.setTitle("", for: .normal)
                    shareButton.imageView?.contentMode = .scaleAspectFit
                    shareButton.tintColor = UIColor.black
                }
                if let translateImage = UIImage(systemName: "globe") {
                    translateButton.setImage(translateImage, for: .normal)
                    translateButton.setTitle("", for: .normal)
                    translateButton.imageView?.contentMode = .scaleAspectFit
                    translateButton.tintColor = UIColor.black
                }
            }
        }
        else {
            settingsButton.setTitle("Settings", for: .normal)
            shareButton.setTitle("Share", for: .normal)
            translateButton.setTitle("Translate", for: .normal)
            refreshButton.setTitle("Refresh", for: .normal)
        }
        
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
    
    @IBAction func shareQuote(){
        
        if let quoteAttrString = quoteTextLabel?.attributedText {
            
            // Create an image with the quote
            let image = createImageWithQuote(quoteAttrString: quoteAttrString)
            
            // Share the image
            let activityViewController = UIActivityViewController(activityItems: [image], applicationActivities: nil)
            present(activityViewController, animated: true, completion: nil)
        }
    }
    
    func createImageWithQuote(quoteAttrString: NSAttributedString) -> UIImage {
        
        // Define the size of the image
        let size = CGSize(width: 628, height: 1200)
        // Begin image context
        UIGraphicsBeginImageContextWithOptions(size, false, 0)
        defer { UIGraphicsEndImageContext() }
        
        // Draw the first rectangle (background)
        let backgroundRect = CGRect(x: 0, y: 0, width: size.width, height: size.height)
        let backgroundColor = UIColor(hex: "#01CDBC")
        backgroundColor.setFill()
        UIRectFill(backgroundRect)
        
        // Draw the second rectangle (quote background)
        let quoteRect = CGRect(x: 30, y: 60, width: size.width-60, height: size.height-120)
        let quoteBackgroundColor = UIColor(hex: "#EEE5E9")
        let quoteBackgroundPath = UIBezierPath(roundedRect: quoteRect, cornerRadius: 10)
        quoteBackgroundColor.setFill()
        quoteBackgroundPath.fill()
    
        // Custom drawing code here (draw the quote string)
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.alignment = .center
        
        let attributes: [NSAttributedString.Key: Any] = [
                .paragraphStyle: paragraphStyle
            ]
        
        // Center the string
        let mutableQuoteAttrString = NSMutableAttributedString(attributedString: quoteAttrString)
        let fullRange = NSRange(location: 0, length: mutableQuoteAttrString.length)
        mutableQuoteAttrString.addAttributes(attributes, range: fullRange)
        // Increase the font size
        mutableQuoteAttrString.enumerateAttribute(.font, in: fullRange, options: []) { value, range, stop in
            if let font = value as? UIFont {
                let newFontSize = font.pointSize + 15
                let newFont = UIFont(descriptor: font.fontDescriptor, size: newFontSize)
                mutableQuoteAttrString.addAttribute(.font, value: newFont, range: range)
            }
        }
        
        // Calculate the bounding rectangle for the text
        let textRect = mutableQuoteAttrString.boundingRect(with: CGSize(width: quoteRect.width - 20, height: CGFloat.greatestFiniteMagnitude), options: [.usesLineFragmentOrigin, .usesFontLeading], context: nil)

        // Center the textRect within the quoteRect
        let centeredRect = CGRect(x: quoteRect.origin.x + (quoteRect.width - textRect.width) / 2, y: quoteRect.origin.y + (quoteRect.height - textRect.height) / 2, width: textRect.width, height: textRect.height)

        // Draw the attributed string in the centered rectangle
        mutableQuoteAttrString.draw(in: centeredRect)
        
        return UIGraphicsGetImageFromCurrentImageContext()!
        
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
        
extension UIColor {
    convenience init(hex: String) {
        let hexString: String = hex.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
        let scanner = Scanner(string: hexString)

        if hexString.hasPrefix("#") {
            scanner.scanLocation = 1
        }

        var color: UInt64 = 0
        scanner.scanHexInt64(&color)

        let mask = 0x000000FF
        let r = Int(color >> 16) & mask
        let g = Int(color >> 8) & mask
        let b = Int(color) & mask

        let red   = CGFloat(r) / 255.0
        let green = CGFloat(g) / 255.0
        let blue  = CGFloat(b) / 255.0

        self.init(red: red, green: green, blue: blue, alpha: 1)
    }
}

