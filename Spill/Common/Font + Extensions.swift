//
//  Font + Extensions.swift
//  Spill
//
//  Created by User on 2025-01-10.
//

import SwiftUI

extension Font {
    static func gilroyMedium(size: CGFloat) -> Font {
        return .custom("Gilroy-Medium", size: size)
    }
    
    // Commonly used preset sizes
    static let gilroyMedium10: Font = .gilroyMedium(size: 10)
    static let gilroyMedium12: Font = .gilroyMedium(size: 12)
    static let gilroyMedium14: Font = .gilroyMedium(size: 14)
    static let gilroyMedium16: Font = .gilroyMedium(size: 16)
    static let gilroyMedium18: Font = .gilroyMedium(size: 18)
    static let gilroyMedium20: Font = .gilroyMedium(size: 20)
}
