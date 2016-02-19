//
//  NodeCell.swift
//  StrongReferenceDemo
//
//  Created by Schmelter, Tim on 2/12/16.
//  Copyright © 2016 Amazon. All rights reserved.
//

import UIKit

class NodeCell: UITableViewCell {
    var node: Node!

    // PATTERN 2: Closures capture references to `self`
    lazy var statusText: () -> String = {
        let status = self.node == nil ? "EMPTY" : "READY"
        let name = self.node?.name ?? "EMPTY"
        return "\(name): \(status)"
    }

    // MARK: - Lifecycle

    required init?(coder aDecoder: NSCoder) {
        Log.t()
        super.init(coder: aDecoder)
    }

    deinit {
        Log.t()
    }

    override func prepareForReuse() {
        node = nil
        detailTextLabel?.text = nil
        textLabel?.text = nil
        accessoryType = .None
        imageView?.image = nil
    }

}
