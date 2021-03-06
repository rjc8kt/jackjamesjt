//
//  SafeTrek.swift
//  jackjamesjt
//
//  Created by Jack Morris on 3/24/18.
//  Copyright © 2018 Richard James Childress. All rights reserved.
//


import Alamofire

// var api_endpoint_base = "https://api.safetrek.io/v1/"
var api_endpoint_base = "https://api-sandbox.safetrek.io/v1/"

class SafeTrekAPI {

    func getToken() -> String {
        return UserDefaults.init().string(forKey: "ACCESS_TOKEN") ?? ""
    }

    func createAlarm(police: Bool, fire: Bool, medical: Bool, lat: Double, lon: Double, callback: (() -> String)) -> Void {
        let alarm_href = "alarms"
        let params : [String: Any] = [
            "services": [
                "police": police,
                "fire": fire,
                "medical": medical
            ],
            "location.coordinates": [
                "lat": lat,
                "lng": lon,
                "accuracy": 5
            ]
        ]
        print ("making request with params", params)
        makeSafeTrekRequest(href: alarm_href, params: params)
    }

    func makeSafeTrekRequest(href: String, params: Dictionary<String, Any>) -> Void {
        print ("token ", getToken())
        let headers: HTTPHeaders = [
            "Authorization": "Bearer: " + getToken(),
            "Content-Type": "application/json"
        ]
        Alamofire.request(api_endpoint_base + href,  method: .post, parameters: params, headers: headers)
    }
}
