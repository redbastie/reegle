//
//  SearchTextField.swift
//  Reegle
//
//  Created by Kevin Dion on 2020-08-09.
//  Copyright © 2020 redbastie. All rights reserved.
//

import SwiftUI

struct SearchTextField: UIViewRepresentable {
    @Binding var text: String
    @Binding var showResults: Bool
    
    class Coordinator: NSObject, UITextFieldDelegate {
        @Binding var text: String
        @Binding var showResults: Bool
        var didBecomeFirstResponder = false
        
        init(text: Binding<String>, showResults: Binding<Bool>) {
            _text = text
            _showResults = showResults
        }
        
        func textFieldDidChangeSelection(_ textField: UITextField) {
            text = textField.text ?? ""
        }
        
        func textFieldShouldReturn(_ textField: UITextField) -> Bool {
            let text = textField.text ?? ""
            
            if (text != "") {
                showResults = true
            }
            
            return false
        }
    }
    
    func makeUIView(context: UIViewRepresentableContext<SearchTextField>) -> UITextField {
        let textField = UITextField()
        
        textField.placeholder = "Search"
        textField.returnKeyType = .search
        textField.autocapitalizationType = .none
        textField.delegate = context.coordinator
        
        return textField
    }
    
    func makeCoordinator() -> SearchTextField.Coordinator {
        return Coordinator(text: $text, showResults: $showResults)
    }
    
    func updateUIView(_ uiView: UITextField, context: UIViewRepresentableContext<SearchTextField>) {
        uiView.text = text
        
        if !context.coordinator.didBecomeFirstResponder  {
            uiView.becomeFirstResponder()
            context.coordinator.didBecomeFirstResponder = true
        }
    }
}
