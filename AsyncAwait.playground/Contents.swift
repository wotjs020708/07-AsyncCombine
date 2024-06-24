import Foundation

public func customerSays(_ message: String) {
    print("[Coustomer] \(message)")
}

public func sandwichMakerSays(_ message: String, waitFor time: UInt32 = 0) {
    print("[Sandwich maker \(message)")
    if time > 0 {
        print("           ... this will take \(time)s")
        sleep(time)
    }
}

func toastBrad(_ bread:String) -> String {
    sandwichMakerSays("Toasting th bread... Standing by...", waitFor:  5)
    return "Cripy\(bread)"
}
func slice(_ ingredients: [String]) -> [String] {
    let results = ingredients.map { ingredient in
        sandwichMakerSays("Slicing \(ingredient)", waitFor: 1)
        return "slice \(ingredient)"
    }
    return results
}

func makeSandwich(bread: String, ingredients: [String], condiments: [String]) -> String {
    sandwichMakerSays("Preparing your sandwitch")
    let toasted = toastBrad(bread)
    let sliced = slice(ingredients)
    sandwichMakerSays("Spreading \(condiments.joined(separator: ", and"))")
    sandwichMakerSays("Layering \(sliced.joined(separator: ", "))")
    sandwichMakerSays("Putting lettuce on top")
    sandwichMakerSays("Putting antoher slice of bread on top")
    return "\(ingredients.joined(separator: ", ")), \(condiments.joined(separator: ", ")) on \(toasted)"
}

sandwichMakerSays("Hello to Cafe Synchronous, where we execute your order sarially.")
sandwichMakerSays("Please Place your order.")


let clock = ContinuousClock()
let time = clock.measure {
    let sandwich = makeSandwich(bread: "Rye", ingredients: ["Cucmbers", "Tomatoes"], condiments: ["Mayo", "Mustard"])
    customerSays("Hmmm.... this looks like a delicious \(sandwich) sandwich!")
}

print("Making this sandwich took \(time)")
