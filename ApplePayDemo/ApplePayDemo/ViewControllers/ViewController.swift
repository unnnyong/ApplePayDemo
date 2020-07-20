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

// MARK: PKPaymentAuthorizationViewControllerDelegate
extension ViewController: PKPaymentAuthorizationViewControllerDelegate {

    func paymentAuthorizationViewControllerDidFinish(_ controller: PKPaymentAuthorizationViewController) {
        paymentStatusLabel.isHidden = false
    }

    func paymentAuthorizationViewController(
        _ controller: PKPaymentAuthorizationViewController,
        didAuthorizePayment payment: PKPayment,
        handler completion: @escaping (PKPaymentAuthorizationResult) -> Void
    ) {
        applePayButton.isHidden = true
        paymentStatusLabel.isHidden = false

        controller.dismiss(animated: true)
    }
}

// MARK: Private methods
private extension ViewController {

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

    @objc func presentToPaymentVC() {
        let item = PKPaymentSummaryItem(label: "삼겹살 500g", amount: NSDecimalNumber(integerLiteral: 10_000))
        let shippingMethod = PKShippingMethod(label: "미사일배송", amount: NSDecimalNumber(integerLiteral: 2_500))
        let summary = PKPaymentSummaryItem(label: "전체 금액", amount: NSDecimalNumber(integerLiteral: 12_500))

        let request = PKPaymentRequest()
        request.currencyCode = "KRW"
        request.countryCode = "JP" // "KR"은 아직 안됩니다 🥺
        request.supportedNetworks = [.amex, .visa, .masterCard]
        request.merchantCapabilities = .capability3DS
        request.merchantIdentifier = "merchant.com.example.applePay" // 임의의 Identifier value
        request.paymentSummaryItems = [item, shippingMethod, summary]

        request.shippingType = .shipping
        request.requiredShippingContactFields = [.postalAddress, .name, .phoneNumber, .emailAddress]

        // 회원의 경우에만 회원정보를 설정하면 된다.
        request.shippingContact = makeContact()

        guard let paymentViewController = PKPaymentAuthorizationViewController(paymentRequest: request) else { return }
        paymentViewController.delegate = self

        present(paymentViewController, animated: true)
    }

    func makeContact() -> PKContact {
        let userInfo = UserInfo.shared
        let contact = PKContact()

        contact.emailAddress = userInfo.email
        contact.phoneNumber = CNPhoneNumber(stringValue: userInfo.phoneNumber)

        var name = PersonNameComponents()
        name.givenName = userInfo.name
        contact.name = name

        let address = CNMutablePostalAddress()
        address.street = userInfo.address1
        contact.postalAddress = address

        return contact
    }

}
