//
//  MultipleSelectionStore.swift
//  QuizApp
//
//  Created by Саша Восколович on 22.03.2024.
//

import Foundation

struct MultipleSelectionStore {
    
    var options: [MultipleSelectionOption]
    var canSubmit: Bool {
        !options.filter(\.isSelected).isEmpty
    }
    
    private let handler: ([String]) -> Void
    
    
    init(options: [String], handler: @escaping ([String]) -> Void = { _ in }) {
        self.options = options.map { MultipleSelectionOption(text: $0) }
        self.handler = handler
    }
    
    func submit() {
        guard canSubmit else { return }
        handler(options.filter(\.isSelected).map(\.text))
    }
}


struct MultipleSelectionOption {
    let text: String
    var isSelected: Bool = false
    
    mutating func select() {
        isSelected.toggle()
    }
}
