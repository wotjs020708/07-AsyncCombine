//: [Previous](@previous)

import Foundation
import Combine

let margheritaOrder = Order(toppings: [
    Topping("tomatoes", isVegan: true),
    Topping("vegan mozzarella", isVegan: true),
    Topping("basil", isVegan: true)
])

let margheritaOrderPublisher = NotificationCenter.default.publisher(for: .didUpdateOrderStatus, object: margheritaOrder)
margheritaOrderPublisher
    .compactMap { notification in
        notification.userInfo?["status"] as? OrderStatus
    }
    .assign(to: \.status, on: margheritaOrder)

let extraToppingpublisher = NotificationCenter.default.publisher(for: .addTopping, object: margheritaOrder)

extraToppingpublisher
    .compactMap{ notification in
        notification.userInfo?["extra"] as? Topping
    }
    .filter{ topping in
        topping.isVegan
    }
    .filter{ $0.isVegan } // 위와 동일
    .prefix(3)
    .prefix(while: {
        margheritaOrder.status == .placing
    })
    .sink { value in
        if margheritaOrder.toppings != nil {
            margheritaOrder.toppings!.append(value)
            print("Adding \(value.name)")
            print("Your order now contains \(margheritaOrder.toppings!.count) toppings")
        }
    }
NotificationCenter.default.post(name: .addTopping, object: margheritaOrder, userInfo: ["extra": Topping("salami", isVegan: false)])
NotificationCenter.default.post(name: .addTopping, object: margheritaOrder, userInfo: ["extra": Topping("olives", isVegan: true)])
NotificationCenter.default.post(name: .addTopping, object: margheritaOrder, userInfo: ["extra": Topping("pepperoni", isVegan: true)])
NotificationCenter.default.post(name: .addTopping, object: margheritaOrder, userInfo: ["extra": Topping("capers", isVegan: true)])

NotificationCenter.default.post(name: .didUpdateOrderStatus, object: margheritaOrder, userInfo: ["status": OrderStatus.processing])
NotificationCenter.default.post(name: .addTopping, object: margheritaOrder, userInfo: ["extra": Topping("olives", isVegan: true)])
NotificationCenter.default.post(name: .didUpdateOrderStatus, object: margheritaOrder, userInfo: ["status": OrderStatus.delivered])
