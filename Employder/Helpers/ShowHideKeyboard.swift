//
//  ShowHideKeyboard.swift
//  Employder
//
//  Created by Serov Dmitry on 12.10.22.
//

//import UIKit
//
//class ShowHideKeyboard {
//
//    func setupKeyboardHidding(observer: Any) {
//        NotificationCenter.default.addObserver(observer, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
//        NotificationCenter.default.addObserver(observer, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
//    }
//
//    @objc func keyboardWillShow(VC: UIViewController, sender: NSNotification) {
//        guard let userInfo = sender.userInfo,
//              let keyboardFrame = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue,
//              let currentTextField = UIResponder.currentFirst() as? UITextField else { return }
//
//        let keyboardTopY = keyboardFrame.cgRectValue.origin.y
//        let convertedTextFieldFrame = VC.view.convert(currentTextField.frame, from: currentTextField.superview)
//        let textFieldBottomY = convertedTextFieldFrame.origin.y + convertedTextFieldFrame.size.height
//
//        if textFieldBottomY < keyboardTopY {
//            let textBoxY = convertedTextFieldFrame.origin.y
//            let newFrameY = (textBoxY - keyboardTopY / 2) * -1
//            VC.view.frame.origin.y = newFrameY
//        }
//    }
//
//    @objc func keyboardWillHide(VC: UIViewController, notification: NSNotification) {
//        VC.view.frame.origin.y = 0
//    }
//
//
//
//}
