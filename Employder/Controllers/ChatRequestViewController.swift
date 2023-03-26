//
//  ChatRequestViewController.swift
//  Employder
//
//  Created by Serov Dmitry on 01.09.22.
//

import UIKit

class ChatRequestViewController: UIViewController {

    // Models
    private var chat: MChat

    // Delegates
    weak var delegate: WaitingChatsNavigationDelegate?

    let containerView = UIView()
    let userNameLabel = UILabel()
    let aboutMeLabel = UILabel()
    let imageView = UIImageView(image: UIImage(named: "human11"),
                                contentMode: .scaleAspectFill)
    let acceptButton = UIButton(title: "Принять",
                                titleColor: .white,
                                backgroundColor: .black,
                                font: .avenir20(),
                                isShadow: false,
                                cornerRadius: 10)
    let denyButton = UIButton(title: "Отклонить",
                              titleColor: #colorLiteral(red: 0.7450980544, green: 0.1568627506, blue: 0.07450980693, alpha: 1),
                              backgroundColor: .white,
                              font: .avenir20(),
                              isShadow: false,
                              cornerRadius: 10)

    // MARK: - init

    init(chat: MChat) {
        self.chat = chat
        userNameLabel.text = chat.friendUserName
        imageView.sd_setImage(with: URL(string: chat.friendUserImageStringURL))
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - viewDidLoad

    override func viewDidLoad() {
        super.viewDidLoad()

        // Setups
        view.backgroundColor = .white
        customizeElements()
        setupConstraints()

        // Buttons
        denyButton.addTarget(self, action: #selector(denyButtonTapped), for: .touchUpInside)
        acceptButton.addTarget(self, action: #selector(acceptButtonTapped), for: .touchUpInside)
    }

    // MARK: - viewWillLayoutSubviews

    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        self.acceptButton.applyGradients(cornerRadius: 10)
    }

    // MARK: - Buttons

    @objc private func denyButtonTapped() {
        self.dismiss(animated: true) {
            self.delegate?.removeWaitingChats(chat: self.chat )
        }
    }

    @objc private func acceptButtonTapped() {
        self.dismiss(animated: true) {
            self.delegate?.changeToActive(chat: self.chat)
        }
    }

    // MARK: - Setups

    private func customizeElements() {
        containerView.translatesAutoresizingMaskIntoConstraints = false
        userNameLabel.translatesAutoresizingMaskIntoConstraints = false
        aboutMeLabel.translatesAutoresizingMaskIntoConstraints = false
        imageView.translatesAutoresizingMaskIntoConstraints = false
        denyButton.layer.borderWidth = 1.2
        denyButton.layer.borderColor = #colorLiteral(red: 0.7450980544, green: 0.1568627506, blue: 0.07450980693, alpha: 1)
        containerView.backgroundColor = .white
        containerView.layer.cornerRadius = 30
    }
}

// MARK: - Setup constraints

extension ChatRequestViewController {

    private func setupConstraints() {

        // addSubviews
        view.addSubview(imageView)
        view.addSubview(containerView)
        containerView.addSubview(userNameLabel)
        containerView.addSubview(aboutMeLabel)

        let buttonsStackView = UIStackView(arrangedSubviews: [acceptButton, denyButton], axis: .horizontal, spacing: 16)
        buttonsStackView.translatesAutoresizingMaskIntoConstraints = false
        buttonsStackView.distribution = .fillEqually
        containerView.addSubview(buttonsStackView)

        // Constraints
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: view.topAnchor),
            imageView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            imageView.bottomAnchor.constraint(equalTo: containerView.topAnchor, constant: 30)
        ])

        NSLayoutConstraint.activate([
            containerView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            containerView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            containerView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            containerView.heightAnchor.constraint(equalToConstant: 220)
        ])

        NSLayoutConstraint.activate([
            userNameLabel.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 44),
            userNameLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 24),
            userNameLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -24)
        ])

        NSLayoutConstraint.activate([
            aboutMeLabel.topAnchor.constraint(equalTo: userNameLabel.bottomAnchor, constant: 16),
            aboutMeLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 24),
            aboutMeLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -24)
        ])

        NSLayoutConstraint.activate([
            buttonsStackView.topAnchor.constraint(equalTo: aboutMeLabel.bottomAnchor, constant: 24),
            buttonsStackView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 24),
            buttonsStackView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -24),
            buttonsStackView.heightAnchor.constraint(equalToConstant: 48)
        ])
    }
}
