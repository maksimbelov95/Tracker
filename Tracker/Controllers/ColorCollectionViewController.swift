import UIKit

class ColorCollectionViewController: UICollectionView {
    
    private let colorSelection: [UIColor] = [
        UIColor(named: "Color Selection 1") ?? .red,
        UIColor(named: "Color Selection 2") ?? .orange,
        UIColor(named: "Color Selection 3") ?? .blue,
        UIColor(named: "Color Selection 4") ?? .magenta,
        UIColor(named: "Color Selection 5") ?? .purple,
        UIColor(named: "Color Selection 6") ?? .systemPink,
        UIColor(named: "Color Selection 7") ?? .systemPink,
        UIColor(named: "Color Selection 8") ?? .systemTeal,
        UIColor(named: "Color Selection 9") ?? .blue,
        UIColor(named: "Color Selection 10") ?? .blue,
        UIColor(named: "Color Selection 11") ?? .orange,
        UIColor(named: "Color Selection 12") ?? .systemPink,
        UIColor(named: "Color Selection 13") ?? .orange,
        UIColor(named: "Color Selection 14") ?? .blue,
        UIColor(named: "Color Selection 15") ?? .purple,
        UIColor(named: "Color Selection 16") ?? .magenta,
        UIColor(named: "Color Selection 17") ?? .purple,
        UIColor(named: "Color Selection 18") ?? .green
    ]
}
extension ColorCollectionViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.colorSelection.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ColorCell", for: indexPath) as! ColorCollectionViewCell
        cell.colorsCellView.backgroundColor = colorSelection[indexPath.row]
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        guard let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "EmojiAndColorsHeaderView", for: indexPath) as? EmojiAndColorsHeaderView else {return UICollectionReusableView()}
        headerView.titleLabel.text = "Цвет"
        return headerView
    }
}
extension ColorCollectionViewController: UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: collectionView.bounds.width, height: 50)
    }
}

