//
//  _TVOSTextView.swift
//  SwiftPackageListUI
//
//  Created by Felix Herrmann on 06.03.22.
//

#if canImport(SwiftUI) && os(tvOS)

import SwiftUI

/// Text in ScrollView is not working on tvOS due to the focus system.
@available(tvOS 13.0, *)
internal struct _TVOSTextView: UIViewRepresentable {
    internal var _text: String
    
    internal func makeUIView(context: Context) -> UITextView {
        let textView = UITextView()
        textView.isSelectable = true
        textView.isScrollEnabled = true
        textView.isUserInteractionEnabled = true
        textView.panGestureRecognizer.allowedTouchTypes = [NSNumber(value: UITouch.TouchType.indirect.rawValue)]
        textView.font = .preferredFont(forTextStyle: .caption1)
        textView.textColor = .secondaryLabel
        textView.textAlignment = .center
        return textView
    }
    
    internal func updateUIView(_ uiView: UITextView, context: Context) {
        uiView.text = _text
    }
}

#endif // canImport(SwiftUI) && os(tvOS)
