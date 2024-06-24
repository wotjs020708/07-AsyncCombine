import Foundation
import PlaygroundSupport

PlaygroundPage.current.needsIndefiniteExecution = true

public func customerSays(_ message: String) {
    print("[Customer] \(message)")
}

public func sandwichMakerSays(_ message: String, waitFor time: UInt32 = 0) {
    print("[Sandwich maker] \(message)")
    if time > 0 {
        print("                 ... this will take \(time)s")
        sleep(time)
    }
}

func toastBread(_ bread: String) async -> String {
    sandwichMakerSays("Toasting the bread... Standing by...")
    try? await Task.sleep(nanoseconds: 5_000_000_000)
    return "Cripy \(bread)"
}

func slice(_ ingredients: [String]) async -> [String] {
    var result = [String]()
    for ingredient in ingredients {
        sandwichMakerSays("Slicing \(ingredient)")
        try? await Task.sleep(for: .seconds(1))
        result.append("sliced \(ingredient)")
        
    }
    return result
}

func makeSandwich(bread: String, ingredients: [String], condiments: [String]) async -> String {
    sandwichMakerSays("Preparing your sandwich...")
    
    async let toasted = await toastBread(bread)
    async let sliced = await slice(ingredients)
    
    sandwichMakerSays("Spreading \(condiments.joined(separator: ", and ")) om \(await toasted)")
        sandwichMakerSays("Layering \(await sliced.joined(separator: ", "))")
        sandwichMakerSays("Putting lettuce on top")
        sandwichMakerSays("Putting another slice of bread on top")

        return "\(ingredients.joined(separator: ", ")), \(condiments.joined(separator: ", ")) on \(await toasted)"
}

let clock = ContinuousClock()

sandwichMakerSays("Hello to Cafe Async, where we execute your order in parallel.")
sandwichMakerSays("Please place your order.")

Task {
    let time = await clock.measure {
        let sandwich = await makeSandwich(bread: "Rye", ingredients: ["Cucmbers", "Tomatoes"], condiments: ["Mayo", "Mustard"])
        customerSays("Hmmm.... this looks like a delicious \(sandwich) sandwich!")
        print("The end.")
    }
    print("Making this sandwich took \(time)") // prints "Making this sandwich took 5.331491 seconds"
}
