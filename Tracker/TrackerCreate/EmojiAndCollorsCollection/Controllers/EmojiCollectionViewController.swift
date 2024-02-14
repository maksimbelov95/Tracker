import UIKit

protocol EmojiCollectionViewControllerDelegate: AnyObject{
    func emojiDelegate(emoji: String)
}

class EmojiCollectionViewController: UICollectionView {
    private let emoji = ["🙂", "😻","🌺","🐶","❤️","😱","😇","😡","🥶","🤔","🙌","🍔","🥦","🏓","🥇","🎸","🌴","😪"]
    
    weak var emojiSelected: EmojiCollectionViewControllerDelegate?
    
    private var indexPath: IndexPath?
    
}

extension EmojiCollectionViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.emoji.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "EmojiCell", for: indexPath) as! EmojiCollectionViewCell
        cell.emojiLabel.text = emoji[indexPath.row]
        if indexPath == self.indexPath{
            cell.emojiCellView.backgroundColor = .ypGray
        } else {
            cell.emojiCellView.backgroundColor = .clear
        }
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {

        guard let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "EmojiAndColorsHeaderView", for: indexPath) as? EmojiAndColorsHeaderView else {return UICollectionReusableView()}
            headerView.titleLabel.text = "Emoji"
            return headerView
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath){
        let emoji = self.emoji[indexPath.row]
        self.indexPath = indexPath
        emojiSelected?.emojiDelegate(emoji: emoji)
    }
}

extension EmojiCollectionViewController: UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: collectionView.bounds.width, height: 50)
    }
}

