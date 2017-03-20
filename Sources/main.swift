import Foundation

let engine = COEngine()

engine.addParser(AVBYParser())

while true {
    engine.checkout()
    sleep(3)
}
