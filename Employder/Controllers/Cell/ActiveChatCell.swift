//
//  ActiveChatCell.swift
//  Employder
//
//  Created by Serov Dmitry on 24.08.22.
//

import UIKit
import SDWebImage

class ActiveChatCell: UICollectionViewCell, SelfConfiguringCell {

    static var reuseId: String = "ActiveChatCell"

    let friendImageView = UIImageView()
    let friendName = UILabel(text: "User Name", font: .laoShangamMN20())
    let friendLastMessage = UILabel(text: "user message ", font: .laoShangamMN18())
    let gradientView = GradientView(fromPoint: .topTrailing,
                                    toPoint: .bottomLeading,
                                    startColor: .gradientColor1(),
                                    endColor: .gradientColor2())

    // MARK: - init

    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .white
        setupConstraints()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Setups

    func configur<U>(with value: U) where U: Hashable {
        guard let chat: MChat = value as? MChat else { return }
        friendImageView.sd_setImage(with: URL(string: chat.friendUserImageStringURL))
        friendImageView.contentMode = .scaleAspectFill
        friendImageView.layer.cornerRadius = 39
        friendImageView.clipsToBounds = true
        friendName.text = chat.friendUserName
        friendLastMessage.text = chat.lastMessageContent
        gradientView.layer.cornerRadius = 8
        gradientView.clipsToBounds = true
    }
}

// MARK: - Setup constraints

extension ActiveChatCell {

    private func setupConstraints() {

        // tAMIC
        friendImageView.translatesAutoresizingMaskIntoConstraints = false
        friendName.translatesAutoresizingMaskIntoConstraints = false
        friendLastMessage.translatesAutoresizingMaskIntoConstraints = false
        gradientView.translatesAutoresizingMaskIntoConstraints = false

        // addSubviews
        addSubview(friendImageView)
        addSubview(friendName)
        addSubview(friendLastMessage)
        addSubview(gradientView)

        // Constarints
        NSLayoutConstraint.activate([
            friendImageView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            friendImageView.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            friendImageView.widthAnchor.constraint(equalToConstant: 78),
            friendImageView.heightAnchor.constraint(equalToConstant: 78)
        ])

        NSLayoutConstraint.activate([
            friendName.topAnchor.constraint(equalTo: self.topAnchor, constant: 10),
            friendName.leadingAnchor.constraint(equalTo: friendImageView.trailingAnchor, constant: 16),
            friendName.trailingAnchor.constraint(equalTo: gradientView.leadingAnchor, constant: 16)
        ])

        NSLayoutConstraint.activate([
            friendLastMessage.topAnchor.constraint(equalTo: friendName.bottomAnchor, constant: 2),
            friendLastMessage.leadingAnchor.constraint(equalTo: friendImageView.trailingAnchor, constant: 22),
            friendLastMessage.trailingAnchor.constraint(equalTo: gradientView.leadingAnchor, constant: 16)
        ])

        NSLayoutConstraint.activate([
            gradientView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            gradientView.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            gradientView.heightAnchor.constraint(equalToConstant: 78),
            gradientView.widthAnchor.constraint(equalToConstant: 7)
        ])
    }
}

// MARK: - SwiftUI

import SwiftUI

struct ActiveChatProvider: PreviewProvider {
    static var previews: some View {
        ContainerView().edgesIgnoringSafeArea(.all)
    }

    struct ContainerView: UIViewControllerRepresentable {

        let tabBarVC = MainTabBarController()

        func makeUIViewController(
            context: UIViewControllerRepresentableContext<ActiveChatProvider.ContainerView>) -> MainTabBarController {
            return tabBarVC
        }

        func updateUIViewController(_ uiViewController: ActiveChatProvider.ContainerView.UIViewControllerType,
                                    context: UIViewControllerRepresentableContext<ActiveChatProvider.ContainerView>) {

        }
    }
}
