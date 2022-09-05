//
//  CandidateCell.swift
//  Employder
//
//  Created by Serov Dmitry on 30.08.22.
//

import UIKit

class CandidateCell: UICollectionViewCell, SelfConfiguringCell {

    
    
    static var reuseId: String = "CandidateCell"
    
    let userName = UILabel(text: "", font: .systemFont(ofSize: 28, weight: .light))
    let userImageView = UIImageView()
    let containerView = UIView()
    let aboutMe = UILabel()
    let aboutMeHeader = UILabel.init(text: "Обо мне:", font: .systemFont(ofSize: 18, weight: .light))
    let experience = UILabel.init(text: "", font: .systemFont(ofSize: 18, weight: .ultraLight))
    let speciality = UILabel.init(text: "", font: .systemFont(ofSize: 18, weight: .light))
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupConstrints()
        backgroundColor = .white
        
        self.layer.cornerRadius = 10
        
        self.layer.shadowColor = UIColor.gray.cgColor
        self.layer.shadowRadius = 3
        self.layer.shadowOpacity = 0.5
        self.layer.shadowOffset = CGSize(width: 0, height: 4)
        
        
        
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        //self.containerView.layer.cornerRadius = 100
        //self.containerView.clipsToBounds = true
    }
    
    func configur<U>(with value: U) where U : Hashable {
        guard let userss: MCandidate = value as? MCandidate else { return }
        userImageView.image = UIImage(named: userss.avatarStringURL)
        userImageView.contentMode = .scaleAspectFill
        userImageView.layer.cornerRadius = 40
        userImageView.clipsToBounds = true
        userName.text = userss.userName
        userName.numberOfLines = 0
        aboutMe.text = userss.aboutMe
        aboutMe.numberOfLines = 4
        experience.text = "Опыт работы \(userss.experience) года"
        speciality.text = userss.speciality

    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

//MARK: - Setup constraints

extension CandidateCell {
    
    private func setupConstrints() {
        userName.translatesAutoresizingMaskIntoConstraints = false
        userImageView.translatesAutoresizingMaskIntoConstraints = false
        containerView.translatesAutoresizingMaskIntoConstraints = false
        aboutMe.translatesAutoresizingMaskIntoConstraints = false
        aboutMeHeader.translatesAutoresizingMaskIntoConstraints = false
        experience.translatesAutoresizingMaskIntoConstraints = false
        speciality.translatesAutoresizingMaskIntoConstraints = false
        
        addSubview(containerView)
        containerView.addSubview(userImageView)
        containerView.addSubview(userName)
        containerView.addSubview(aboutMe)
        containerView.addSubview(aboutMeHeader)
        containerView.addSubview(experience)
        containerView.addSubview(speciality)
                
        NSLayoutConstraint.activate([
            containerView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            containerView.topAnchor.constraint(equalTo: self.topAnchor),
            containerView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            containerView.bottomAnchor.constraint(equalTo: self.bottomAnchor)
        ])
        
        NSLayoutConstraint.activate([
            userImageView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 8),
            userImageView.topAnchor.constraint(equalTo: self.topAnchor, constant: 8),
            userImageView.widthAnchor.constraint(equalToConstant: 80),
            userImageView.heightAnchor.constraint(equalToConstant: 80)
        ])
        
        NSLayoutConstraint.activate([
            userName.leadingAnchor.constraint(equalTo: userImageView.trailingAnchor, constant: 16),
            userName.topAnchor.constraint(equalTo: self.topAnchor, constant: 8),
            //userName.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            userName.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -8)
        ])
        
        NSLayoutConstraint.activate([
            aboutMe.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 20),
            aboutMe.topAnchor.constraint(equalTo: self.topAnchor, constant: 130),
            //aboutMe.bottomAnchor.constraint(equalTo: self.bottomAnchor. constant: 24),
            aboutMe.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -16)
        ])
        
        NSLayoutConstraint.activate([
            aboutMeHeader.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 16),
            aboutMeHeader.topAnchor.constraint(equalTo: self.topAnchor, constant: 96),
            //userName.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            aboutMeHeader.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -8)
        ])
        
        NSLayoutConstraint.activate([
            experience.leadingAnchor.constraint(equalTo: userImageView.trailingAnchor, constant: 16),
            experience.topAnchor.constraint(equalTo: speciality.bottomAnchor, constant: 4),
            //userName.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            experience.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -8)
        ])
        
        NSLayoutConstraint.activate([
            speciality.leadingAnchor.constraint(equalTo: userImageView.trailingAnchor, constant: 16),
            speciality.topAnchor.constraint(equalTo: userName.bottomAnchor, constant: 2),
            //userName.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            speciality.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -8)
        ])
        
    }
}

//MARK: - SwiftUI

import SwiftUI

struct CandidateCellProvider: PreviewProvider {
    static var previews: some View {
        ContainerView().edgesIgnoringSafeArea(.all)
    }
    
    struct ContainerView: UIViewControllerRepresentable {
        
        let tabBarVC = MainTabBarController()
        
        func makeUIViewController(context: UIViewControllerRepresentableContext<CandidateCellProvider.ContainerView>) -> MainTabBarController {
            return tabBarVC
        }
        
        func updateUIViewController(_ uiViewController: CandidateCellProvider.ContainerView.UIViewControllerType, context: UIViewControllerRepresentableContext<CandidateCellProvider.ContainerView>) {
            
        }
    }
}
