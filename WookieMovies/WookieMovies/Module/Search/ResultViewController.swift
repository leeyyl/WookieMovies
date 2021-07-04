//
//  ResultViewController.swift
//  WookieMovies
//
//  Created by lee on 2021/1/29.
//

import UIKit

protocol SearchResultsDelegate: AnyObject {
    func didClickResult(movie: Movie)
}


class ResultViewController: UIViewController {
    weak var delegate: SearchResultsDelegate?
    
    var movies: [Movie]? {
        didSet {
            self.setupDataSource()
        }
    }
    
    lazy var collectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: collectionViewLayout())
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.backgroundColor = .systemBackground
        collectionView.register(SearchCollectionViewCell.self,
                                forCellWithReuseIdentifier: SearchCollectionViewCell.description())
        collectionView.delegate = self
        return collectionView
    }()
    
    public enum SearchSection: String, CaseIterable {
        case search = "Search"
    }
    
    private var movieDataSource: UICollectionViewDiffableDataSource<SearchSection, Movie>?
    
    override class func description() -> String {
        "ResultViewController"
    }


    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
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
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}


extension ResultViewController {
    func collectionViewLayout() -> UICollectionViewLayout {
        let layout = UICollectionViewCompositionalLayout { (sectionIndex: Int, layoutEnvironment: NSCollectionLayoutEnvironment) -> NSCollectionLayoutSection? in
            let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                                  heightDimension: .fractionalWidth(2/3))
            let item = NSCollectionLayoutItem(layoutSize: itemSize)
            let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                                   heightDimension: .fractionalWidth(1.0))
            let group = NSCollectionLayoutGroup.vertical(layoutSize: groupSize, subitem: item, count: 3)
            group.contentInsets = .init(top: 5, leading: 0, bottom: 5, trailing: 20)
            
            let section = NSCollectionLayoutSection(group: group)
            section.orthogonalScrollingBehavior = .groupPaging
            return section
        }
       return layout
    }
    
    fileprivate func setupDataSource() {
       movieDataSource = UICollectionViewDiffableDataSource<SearchSection, Movie>(
        collectionView: collectionView,
        cellProvider: { (collectionView, indexPath, movie) -> UICollectionViewCell? in
            let description = SearchCollectionViewCell.description()
            let reusable = collectionView.dequeueReusableCell(withReuseIdentifier: description, for: indexPath)
            guard let cell = reusable as? SearchCollectionViewCell else {
                return SearchCollectionViewCell()
            }
            cell.setupCell(viewModel: MovieViewModel(movie: movie))
            return cell
        })
        
        movieDataSource?.apply(generateSnapshot(), animatingDifferences: false, completion: nil)
    }
    
    func generateSnapshot() -> NSDiffableDataSourceSnapshot<SearchSection, Movie> {
        var snapshot = NSDiffableDataSourceSnapshot<SearchSection, Movie>()
        snapshot.appendSections([SearchSection.search])
        snapshot.appendItems(movies ?? [])
        return snapshot
    }
}


extension ResultViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let movie = movieDataSource?.itemIdentifier(for: indexPath) else { return }
        self.delegate?.didClickResult(movie: movie)
    }
}
