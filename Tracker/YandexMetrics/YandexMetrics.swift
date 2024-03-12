
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
    
    func clickedTrackerCreateButton() {
        reportYandexMetric(event: "click", screen: "Main", item: "add_tracker")
    }
    
    func clickedFilterButton() {
        reportYandexMetric(event: "click", screen: "Main", item: "selected_filter")
    }
    
    func reportTrackerEdit() {
        reportYandexMetric(event: "click", screen: "Main", item: "edit")
    }
    
    func reportTrackerDelete() {
        reportYandexMetric(event: "click", screen: "Main", item: "delete")
    }
    
    func reportTrackerCompleteButton() {
        reportYandexMetric(event: "click", screen: "Main", item: "tracker_complete")
    }
    func reportTrackerUnCompleteButton() {
        reportYandexMetric(event: "click", screen: "Main", item: "tracker_uncomplete")
    }
}
