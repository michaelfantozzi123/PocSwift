import SwiftUI

struct ContentView: View {
    @State private var selection: Int? = nil
    let logoUrl = URL(string: "https://nvm.co.uk/wp-content/uploads/2015/02/kerridge-commercial-systems.png") // Replace with actual URL
    
    var body: some View {
        let columns = [
            GridItem(.flexible(), spacing: 20),
            GridItem(.flexible(), spacing: 20)
        ]
        
        NavigationView {
            
            
            VStack {
                if let url = logoUrl {
                    AsyncImage(url: url) { image in
                        image.resizable()
                    } placeholder: {
                        ProgressView()
                    }
                    .aspectRatio(contentMode: .fit)
                    .padding()
                }
                
                LazyVGrid(columns: columns, spacing: 20) {
                    Button(action: { self.selection = 1 }) {
                        VStack {
                            Image(systemName: "chart.bar.xaxis")
                                .font(.largeTitle)
                            Text("Chart")
                        }
                        .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity)
                        .padding()
                        .background(Color.gray.opacity(0.2))
                        .cornerRadius(10)
                    }
                    .background(
                        NavigationLink(destination: ChartPage(), tag: 1, selection: $selection) {
                            EmptyView()
                        }
                    )
                    
                    Button(action: { self.selection = 2 }) {
                        VStack {
                            Image(systemName: "qrcode")
                                .font(.largeTitle)
                            Text("QR")
                        }
                        .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity)
                        .padding()
                        .background(Color.gray.opacity(0.2))
                        .cornerRadius(10)
                    }
                    .background(
                        NavigationLink(destination: QRPage(), tag: 2, selection: $selection) {
                            EmptyView()
                        }
                    )
                    
                    Button(action: { self.selection = 3 }) {
                        VStack {
                            Image(systemName: "radiowaves.left")
                                .font(.largeTitle)
                            Text("NFC")
                        }
                        .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity)
                        .padding()
                        .background(Color.gray.opacity(0.2))
                        .cornerRadius(10)
                    }
                    .background(
                        NavigationLink(destination: NFCPage(), tag: 3, selection: $selection) {
                            EmptyView()
                        }
                    )
                    
                    Button(action: { self.selection = 4 }) {
                        VStack {
                            Image(systemName: "faceid")
                                .font(.largeTitle)
                            Text("Biometrics")
                        }
                        .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity)
                        .padding()
                        .background(Color.gray.opacity(0.2))
                        .cornerRadius(10)
                    }
                    .background(
                        NavigationLink(destination: BiometricsPage(), tag: 4, selection: $selection) {
                            EmptyView()
                        }
                    )
                    
                    Button(action: { self.selection = 5 }) {
                        VStack {
                            Image(systemName: "star")
                                .font(.largeTitle)
                            Text("Bonus")
                        }
                        .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity)
                        .padding()
                        .background(Color.gray.opacity(0.2))
                        .cornerRadius(10)
                    }
                    .background(
                        NavigationLink(destination: BonusPage(), tag: 5, selection: $selection) {
                            EmptyView()
                        }
                    )
                }
                .padding(5)
                .background(Color.gray.opacity(0.05))
            } 
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
