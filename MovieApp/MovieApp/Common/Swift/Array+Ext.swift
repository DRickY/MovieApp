//
//  Array+Ext.swift
//  MovieApp
//
//  Created by Dmytro on 08.01.2025.
//

import Foundation
import UIKit

extension Array {
    public subscript(indexPath: IndexPath) -> Element {
        return self[indexPath.row]
    }
}
