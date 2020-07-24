import Foundation
import TGSwiftSignalKit
import CoreLocation

enum AccessType {
    case notDetermined
    case allowed
    case denied
    case restricted
    case unreachable
}

enum DeviceAccessSubject {
    case location
}

func authorizationStatus(subject: DeviceAccessSubject) -> Signal<AccessType, NoError> {
    switch subject {
    case .location:
        return Signal { subscriber in
            let status = CLLocationManager.authorizationStatus()
            switch status {
            case .authorizedWhenInUse, .authorizedAlways:
                subscriber.putNext(.allowed)
            case .denied, .restricted:
                subscriber.putNext(.denied)
            case .notDetermined:
                subscriber.putNext(.notDetermined)
            @unknown default:
                fatalError()
            }
            subscriber.putCompletion()
            return EmptyDisposable
        }
    }
}

