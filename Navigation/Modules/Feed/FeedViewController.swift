//
//  FeedViewController.swift
//  Navigation
//
//  Created by Евгения Шевякова on 20.12.2023.
//

import UIKit

class FeedViewController: UIViewController {
    let viewModel: FeedViewModelProtocol
    
    private lazy var tableView: UITableView = {
        let table = UITableView()
        table.delegate = self
        table.dataSource = self
        table.separatorStyle = .none
        table.toAutoLayout()
        return table
    }()
    
    init(viewModel: FeedViewModelProtocol) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        title = String(localized: "feedTitle")
        setupUi()
        tableView.register(PostCell.self, forCellReuseIdentifier: PostCell.reuseIdentifier())
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.loadPosts { [weak self] in
            self?.tableView.reloadData()
        }
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
}

extension FeedViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.posts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: PostCell.reuseIdentifier(), for: indexPath)
        if let cell = cell as? PostCell {
            let post = viewModel.posts[indexPath.row]
            cell.update(post: post)
        }
        return cell
    }
}
