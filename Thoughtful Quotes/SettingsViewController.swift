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

    @IBOutlet weak var englishButton: UIButton!
    @IBOutlet weak var deutschButton: UIButton!
    @IBOutlet weak var settingsLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UITextView!
    @IBOutlet weak var remindMeLabel: UILabel!
    @IBOutlet weak var numQuotesLabel: UILabel!
    @IBOutlet weak var refreshButton: UIButton!
    @IBOutlet weak var doneButton: UIButton!
    @IBOutlet weak var remindMeTime: UIDatePicker!
    @IBOutlet weak var setReminderButton: UIButton!
    
    var quoteModel: QuoteModel? = nil
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Round the corners
        descriptionLabel.layer.masksToBounds = true
        descriptionLabel.layer.cornerRadius = 10.0
        englishButton.layer.cornerRadius = 10.0
        deutschButton.layer.cornerRadius = 10.0
        refreshButton.layer.cornerRadius = 10.0
        doneButton.layer.cornerRadius = 10.0
        setReminderButton.layer.cornerRadius = 10.0
        
        //Add padding to description label
        descriptionLabel.textContainerInset = UIEdgeInsets(top: 10.0, left: 10.0, bottom: 10.0, right: 10.0)
        
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
            descriptionLabel.text = "Welcome to the Mindful Quotes App. This app will present you with daily quotes in different languages. Tap on the quote or press 'Translate' to show the translation. Press 'Refresh' to show a new quote. If you'd like a reminder when the new daily quote is available, then you can set it below. When we get inspired by quotes we find in the world, we will update our list. If your device is connected to the internet, you can click the 'Refresh' button in 'Settings' to get our latest set of quotes. We hope these quotes help you think deeply about the world."
            remindMeLabel.text = "Daily Quote:"
            setReminderButton.setTitle("Notify", for: .normal)
            numQuotesLabel.text = "  \(findNumQuotes()) Quotes"
            refreshButton.setTitle("Refresh", for: .normal)
            doneButton.setTitle("Done", for: .normal)
        case .Deutsch:
            settingsLabel.text = "Einstellungen"
            descriptionLabel.text = """
            Willkommen bei „Mindful Quotes“. Diese App zeigt Ihnen tägliche Zitate in verschiedenen Sprachen. Tippen Sie auf das Zitat oder auf den „Translate“ Button, um die Übersetzung zu lesen. Drücken Sie den „Refresh“ Button um ein neues Zitat angezeigt zu bekommen. Wenn Sie einmal pro Tag eine Erinnerung erhalten möchten, wenn ein neues Zitat verfügbar ist, können Sie es unten einstellen. Wenn wir uns von Zitaten inspirieren lassen, die wir auf der Welt finden, werden wir unsere Liste aktualisieren. Wenn Ihr Gerät mit dem Internet verbunden ist, können Sie auf die Schaltfläche „Refresh“ klicken, um unsere neuesten Zitate abzurufen. Wir hoffen, diese Zitate helfen Ihnen dabei, tief über die Welt nachzudenken.
            """
            remindMeLabel.text = "Tägliches Zitat:"
            setReminderButton.setTitle("Benachrichtigen", for: .normal)
            numQuotesLabel.text = "  \(findNumQuotes()) Zitate"
            refreshButton.setTitle("  Refresh", for: .normal)
            doneButton.setTitle("Erledigt", for: .normal)
        }
        
        remindMeLabel.adjustsFontSizeToFitWidth = true
        setReminderButton.titleLabel?.adjustsFontSizeToFitWidth = true
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
        let englishNotificationEnabledTitle = "Daily Quote"
        let englishNotificationEnabledBody = "Daily Quote set for "
        let germanNotificationEnabledTitle = "Tägliches Zitat"
        let germanNotificationEnabledBody = "Erinnerung eingestellt für "
        
        // Tuple in this format: (Hour, Minute)
        var reminderTimeInt: (Int, Int)? = nil
        let date = remindMeTime.date
        let dateFormatter = DateFormatter()
        dateFormatter.timeStyle = .short
        let timeString = dateFormatter.string(from: date)
        let components = Calendar.current.dateComponents([.hour, .minute], from: date)
        let hour = components.hour!
        let minute = components.minute!
        reminderTimeInt = (hour, minute)
        if hour < 12 {
            switch quoteModel!.userLanguage {
            case .English:
                notificationTitle = "Good Morning"
            case .Deutsch:
                notificationTitle = "Guten Morgen"
            }
        }
        else if hour < 18 {
            switch quoteModel!.userLanguage {
            case .English:
                notificationTitle = "Good Afternoon"
            case .Deutsch:
                notificationTitle = "Guten Tag"
            }
        }
        else {
            switch quoteModel!.userLanguage {
            case .English:
                notificationTitle = "Good Evening"
            case .Deutsch:
                notificationTitle = "Guten Abend"
            }
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
                                    let alert = UIAlertController(title: englishNotificationEnabledTitle, message: englishNotificationEnabledBody + timeString, preferredStyle: .alert)
                                    alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                                    self?.present(alert, animated: true)
                                case .Deutsch?:
                                    let alert = UIAlertController(title: germanNotificationEnabledTitle, message: germanNotificationEnabledBody + timeString, preferredStyle: .alert)
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
                    case .English?: self?.numQuotesLabel.text = "  \(self?.findNumQuotes() ?? 0) Quotes"
                    case .Deutsch?: self?.numQuotesLabel.text = "  \(self?.findNumQuotes() ?? 0) Zitate"
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
