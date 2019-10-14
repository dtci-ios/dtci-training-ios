//
//  TopGamesCollectionViewController.swift
//  VideoStreaming
//
//  Created by Rodrigo Cian Berrios on 24/09/2019.
//  Copyright © 2019 ESPN. All rights reserved.
//

import UIKit

class ColumsLayoutHelper {

    static func widthOfSafeArea() -> CGFloat {
        guard let rootView = (UIApplication.shared.windows.filter {$0.isKeyWindow}.first) else { return 0 }

        if #available(iOS 11.0, *) {
            let leftInset = rootView.safeAreaInsets.left
            let rightInset = rootView.safeAreaInsets.right
            return rootView.bounds.width - leftInset - rightInset
        } else {
            return rootView.bounds.width
        }
    }

    static func heightOfSafeArea() -> CGFloat {
        guard let rootView = (UIApplication.shared.windows.filter {$0.isKeyWindow}.first) else { return 0 }

        if #available(iOS 11.0, *) {
            let topInset = rootView.safeAreaInsets.top
            let bottomInset = rootView.safeAreaInsets.bottom
            return rootView.bounds.height - topInset - bottomInset
        } else {
            return rootView.bounds.height
        }
    }

    static func columnsForTraitCollection() -> Int {
        switch UITraitCollection.current.horizontalSizeClass {
        case .compact:
            return UITraitCollection.current.verticalSizeClass == .compact ? 3 : 2
        case .regular:
            return UITraitCollection.current.verticalSizeClass == .compact ? 3 : 4
        default:
            return 2
        }
    }
}

struct CellAspectRatio {
    // Portrait mode => 4:3 is 4 heigth and 3 width
    var width: Int
    var height: Int

    init(width: Int = 3, height: Int = 4) {
        self.width = width
        self.height = height
    }

    var heightRatioFactor: Float {
        return Float(height) / Float(width)
    }

    var widthRatioFactor: Float {
        return Float(width) / Float(height)
    }
}

struct ColumsLayout {

    let cellAspectRatio: CellAspectRatio

    var itemsWidthPercentage: Float // in range of 0..1

    init(itemsWidthPercentage: Float = 0.88, cellAspectRatio: CellAspectRatio = CellAspectRatio()) {
        let normalizedItemsWidthPercentage = itemsWidthPercentage > 1 ? itemsWidthPercentage / 100 : itemsWidthPercentage
        self.itemsWidthPercentage = normalizedItemsWidthPercentage
        self.cellAspectRatio = cellAspectRatio
    }

    var paddingsWidthPercentage: Float { // in range of 0..1
        1 - itemsWidthPercentage
    }

    var fullDisponibleWidthForItems : CGFloat {
        floor(ColumsLayoutHelper.widthOfSafeArea() * CGFloat(itemsWidthPercentage))
    }

    var fullDisponibleWidthForPaddings : CGFloat {
        floor(ColumsLayoutHelper.widthOfSafeArea() - fullDisponibleWidthForItems)
    }

    var itemWidth : CGFloat {
       floor(fullDisponibleWidthForItems / CGFloat(ColumsLayoutHelper.columnsForTraitCollection()))
    }

    var itemHeight : CGFloat {
        floor(itemWidth * CGFloat(cellAspectRatio.heightRatioFactor))
    }

    var paddingWidth : CGFloat {
       floor(fullDisponibleWidthForPaddings / CGFloat(ColumsLayoutHelper.columnsForTraitCollection() + 1))
    }

    func itemSize() -> CGSize {
        return CGSize(width: itemWidth, height: itemHeight)
    }
}

class TopGamesDataSource: NSObject {

    private var topGamesAPI: TopGamesAPIProtocol
    private var games: [Game] = []

    func getGames() -> [Game] {
        return games
    }

    init(topGamesAPI: TopGamesAPIProtocol){
        self.topGamesAPI = topGamesAPI
    }

    func fetchDataSource(completionForView: @escaping (APIError?) -> Void) {
        topGamesAPI.fetchTopGames { result in
            switch result {
            case .success(let topGames):
                self.games = topGames
                completionForView(nil)
            case .failure(let error):
                self.games = []
                completionForView(error)
            }
        }
    }
}

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

        dataSource.fetchDataSource(completionForView: errorCompletionHandler(error:))

        collectionView.delegate = self
        collectionView.dataSource = self
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

extension TopGamesCollectionViewController: UICollectionViewDelegate, UICollectionViewDataSource {

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cell = self.collectionView(collectionView, cellForItemAt: indexPath) as! GameCollectionViewCell

        guard let game = cell.game else { return }

        let videoPlaylistVC = VideoPlaylistViewController(with: game)

        navigationController?.pushViewController(videoPlaylistVC, animated: true)
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.dataSource.getGames().count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let viewCell = collectionView.dequeueReusableCell(withReuseIdentifier: GameCollectionViewCell.Constants.reuseIdentifier, for: indexPath) as? GameCollectionViewCell else {
            return UICollectionViewCell()
        }

        viewCell.game = self.dataSource.getGames()[indexPath.row]

        return viewCell
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
