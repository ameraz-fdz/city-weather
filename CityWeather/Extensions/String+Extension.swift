//
//  String+Extension.swift
//  CityWeather
//
//  Created by Alex Meraz on 10/3/24.
//

import Foundation

extension String {
    func urlEncoded() -> String {
        return self.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? self
    }
}
