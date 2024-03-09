import Foundation
import YandexMobileMetrica

struct YandexMetrics {

    func report(event: String, screen: String, item: String?) {
        var params: [String: Any] = ["event": event, "screen": screen]
        if let itemValue = item {
            params["item"] = itemValue
        }

        YMMYandexMetrica.reportEvent(event, parameters: params, onFailure: { error in
            print("REPORT ERROR: %@", error.localizedDescription)
        })
    }
    
    func didOpenMain() {
        report(event: "open", screen: "Main", item: nil)
    }
    
    func closedMain() {
        report(event: "close", screen: "Main", item: nil)
    }
    
    func clickedAddButton() {
        report(event: "click", screen: "Main", item: "add_track")
    }
    
    func clickedFilterButton() {
        report(event: "click", screen: "Main", item: "filter")
    }
    
    func reportEditEventOnMain() {
        report(event: "click", screen: "Main", item: "edit")
    }

    func reportDeleteEventOnMain() {
        report(event: "click", screen: "Main", item: "delete")
    }

    func reportTrackEventOnMain() {
        report(event: "click", screen: "Main", item: "track")
    }
    
    
}
