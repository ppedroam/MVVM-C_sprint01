//
//  Handlers.swift
//  mvvmcDevSprint
//
//  Created by Pedro Menezes on 06/10/22.
//

import Foundation
import UIKit

protocol ExternalToolHandling {
    var whatsappHandler: WhatsappUseCasing { get }
    var telephoneHandler: TelephoneHandling { get }
    var youtubeHandler: YoutubeHandling { get }
    var linkedinHandler: LinkedinHandling { get }
    var mediumHandler: MediumHandling { get }
}

struct ExternalToolHandler: ExternalToolHandling {
    var whatsappHandler: WhatsappUseCasing {
        return WhatsappUseCase()
    }
    var telephoneHandler: TelephoneHandling {
        return TelephoneHandler()
    }
    
    var youtubeHandler: YoutubeHandling {
        return YoutubeHandler()
    }
    
    var linkedinHandler: LinkedinHandling {
        return LinkedinHandler()
    }
    
    var mediumHandler: MediumHandling {
        return MediumHandler()
    }
}


protocol WhatsappUseCasing {
    func openWhatsapp(with whatsapp: String, errorCompletion: ()->Void)
}

struct WhatsappUseCase: WhatsappUseCasing {
    func openWhatsapp(with whatsapp: String, errorCompletion: ()->Void) {
        let application = UIApplication.shared
        let urlString =  "https://wa.me/\(whatsapp)"
        if let appURL = URL(string: urlString),
           application.canOpenURL(appURL) {
            application.open(appURL, options: [:], completionHandler: nil)
        } else {
            errorCompletion()
        }
    }
}

protocol TelephoneHandling {
    func openTelephone(with telephone: String, errorCompletion: ()->Void)
}

struct TelephoneHandler: TelephoneHandling {
    private let application = UIApplication.shared
    
    func openTelephone(with telephone: String, errorCompletion: ()->Void) {
        if let url = URL(string: "tel://\(telephone)"),
           application.canOpenURL(url) {
            if #available(iOS 10, *) {
                UIApplication.shared.open(url, options: [:], completionHandler:nil)
            } else {
                UIApplication.shared.openURL(url)
            }
        } else {
            errorCompletion()
        }
    }
}

protocol YoutubeHandling {
    func openYoutube(with youtubeID: String)
}

struct YoutubeHandler: YoutubeHandling {
    func openYoutube(with youtubeID: String) {
        guard var url = URL(string:"youtube://\(youtubeID)") else {
            return
        }
        if !UIApplication.shared.canOpenURL(url)  {
            if let url_ = URL(string:"https://www.youtube.com/channel/\(youtubeID)") {
                url = url_
            }
        }
        UIApplication.shared.open(url, options: [:], completionHandler: nil)
    }
}

protocol LinkedinHandling {
    func openLinkedin(with username: String)
}

struct LinkedinHandler: LinkedinHandling {
    func openLinkedin(with username: String) {
        guard let appURL = URL(string: "linkedin://profile/\(username)") else { return }
        let application = UIApplication.shared
        
        if application.canOpenURL(appURL) {
            application.open(appURL)
        } else {
            guard let webURL = URL(string: "http://www.linkedin.com/profile/\(username)") else {
                return
            }
            application.open(webURL)
        }
    }
}

protocol MediumHandling {
    func openMedium(with urlString: String)
}

struct MediumHandler: MediumHandling {
    func openMedium(with urlString: String) {
        let application = UIApplication.shared
        guard let webURL = URL(string: urlString) else { return }
        application.open(webURL)
    }
}
