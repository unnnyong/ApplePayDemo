//
//  ViewController.swift
//  ApplePayDemo
//
//  Created by Eunyeong Kim on 2020/07/20.
//  Copyright © 2020 Eunyeong Kim. All rights reserved.
//

import UIKit
import PassKit

final class ViewController: UIViewController {

    @IBOutlet private weak var paymentStatusLabel: UILabel!

    private let applePayButton = PKPaymentButton(paymentButtonType: .buy, paymentButtonStyle: .black)

    override func viewDidLoad() {
        super.viewDidLoad()

        setupApplePayButton()
    }

}

// MARK: Private methods
private extension ViewController {

    @objc func presentToPaymentVC() {}

    func setupApplePayButton() {
        view.addSubview(applePayButton)

        applePayButton.translatesAutoresizingMaskIntoConstraints = false

        [
            applePayButton.centerXAnchor.constraint(
                equalToSystemSpacingAfter: view.centerXAnchor,
                multiplier: 0.0
            ),
            applePayButton.centerYAnchor.constraint(
                equalToSystemSpacingBelow: view.centerYAnchor,
                multiplier: 0.0
            )
        ].forEach { constraint in
            constraint.isActive = true
        }

        applePayButton.addTarget(self, action: #selector(presentToPaymentVC), for: .touchUpInside)
    }

}
