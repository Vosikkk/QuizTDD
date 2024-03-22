//
//  SingleTextSelectionCell.swift
//  QuizApp
//
//  Created by Саша Восколович on 22.03.2024.
//

import SwiftUI

struct SingleTextSelectionCell: View {
    
    let text: String
    let selection: () -> Void
    
    var body: some View {
        Button(action: selection, label: {
            HStack {
                Circle()
                    .stroke(Color.secondary, lineWidth: Constants.Size.circleLineWidth)
                    .frame(width: Constants.Size.circleWidth, height: Constants.Size.circleHeight)
                
                Text(text)
                    .font(.title)
                Spacer()
            }
            .padding(.leading, Constants.leadingInset)
            .padding(.top, Constants.topInset)
        })
        .tint(.secondary)
    }
    
    private struct Constants {
        static let leadingInset: CGFloat = 10
        static let topInset: CGFloat = 20
        
        struct Size {
            static let circleLineWidth: CGFloat = 2.5
            static let circleWidth: CGFloat = 40
            static let circleHeight: CGFloat = 40
        }
    }
}


#Preview {
    SingleTextSelectionCell(text: "You", selection: {})
}
