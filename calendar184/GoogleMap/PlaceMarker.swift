import UIKit
import GoogleMaps

class PlaceMarker: GMSMarker {
    
    let place: GooglePlace
    
    init(place: GooglePlace) {
        self.place = place
        super.init()
        
        position = place.coordinate
        groundAnchor = CGPoint(x: 0.5, y: 1)
        appearAnimation = .pop
        title = place.name
        snippet = place.address
    }
}

