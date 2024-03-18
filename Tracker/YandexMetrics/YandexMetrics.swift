
import Foundation
import YandexMobileMetrica

struct YandexMetrics {
    
    func reportYandexMetric(event: String, screen: String, item: String?) {
        var params: [String: Any] = ["event": event, "screen": screen]
        if let itemValue = item {
            params["item"] = itemValue
        }
        
        YMMYandexMetrica.reportEvent(event, parameters: params, onFailure: { error in
            print("REPORT ERROR: %@", error.localizedDescription)
        })
    }
    
    func openMainScreen() {
        reportYandexMetric(event: "open", screen: "Main", item: nil)
    }
    
    func closedMainScreen() {
        reportYandexMetric(event: "close", screen: "Main", item: nil)
    }
    
    func clickedTrackerCreateButton() {
        reportYandexMetric(event: "click", screen: "Main", item: "add_tracker")
    }
    
    func clickedFilterButton() {
        reportYandexMetric(event: "click", screen: "Main", item: "filter")
    }
    
    func reportTrackerEdit() {
        reportYandexMetric(event: "click", screen: "Main", item: "edit")
    }
    
    func reportTrackerDelete() {
        reportYandexMetric(event: "click", screen: "Main", item: "delete")
    }
    
    func reportTrackerCompleteButton() {
        reportYandexMetric(event: "click", screen: "Main", item: "track")
    }
    func reportTrackerUnCompleteButton() {
        reportYandexMetric(event: "click", screen: "Main", item: "no_track")
    }
}
