//
//  MovieListBaseViewController.swift
//  StrongReferenceDemo
//
//  Created by Matthews, Jamie on 3/25/16.
//  Copyright © 2016 Amazon. All rights reserved.
//

import UIKit

class MovieListBaseViewController: UITableViewController {
   
    var selectedNode: Node?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupBackgroundView()
        tableView.separatorStyle = .SingleLine
    }
    
    func getCurrentFolder() -> Node {
        // subclasses should override
        return Node(id: 0, name: "")
    }
    
    // MARK: - UITableViewDelegate
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        guard let node = nodeForIndexPath(indexPath) else {
            return
        }
        if NodeDataSource.hasChildren(node) {
            navigateToFolder(node)
        } else {
            navigateToItem(node)
        }
    }
    
    private func navigateToFolder(node: Node) {
        guard let storyboard = self.storyboard else {
            return
        }
        guard let folderViewController = storyboard.instantiateViewControllerWithIdentifier("MovieListViewController") as? MovieListViewController else {
            return
        }
        folderViewController.currentFolder = node
        self.navigationController?.pushViewController(folderViewController, animated: true)
    }

    
    // MARK: - UIViewController overrides
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        guard let identifier = segue.identifier else {
            return
        }
        
        switch identifier {
        case "navigateToMovie":
            defer {
                selectedNode = nil
            }
            guard let movieImageViewController = segue.destinationViewController as? MovieImageViewController else {
                return
            }
            movieImageViewController.node = selectedNode
        default:
            break
        }
    }
    
    // MARK: - Navigation
    
    
    private func navigateToItem(node: Node) {
        selectedNode = node
        performSegueWithIdentifier("navigateToMovie", sender: self)
    }
    
    func nodeForIndexPath(indexPath: NSIndexPath) -> Node? {
        let children = getCurrentFolder().childIds ?? []
        let childId = children[indexPath.row]
        return NodeDataSource.nodeById(childId)
    }

    // MARK: - Private utility methods
    
    private func setupBackgroundView() {
        let backgroundView = UIView(frame: tableView.frame)
        backgroundView.backgroundColor = UIColor(red: 255/255, green: 255/255, blue: 255/255, alpha: 1.0)
        
        let imageView = UIImageView(image: UIImage(named: "Arrows")!)
        let size = CGSize(width: 100, height: 100)
        let centerX = CGRectGetMidX(tableView.frame)
        let centerY = CGRectGetMidY(tableView.frame)
        let center = CGPoint(x: centerX, y: centerY)
        let frame = CGRect(center: center, size: size)
        imageView.frame = frame
        imageView.layer.opacity = 0.20
        backgroundView.addSubview(imageView)
        
        tableView.backgroundView = backgroundView
    }
}

// MARK: - Private extensions

private extension CGRect {
    init(center: CGPoint, size: CGSize) {
        let originX = center.x - (size.width / 2)
        let originY = center.y - (size.height / 2)
        let origin = CGPoint(x: originX, y: originY)
        self.init(origin: origin, size: size)
    }
}
