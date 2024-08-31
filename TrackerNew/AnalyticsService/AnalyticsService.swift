//
//  AnalyticsService.swift
//  TrackerNew
//
//  Created by gimon on 18.08.2024.
//

import Foundation
import AppMetricaCore

struct AnalyticsService {
    static func activate() {
        guard let configuration = AppMetricaConfiguration(apiKey: "6fd126b9-47de-433d-9aae-d30939293f52") else {
            print(#fileID, #function, #line, "AppMetricaConfiguration")
            return
        }
        
        AppMetrica.activate(with: configuration)
    }
    
    func report(event: String, params : [AnyHashable : Any]) {
        AppMetrica.reportEvent(name: event, parameters: params, onFailure: { error in
            print("DID FAIL REPORT EVENT: %@", params)
            print("REPORT ERROR: %@", error.localizedDescription)
        })
    }
}
