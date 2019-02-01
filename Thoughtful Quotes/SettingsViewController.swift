//
//  SettingsViewController.swift
//  Thoughtful Quotes
//
//  Created by Raj Gupta on 13/1/19.
//  Copyright © 2019 SoulfulMachine. All rights reserved.
//

import UIKit
import UserNotifications

class SettingsViewController: UIViewController {

    
    @IBOutlet weak var settingsLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UITextView!
    @IBOutlet weak var remindMeLabel: UILabel!
    @IBOutlet weak var morningButton: UIButton!
    @IBOutlet weak var lunchtimeButton: UIButton!
    @IBOutlet weak var numQuotesLabel: UILabel!
    @IBOutlet weak var refreshButton: UIButton!
    @IBOutlet weak var doneButton: UIButton!
    
    var quoteModel: QuoteModel? = nil
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        refreshLanguage()
        
    }
    
    @IBAction private func setUserLanguage(_ sender: UIButton) {
        switch sender.tag {
        case 1:
            UserDefaults.standard.set("English", forKey: "userLanguage")
            quoteModel!.userLanguage = .English
        case 2:
            UserDefaults.standard.set("Deutsch", forKey: "userLanguage")
            quoteModel!.userLanguage = .Deutsch
        default: break
        }
        
        refreshLanguage()
        
    }
    
    private func refreshLanguage() {
        
        switch quoteModel!.userLanguage {
        case .English:
            settingsLabel.text = "Settings"
            descriptionLabel.text = "Welcome to the Thoughtful Quotes App. This app will present you with daily quotes in different languages. Tap on the quote to get the translation. If you'd like a reminder when a new quote is available, once per day, then you can set it below. When we get inspired by quotes we find in the world, we will update our list. You can click the Refresh button to get our latest set of quotes. However please make sure you have access to the internet. We hope these quotes help you think deeply about the world."
            remindMeLabel.text = "Remind Me:"
            morningButton.setTitle("Morning", for: .normal)
            lunchtimeButton.setTitle("Lunchtime", for: .normal)
            numQuotesLabel.text = "\(findNumQuotes()) Quotes"
            refreshButton.setTitle("Refresh", for: .normal)
            doneButton.setTitle("Done", for: .normal)
        case .Deutsch:
            settingsLabel.text = "Einstellungen"
            descriptionLabel.text = "Willkommen bei der durchdachten Zitate-App. Diese App zeigt Ihnen tägliche Zitate in verschiedenen Sprachen. Tippen Sie auf das Zitat, um die Übersetzung zu erhalten. Wenn Sie einmal pro Tag eine Erinnerung erhalten möchten, wenn ein neues Angebot verfügbar ist, können Sie es unten einstellen. Wenn wir uns von Zitaten inspirieren lassen, die wir auf der Welt finden, werden wir unsere Liste aktualisieren. Sie können auf die Schaltfläche Aktualisieren klicken, um die neuesten Angebote zu erhalten. Bitte stellen Sie jedoch sicher, dass Sie Zugang zum Internet haben. Wir hoffen, diese Zitate helfen Ihnen dabei, tief über die Welt nachzudenken."
            remindMeLabel.text = "Erinnere mich:"
            morningButton.setTitle("Morgen", for: .normal)
            lunchtimeButton.setTitle("Mittag", for: .normal)
            numQuotesLabel.text = "\(findNumQuotes()) Zitate"
            refreshButton.setTitle("Aktualisierung", for: .normal)
            doneButton.setTitle("Erledigt", for: .normal)
        }
        
        remindMeLabel.adjustsFontSizeToFitWidth = true
        morningButton.titleLabel?.adjustsFontSizeToFitWidth = true
        lunchtimeButton.titleLabel?.adjustsFontSizeToFitWidth = true
        refreshButton.titleLabel?.adjustsFontSizeToFitWidth = true
        doneButton.titleLabel?.adjustsFontSizeToFitWidth = true
    }
    
    private func findNumQuotes() -> Int {
        
        //quoteModel!.refreshQuotesDict()
        return quoteModel!.quotesDict?.count ?? 0
    }
    
    
    @IBAction private func setReminder(_ sender: UIButton) {
        
        let englishNotificationDisabledTitle = "Notification Disabled"
        let englishNotificationDisabledBody = "Enable Notifications in Settings"
        let germanNotificationDisabledTitle = "Benachrichtigung deaktiviert"
        let germanNotificationDisabledBody = "Aktivieren Sie Benachrichtigungen in den Einstellungen"
        var notificationTitle = ""
        let englishNotificationEnabledTitle = "Daily Reminder Set"
        let englishNotificationEnabledBody = "Reminder set for "
        let germanNotificationEnabledTitle = "Tägliche Erinnerung eingestellt"
        let germanNotificationEnabledBody = "Erinnerung eingestellt für "
        
        // Tuple in this format: (Hour, Minute)
        var reminderTimeInt: (Int, Int)? = nil
        
        // Get the time of the reminder
        switch sender.tag {
        case 1:
            reminderTimeInt = (7,0)
            switch quoteModel!.userLanguage {
            case .English:
                    notificationTitle = "Good Morning"
            case .Deutsch:
                    notificationTitle = "Guten Morgen"
            }
        case 2:
            reminderTimeInt = (12,0)
            switch quoteModel!.userLanguage {
            case .English:
                notificationTitle = "Good Afternoon"
            case .Deutsch:
                notificationTitle = "Guten Tag"
            }
        default: break
        }
        
        // Prompt the user for notification permission
        // System only prompts the user the first time
        // Check if user has not granted authorization, then exit function
        let center = UNUserNotificationCenter.current()
        center.requestAuthorization(options: [.alert, .sound])
        {
            (granted, error) in
            if granted == false {
                DispatchQueue.main.async { [weak self] in
                    switch self?.quoteModel!.userLanguage {
                    case .English?:
                        let alert = UIAlertController(title: englishNotificationDisabledTitle, message: englishNotificationDisabledBody, preferredStyle: .alert)
                        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                        self?.present(alert, animated: true)
                    case .Deutsch?:
                        let alert = UIAlertController(title: germanNotificationDisabledTitle, message: germanNotificationDisabledBody, preferredStyle: .alert)
                        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                        self?.present(alert, animated: true)
                    default: break
                        
                    }
                }
                // As the user has not granted permission to show quotes, exit the function
                return
            }
            else if granted == true {
                // If user has granted authorization
                // Set a notification with the user requested time
                // If previous notification exists, then it will be replaced
                center.getNotificationSettings { (settings) in
                    guard settings.authorizationStatus == .authorized else {return}
                    
                    if settings.alertSetting == .enabled {
                        let content = UNMutableNotificationContent()
                        content.title = NSString.localizedUserNotificationString(forKey: notificationTitle, arguments: nil)
                        switch self.quoteModel!.userLanguage {
                        case .English:
                            content.body = NSString.localizedUserNotificationString(forKey: "What is today's Thoughtful Quote?", arguments: nil)
                        case .Deutsch:
                            content.body = NSString.localizedUserNotificationString(forKey: "Was ist das heutige durchdachte Zitat?", arguments: nil)
                        }
                        
                        // Configure the trigger
                        var dateInfo = DateComponents()
                        if let reminderTime = reminderTimeInt {
                            dateInfo.hour = reminderTime.0
                            dateInfo.minute = reminderTime.1
                            let trigger = UNCalendarNotificationTrigger(dateMatching: dateInfo, repeats: true)
                            
                            // Create the request object
                            let request = UNNotificationRequest(identifier: "ThoughtfulQuoteNotification", content: content, trigger: trigger)
                            
                            // Schedule the notification
                            center.add(request) {
                                (error: Error?) in
                                if let theError = error {
                                    print(theError.localizedDescription)
                                }
                            }
                            
                            DispatchQueue.main.async { [weak self] in
                                switch self?.quoteModel!.userLanguage {
                                case .English?:
                                    let alert = UIAlertController(title: englishNotificationEnabledTitle, message: englishNotificationEnabledBody + "\(reminderTime.0):00", preferredStyle: .alert)
                                    alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                                    self?.present(alert, animated: true)
                                case .Deutsch?:
                                    let alert = UIAlertController(title: germanNotificationEnabledTitle, message: germanNotificationEnabledBody + "\(reminderTime.0):00", preferredStyle: .alert)
                                    alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                                    self?.present(alert, animated: true)
                                default: break
                                }
                            }
                            
                        }
                        
                    }
                    
                }
            }
        }
        
        
        
    }
    
    @IBAction private func refreshQuotesFromServer(_ sender: UIButton) {
        
        
        // Update the Num of Quotes label to show Downloading
        switch quoteModel!.userLanguage {
        case .English:
            numQuotesLabel.text = "Downloading"
        case .Deutsch:
            numQuotesLabel.text = "Wird heruntergeladen"
        }
        numQuotesLabel.adjustsFontSizeToFitWidth = true
        
 
        let url = URL(string: "https://www.soulfulmachine.com/App/ThoughtfulQuotes/quotes.json")!
        
        let request = NSMutableURLRequest(url: url)
        request.httpMethod = "GET"
        //request.cachePolicy = URLRequest.CachePolicy.reloadIgnoringLocalAndRemoteCacheData
        
        URLSession.shared.dataTask(with: request as URLRequest) { (data,response,error) in
            if error != nil {
                print(error!.localizedDescription)
                
                DispatchQueue.main.async { [weak self] in
                    switch self?.quoteModel!.userLanguage {
                    case .English?: self?.numQuotesLabel.text = "Error. Check Internet."
                    case .Deutsch?: self?.numQuotesLabel.text = "Error. Überprüfen Sie das Internet"
                    default: break
                    }
                    self?.numQuotesLabel.adjustsFontSizeToFitWidth = true
                }
                
                return
            }
            
            var fileWriteResult = false
            if let theData = data {
                print(theData)
                fileWriteResult = self.writeFileToDisk(data: theData)
            }
            
            
            self.quoteModel!.refreshQuotesDict()
            
            DispatchQueue.main.async { [weak self] in
                
                if fileWriteResult {
                    switch self?.quoteModel!.userLanguage {
                    case .English?: self?.numQuotesLabel.text = "\(self?.findNumQuotes() ?? 0) Quotes"
                    case .Deutsch?: self?.numQuotesLabel.text = "\(self?.findNumQuotes() ?? 0) Zitate"
                    default: break
                    }
                    
                    //self?.numQuotesLabel.text = "\(self?.findNumQuotes() ?? 0) quotes found"
                }
                else {
                    switch self?.quoteModel!.userLanguage {
                    case .English?: self?.numQuotesLabel.text = "Error. Check Internet."
                    case .Deutsch?: self?.numQuotesLabel.text = "Error. Überprüfen Sie das Internet"
                    default: break
                    }
                }
                self?.numQuotesLabel.adjustsFontSizeToFitWidth = true
            }
        }.resume()
        
        
        
    }
    
    private func writeFileToDisk(data: Data) -> Bool {
        if let documentDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).last {
            let fileURL = documentDirectory.appendingPathComponent("internetQuotes.json")
            do {
                try data.write(to: fileURL, options: .atomic)
                return true
            }
            catch {
                print("error writing file to disk")
                return false
            }
        }
        return false
    }
    
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        if segue.identifier == "showQuote" {
            if let vc = segue.destination as? QuoteViewController {
                if quoteModel == nil {
                    quoteModel = QuoteModel()
                }
                vc.quoteModel = quoteModel!
            }
        }
    }
 

}
