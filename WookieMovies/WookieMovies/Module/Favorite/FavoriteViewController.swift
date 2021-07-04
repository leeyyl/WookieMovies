//
//  FavoriteViewController.swift
//  WookieMovies
//
//  Created by lee on 2021/1/27.
//

import UIKit

class FavoriteViewController: UIViewController {
    let defaultsManager = WMUserDefaults()
    
    lazy var collectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: collectionViewLayout())
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.backgroundColor = .systemBackground
        collectionView.register(FavoriteCollectionViewCell.self,
                                forCellWithReuseIdentifier: FavoriteCollectionViewCell.description())
        collectionView.delegate = self
        return collectionView
    }()
    
    public enum FavoriteSection: String, CaseIterable {
        case favorite = "Favorite"
    }
    
    private var movieDataSource: UICollectionViewDiffableDataSource<FavoriteSection, Movie>?
    
    override class func description() -> String {
        "FavoriteViewController"
    }
    
    // MARK:- life cycle methods for the viewController
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        view.addSubview(collectionView)
        NSLayoutConstraint.activate([
           collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
           collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
           collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
           collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        
        self.setupDataSource()
    }


    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
    }
    */

}


extension FavoriteViewController {
    func collectionViewLayout() -> UICollectionViewLayout {
        let layout = UICollectionViewCompositionalLayout { (sectionIndex: Int, layoutEnvironment: NSCollectionLayoutEnvironment) -> NSCollectionLayoutSection? in
            let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                                  heightDimension: .fractionalHeight(1.0))
            let item = NSCollectionLayoutItem(layoutSize: itemSize)
            let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                                   heightDimension: .fractionalWidth(0.75))
            let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitem: item, count: 2)
            group.contentInsets = .init(top: 5, leading: 5, bottom: 5, trailing: 5)
            
            let section = NSCollectionLayoutSection(group: group)
            return section
        }
       return layout
    }
    
    fileprivate func setupDataSource() {
       movieDataSource = UICollectionViewDiffableDataSource<FavoriteSection, Movie>(
        collectionView: collectionView,
        cellProvider: { (collectionView, indexPath, movie) -> UICollectionViewCell? in
            let description = FavoriteCollectionViewCell.description()
            let reusable = collectionView.dequeueReusableCell(withReuseIdentifier: description, for: indexPath)
            guard let cell = reusable as? FavoriteCollectionViewCell else {
                return FavoriteCollectionViewCell()
            }
            cell.setupCell(viewModel: MovieViewModel(movie: movie))
            return cell
        })
        
        movieDataSource?.apply(generateSnapshot(), animatingDifferences: false, completion: nil)
    }
    
    func generateSnapshot() -> NSDiffableDataSourceSnapshot<FavoriteSection, Movie> {
        var snapshot = NSDiffableDataSourceSnapshot<FavoriteSection, Movie>()
        snapshot.appendSections([FavoriteSection.favorite])
        let movies = defaultsManager.getFavorites()
        snapshot.appendItems(movies)
        return snapshot
    }
}

extension FavoriteViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let movie = movieDataSource?.itemIdentifier(for: indexPath) else { return }
        let viewController = storyboard?.instantiateViewController(withIdentifier: DetailViewController.description())
        guard let detailViewController = viewController as? DetailViewController else {
            return
        }
        detailViewController.movieViewModel = MovieViewModel(movie: movie)
        self.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(detailViewController, animated: true)
        self.hidesBottomBarWhenPushed = false
    }
}
