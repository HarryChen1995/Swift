import Foundation
let queue = OperationQueue()


class WorkerA: Operation {
    
    override func main() {
        guard  !isCancelled else {
            return
        }
        print("worker A started")
    }
}

class WorkerB: Operation {
    
    override func main() {
        guard !dependencies.contains(where: {$0.isCancelled}), !isCancelled else {
            return
        }
        print("worker B started")
    }
}

let workerA = WorkerA()
workerA.completionBlock = {
    print("worker A finished")
}
let workerB = WorkerB()
workerB.completionBlock = {
    print("Worker B finished")
}
workerB.addDependency(workerA)
queue.addOperations([workerA, workerB], waitUntilFinished: true)


