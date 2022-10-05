//
//  SetupProfileViewController.swift
//  Employder
//
//  Created by Serov Dmitry on 10.08.22.
//

import UIKit
import FirebaseAuth
import SDWebImage
import PhotosUI

class SetupProfileViewController: UIViewController {
    
    let welcomeLabel = UILabel(text: "Set up profile", font: .avenir26())
    let fullNameLabel = UILabel(text: "Full name")
    let aboutMeLabel = UILabel(text: "About me")
    let sexLabel = UILabel(text: "Sex")
    
    let fullNameTextField = OneLineTextField(font: .avenir20())
    let aboutMeTextField = OneLineTextField(font: .avenir20())
    
    let fullAddPhotoView = AddPhotoView()
    
    let sexSelector = UISegmentedControl(first: "Male", second: "Female")
    
    let goToChatButton = UIButton(title: "Go to chats!", titleColor: .white, backgroundColor: .buttonBlack())
    
    private let currentUser: User
    
    init (currentUser: User) {
        self.currentUser = currentUser
        super.init(nibName: nil, bundle: nil)
        
        //TODO: set google image
        if let photoURL = currentUser.photoURL {
            fullAddPhotoView.circleImageView.sd_setImage(with: photoURL)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        setupConstraints()
        
        goToChatButton.addTarget(self, action: #selector(goToChatButtonTapped), for: .touchUpInside)
        fullAddPhotoView.plusButton.addTarget(self, action: #selector(plusButtonTapped), for: .touchUpInside)
    }
    
    @objc private func plusButtonTapped() {
        var config = PHPickerConfiguration(photoLibrary: .shared())
        config.selectionLimit = 1
        config.filter = .images
        let vc = PHPickerViewController(configuration: config)
        vc.delegate = self
        self.present(vc, animated: true)
    }
    
    @objc private func goToChatButtonTapped() {
        FirebaseService.shared.saveProfileWith(
            id: currentUser.uid,
            email: currentUser.email!,
            userName: fullNameTextField.text,
            avatarImage: fullAddPhotoView.circleImageView.image,
            description: aboutMeTextField.text,
            sex: sexSelector.titleForSegment(at: sexSelector.selectedSegmentIndex)) { (result) in
                switch result {
                case .success(let mcandidate):
                    self.showAlert(with: "Успешно", and: "Вы заполнили профиль!") {
                        let mainTabBar = MainTabBarController()
                        mainTabBar.modalPresentationStyle = .fullScreen
                        self.present(mainTabBar, animated: true)
                    }
                    print(mcandidate)
                case .failure(let error):
                    self.showAlert(with: "Ошибка", and: error.localizedDescription)
                }
            }
    }
}
    
// MARK: - PHPickerViewControllerDelegate

extension SetupProfileViewController: PHPickerViewControllerDelegate {
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        picker.dismiss(animated: true)
        
        results.forEach { result in
            result.itemProvider.loadObject(ofClass: UIImage.self) { reading, error in
                guard let image = reading as? UIImage, error == nil else {
                    return
                }
                DispatchQueue.main.async {
                    self.fullAddPhotoView.circleImageView.image = image
                }
            }
        }
    }
}

//MARK: - Setup constraints

extension SetupProfileViewController {
    
    private func setupConstraints() {
        
        let fullNameStackView = UIStackView(arrangedSubviews: [fullNameLabel,fullNameTextField],
                                            axis: .vertical,
                                            spacing: 8)
        let aboutMeStackView = UIStackView(arrangedSubviews: [aboutMeLabel,aboutMeTextField],
                                           axis: .vertical,
                                           spacing: 8)
        let sexStackView = UIStackView(arrangedSubviews: [sexLabel,sexSelector],
                                       axis: .vertical,
                                       spacing: 8)
        
        let stackView = UIStackView(arrangedSubviews: [fullNameStackView, aboutMeStackView, sexStackView, goToChatButton],
                                    axis: .vertical,
                                    spacing: 40)
        
        welcomeLabel.translatesAutoresizingMaskIntoConstraints = false
        fullAddPhotoView.translatesAutoresizingMaskIntoConstraints = false
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(welcomeLabel)
        view.addSubview(fullAddPhotoView)
        view.addSubview(stackView)
        
        goToChatButton.heightAnchor.constraint(equalToConstant: 60).isActive = true
        
        NSLayoutConstraint.activate([
            welcomeLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 100),
            welcomeLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
        
        NSLayoutConstraint.activate([
            fullAddPhotoView.topAnchor.constraint(equalTo: welcomeLabel.bottomAnchor, constant: 40),
            fullAddPhotoView.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
        
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: fullAddPhotoView.bottomAnchor, constant: 50),
            stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 40),
            stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -40)
        ])
    }
}
//MARK: - SwiftUI

import SwiftUI

struct SetupProfileVCProvider: PreviewProvider {
    static var previews: some View {
        ContainerView().edgesIgnoringSafeArea(.all)
    }
    
    struct ContainerView: UIViewControllerRepresentable {
        
        let setupProfileVC = SetupProfileViewController(currentUser: Auth.auth().currentUser!)
        
        func makeUIViewController(context: UIViewControllerRepresentableContext<SetupProfileVCProvider.ContainerView>) -> SetupProfileViewController {
            return setupProfileVC
        }
        
        func updateUIViewController(_ uiViewController: SetupProfileVCProvider.ContainerView.UIViewControllerType, context: UIViewControllerRepresentableContext<SetupProfileVCProvider.ContainerView>) {
        }
    }
}