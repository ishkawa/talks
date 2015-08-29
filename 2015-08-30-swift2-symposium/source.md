class: center, middle

# Patterns in Swift

### ishkawa

---

background-image: url(./profile.png)

---

## Patterns in Swift

- `if-case`
- `switch-case`
- `for-case`

```swift
let something = ...
if case let foo as Foo = something {
    ...
}
```

- `do-catch`

```swift
do {
    try doSomething()
} catch let error as MyError {
    print(error)
}
```

---

## 問題点

- 文法がよくわからん

---

class: center, middle
# 例 1

---

## enumのassociated value

```swift
enum Either<A, B> {
    case Left(A)
    case Right(B)
}
```

```swift
let either: Either<A, B> = ...

switch either {
case .Left(let a):
    print("A: \(a)")

case .Right(let b):
    print("B: \(b)")
}
```

---

## これでもいいの？

```swift
enum Either<A, B> {
    case Left(A)
    case Right(B)
}
```

```swift
let either: Either<A, B> = ...

switch either {
case let .Left(a):
    print("A: \(a)")

case let .Right(b):
    print("B: \(b)")
}
```

---

class: center, middle
# 例 2

---

## Optional

```swift
let tuple: (A?, B) = ...

switch tuple {
case (.Some(let a), let b):
    print("A: \(a), B: \(b)")

case (.None, let b):
    print("A: nil, B: \(b)")
}
```

---

## これでもいいの？

```swift
let tuple: (A?, B) = ...

switch tuple {
case (let a?, let b):
    print("A: \(a), B: \(b)")

case (.None, let b):
    print("A: nil, B: \(b)")
}
```

---

## これも同じ？？？？

```swift
let tuple: (A?, B) = ...

switch tuple {
case (let a?, let b):
    print("A: \(a), B: \(b)")

case (let a, let b):
    print("A: \(a), B: \(b)")
}
```

---

class: center, middle
# 😇

---

## パターンの文法を知らないと...

- 込み入ったswitch文が読めない
- 愚直なswitch文しか書けない
- ググってみるけどよくわからなくて時間を浪費する

結果的に劣等感に悩まされる

---

class: center, middle
### パターンの文法はそんなに難しくないけど
### 初見で察することができるほど簡単ではない

---

## あらためてパターンってなに？

- 具体的な値ではなく値の性質を表すもの
- 具体的な値がマッチしているかどうかテストできる
- 数種類のパターンがあり組み合わせが可能
  - Wildcard Pattern
  - Identifier Pattern
  - Value-Binding Pattern
  - Tuple Pattern
  - Enumeration Case Pattern
  - Optional Pattern
  - Type-Casting Pattern
  - Expression Pattern

---

## 組み合わせ可能

```swift
let tuple: (A?, B) = ...

switch tuple {
case (let a?, let b):
    print("A: \(a), B: \(b)")

case (let a, let b):
    print("A: \(a), B: \(b)")
}
```

`case (let a?, let b)`では以下が組み合わされている

- Tuple Pattern
- Identifier Pattern
- Value-Binding Pattern
- Optional Pattern

---

## 各パターンの仕様

書くのが大変なので公式を参照します 🙇

- The Swift Programming Language
  - Language Reference
     - Patterns

---

class: center, middle
# どれも結構使う

---

class: center, middle
### よくわからなかったやつを振り返ると...

---

例1: パターンの組み合わせの順序が異なる

```swift
let either: Either<A, B> = ...

switch either {
case .Left(let a):
    print("A: \(a)")

case .Right(let b):
    print("B: \(b)")
}
```

```swift
switch either {
case let .Left(a):
    print("A: \(a)")

case let .Right(b):
    print("B: \(b)")
}
```

---

例 2: 同じもの違うパターンで表現している

```swift
let tuple: (A?, B) = ...
switch tuple {
case (.Some(let a), let b):
    print("A: \(a), B: \(b)")

case (.None, let b):
    print("A: nil, B: \(b)")
}
```
```swift
switch tuple {
case (let a?, let b):
    print("A: \(a), B: \(b)")

case (.None, let b):
    print("A: nil, B: \(b)")
}
```
```swift
switch tuple {
case (let a?, let b):
    print("A: \(a), B: \(b)")

case (let a, let b):
    print("A: \(a), B: \(b)")
}
```

---

class: center, middle
### ところで、普通のswitchはどうなってたの？

---

## IntとかRange&lt;Int&gt;とか

```swift
let int: Int = ...

switch int {
case 1:
    print("1")

case 3..<10:
    print("3..<10")
}
```

どのパターンが使われているかわかりますか？

---

## 正解はexpression pattern

```swift
func ~=<T: Equatable>(a: T, b: T) -> Bool
func ~=<I: ForwardIndexType where I: Comparable>
    (pattern: Range<I>, value: I) -> Bool
```

標準ライブラリで`~=`が定義されている

---

class: center, middle
### アプリ開発での使いどころ

---

### UITableViewController

```swift
class MyTableViewController: UITableViewController {
    // セルがA, B, Cの三種類あるとする
    enum CellType {
        case A
        case B
        case C

        var reuseIdentifier: String {
            switch self {
            case .A: return "A"
            case .B: return "B"
            case .C: return "C"
            }
        }
    }
    ...
}
```

セルの種類が複数あると期待通りの型のセルがdequeueできたか  
確認するのもだるいし安全にキャストしていくのもだるい

---

### UITableViewController

```swift
override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    let cellType = /* indexPathなどからセルの種類を決める */
    let cell = tableView.dequeueReusableCellWithIdentifier(
        cellType.reuseIdentifier, forIndexPath: indexPath)

    switch (cellType, cell) {
    case (.A, let cell as CellA):
        // cellはCellAとして扱える
        cell.cellALabel.text = "Hello!"

    default:
        fatalError("Unexpected cell dequeued.")
    }

    return cell
}
```

期待している種類と実際にdequeueされたセルの型を  
同時にマッチングしてあげればそこまでだるくない

---

## まとめ

- パターンの文法は初見では難しいが1度理解すれば簡単
- 複数のパターンの組み合わせで値の性質を表現する
- 標準ライブラリでいくつかexpression patternが用意されている
- アプリ開発でも使いどころはある
