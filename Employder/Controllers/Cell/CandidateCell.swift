//
//  CandidateCell.swift
//  Employder
//
//  Created by Serov Dmitry on 30.08.22.
//

import UIKit
import SDWebImage

class CandidateCell: UICollectionViewCell, SelfConfiguringCell {

    static var reuseId: String = "CandidateCell"

    let userName = UILabel(text: "", font: .systemFont(ofSize: 28, weight: .light))
    let userImageView = UIImageView()
    let containerView = UIView()
    let aboutMe = UILabel()
    let aboutMeHeader = UILabel.init(text: "Обо мне:", font: .systemFont(ofSize: 18, weight: .light))
    let experience = UILabel.init(text: "", font: .systemFont(ofSize: 18, weight: .ultraLight))
    let speciality = UILabel.init(text: "", font: .systemFont(ofSize: 18, weight: .light))

    // MARK: - init

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

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func prepareForReuse() {
        userImageView.image = nil
    }

    // MARK: - Setups

    func configur<U>(with value: U) where U: Hashable {
        guard let user: MUser = value as? MUser else { return }
        userImageView.image = UIImage(named: user.avatarStringURL)
        userImageView.contentMode = .scaleAspectFill
        userImageView.layer.cornerRadius = 40
        userImageView.clipsToBounds = true
        userName.text = user.userName
        userName.numberOfLines = 0
        aboutMe.text = user.description
        aboutMe.numberOfLines = 4
        guard let url = URL(string: user.avatarStringURL) else { return }
        userImageView.sd_setImage(with: url)
    }
}

// MARK: - Setup constraints

extension CandidateCell {

    private func setupConstrints() {
        // tAMIC
        disablingTAMIC()

        // addSubviews
        addSubview(containerView)
        containerView.addSubview(userImageView)
        containerView.addSubview(userName)
        containerView.addSubview(aboutMe)
        containerView.addSubview(aboutMeHeader)
        containerView.addSubview(experience)
        containerView.addSubview(speciality)

        // Constraints
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
            userName.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -8)
        ])

        NSLayoutConstraint.activate([
            aboutMe.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 20),
            aboutMe.topAnchor.constraint(equalTo: self.topAnchor, constant: 130),
            aboutMe.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -16)
        ])

        NSLayoutConstraint.activate([
            aboutMeHeader.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 16),
            aboutMeHeader.topAnchor.constraint(equalTo: self.topAnchor, constant: 96),
            aboutMeHeader.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -8)
        ])

        NSLayoutConstraint.activate([
            experience.leadingAnchor.constraint(equalTo: userImageView.trailingAnchor, constant: 16),
            experience.topAnchor.constraint(equalTo: speciality.bottomAnchor, constant: 4),
            experience.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -8)
        ])

        NSLayoutConstraint.activate([
            speciality.leadingAnchor.constraint(equalTo: userImageView.trailingAnchor, constant: 16),
            speciality.topAnchor.constraint(equalTo: userName.bottomAnchor, constant: 2),
            speciality.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -8)
        ])
    }

    private func disablingTAMIC() {
        userName.translatesAutoresizingMaskIntoConstraints = false
        userImageView.translatesAutoresizingMaskIntoConstraints = false
        containerView.translatesAutoresizingMaskIntoConstraints = false
        aboutMe.translatesAutoresizingMaskIntoConstraints = false
        aboutMeHeader.translatesAutoresizingMaskIntoConstraints = false
        experience.translatesAutoresizingMaskIntoConstraints = false
        speciality.translatesAutoresizingMaskIntoConstraints = false
    }
}

// MARK: - SwiftUI

import SwiftUI

struct CandidateCellProv: PreviewProvider {
    static var previews: some View {
        ContainerView().edgesIgnoringSafeArea(.all)
    }

    struct ContainerView: UIViewControllerRepresentable {

        let tabBarVC = MainTabBarController()

        func makeUIViewController(
            context: UIViewControllerRepresentableContext<CandidateCellProv.ContainerView>) -> MainTabBarController {
            return tabBarVC
        }

        func updateUIViewController(_ uiViewController: CandidateCellProv.ContainerView.UIViewControllerType,
                                    context: UIViewControllerRepresentableContext<CandidateCellProv.ContainerView>) {

        }
    }
}
