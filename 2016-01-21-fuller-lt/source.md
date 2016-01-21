class: center, middle

# Swiftってどうなの？

### ishkawa

---

background-image: url(./profile.png)

---
class: center, middle

## Swiftはよく叱ってくれる

---

## BooleanTypeでない条件式

- truthy, falsyという概念はない

```swift
let value = 1

// コンパイルエラー
if value {

}
```

- 明示的にtrue, falseを指定する必要がある

```swift
// OK
if value > 0 {

}
```

---

## 暗黙的なキャスト

- 型が一致しない値は代入できない
- `Int`と`UInt`であってもダメ

```swift
let int = 1
let uint: UInt

// コンパイルエラー
uint = int
```

- どのように変換するのか明示する必要がある
- 以下の例では`UInt.init(_:)`を使うことを明示している

```swift
// OK
uint = UInt(int)
```

- アップキャストだけは常に成功するのでOK

---

## `nil`リテラルの代入

- Swiftには値としての`nil`はないが`nil`リテラルがある
- `NilLiteralConvertible`な型なら`nil`リテラルを代入可能
- 代表的なものは`Optional<Wrapped>`

```swift
enum Optional<Wrapped>: NilLiteralConvertible {
    case None
    case Some(Wrapped)

    init(nilLiteral: ()) {
        self = .None
    }
}
```

- それ以外の型には`nil`リテラルは代入できない

```swift
// コンパイルエラー
let int: Int = nil
```

---

## エラー処理

- エラーの扱い明示しないとコンパイルエラー
  - 外に投げる
  - 中で処理する (キャッチ, オプショナル化, クラッシュ)

```swift
func doFailable() throws {

}

// コンパイルエラー
func doSomething() {
    doFailable()
}

// OK (外に投げる)
func doSomething() throws {
    try doFailable()
}
```

---

## エラー処理

```swift
// OK (キャッチ)
func doSomething() throws {
    do {
        try doFailable()
    } catch {
        // handle error
    }
}

// OK (オプショナル化)
func doSomething() throws {
    try? doFailable()
}

// OK (クラッシュ)
func doSomething() throws {
    try! doFailable()
}
```

---

## switchの列挙漏れ

```swift
enum TrafficLight {
    case Green, Yellow, Red
}
```

```swift
let trafficLight: TrafficLight = ...

// case .Yellowがないのでコンパイルエラー
switch trafficLight {
case .Green:
    print("Green")

case .Red:
    print("Red")
}
```

- ケースが変わった時に変更すべき場所を特定しやすい
- コンパイルエラーによって実装漏れに気づける

---

## 初期化前の変数へのアクセス

```swift
let shouldStop: Bool

switch trafficLight {
case .Green:
    break

case .Yellow, .Red:
    shouldStop = true
}

// .Greenの場合shouldStopが初期化されていないのでコンパイルエラー
if shouldStop {

}
```

- コンパイラが初期化をチェックしてくれる
- 変数宣言時に初期化しなくても安心
- `let`の場合は再代入もコンパイラがチェックしてくれる

---

## 戻り値の型の不整合

```swift
func shouldStop() -> Bool {
    switch trafficLight {
    case .Green:
        return false

    case .Yellow:
        return true

    case .Red:
        // このケースで戻り値がBoolじゃないのでコンパイルエラー
        break
    }
}
```

- 全実行パターンが宣言された型を返すかチェックしてくれる
- 末尾リターンに拘る必要がない

---
class: center, middle

# 結論

---
class: center, middle

# Swiftはよく叱ってくれる

---
class: center, middle

# 叱られたい人におすすめ
