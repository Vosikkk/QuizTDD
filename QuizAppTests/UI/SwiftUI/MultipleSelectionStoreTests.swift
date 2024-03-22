//
//  MultipleSelectionStoreTests.swift
//  QuizAppTests
//
//  Created by Саша Восколович on 22.03.2024.
//

import XCTest

struct MultipleSelectionStore {
    
    var options: [MultipleSelectionOption]
    var canSubmit: Bool {
        !options.filter(\.isSelected).isEmpty
    }
    
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

    func test_selectOption_togglesState() {
        
        var sut = MultipleSelectionStore(options: ["o0", "o1"])
        XCTAssertFalse(sut.options[0].isSelected)
        
        sut.options[0].select()
        XCTAssertTrue(sut.options[0].isSelected)
        
        sut.options[0].select()
        XCTAssertFalse(sut.options[0].isSelected)
    }
    
    func test_canSubmit_whenAtLeastOneOptionIsSelected() {
        
        var sut = MultipleSelectionStore(options: ["o0", "o1"])
        XCTAssertFalse(sut.canSubmit)
        
        sut.options[0].select()
        XCTAssertTrue(sut.canSubmit)
        
        sut.options[0].select()
        XCTAssertFalse(sut.canSubmit)
        
        sut.options[1].select()
        XCTAssertTrue(sut.canSubmit)
    }
}
