//
//  AppLabel.swift
//  ios-coin-pedia
//
//  Created by Goo on 3/8/25.
//

import UIKit

final class AppLabel: UILabel {

    init(_ font: AppFont, _ color: AppColor = .navy) {
        super.init(frame: .zero)
        self.font = font.value
        self.textColor = color.value
    }
    
    func setLineSpacing(_ spacing: CGFloat) {
        guard let text else { return }
        
        let attributeString = NSMutableAttributedString(string: text)
        let style = NSMutableParagraphStyle()
        style.lineSpacing = spacing
        style.alignment = textAlignment
        attributeString.addAttribute(
            .paragraphStyle,
            value: style,
            range: NSRange(location: 0, length: attributeString.length)
        )
        attributedText = attributeString
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
