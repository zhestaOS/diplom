//
//  ProfileViewController.swift
//  Navigation
//
//  Created by Евгения Шевякова on 20.12.2023.
//

import UIKit

class ProfileViewController: UIViewController {
    
    let viewModel: ProfileViewModelProtocol
    
    private lazy var tableView: UITableView = {
        let table = UITableView()
        table.delegate = self
        table.dataSource = self
        table.separatorStyle = .none
        table.toAutoLayout()
        return table
    }()
    
    init(viewModel: ProfileViewModelProtocol) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        title = String(localized: "profileTitle")
        view.backgroundColor = .systemBackground
        setupUi()
        registerCells()
        
        viewModel.loadPosts { [weak self] in
            self?.tableView.reloadData()
        }
        
        let barButton = UIBarButtonItem(title: String(localized: "logout"), style: .plain, target: self, action: #selector(logoutTapped))
        navigationItem.rightBarButtonItem = barButton
    }
    
    private func registerCells() {
        tableView.register(ProfileInfoCell.self, forCellReuseIdentifier: ProfileInfoCell.reuseIdentifier())
        tableView.register(PostCell.self, forCellReuseIdentifier: PostCell.reuseIdentifier())
    }
    
    private func setupUi() {
        view.addSubview(tableView)
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    @objc
    private func logoutTapped() {
        viewModel.logout()
    }

}

extension ProfileViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 1
        }
        return viewModel.posts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            if indexPath.row == 0 {
                let cell = tableView.dequeueReusableCell(withIdentifier: ProfileInfoCell.reuseIdentifier(), for: indexPath)
                if let cell = cell as? ProfileInfoCell {
                    cell.update(email: viewModel.userEmail())
                    viewModel.userAvatar { image in
                        cell.updateAvatar(image: image)
                    }
                    cell.createPostCallback = {
                        self.viewModel.handleCreatePostButtonTapped(vc: self, completion: { [weak self] in
                            self?.viewModel.loadPosts { [weak self] in
                                self?.tableView.reloadData()
                            }
                        })
                    }
                }
                return cell
            }
        } else if indexPath.section == 1 {
            let cell = tableView.dequeueReusableCell(withIdentifier: PostCell.reuseIdentifier(), for: indexPath)
            if let cell = cell as? PostCell {
                let post = viewModel.posts[indexPath.row]
                cell.update(post: post)
            }
            return cell
        }
        
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        section == 0 ? nil : String(localized: "postSectionTitle")
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 0, indexPath.row == 0 {
            let picker = UIImagePickerController()
            picker.allowsEditing = true
            picker.delegate = self
            present(picker, animated: true)
        }
    }
}

extension ProfileViewController: UIImagePickerControllerDelegate & UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let image = info[.editedImage] as? UIImage else { return }
        
        viewModel.updateAvatar(image: image) { [weak self] isSuccess in
            if isSuccess {
                self?.tableView.reloadData()
            }
        }
        
        dismiss(animated: true)
    }

    func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }
}
