import SwiftUI
import LaTeXSwiftUI
import MathExpression
import CoreImage.CIFilterBuiltins

struct CalculatorView: View {
    
    @State private var orientation = UIDeviceOrientation.unknown
    @Binding var path: NavigationPath
    
    @State var encodedDeepLink = String()
    @Binding var calculatorDeepLinkSource: String
    
    var body: some View {
        if true {
            // simplified calculator
            SimplifiedCalculatorView(path: $path, calculatorDeepLinkSource: $calculatorDeepLinkSource)
        } else {
            // advance scientific calculator - WIP - will be an update
            ScientificCalculatorView(path: $path, calculatorDeepLinkSource: $calculatorDeepLinkSource)
        }
    }
}

struct DeviceRotationViewModifier: ViewModifier {
    let action: (UIDeviceOrientation) -> Void
    
    func body(content: Content) -> some View {
        content
            .onAppear()
            .onReceive(NotificationCenter.default.publisher(for: UIDevice.orientationDidChangeNotification)) { _ in
                action(UIDevice.current.orientation)
            }
    }
}

extension View {
    func onRotate(perform action: @escaping (UIDeviceOrientation) -> Void) -> some View {
        self.modifier(DeviceRotationViewModifier(action: action))
    }
}

struct CalculatorView_Previews: PreviewProvider {
    static var previews: some View {
        Text("CalculatorView()")
    }
}
