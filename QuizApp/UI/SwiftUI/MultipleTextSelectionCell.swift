//
//  MultipleTextSelectionCell.swift
//  QuizApp
//
//  Created by Саша Восколович on 23.03.2024.
//

import SwiftUI

struct MultipleTextSelectionCell: View {

    
    @Binding var option: MultipleSelectionOption
    
    
    var body: some View {
        Button(action: { option.select() } , label: {
            HStack {
                Rectangle()
                    .strokeBorder(lineWidth: Constants.Size.rectLineWidth)
                    .frame(width: Constants.Size.rectWidth, height: Constants.Size.rectHeight)
                    .overlay(
                        Rectangle()
                            .fill(option.isSelected ? .blue : .clear)
                            .frame(width: Constants.Size.innerRectWidth, height:  Constants.Size.innerRectHeight)
                    )
                
                Text(option.text)
                    .font(.title)
                Spacer()
            }
            .foregroundStyle(option.isSelected ? .blue : .secondary)
            .padding(.leading, Constants.leadingInset)
            .padding(.top, Constants.topInset)
        })
        .tint(.secondary)
    }
    
    private struct Constants {
        static let leadingInset: CGFloat = 15
        static let topInset: CGFloat = 20
        
        struct Size {
            static let innerRectWidth: CGFloat = 26
            static let innerRectHeight: CGFloat = 26
            static let rectLineWidth: CGFloat = 2.5
            static let rectWidth: CGFloat = 40
            static let rectHeight: CGFloat = 40
        }
    }
}


#Preview {
    VStack {
        MultipleTextSelectionCell(option: .constant(.init(text: "Test", isSelected: false)))
        MultipleTextSelectionCell(option: .constant(.init(text: "Test", isSelected: true)))
    }
}
