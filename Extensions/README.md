# UITableView and UICollectionView Generics

## About
Generic classes of the most commonly used classes, to minimize the code used in the ViewControllers and become more efficient

## Requirements
Copy the 2 extensions to your project

## Usage (Collection View)

#### Register Custom Nib Cell in viewDidLoad()

```
collectionView.delegate = self
collectionView.dataSource = self

collectionView.registerCellNib(cellClass: CustomCollectionViewCell.self)
```
#### Dequeue Cell in UICollectionViewDataSource Method

```
let cell = collectionView.dequeue(indexPath: indexPath) as CustomCollectionViewCell

cell.textView.text = "Hello World"

return cell
```

## Usage (Table View)

#### Register Custom Nib Cell in viewDidLoad()

```
tableView.delegate = self
tableView.dataSource = self

tableView.registerCellNib(cellClass: CustomTableViewCell.self)
```
#### Dequeue Cell in UICollectionViewDataSource Method

```
let cell = tableView.dequeue(indexPath: indexPath) as CustomTableViewCell

cell.textView.text = "Hello World"

return cell
```
