//
//  Extensions.swift
//  CashFlow
//
//  Created by EMRE ÇOBAN on 30.01.2026.
//

import Foundation

extension Double {
    func asCurrency() -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency // Format para birimi olsun
        formatter.locale = Locale.current // Telefon dili neyse o para birimini kullan
        
        // Türkiyede ₺ simgesi sağ tarafta olduğu için eğer telefon dili Türkiye ise "₺" simgesi sağ tarafta gözükecek,
        // diğer para birimleri sol tarafta kalmaya devam edecek
        if formatter.currencyCode == "TRY" {
            formatter.positiveFormat = "#,##0.00 ¤"
            formatter.negativeFormat = "-#,##0.00 ¤"
        }
        
        return formatter.string(from: NSNumber(value: self)) ?? "\(self)"
    }
}
