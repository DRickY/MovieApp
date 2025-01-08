//
//  PopularTabActionStyle.swift
//  MovieApp
//
//  Created by Dmytro on 08.01.2025.
//

import UIKit
import Combine

enum ButtonLocation {
    case left
    case right
}

struct PopularTabActionStyle: Decorator {
    let image: UIImage
    let place: ButtonLocation
    let selected: MovieSortingOption

    init(selected: MovieSortingOption, image: UIImage, place: ButtonLocation = .left) {
        self.image = image
        self.place = place
        self.selected = selected
    }

    @discardableResult
    func apply(on object: PopularViewController) -> AnyPublisher<MovieSortingOption, Never> {
        let selectedOption = PassthroughSubject<MovieSortingOption, Never>()

        let item = BarButtonItem(
            image: image.withRenderingMode(.alwaysTemplate),
            menu: actions(selected: selected) { option in
                selectedOption.send(option)
            })

        item.backgroundConfig = .init(normalColor: .darkText, disabledColor: .lightGray)

        let publisher = selectedOption
            .mapValue({ [weak item] option in
                guard let item else { return }

                item.menu = self.actions(selected: option) { option in
                    selectedOption.send(option)
                }
            })
            .eraseToAnyPublisher()

        switch place {
        case .left:
            object.navigationItem.leftBarButtonItem = item
        case .right:
            object.navigationItem.rightBarButtonItem = item
        }

        return publisher
    }

    private func actions(selected: MovieSortingOption, _ selectOption: @escaping (MovieSortingOption) -> Void) -> UIMenu {
        var menuActions: [UIAction] = []

        for option in MovieSortingOption.allCases {
            let action = UIAction(
                title: option.description,
                state: option == selected ? .on : .off
            ) { _ in
                selectOption(option)
            }

            menuActions.append(action)
        }

        return UIMenu(options: .displayInline,
                      children: menuActions)
    }
}
