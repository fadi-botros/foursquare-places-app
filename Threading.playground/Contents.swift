import Foundation

for i in 1...10 {
    DispatchQueue.global().async {
        print("Before \(i)")
        Thread.sleep(forTimeInterval: 1)
        print("After \(i)")
    }
}
