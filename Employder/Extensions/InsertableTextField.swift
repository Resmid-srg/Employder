//
//  InsertableTextField.swift
//  Employder
//
//  Created by Serov Dmitry on 31.08.22.
//

import UIKit

class InsertableTextField: UITextField {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = .white
        placeholder = "Напишите что-нибудь..."
        font = UIFont.systemFont(ofSize: 19)
        clearButtonMode = .whileEditing
        borderStyle = .none
        layer.cornerRadius = 18
        layer.masksToBounds = true
        
        let image = UIImage(systemName: "face.smiling")
        let imageView = UIImageView(image: image)
        imageView.setupColor(color: .lightGray)
        
        leftView = imageView
        leftView?.frame = CGRect(x: 2, y: 2, width: 20, height: 20)
        leftViewMode = .always
        
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "arrow.up.circle"), for: .normal)
        button.applyGradients(cornerRadius: 10)
        
        rightView = button
        rightView?.frame = CGRect(x: 0, y: 0, width: 20, height: 20)
        rightViewMode = .always
    }
    
    override func textRect(forBounds: CGRect) -> CGRect {
        return bounds.insetBy(dx: 46, dy: -26)
    }
    
    override func placeholderRect(forBounds: CGRect) -> CGRect {
        return bounds.insetBy(dx: 40, dy: 0)
    }
    
    override func editingRect(forBounds: CGRect) -> CGRect {
        return bounds.insetBy(dx: 38, dy: 0)
    }
    
    override func leftViewRect(forBounds bounds: CGRect) -> CGRect {
        var rect = super.leftViewRect(forBounds: bounds)
        rect.origin.x += 12
        return rect
    }
    
    override func rightViewRect(forBounds bounds: CGRect) -> CGRect {
        var rect = super.rightViewRect(forBounds: bounds)
        rect.origin.x += -12
        return rect
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

//MARK: - SwiftUI

import SwiftUI

struct TextFieldProvider: PreviewProvider {
    static var previews: some View {
        ContainerView().edgesIgnoringSafeArea(.all)
    }
    
    struct ContainerView: UIViewControllerRepresentable {
        
        let profileVC = ProfileViewController()
        
        func makeUIViewController(context: UIViewControllerRepresentableContext<TextFieldProvider.ContainerView>) -> ProfileViewController {
            return profileVC
        }
        
        func updateUIViewController(_ uiViewController: TextFieldProvider.ContainerView.UIViewControllerType, context: UIViewControllerRepresentableContext<TextFieldProvider.ContainerView>) {
            
        }
    }
}
