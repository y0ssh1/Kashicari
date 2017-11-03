import Foundation
import XLPagerTabStrip

class TabPageViewController: UIViewController, IndicatorInfoProvider {
    var tabType = TabType.create(rawValue: 0)
    fileprivate var items: [Item] = []
    
    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let cellSize = (view.frame.width - 30) / 3
        layout.itemSize = CGSize(width: cellSize, height: cellSize)
        layout.sectionInset = UIEdgeInsetsMake(5, 5, 5, 5)
        layout.headerReferenceSize = CGSize(width: view.frame.width, height: 5)
        let collectionView = UICollectionView(frame: view.frame, collectionViewLayout: layout)
        let navBarHeight = navigationController?.navigationBar.frame.height ?? 0.0
        collectionView.register(TabPageCollectionViewCell.self, forCellWithReuseIdentifier: "TabPageCollectionViewCell")
        collectionView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: navBarHeight + 50, right: 0)
        collectionView.backgroundColor = UIColor.defaultBackGroundColor
        collectionView.delegate = self
        collectionView.dataSource = self
        return collectionView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(collectionView)
        Service.items.index(completion: {[weak self] items in
            self?.items = items
            DispatchQueue.main.async {
                self?.collectionView.reloadData()
            }
        })
    }
    
    
    func indicatorInfo(for pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
        return IndicatorInfo(title: tabType.getTabName())
    }
}

extension TabPageViewController: UICollectionViewDelegate, UICollectionViewDataSource {

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let item = items[indexPath.row]
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "TabPageCollectionViewCell", for: indexPath) as! TabPageCollectionViewCell
        cell.setup(item: item)
        return cell
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return items.count
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let item = items[indexPath.row]
        let vc = ItemShowViewController()
        vc.item = item
        navigationController?.pushViewController(vc, animated: true)
    }
}
