//
//  Extension + String.swift
//  Tracker
//
//  Created by Максим белов on 06.03.2024.
//

import Foundation

extension String{
    func localized() -> String {
        NSLocalizedString(self, tableName: "Localizable", bundle: .main, value: self, comment: self)
    }
}
