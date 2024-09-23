//
//  DragDropViewController.swift
//  DragDropCollectionView
//
//  Created by Renoy Chowdhury on 23/09/24.
//

import UIKit

class DragDropViewController: UIViewController {
    var collectionView: UICollectionView!
    var dataSource: [String] = []
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        collectionView.frame = self.view.bounds
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        dataSource = ["Item 1", "Item 2", "Item 3", "Item 4", "Item 5"]
        
        let flowlayout = UICollectionViewFlowLayout()
        flowlayout.scrollDirection = .vertical
        flowlayout.minimumInteritemSpacing = 0
        flowlayout.minimumLineSpacing = 20
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: flowlayout)
        collectionView.showsVerticalScrollIndicator = false
        
        // Initialize collection view
        collectionView = UICollectionView(frame: self.view.bounds, collectionViewLayout: flowlayout)
        collectionView.backgroundColor = .white
        
        // Register cell class
        collectionView.register(CustomCell.self, forCellWithReuseIdentifier: CustomCell.identifier)
        
        // Set delegates
        collectionView.delegate = self
        collectionView.dataSource = self
        
        // Enable drag and drop interactions
        collectionView.dragInteractionEnabled = true
        collectionView.dragDelegate = self
        collectionView.dropDelegate = self
        
        // Add collection view to the view hierarchy
        self.view.addSubview(collectionView)
    }
    
}

extension DragDropViewController: UICollectionViewDragDelegate {
    func collectionView(_ collectionView: UICollectionView, itemsForBeginning session: UIDragSession, at indexPath: IndexPath) -> [UIDragItem] {
        let item = dataSource[indexPath.item] as NSString
        let itemProvider = NSItemProvider(object: item)
        
        let dragItem = UIDragItem(itemProvider: itemProvider)
        dragItem.localObject = item
        
        return [dragItem]
        
    }
}

extension DragDropViewController: UICollectionViewDropDelegate {
    func collectionView(_ collectionView: UICollectionView, performDropWith coordinator: UICollectionViewDropCoordinator) {
        guard let destinationIndexPath = coordinator.destinationIndexPath else { return }

                coordinator.items.forEach { dropItem in

                    if let sourceIndexPath = dropItem.sourceIndexPath {
                        // Move item within the same collection view
                        collectionView.performBatchUpdates({
                            let item = dataSource.remove(at: sourceIndexPath.item)
                            dataSource.insert(item, at: destinationIndexPath.item)

                            collectionView.moveItem(at: sourceIndexPath, to: destinationIndexPath)
                        })

                        coordinator.drop(dropItem.dragItem, toItemAt: destinationIndexPath)
                    }
                }
    }
    
    // Determine if the session can handle the drop
    func collectionView(_ collectionView: UICollectionView, canHandle session: UIDropSession) -> Bool {
        // Only handle local drags
        return session.localDragSession != nil
    }
    
    // Update the drop proposal based on session state
    func collectionView(_ collectionView: UICollectionView, dropSessionDidUpdate session: UIDropSession,
                        withDestinationIndexPath destinationIndexPath: IndexPath?) -> UICollectionViewDropProposal {
        
        if collectionView.hasActiveDrag {
            // Allow moving items within the collection view
            return UICollectionViewDropProposal(operation: .move, intent: .insertAtDestinationIndexPath)
        } else {
            // Do not allow drops from other sources
            return UICollectionViewDropProposal(operation: .forbidden)
        }
    }
}

extension DragDropViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
    }
}

extension DragDropViewController: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        dataSource.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CustomCell.identifier, for: indexPath) as! CustomCell
        cell.label.text = dataSource[indexPath.item]
        return cell
    }
    
    
}

extension DragDropViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        CGSize(width: UIScreen.main.bounds.width, height: 100)
    }
}

