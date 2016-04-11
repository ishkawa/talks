# 大河
#### ishkawa

Note:
- それでは、発表を始めます。
- よろしくお願いします。



## ishkawa?

<img src="./img/profile.png" height="500">

Note:
- GitHub IDはishkawaです。
- APIKitというネットワーキングライブラリをつくっています。
- 最近はメルカリで働いています。



# 概要

1. Rx + ViewModelを前提とした設計
2. 画面を跨ぐグローバルなイベント
3. イベントの待ち合わせの活用事例



## Rx + ViewModelを前提とした設計



### UIはよく変わる

<img src="./img/tweet1.png" height="500">
<img src="./img/tweet2.png" height="500">



### 操作は変わりにくい

<img src="./img/tweet1.png" height="500">
<img src="./img/tweet2.png" height="500">



<img src="./img/MVVM.png" height="500" style="background:none; border:none; box-shadow:none;">



<img src="./img/MVVM2.png" height="500" style="background:none; border:none; box-shadow:none;">



<img src="./img/MVVM3.png" height="500" style="background:none; border:none; box-shadow:none;">



`Observable<T>`



<img src="./img/Observable.png" height="500" style="background:none; border:none; box-shadow:none;">



### `Observable<T>`を3行で

- `T`の値が流れてくる川
- 演算できる (map, filter, zipなど)
- Observerに接続できる



<img src="./img/tweet1.png" height="500">
<img src="./img/tweet2.png" height="500">



<img src="./img/MVVM5.png" height="500" style="background:none; border:none; box-shadow:none;">



<img src="./img/MVVM4.png" height="500" style="background:none; border:none; box-shadow:none;">



### View

- 入出力のストリームを接続するだけ
- 頻繁に変更されるが実装コストは低い



### ViewModel

- 状態管理も担当する
- 実装コストは高いが再利用性が高い



### 小まとめ

- 変更されやすい箇所と変更されにくいところを分ける
- 変更されやすい箇所の実装コストを下げる
- 変更されにくいところの再利用性を高める




## 画面を跨ぐグローバルなイベント



一覧画面と詳細画面の図



- 状態の変更は画面間で共有されてほしい
- 画面間で共有されるということはグローバル



これでやってみるか...

```swift
final class GlobalObservables {
    // Itemはvalue typeの方が望ましい
    static let likedItem = PublishSubject<Item>()
}
```



<img src="./img/GlobalObservable1.png" height="500" style="background:none; border:none; box-shadow:none;">



<img src="./img/GlobalObservable6.png" height="500" style="background:none; border:none; box-shadow:none;">



<img src="./img/GlobalObservable2.png" height="500" style="background:none; border:none; box-shadow:none;">



<img src="./img/GlobalObservable3.png" height="500" style="background:none; border:none; box-shadow:none;">



<img src="./img/GlobalObservable4.png" height="500" style="background:none; border:none; box-shadow:none;">



<img src="./img/GlobalObservable5.png" height="500" style="background:none; border:none; box-shadow:none;">



- `Observable<Item>`に値を流すのはViewModel
- `Observable<Item>`を購読するのもViewModel
- ViewにはViewModelの値をバインドするだけ



```swift
class ItemViewModel {
    let item: Variable<Item>()
    let toggleLike: PublishSubject<Void>

    func bind() {
        toggleLike
            .flatMap { /* Like APIを呼んでObservable<Item>を返す */ }
            .bindTo(GlobalObservables.likedItem)
            .addDisposableTo(disposeBag)

        GlobalObservables.likedItem
            .withLatestFrom(item) { $0 }
            .filter { $0.id == $1.id }
            .bindTo(item)
            .addDisposableTo(disposeBag)
    }
}
```



### 実際はもうちょっと複雑

- ボタン押した直後に反映する
- 失敗したら元に戻す



```swift
class ItemTableViewCell: UITableViewCell {
    let likeButton: UIButton
    let viewModel: ItemViewModel
    private var item: Item {
        didSet { ... }
    }

    func bind() {
        likeButton.rx_tap.asDriver().map { _ in () }
            .drive(viewModel.toggleLike)
            .addDisposableTo(disposeBag)

        viewModel.item.asDriver()
            .drive(item)
            .addDisposableTo(disposeBag)
    }
}
```



```swift
class ItemCollectionViewCell: UICollectionView {
    let likeButton: UIButton
    let viewModel: ItemViewModel
    private var item: Item {
        didSet { ... }
    }

    func bind() {
        likeButton.rx_tap.asDriver().map { _ in () }
            .drive(viewModel.toggleLike)
            .addDisposableTo(disposeBag)

        viewModel.item.asDriver()
            .drive(item)
            .addDisposableTo(disposeBag)
    }
}
```



### 小まとめ

- 変更はグローバルな`Observable<T>`で通知
- 値の送信も購読もViewModelが担当する
- Viewは画面間の同期について考える必要がない
  - バインドしてれば自動的に同期される
