import Foundation
import Koloda

class ItemSelectViewController: UIViewController {
    var imageUrls: [String] = [] {
        didSet {
            progressUnit = 1.0 / Float(imageUrls.count)
        }
    }
    fileprivate var progressUnit: Float = 0.0
    fileprivate var stash: [String] = []
    fileprivate var items: [Item] = []
    
    private lazy var kolodaView: KolodaView = {
        let view = KolodaView()
        view.dataSource = self
        view.delegate = self
        return view
    }()
    
    private lazy var titleLabel: UILabel = {
       let label = UILabel()
        label.text = "出品するアイテムを選んでください"
        label.tintColor = UIColor.darkGray
        label.font = UIFont(name: UIFont.themeBoldFont, size: 15)
        return label
    }()
    
    fileprivate lazy var progressBar: UIProgressView = {
        let bar = UIProgressView(frame: CGRect(x: 0, y: 0, width: 300, height: 10))
        bar.progressTintColor = UIColor.themeColor
        bar.trackTintColor = UIColor.white
        bar.transform = CGAffineTransform(scaleX: 1.0, y: 2.0)
        bar.progress = 0.0
        return bar
    }()
    
    fileprivate lazy var okButton: UIButton = {
        let button = UIButton()
        button.frame = CGRect(x: 0, y:0, width: 50, height: 50)
        button.setImage(UIImage(named: "maru10"), for: .normal)
        button.imageView?.contentMode = .scaleToFill
        button.addTarget(self, action: #selector(okAction), for: .touchUpInside)
        return button
    }()
    
    fileprivate lazy var cancelButton: UIButton = {
        let button = UIButton()
        button.frame = CGRect(x: 0, y:0, width: 50, height: 50)
        button.setImage(UIImage(named: "batu9"), for: .normal)
        button.imageView?.contentMode = .scaleToFill
        button.addTarget(self, action: #selector(cancelAction), for: .touchUpInside)
        return button
    }()
    
    @objc private func okAction() {
        kolodaView.swipe(.right)
    }
    
    @objc private func cancelAction() {
        kolodaView.swipe(.left)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.isTranslucent = false
        view.backgroundColor = UIColor.defaultBackGroundColor
        
        view.addSubview(titleLabel)
        titleLabel.snp.makeConstraints({ (make) -> Void in
            make.top.equalToSuperview().offset(15)
            make.centerX.equalToSuperview()
        })
        
        view.addSubview(kolodaView)
        kolodaView.snp.makeConstraints({ (make) -> Void in
            make.top.equalTo(titleLabel.snp.bottom).offset(15)
            make.width.equalTo(view.frame.width - 60)
            make.height.equalTo(400)
            make.centerX.equalToSuperview()
        })
        
        progressBar.progress = progressUnit
        view.addSubview(progressBar)
        progressBar.snp.makeConstraints({ (make) -> Void in
            make.top.equalTo(kolodaView.snp.bottom).offset(20)
            make.centerX.equalToSuperview()
            make.width.equalTo(300)
            make.height.equalTo(10)
        })
        
        view.addSubview(okButton)
        okButton.snp.makeConstraints({ (make) -> Void in
            make.top.equalTo(progressBar.snp.bottom).offset(25)
            make.right.lessThanOrEqualToSuperview().offset(-50)
            make.width.equalTo(50)
            make.height.equalTo(50)
        })
        
        view.addSubview(cancelButton)
        cancelButton.snp.makeConstraints({ (make) -> Void in
            make.top.equalTo(progressBar.snp.bottom).offset(25)
            make.left.greaterThanOrEqualToSuperview().offset(50)
            make.width.equalTo(50)
            make.height.equalTo(50)
        })
        
        view.bringSubview(toFront: kolodaView)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        view.subviews.forEach{ $0.removeFromSuperview() }
    }
    
}

extension ItemSelectViewController: KolodaViewDelegate {
    func kolodaDidRunOutOfCards(_ koloda: KolodaView) {
        koloda.reloadData()
    }
}

extension ItemSelectViewController: KolodaViewDataSource {
    
    func kolodaNumberOfCards(_ koloda:KolodaView) -> Int {
        return imageUrls.count
    }
    
    func kolodaSpeedThatCardShouldDrag(_ koloda: KolodaView) -> DragSpeed {
        return .default
    }
    
    func koloda(_ koloda: KolodaView, viewForCardAt index: Int) -> UIView {
        let imageView = UIImageView()
        if let url = URL(string: imageUrls[index]) {
            imageView.af_setImage(withURL: url)
        }
        imageView.contentMode = .scaleAspectFit
        return imageView
    }
    
    func koloda(_ koloda: KolodaView, allowedDirectionsForIndex index: Int) -> [SwipeResultDirection] {
        return [.left, .right]
    }
    
    func koloda(_ koloda: KolodaView, didSwipeCardAt index: Int, in direction: SwipeResultDirection) {
        let item = imageUrls[index]
        switch direction {
        case .right:
            let item: Item = Item(image: imageUrls[index])
            items.append(item)
        default:
            stash.append(item)
        }
        let nextProgress = progressBar.progress + progressUnit
        progressBar.setProgress(nextProgress, animated: true)
        if index + 1 == imageUrls.count {
            guard stash.count != imageUrls.count else {
                navigationController?.popViewController(animated: true)
                return
            }
            let vc = ItemCreateViewController()
            vc.items = items
            navigationController?.pushViewController(vc, animated: true)
        }
    }
}
