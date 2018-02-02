//: Playground - noun: a place where people can play
import UIKit

class Person {
    var name: String
    var age: Int
    init(name: String, age: Int) {
        self.name = name;
        self.age = age;
    }
}

let originPerson = Person(name: "Tony", age: 10)
let copyPerson = originPerson
originPerson.age = 20

var mutableFibs = [0, 1, 1, 2, 3, 5]
let squares = mutableFibs.map { number in number * number }

extension Array {
    func map<T>(_ transform: (Element) -> T) -> [T] {
        var result: [T] = []
        result.reserveCapacity(count)
        for x in self {
            result.append(transform(x))
        }
        return result;
    }
}

let index1 = mutableFibs.index(of: 7)
let index2 = mutableFibs.index(of: 1)

let reverseSquares = squares.reversed()

let names = ["Paula", "Elena", "Zoe"]
var firstNameEndingInA: String?
for name in names where name.hasSuffix("a") {
    firstNameEndingInA = name
    break
}

var lastNameEndingInA: String?
for name in names.reversed() where name.hasSuffix("a") {
    lastNameEndingInA = name
    break
}

extension Sequence {
    func first(where predicate: (Element) -> Bool) -> Element? {
        for element in self where predicate(element) {
            return element
        }
        return nil
    }
    func last(where predicate: (Element) -> Bool) -> Element? {
        for element in reversed() where predicate(element) {
            return element
        }
        return nil
    }
}

let firstMatch = names.first{ $0.hasSuffix("a") }
firstMatch

let lastMatch = names.last { (ele) -> Bool in
    ele.hasSuffix("a")
}
// “accumulate — 累加，和 reduce 类似，不过是将所有元素合并到一个数组中，并保留合并时每一步的值。”
extension Array {
    func accumulate<Result>(_ initialResult: Result, _ nextPartialResult: (Result, Element) -> Result) -> [Result] {
        var running = initialResult
        return map { next in
            running = nextPartialResult(running, next)
            return running
        }
    }
}
[1, 2, 3, 4].accumulate(0, +)
[1, 2, 3, 4].accumulate(1, *)
// “all(matching:) 和 none(matching:) — 测试序列中是不是所有元素都满足某个标准，以及是不是没有任何元素满足某个标准。它们可以通过 contains 和它进行了精心对应的否定形式来构建。
//count(where:) — 计算满足条件的元素的个数，和 filter 相似，但是不会构建数组。
//indices(where:) — 返回一个包含满足某个标准的所有元素的索引的列表，和 index(where:) 类似，但是不会在遇到首个元素时就停止。”




// “寻找 100 以内同时满足是偶数并且是其他数字的平方的数”
let result = (1..<10).map{$0 * $0 }.filter{ $0 % 2 == 0 }
result

// Filter
extension Array {
    func filter(_ isIncluded: (Element) -> Bool) -> [Element] {
        var result: [Element] = []
        for x in self where isIncluded(x) {
            result.append(x)
        }
        return result
    }
}

// “想检查一个序列中的所有元素是否全部都满足某个条件”
extension Sequence {
    public func all(matching predicate: (Element) -> Bool) -> Bool {
        return !contains{!predicate($0)}
    }
}
let evenNums = [2, 4, 6, 8]
let isContainAll = evenNums.all{ $0 % 2 == 0 }
isContainAll

// Reduce
extension Array {
    func reduce<Result>(_ initialResult: Result, _ nextPartialResult: (Result, Element) -> Result) -> Result {
        var result = initialResult
        for x in self {
            result = nextPartialResult(result, x)
        }
        return result
    }
}

// Flatmap
extension Array {
    func flatMap<T>(_ transform: (Element) -> [T]) -> [T] {
        var result: [T] = []
        for x in self {
            result.append(contentsOf: transform(x))
        }
        return result
    }
}

let suits = ["♠︎", "♥︎", "♣︎", "♦︎"]
let ranks = ["J","Q","K","A"]
let results = suits.flatMap { suit in
    ranks.map { rank in
        (suit, rank)
    }
}
results

//切片
let slice = mutableFibs[1...]
type(of: slice) //ArraySlice类型
// 将ArraySlice转化为数组
let newArray = Array(slice)
type(of: newArray) // Array<Int>

//字典
enum Setting {
    case text(String)
    case int(Int)
    case bool(Bool)
}
let defaultSettings: [String:Setting] = [
    "Airplane Mode": .bool(false),
    "Name": .text("My iPhone")
]

var userSettings = defaultSettings
userSettings["Name"] = .text("Jared's iPhone")
userSettings["Do Not Disturb"] = .bool(true)

//userSettings["Airplane Mode"] = nil // will remove this key
//let oldKey = userSettings.removeValue(forKey: "Airplane Mode") // “除了删除这个键以外，还会将被删除的值返回 (如果待删除的键不存在，则返回 nil)。”
let oldName = userSettings
    .updateValue(.text("Jane's iPhone"), forKey: "Name") // “这个方法将在更新之前有值的时候返回这个更新前的值”

/*
var settings = defaultSettings
let overriddenSettings: [String:Setting] = ["Name": .text("Jane's iPhone")]
settings.merge(overriddenSettings, uniquingKeysWith: { $1 })
settings
// ["Name": Setting.text("Jane\'s iPhone"), "Airplane Mode": Setting.bool(false)]
在上面的例子中，我们使用了 { $1 } 来作为合并两个值的策略。也就是说，如果某个键同时存在于 settings 和 overriddenSettings 中时，我们使用 overriddenSetttings 中的值。
*/

extension Sequence where Element: Hashable {
    var frequencies: [Element: Int] {
        let frequencyPairs = self.map { ($0, 1) }
        return Dictionary(frequencyPairs, uniquingKeysWith: +)
    }
}

let frequencies = "hello".frequencies

let settingsAsStrings = userSettings.mapValues { setting -> String in
    switch setting {
    case .text(let text): return text
    case .int(let number): return String(number)
    case .bool(let value): return String(value)
    }
}
settingsAsStrings // ["Name": "Jane\'s iPhone", "Airplane Mode": "false"]
//Set的操作查询 SetAlgebra协议


// “找到序列中的所有不重复的元素，并且维持它们原来的顺序”
extension Sequence where Element: Hashable {
    func unique() -> [Element] {
        var seen: Set<Element> = []
        return filter({ (element) -> Bool in
            if seen.contains(element) {
                return false
            } else {
                seen.insert(element)
                return true
            }
        })
    }
}
[1,2,3,12,1,3,4,5,6,4,6].unique() // [1, 2, 3, 12, 4, 5, 6]

let ununiqueSet: Set = [1,2,3,12,1,3,4,5,6,4,6] // [12, 2, 4, 5, 6, 3, 1]

// FibsIterator 迭代器
struct FibsIterator: IteratorProtocol {
    var state = (0, 1)
    mutating func next() -> Int? {
        let upcomingNumber = state.0
        state = (state.1, state.0 + state.1)
        return upcomingNumber
    }
}

var fib = FibsIterator();
var fibs: [Int] = []
for _ in 0...5 {
    if let fib = fib.next() {
        fibs.append(fib)
    }
}
fibs


//遵守序列协议
struct PrefixIterator: IteratorProtocol {
    let string: String
    var offset: String.Index

    init(string: String) {
        self.string = string
        offset = string.startIndex
    }

    mutating func next() -> Substring? {
        guard offset < string.endIndex else {
            return nil
        }
        offset = string.index(after: offset)
        return string[..<offset]
    }
}

struct PrefixSequence: Sequence {
    let string: String
    func makeIterator() -> PrefixIterator {
        return PrefixIterator(string: string)
    }
}

for prefix in PrefixSequence(string: "Hello") {
    print(prefix)
}


