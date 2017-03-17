import Foundation

var sema = DispatchSemaphore( value: 0 )

let engine = COEngine()

engine.addParser(AVBYParser())

DispatchQueue(label: "checkoutQueue").async {
    while true {
        engine.checkout()
        sleep(3)
    }
}

sema.wait()
