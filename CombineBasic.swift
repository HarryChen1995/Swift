import Foundation
import Combine

// Timer Publisher
var count:Int = 0
var timerPublisher = Timer.publish(every: 1, on: .main, in: .default).autoconnect().sink(receiveValue: { _ in
    count += 1
    print("\(count) seconds passed")
})

// URL publisher

let url = URL(string: "https://www.apple.com/")!
var urlSession = URLSession.shared.dataTaskPublisher(for: url).tryMap{
    data, response -> Data in
    
    guard let response  = response as? HTTPURLResponse , response.statusCode == 200 else {
        throw URLError(.badServerResponse)
    }
    return data
}.map {
    String(data: $0, encoding: .utf8)
}.sink(receiveCompletion: {
    print($0)
}, receiveValue: {
    print($0!)
})

// PassThroughSubject Publisher
var passThroughPublisher = PassthroughSubject<String, Never>()
passThroughPublisher.map {
    if $0 == "good" {
        return 1
    }
    else {
        return 0
    }
}.sink(receiveValue: {
    print($0)
})
passThroughPublisher.send("good")


// CurrentValueSubject Publisher
var currentPublisher = CurrentValueSubject<String, Never>("good")
print(currentPublisher.value)
currentPublisher.map {
    if $0 == "good" {
        return 1
    }
    else {
        return 0
    }
}.sink(receiveValue: {
    print($0)
})
currentPublisher.send("bad")


// future
var future = Future<Int, Never>{
    promise in
    DispatchQueue.main.asyncAfter(deadline: .now() + 2 , execute: {
        promise(.success(1))
    })
}.sink(receiveValue: {
    print($0)
})


//  merge and combine publishers
let pub1 = PassthroughSubject<Int, Never>()
let pub2 = PassthroughSubject<Int, Never>()

pub1.combineLatest(pub2).sink { print("Result: \($0).") }

pub1.send(1)
pub1.send(2)
pub2.send(2)
pub1.send(3)
pub1.send(45)
pub2.send(22)

let pubA = PassthroughSubject<Int, Never>()
let pubB = PassthroughSubject<Int, Never>()
let pubC = PassthroughSubject<Int, Never>()

pubA.merge(with: pubB, pubC).sink { print("\($0)", terminator: " " )}

pubA.send(1)
pubB.send(40)
pubC.send(90)
pubA.send(2)
pubB.send(50)
pubC.send(100)
