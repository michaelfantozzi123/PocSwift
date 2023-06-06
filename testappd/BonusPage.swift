import SwiftUI
import CoreLocation

class LocationManager: NSObject, ObservableObject, CLLocationManagerDelegate {
    private let locationManager = CLLocationManager()
    @Published var currentLocation: CLLocation?

    override init() {
        super.init()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        currentLocation = locations.last
    }
}

struct BonusPage: View {
    @StateObject var locationManager = LocationManager()
    @State var showCoordinates = false

    var body: some View {
        VStack {
            Spacer()
            if showCoordinates, let location = locationManager.currentLocation {
                Text("Lat: \(location.coordinate.latitude), Lon: \(location.coordinate.longitude)")
                    .font(.title)
            }
            Spacer()
            Button(action: {
                self.showCoordinates.toggle()
            }) {
                Text("Show Coordinates")
                    .font(.headline)
                    .padding()
                    .background(Color.gray.opacity(0.2))
                    .cornerRadius(10)
            }
            .padding()
        }
    }
}

struct BonusPage_Previews: PreviewProvider {
    static var previews: some View {
        BonusPage()
    }
}
