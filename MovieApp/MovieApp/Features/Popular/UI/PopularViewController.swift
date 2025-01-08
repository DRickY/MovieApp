//
//  PopularViewController.swift
//  MovieApp
//
//  Created by Dmytro on 08.01.2025.
//

import UIKit
import Combine
import CombineCocoa

final class PopularViewController: RootViewController<IPopularViewModel> {
    private var storage = DisposeStorage()

    private var searchBarDelegate = PopularSearchBarDelegate()

    private var sortAction = PassthroughSubject<MovieSortingOption, Never>()

    private var loadNext = PassthroughSubject<Void, Never>()

    private var didSelectRow = PassthroughSubject<IndexPath, Never>()

    internal lazy var tableView = UITableView()

    internal lazy var refreshControl = UIRefreshControl()

    internal lazy var viewLoader = ViewLoader()

    internal lazy var viewSpinner = ViewSpinner(
        size: .init(width: view.bounds.width, height: 100)
    )

    override func setup() {
        self.title = L10n.popularMovies
        tableView.apply(DefaultTableViewStyle())
        tableView.refreshControl = refreshControl
        refreshControl.apply(DefaultRefreshStyle())
        tableView.dataSource = self
        tableView.register(cellType: PopularViewCell.self)
        view.addSubviews(tableView)

        apply(PopularViewControllerStyle(searchBarDelegate: searchBarDelegate))

        apply(PopularTabActionStyle(selected: model.sortingOption,
                                    image: Asset.sortImage,
                                    place: .right))
            .weakAssign(to: \.sortAction, on: self)
            .store(in: &storage)

        view.addSubview(viewLoader)
    }

    override func setupLayout() {
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(
                equalTo: view.topAnchor, constant: 0),
            tableView.leadingAnchor.constraint(
                equalTo: view.leadingAnchor, constant: 0),
            tableView.trailingAnchor.constraint(
                equalTo: view.trailingAnchor, constant: 0),
            tableView.bottomAnchor.constraint(
                equalTo: view.bottomAnchor, constant: 0)
        ])
    }

    override func bindings() {
        tableView
            .didScrollPublisher
            .onEvents(with: self, onOutput: { target, _ in
                target.searchControllerBarResignResponder()
            })
            .map(self) { target, _ in
                let offsetY = target.tableView.contentOffset.y
                let contentHeight = target.tableView.contentSize.height
                let diff = contentHeight - target.tableView.frame.size.height - 200

                return (offsetY, diff)
            }
            .filter { $0 > $1 }
            .mapToVoid()
            .weakAssign(to: \.loadNext, on: self)
            .store(in: &storage)

        tableView
            .didSelectRowPublisher
            .weakAssign(to: \.didSelectRow, on: self)
            .store(in: &storage)
    }
}

extension PopularViewController: ConfigurableView {
    func configure(with model: Void) {
        // Note: need to implement reload do insert new rows
        tableView.reloadData()
    }

    func disable(_ enable: Bool) {
        navigationItem.enableRightBarItem(enable)
    }
}

extension PopularViewController: PopularView {
    public var reloadContent: AnySubscriber<Bool, Never> {
        AnySubscriber(self) { target, _ in
            target.configure(with: ())
        }
    }

    public var disable: AnySubscriber<Bool, Never> {
        AnySubscriber(self) { target, toggle in
            target.disable(toggle)
        }
    }

    public var sortActionTrigger: AnyPublisher<MovieSortingOption, Never> {
        sortAction.asPublisher()
    }

    public var loadNextTrigger: AnyPublisher<Void, Never> {
        loadNext.asPublisher()
    }

    public var searchTextTrigger: AnyPublisher<String, Never> {
        searchBarDelegate.textDidChange.removeDuplicates().asPublisher()
    }

    public var didSelectRowTrigger: AnyPublisher<IndexPath, Never> {
        didSelectRow.asPublisher()
    }
}

extension PopularViewController: UITableViewDataSource, UITableViewDelegate {
    // MARK: - UITableViewDataSource Methods

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return model.items
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueCell(for: indexPath, cellType: PopularViewCell.self)
        cell.configure(with: model.model(for: indexPath))

        return cell
    }
}
