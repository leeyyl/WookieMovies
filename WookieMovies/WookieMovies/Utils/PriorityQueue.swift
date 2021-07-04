//
//  PriorityQueue.swift
//  WookieMovies
//
//  Created by lee on 2021/3/4.
//

import Foundation

struct Heap<Element> {
    var elements: [Element]
    let priority: (Element, Element) -> Bool
    
    init(elements: [Element] = [], priority: @escaping (Element, Element) -> Bool) {
        self.elements = elements
        self.priority = priority
        buildHeap()
    }
    
    mutating func buildHeap() {
        // 非叶子结点下沉
        for index in (0..<(count / 2)).reversed() {
            sink(elementAtIndex: index)
        }
    }
    
    mutating func sink(elementAtIndex index: Int) {
        let childIndex = highestPriorityIndex(for: index)
        if index == childIndex {
            return
        }
        swapElement(at: index, with: childIndex)
        sink(elementAtIndex: childIndex)
    }
    
    var isEmpty: Bool {
        return elements.isEmpty
    }
    
    var count: Int {
        return elements.count
    }
    
    func peek() -> Element? {
        return elements.first
    }
    
    mutating func push(_ element: Element) {
        // 添加到最后一个位置，并上浮
        elements.append(element)
        shift(elementAtIndex: count - 1)
    }
    
    mutating func shift(elementAtIndex index: Int) {
        let parent = parentIndex(of: index)
        guard !isRoot(index), isHigherPriority(at: index, than: parent) else {
            return
        }
        swapElement(at: index, with: parent)
        shift(elementAtIndex: parent)
    }
    
    mutating func pop() -> Element? {
        guard !isEmpty else {
            return nil
        }
        
        swapElement(at: 0, with: count - 1)
        let element = elements.removeLast()
        if !isEmpty {
            sink(elementAtIndex: 0)
        }
        return element
    }
    
    // helper functions
    func isRoot(_ index: Int) -> Bool {
        return index == 0
    }
    
    func leftChildIndex(of index: Int) -> Int {
        return 2 * index + 1
    }
    
    func rightChildIndex(of index: Int) -> Int {
        return 2 * index + 2
    }
    
    func parentIndex(of index: Int) -> Int {
        return (index - 1) / 2
    }
    
    func isHigherPriority(at first: Int, than second: Int) -> Bool {
        return priority(elements[first], elements[second])
    }
    
    func highestPriorityIndex(of parent: Int, and child: Int) -> Int {
        guard child < count, isHigherPriority(at: child, than: parent) else {
            return parent
        }
        return child
    }
    
    func highestPriorityIndex(for parent: Int) -> Int {
        let highest = highestPriorityIndex(of: parent, and: leftChildIndex(of: parent))
        return highestPriorityIndex(of: highest, and: rightChildIndex(of: parent))
    }
    
    mutating func swapElement(at first: Int, with second: Int) {
        guard first != second else {
            return
        }
        elements.swapAt(first, second)
    }
}

extension Heap where Element: Equatable {
    mutating func remove(_ element: Element) {
        guard let index = elements.firstIndex(of: element) else {
            return
        }
        
        swapElement(at: index, with: count - 1)
        elements.remove(at: count - 1)
        sink(elementAtIndex: index)
    }
    
    mutating func boost(_ element: Element) {
        guard let index = elements.firstIndex(of: element) else {
            return
        }
        
        shift(elementAtIndex: index)
    }
}
