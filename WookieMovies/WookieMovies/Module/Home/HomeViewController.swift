//
//  HomeViewController.swift
//  WookieMovies
//
//  Created by lee on 2021/1/25.
//

import UIKit
import RxCocoa
import RxSwift

class HomeViewController: UIViewController {
    static let sectionHeader = "SectionHeader"
    
    lazy var collectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: collectionViewLayout())
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.backgroundColor = .systemBackground
        collectionView.register(HomeCollectionViewCell.self,
                                forCellWithReuseIdentifier: HomeCollectionViewCell.description())
        collectionView.register(CollectionSectionHeader.self,
                                forSupplementaryViewOfKind: HomeViewController.sectionHeader,
                                withReuseIdentifier: CollectionSectionHeader.description())
        collectionView.delegate = self
        return collectionView
    }()
    
    public enum GenreSection: String, CaseIterable {
        case action = "Action"
        case adventure = "Adventure"
        case animation = "Animation"
        case biography = "Biography"
        case crime = "Crime"
        case drama = "Drama"
        
    }
    
    // MARK:- variables for the viewController
    var viewModel: HomeViewModel!
    let disposeBag = DisposeBag()
    
    private var movieDataSource: UICollectionViewDiffableDataSource<GenreSection, Movie>?
    
    let defaultsManager = WMUserDefaults()
    let apiManager = WMApiManager()
    
    override class func description() -> String {
        "HomeViewController"
    }
    
    // MARK:- life cycle methods for the viewController
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewModel = HomeViewModel(defaults: defaultsManager, api: apiManager)
        viewModel.movies.drive(onNext: {[unowned self] (_) in
            setupDataSource()
        }).disposed(by: disposeBag)
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

extension HomeViewController {
    func collectionViewLayout() -> UICollectionViewLayout {
        let layout = UICollectionViewCompositionalLayout { (sectionIndex: Int, layoutEnvironment: NSCollectionLayoutEnvironment) -> NSCollectionLayoutSection? in
            let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                                  heightDimension: .fractionalWidth(1.0))
            let item = NSCollectionLayoutItem(layoutSize: itemSize)
            let groupSize = NSCollectionLayoutSize(widthDimension: .absolute(140), heightDimension: .absolute(220))
            let group = NSCollectionLayoutGroup.vertical(layoutSize: groupSize, subitem: item, count: 1)
            group.contentInsets = .init(top: 5, leading: 5, bottom: 5, trailing: 5)
            
            let headerSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
            heightDimension: .estimated(44))
            let sectionHeader = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: headerSize,
                                                                            elementKind: HomeViewController.sectionHeader,
                                                                            alignment: .top)
            
            let section = NSCollectionLayoutSection(group: group)
            section.orthogonalScrollingBehavior = .groupPaging
            section.boundarySupplementaryItems = [sectionHeader]
            return section
        }
       return layout
    }
    
    fileprivate func setupDataSource() {
       movieDataSource = UICollectionViewDiffableDataSource<GenreSection, Movie>(
        collectionView: collectionView,
        cellProvider: { (collectionView, indexPath, movie) -> UICollectionViewCell? in
            let description = HomeCollectionViewCell.description()
            let reusable = collectionView.dequeueReusableCell(withReuseIdentifier: description, for: indexPath)
            guard let cell = reusable as? HomeCollectionViewCell else {
                return HomeCollectionViewCell()
            }
            cell.setupCell(viewModel: MovieViewModel(movie: movie))
            return cell
        })
       
        movieDataSource?.supplementaryViewProvider = { (collectionView, kind, indexPath) -> UICollectionReusableView? in
            let reusable = collectionView.dequeueReusableSupplementaryView(ofKind: kind,
                                                                           withReuseIdentifier: CollectionSectionHeader.description(),
                                                                           for: indexPath)
            guard let supplementaryView = reusable as? CollectionSectionHeader else {
                fatalError("Cannot create header view")
            }
            supplementaryView.label.text = GenreSection.allCases[indexPath.section].rawValue
            return supplementaryView
        }
       
        movieDataSource?.apply(generateSnapshot(), animatingDifferences: false, completion: nil)
    }
    
    func generateSnapshot() -> NSDiffableDataSourceSnapshot<GenreSection, Movie> {
        var snapshot = NSDiffableDataSourceSnapshot<GenreSection, Movie>()

        snapshot.appendSections([GenreSection.action])
        snapshot.appendItems(viewModel.genres[GenreSection.action.rawValue] ?? [])
        
        snapshot.appendSections([GenreSection.adventure])
        snapshot.appendItems(viewModel.genres[GenreSection.adventure.rawValue] ?? [])
        
        snapshot.appendSections([GenreSection.animation])
        snapshot.appendItems(viewModel.genres[GenreSection.animation.rawValue] ?? [])
        
        snapshot.appendSections([GenreSection.biography])
        snapshot.appendItems(viewModel.genres[GenreSection.biography.rawValue] ?? [])
       
        snapshot.appendSections([GenreSection.crime])
        snapshot.appendItems(viewModel.genres[GenreSection.crime.rawValue] ?? [])
       
        snapshot.appendSections([GenreSection.drama])
        snapshot.appendItems(viewModel.genres[GenreSection.drama.rawValue] ?? [])

        return snapshot
    }
}

extension HomeViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let movie = movieDataSource?.itemIdentifier(for: indexPath) else { return }
        let viewController = storyboard?.instantiateViewController(withIdentifier: DetailViewController.description())
        guard let detailViewController = viewController as? DetailViewController else {
            return
        }
        detailViewController.movieViewModel = MovieViewModel(movie: movie)
        hidesBottomBarWhenPushed = true
        navigationController?.pushViewController(detailViewController, animated: true)
        hidesBottomBarWhenPushed = false
    }
}
