//
//  MultipleSelectionStoreTests.swift
//  QuizAppTests
//
//  Created by Саша Восколович on 22.03.2024.
//

import XCTest

struct MultipleSelectionStore {
    var options: [MultipleSelectionOption]
    
    init(options: [String]) {
        self.options = options.map { MultipleSelectionOption(text: $0) }
    }
}

struct MultipleSelectionOption {
    let text: String
    var isSelected: Bool = false
    
    mutating func select() {
        isSelected.toggle()
    }
}


final class MultipleSelectionStoreTests: XCTestCase {

    func test() {
        
        var sut = MultipleSelectionStore(options: ["o0", "o1"])
        XCTAssertFalse(sut.options[0].isSelected)
        
        sut.options[0].select()
        XCTAssertTrue(sut.options[0].isSelected)
        
        sut.options[0].select()
        XCTAssertFalse(sut.options[0].isSelected)
    }
}
