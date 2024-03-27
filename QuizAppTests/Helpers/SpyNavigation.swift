//
//  SpyNavigation.swift
//  QuizAppTests
//
//  Created by Саша Восколович on 27.03.2024.
//

import UIKit


class NonAnimatedNavigationController: UINavigationController {
    override func pushViewController(
        _ viewController: UIViewController,
        animated: Bool
    ) {
        super.pushViewController(viewController, animated: false)
    }
}



// Another way to test navigation
class SpyNavigation: UINavigationController {
    
    private(set) var pushMessages: [(viewController: UIViewController, animated: Bool)] = []

    override func pushViewController(
        _ viewController: UIViewController,
        animated: Bool
    ) {
        pushMessages.append((viewController, animated))
    }
}
