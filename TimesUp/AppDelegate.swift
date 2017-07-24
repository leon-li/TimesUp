//
//  AppDelegate.swift
//  TimesUp
//
//  Created by Lirong Li on 24/7/17.
//  Copyright © 2017 -. All rights reserved.
//

import Cocoa

struct TimesUpNotification: Decodable {
    let title: String
    let description: String
    let repeatInSeconds: Double
}

struct Config: Decodable {
    let notifications: [TimesUpNotification]
}

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {

    func applicationDidFinishLaunching(_ aNotification: Notification) {
        NSUserNotificationCenter.default.delegate = self
        
        if let path = Bundle.main.path(forResource: "config", ofType: "json") {
            do {
                let data = try Data(contentsOf: URL(fileURLWithPath: path))
                let config = try JSONDecoder().decode(Config.self, from: data)
                for notification in config.notifications {
                    if notification.repeatInSeconds > 0 {
                        Timer.scheduledTimer(withTimeInterval: notification.repeatInSeconds, repeats: true, block: { (timer) in
                            self.post(timesUpNotification: notification)
                        })
                    } else {
                        self.post(timesUpNotification: notification)
                    }
                }
            } catch let e {
                print(e)
            }
        }
        
    }

    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
    }
    
    func post(timesUpNotification: TimesUpNotification) {
        let center = NSUserNotificationCenter.default
        let notification = NSUserNotification()
        notification.title = timesUpNotification.title
        notification.informativeText = timesUpNotification.description
        notification.soundName = NSUserNotificationDefaultSoundName;
        center.deliver(notification)
    }
}


extension AppDelegate: NSUserNotificationCenterDelegate {
    func userNotificationCenter(_ center: NSUserNotificationCenter, shouldPresent notification: NSUserNotification) -> Bool {
        return true
    }
}
