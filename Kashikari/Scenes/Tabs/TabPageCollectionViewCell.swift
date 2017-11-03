import Foundation
import UIKit
import SnapKit
import AlamofireImage

final class TabPageCollectionViewCell: UICollectionViewCell {
    
    private lazy var imageCell: UIImageView = {
        let imageView: UIImageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    private lazy var priceLabel: UILabel = {
        let label: UILabel = UILabel()
        label.font = UIFont(name: UIFont.themeBoldFont, size: 13)
        label.textColor = UIColor.white
        label.backgroundColor = UIColor.translucentBlack
        return label
    }()
    
    func setup(item: Item) {
        contentView.addSubview(imageCell)
        imageCell.snp.makeConstraints({ (make) -> Void in
            make.top.equalToSuperview()
            make.right.equalToSuperview()
            make.left.equalToSuperview()
            make.bottom.equalToSuperview()
        })
        
        priceLabel.text = "\(item.price)"
        imageCell.addSubview(priceLabel)
        priceLabel.snp.makeConstraints({ (make) -> Void in
            make.right.equalToSuperview()
            make.bottom.equalToSuperview().offset(-15)
        })
        if let url = URL(string: item.imgUrl) {
            imageCell.af_setImage(withURL: url)
        }
    }
}
