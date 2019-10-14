//
//  TopGamesCollectionViewController.swift
//  VideoStreaming
//
//  Created by Rodrigo Cian Berrios on 24/09/2019.
//  Copyright © 2019 ESPN. All rights reserved.
//

import UIKit

class TopGamesCollectionViewController: UIViewController {

    @IBOutlet private weak var collectionView: UICollectionView!

    private var columsLayout = ColumsLayout(itemsWidthPercentage: 0.88, cellAspectRatio: CellAspectRatio(width: 3, height: 4))
    private var dataSource: TopGamesDataSource!

    static var nibName: String {
        return String(describing: self)
    }

    init(dataSource: TopGamesDataSource) {
        self.dataSource = dataSource
        super.init(nibName: TopGamesCollectionViewController.nibName, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        title = "Top Games"

        showHUD()
        
        collectionView.register(UINib(nibName: GameCollectionViewCell.Constants.nibName, bundle: nil), forCellWithReuseIdentifier: GameCollectionViewCell.Constants.reuseIdentifier)
        
        collectionView.delegate = self
        collectionView.dataSource = dataSource
        
        dataSource.fetchDataSource(completionForView: errorCompletionHandler(error:))
    }

    func errorCompletionHandler(error: APIError?) {
        dismissHUD()
        if let error = error {
            let alert = UIAlertController(title: "ERROR", message: error.localizedDescription, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            present(alert, animated: true)
        } else {
            collectionView.reloadData()
            dismissHUD()
        }
    }

    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        collectionView.collectionViewLayout.invalidateLayout()
    }
}

extension TopGamesCollectionViewController: UICollectionViewDelegate {

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cell = self.collectionView.cellForItem(at: indexPath) as! GameCollectionViewCell

        guard let game = cell.game else { return }

        let videoPlaylistVC = VideoPlaylistViewController(with: game)

        navigationController?.pushViewController(videoPlaylistVC, animated: true)
    }

}

extension TopGamesCollectionViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return columsLayout.itemSize()
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: columsLayout.paddingWidth, left: columsLayout.paddingWidth, bottom: columsLayout.paddingWidth, right: columsLayout.paddingWidth)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return columsLayout.paddingWidth
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return columsLayout.paddingWidth
    }
}
