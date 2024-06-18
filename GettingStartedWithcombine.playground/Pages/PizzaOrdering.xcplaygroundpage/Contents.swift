//: [Previous](@previous)

import Foundation
import Combine

let pizzOrder = Order()

let pizzaOrderPublisher = NotificationCenter.default.publisher(for: .didUpdateOrderStatus, object: pizzOrder)

pizzaOrderPublisher.sink { notification in
    print("---------------notification start-------------------")
    dump(notification)
    print("---------------notification end-------------------")
}

pizzaOrderPublisher.map { notification in
    notification.userInfo?["status"] as? OrderStatus ?? OrderStatus.placing
}
.sink{ orderStatus in
    print("Order status [\(orderStatus)]")
}
print("Order: \(pizzOrder.status)")

NotificationCenter.default.post(name: .didUpdateOrderStatus,
                                object: pizzOrder,
                                userInfo: ["status":OrderStatus.processing])


//: [Next](@next)
