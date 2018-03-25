//
//  SafeTrek.swift
//  jackjamesjt
//
//  Created by Jack Morris on 3/24/18.
//  Copyright © 2018 Richard James Childress. All rights reserved.
//


import Alamofire

var api_endpoint_base = "https://api.safetrek.io/v1/"

func createAlarm(police: Bool, fire: Bool, medical: Bool, callback: (() -> String)) -> Void {
    let alarm_href = "alarms"
    let params : [String: Any] = [
        "services": [
            "police": true,
            "fire": false,
            "medical": false
        ],
        "location.coordinates": [
            "lat": 34.32334,
            "lng": -117.3343,
            "accuracy": 5
        ]
    ]
    makeSafeTrekRequest(href: alarm_href, params: params)
}

func getToken() -> String {
    return ""
}

func makeSafeTrekRequest(href: String, params: Dictionary<String, Any>) -> Void {
    let headers: HTTPHeaders = [
        "Authorization": "Bearer: " + getToken(),
        "Content-Type": "application/json"
    ]
    Alamofire.request(api_endpoint_base + href,  method: .post, parameters: params, headers: headers)
}
