//
//  RoundedButton.swift
//  QuizApp
//
//  Created by Саша Восколович on 23.03.2024.
//

import SwiftUI

struct RoundedButton: View {
    
    let title: String
    let isEnabled: Bool
    let action: () -> Void
    
    init(title: String, isEnabled: Bool = true, action: @escaping () -> Void) {
        self.title = title
        self.isEnabled = isEnabled
        self.action = action
    }
    
    var body: some View {
        Button {
            action()
        } label: {
            Text(title)
                .foregroundStyle(.white)
                .hAlign(.center)
                .fillView(.blue)
        }
        .buttonStyle(PlainButtonStyle())
        .disabled(!isEnabled)
    }
}

#Preview {
    RoundedButton(title: "Submit", action: { })
}
