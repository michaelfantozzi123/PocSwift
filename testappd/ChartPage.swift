import SwiftUI

struct SalesData: Identifiable {
    let id = UUID()
    let name: String
    let value: Double
}

struct PieSlice: Shape {
    let startAngle: Angle
    let endAngle: Angle

    func path(in rect: CGRect) -> Path {
        let center = CGPoint(x: rect.midX, y: rect.midY)
        let radius = min(rect.width, rect.height) / 2
        let start = CGPoint(x: center.x + radius * cos(CGFloat(startAngle.radians)), y: center.y + radius * sin(CGFloat(startAngle.radians)))
        var path = Path()
        path.move(to: center)
        path.addLine(to: start)
        path.addArc(center: center, radius: radius, startAngle: startAngle, endAngle: endAngle, clockwise: false)
        path.addLine(to: center)
        return path
    }
}

struct ChartPage: View {
    let salesData = [
        SalesData(name: "Product A", value: 120),
        SalesData(name: "Product B", value: 75),
        SalesData(name: "Product C", value: 200),
        SalesData(name: "Product D", value: 60)
    ]

    @State private var selectedSalesData: SalesData?

    var total: Double {
        salesData.reduce(0) { $0 + $1.value }
    }

    var body: some View {
        GeometryReader { geometry in
            ZStack {
                ForEach(salesData.indices) { index in
                    let startAngle = self.angle(for: self.startValue(at: index))
                    let endAngle = self.angle(for: self.endValue(at: index))
                    PieSlice(startAngle: startAngle, endAngle: endAngle)
                        .fill(self.color(for: index))
                        .onTapGesture {
                            self.selectedSalesData = self.salesData[index]
                        }
                }
            }
            .frame(width: min(geometry.size.width, geometry.size.height), height: min(geometry.size.width, geometry.size.height))
        }
        .alert(item: $selectedSalesData) { data in
            Alert(title: Text(data.name), message: Text("Sales: \(data.value)"), dismissButton: .default(Text("OK")))
        }
    }

    private func startValue(at index: Int) -> Double {
        guard index > 0 else { return 0 }
        return salesData[..<index].reduce(0) { $0 + $1.value } / total
    }

    private func endValue(at index: Int) -> Double {
        return salesData[...index].reduce(0) { $0 + $1.value } / total
    }

    private func angle(for value: Double) -> Angle {
        return Angle(degrees: 360 * value)
    }

    private func color(for index: Int) -> Color {
        let colors = [Color.red, Color.green, Color.blue, Color.yellow]
        return colors[index % colors.count]
    }
}

struct ChartPage_Previews: PreviewProvider {
    static var previews: some View {
        ChartPage()
    }
}
