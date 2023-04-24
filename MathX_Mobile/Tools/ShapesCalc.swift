//
//  ShapesCalc.swift
//  MathX_Mobile
//
//  Created by Tristan on 24/04/2023.
//

import SwiftUI
import SceneKit
import LaTeXSwiftUI

struct ShapesCalc: View {
    
    let dimensions = ["2D", "3D"]
    let TwoDShapes = ["Square", "Triangle", "Circle", "Trapezium", "Parallelogram"]
    let ThreeDShapes = ["Cuboid", "Pyramid", "Sphere", "Cylinder", "Cone"]
    let threeDCalculationType = ["Volume", "Surface Area"]

    @State var side1 = ""
    @State var side2 = ""
    @State var side3 = ""
    
    @State var results = ""
    
    @State var dimensionSelection = "2D"
    @State var statedimensionSelection = "2D"

    @State var shapeSelection = "Square"
    @State var stateshapeSelection = "Square"
    
    @State var threeDCalculation = "Volume"
    @State var statethreeDCalculation = "Volume"
    
    @Environment(\.colorScheme) var colorScheme
    
    @State var scene = SCNScene(named: "")

    var cameraNode: SCNNode? {
        scene?.rootNode.childNode(withName: "camera", recursively: false)
    }

    var body: some View {
        Form {
            Section {
                // 3D shape rendering (cant implement since it makes everything super laggy)
//                if statedimensionSelection == "3D" {
//                    SceneView (
//                        scene: scene,
//                        pointOfView: cameraNode,
//                        options: [.allowsCameraControl]
//                    )
//                    .frame(height: UIScreen.main.bounds.height * 1/5)
//                    .onChange(of: colorScheme) { _ in
//                        if statedimensionSelection == "3D" {
//                            scene = SCNScene(named: getSceneNameColorScheme(shape: stateshapeSelection))
//                        }
//                    }
//                }
                
                Picker("", selection: $dimensionSelection) {
                    ForEach(dimensions, id: \.description) { dimension in
                        Text(dimension)
                            .tag(dimension)
                    }
                }
                .pickerStyle(.segmented)
                .onChange(of: dimensionSelection) { _ in
                    if dimensionSelection == "2D" {
                        shapeSelection = "Square"
                    } else if dimensionSelection == "3D" {
                        shapeSelection = "Cuboid"
                    }
                    
                    withAnimation {
                        statedimensionSelection = dimensionSelection
                    }
                }
                
                if statedimensionSelection == "2D" {
                    Picker("", selection: $shapeSelection) {
                        ForEach(TwoDShapes, id: \.description) { shape in
                            Text(shape)
                                .tag(shape)
                        }
                    }
                    .pickerStyle(.segmented)
                    .onChange(of: shapeSelection) { _ in
                        withAnimation {
                            stateshapeSelection = shapeSelection
                        }
                    }
                } else if statedimensionSelection == "3D" {
                    Picker("", selection: $shapeSelection) {
                        ForEach(ThreeDShapes, id: \.description) { shape in
                            Text(shape)
                                .tag(shape)
                        }
                    }
                    .pickerStyle(.segmented)
                    .onChange(of: shapeSelection) { _ in
                        withAnimation {
                            stateshapeSelection = shapeSelection
                        }
                    }
                }
            }
            
            Section(header: Text(stateshapeSelection)) {
                ScrollView(.horizontal, showsIndicators: false) {
                    LaTeX(getFormulaForShape(shape: stateshapeSelection))
                        .parsingMode(.all)
                        .blockMode(.alwaysInline)
                }
                
                TextField("\(getSidesNames(sideNumber: 1, shape: stateshapeSelection))", text: $side1)
                    .keyboardType(.decimalPad)
                
                if numberOfInputsRequired(shape: stateshapeSelection) > 1 {
                    TextField("\(getSidesNames(sideNumber: 2, shape: stateshapeSelection))", text: $side2)
                        .keyboardType(.decimalPad)
                    
                    if numberOfInputsRequired(shape: stateshapeSelection) > 2 {
                        TextField("\(getSidesNames(sideNumber: 3, shape: stateshapeSelection))", text: $side3)
                            .keyboardType(.decimalPad)
                    }
                }
            }
            
            Section(header: Text("Results")) {
                if statedimensionSelection == "3D" {
                    Picker("", selection: $threeDCalculation) {
                        ForEach(threeDCalculationType, id: \.description) { calculationType in
                            Text(calculationType)
                                .tag(calculationType)
                        }
                    }
                    .pickerStyle(.segmented)
                    .onChange(of: threeDCalculation) { _ in
                        withAnimation {
                            statethreeDCalculation = threeDCalculation
                        }
                    }
                }
                
                HStack {
                    Text(statedimensionSelection == "2D" ? "Area:" : statethreeDCalculation == "Volume" ? "Volume:" : "Surface Area:")
                    Spacer()
                    Text(results)
                        .multilineTextAlignment(.trailing)
                }
            }
        }
        .scrollDismissesKeyboard(.interactively)
        .navigationTitle("Shapes Calculator")
        .onAppear {
            if statedimensionSelection == "3D" {
                scene = SCNScene(named: getSceneName(shape: stateshapeSelection))
            }
        }
        .onChange(of: side1) { _ in
            if getNumberOfTextfieldsFilled() == numberOfInputsRequired(shape: stateshapeSelection) {
                results = calculate(shape: stateshapeSelection)
            } else {
                results = ""
            }
        }
        .onChange(of: side2) { _ in
            if getNumberOfTextfieldsFilled() == numberOfInputsRequired(shape: stateshapeSelection) {
                results = calculate(shape: stateshapeSelection)
            } else {
                results = ""
            }
        }
        .onChange(of: side3) { _ in
            if getNumberOfTextfieldsFilled() == numberOfInputsRequired(shape: stateshapeSelection) {
                results = calculate(shape: stateshapeSelection)
            } else {
                results = ""
            }
        }
        .onChange(of: stateshapeSelection) { _ in
            side1 = ""
            side2 = ""
            side3 = ""
            
            if getNumberOfTextfieldsFilled() == numberOfInputsRequired(shape: stateshapeSelection) {
                results = calculate(shape: stateshapeSelection)
            } else {
                results = ""
            }
            
            if statedimensionSelection == "3D" {
                scene = SCNScene(named: getSceneName(shape: stateshapeSelection))
            }
        }
        .onChange(of: statedimensionSelection) { _ in
            side1 = ""
            side2 = ""
            side3 = ""
            
            if getNumberOfTextfieldsFilled() == numberOfInputsRequired(shape: stateshapeSelection) {
                results = calculate(shape: stateshapeSelection)
            } else {
                results = ""
            }
            
            if statedimensionSelection == "3D" {
                scene = SCNScene(named: getSceneName(shape: stateshapeSelection))
            }
        }
        .onChange(of: statethreeDCalculation) { _ in
            if getNumberOfTextfieldsFilled() == numberOfInputsRequired(shape: stateshapeSelection) {
                results = calculate(shape: stateshapeSelection)
            } else {
                results = ""
            }
        }
    }
    
    func getNumberOfTextfieldsFilled() -> Int {
        var filledCount = 0
        
        if !side1.isEmpty {
            filledCount += 1
        }
        if !side2.isEmpty {
            filledCount += 1
        }
        if !side3.isEmpty {
            filledCount += 1
        }
        
        return filledCount
    }
    
    func numberOfInputsRequired(shape: String) -> Int {
        switch shape {
            // 3D Shapes
        case "Cuboid":
            return 3
        case "Sphere":
            return 1
        case "Cylinder":
            return 2
        case "Pyramid":
            return 3
        case "Cone":
            return 2
            
            // 2D Shapes
        case "Square":
            return 2
        case "Triangle":
            return 2
        case "Circle":
            return 1
        case "Trapezium":
            return 3
        case "Parallelogram":
            return 2
            
        default:
            return 3
        }
    }
    
    func getSidesNames(sideNumber: Int, shape: String) -> String {
        switch shape {
            // 3D Shapes
        case "Cuboid":
            switch sideNumber {
            case 1:
                return "Length (l)"
            case 2:
                return "Breadth (b)"
            case 3:
                return "Height (h)"
            default:
                return ""
            }
        case "Sphere":
            switch sideNumber {
            case 1:
                return "Radius (r)"
            default:
                return ""
            }
        case "Cylinder":
            switch sideNumber {
            case 1:
                return "Radius (r)"
            case 2:
                return "Height (h)"
            default:
                return ""
            }
        case "Pyramid":
            switch sideNumber {
            case 1:
                return "Base length (l)"
            case 2:
                return "Base breadth (b)"
            case 3:
                return "Height (h)"
            default:
                return ""
            }
        case "Cone":
            switch sideNumber {
            case 1:
                return "Radius (r)"
            case 2:
                return "Height (h)"
            default:
                return ""
            }
            
            // 2D Shapes
        case "Square":
            switch sideNumber {
            case 1:
                return "Length"
            case 2:
                return "Breadth"
            default:
                return ""
            }
        case "Triangle":
            switch sideNumber {
            case 1:
                return "Base"
            case 2:
                return "Height"
            default:
                return ""
            }
        case "Circle":
            switch sideNumber {
            case 1:
                return "Radius"
            default:
                return ""
            }
        case "Trapezium":
            switch sideNumber {
            case 1:
                return "Base A"
            case 2:
                return "Base B"
            case 3:
                return "Height"
            default:
                return ""
            }
        case "Parallelogram":
            switch sideNumber {
            case 1:
                return "Base"
            case 2:
                return "Height"
            default:
                return ""
            }
            
        default:
            return ""
        }
    }
    
    func calculate(shape: String) -> String {
        switch shape {
            // 3D Shapes
        case "Cuboid":
            guard let l = Double(side1) else { return "" }
            guard let b = Double(side2) else { return "" }
            guard let h = Double(side3) else { return "" }

            if statethreeDCalculation == "Volume" {
                return (l * b * h).formatted()
            } else {
                return (2 * (l * h + l * b + h * b)).formatted()
            }
        case "Sphere":
            guard let r = Double(side1) else { return "" }

            if statethreeDCalculation == "Volume" {
                return (4/3 * .pi * pow(r, 3)).formatted()
            } else {
                return (4 * .pi * pow(r, 2)).formatted()
            }
        case "Cylinder":
            guard let r = Double(side1) else { return "" }
            guard let h = Double(side2) else { return "" }
            
            if statethreeDCalculation == "Volume" {
                return (.pi * pow(r, 2) * h).formatted()
            } else {
                return ((2 * .pi * r * h) + (2 * .pi * pow(r, 2))).formatted()
            }
        case "Pyramid":
            guard let l = Double(side1) else { return "" }
            guard let w = Double(side2) else { return "" }
            guard let h = Double(side3) else { return "" }
            
            if statethreeDCalculation == "Volume" {
                return ((l * w * h) / 3).formatted()
            } else {
                return (l * w + (l * (sqrt(pow(w / 2, 2) + pow(h, 2)))) + (w * (sqrt(pow(l / 2, 2) + pow(h, 2))))).formatted()
            }
        case "Cone":
            guard let r = Double(side1) else { return "" }
            guard let h = Double(side2) else { return "" }
            
            if statethreeDCalculation == "Volume" {
                return (.pi * pow(r, 2) * (h / 3)).formatted()
            } else {
                return ((.pi * r) * (r + (sqrt(pow(h, 2) + pow(r, 2))))).formatted()
            }
            
            // 2D Shapes
        case "Square":
            guard let l = Double(side1) else { return "" }
            guard let b = Double(side2) else { return "" }
            
            return (l * b).formatted()
        case "Triangle":
            guard let b = Double(side1) else { return "" }
            guard let h = Double(side2) else { return "" }
            
            return (0.5 * b * h).formatted()
        case "Circle":
            guard let r = Double(side1) else { return "" }
            
            return (.pi * pow(r, 2)).formatted()
        case "Trapezium":
            guard let a = Double(side1) else { return "" }
            guard let b = Double(side2) else { return "" }
            guard let h = Double(side3) else { return "" }

            return (((a + b) / 2) * h).formatted()
        case "Parallelogram":
            guard let b = Double(side1) else { return "" }
            guard let h = Double(side2) else { return "" }
            
            return (b * h).formatted()
            
        default:
            return ""
        }
    }
    
    func getFormulaForShape(shape: String) -> String {
        switch shape {
            // 3D Shaoes
        case "Cuboid":
            if statethreeDCalculation == "Volume" {
                return "\(results.isEmpty ? "V" : results) = \(side1.isEmpty ? "l" : side1) * \(side2.isEmpty ? "b" : side2) * \(side3.isEmpty ? "h" : side3)"
            } else {
                return "\(results.isEmpty ? "A" : results) = 2 * ((\(side1.isEmpty ? "l" : side1) * \(side3.isEmpty ? "h" : side3)) + (\(side1.isEmpty ? "l" : side1) * \(side2.isEmpty ? "b" : side2)) + (\(side3.isEmpty ? "h" : side3) * \(side2.isEmpty ? "b" : side2)))"
            }
        case "Sphere":
            if statethreeDCalculation == "Volume" {
                return "\(results.isEmpty ? "V" : results) = \\frac{4}{3} * \\pi * \(side1.isEmpty ? "r" : side1)^3"
            } else {
                return "\(results.isEmpty ? "A" : results) = 4 * \\pi * \(side1.isEmpty ? "r" : side1)^2"
            }
        case "Cylinder":
            if statethreeDCalculation == "Volume" {
                return "\(results.isEmpty ? "V" : results) = \\pi * \(side1.isEmpty ? "r" : side1)^2 * \(side2.isEmpty ? "h" : side2)"
            } else {
                return "\(results.isEmpty ? "A" : results) = (2 * \\pi * \(side1.isEmpty ? "r" : side1) * \(side2.isEmpty ? "h" : side2)) + (2 * \\pi * \(side1.isEmpty ? "r" : side1)^2)"
            }
        case "Pyramid":
            if statethreeDCalculation == "Volume" {
                return "\(results.isEmpty ? "V" : results) = \\frac{\(side1.isEmpty ? "l" : side1) * \(side2.isEmpty ? "b" : side2) * \(side3.isEmpty ? "h" : side3)}{3}"
            } else {
                return "\(results.isEmpty ? "A" : results) = (\(side1.isEmpty ? "l" : side1) * \(side2.isEmpty ? "b" : side2)) * (\(side1.isEmpty ? "l" : side1) * \\sqrt{(\\frac{\(side2.isEmpty ? "b" : side2)}{2})^2 + \(side3.isEmpty ? "h" : side3)^2}) * (\(side2.isEmpty ? "b" : side2) * \\sqrt{(\\frac{\(side1.isEmpty ? "l" : side1)}{2})^2 + \(side3.isEmpty ? "h" : side3)^2})"
            }
        case "Cone":
            if statethreeDCalculation == "Volume" {
                return "\(results.isEmpty ? "V" : results) = \\pi * \(side1.isEmpty ? "r" : side1)^2 * \\frac{\(side2.isEmpty ? "h" : side2)}{3}"
            } else {
                return "\(results.isEmpty ? "A" : results) = (\\pi * \(side1.isEmpty ? "r" : side1)) * (\(side1.isEmpty ? "r" : side1) + \\sqrt{\(side2.isEmpty ? "h" : side2)^2 + \(side1.isEmpty ? "r" : side1)^2})"
            }
            
            // 2D Shapes
        case "Square":
            return "\(results.isEmpty ? "A" : results) = \(side1.isEmpty ? "l" : side1) * \(side2.isEmpty ? "b" : side2)"
        case "Triangle":
            return "\(results.isEmpty ? "A" : results) = \\frac{1}{2} * \(side1.isEmpty ? "b" : side1) * \(side2.isEmpty ? "h" : side2)"
        case "Circle":
            return "\(results.isEmpty ? "A" : results) = \\pi * \(side1.isEmpty ? "r" : side1)^2"
        case "Trapezium":
            return "\(results.isEmpty ? "A" : results) = \\frac{\(side1.isEmpty ? "a" : side1) + \(side2.isEmpty ? "b" : side2)}{2} * \(side3.isEmpty ? "h" : side3)"
        case "Parallelogram":
            return "\(results.isEmpty ? "A" : results) = \(side1.isEmpty ? "b" : side1) * \(side2.isEmpty ? "h" : side2)"

        default:
            return ""
        }
    }
    
    func getSceneName(shape: String) -> String {
        switch shape {
        case "Cuboid":
            if colorScheme == .light {
                return "LightCuboid.scn"
            } else {
                return "DarkCuboid.scn"
            }
        case "Sphere":
            if colorScheme == .light {
                return "LightSphere.scn"
            } else {
                return "DarkSphere.scn"
            }
        case "Cylinder":
            if colorScheme == .light {
                return "LightCylinder.scn"
            } else {
                return "DarkCylinder.scn"
            }
        case "Pyramid":
            if colorScheme == .light {
                return "LightPyramid.scn"
            } else {
                return "DarkPyramid.scn"
            }
        case "Cone":
            if colorScheme == .light {
                return "LightCone.scn"
            } else {
                return "DarkCone.scn"
            }
        default:
            return ""
        }
    }
    
    func getSceneNameColorScheme(shape: String) -> String {
        switch shape {
        case "Cuboid":
            if colorScheme == .dark {
                return "LightCuboid.scn"
            } else {
                return "DarkCuboid.scn"
            }
        case "Sphere":
            if colorScheme == .dark {
                return "LightSphere.scn"
            } else {
                return "DarkSphere.scn"
            }
        case "Cylinder":
            if colorScheme == .dark {
                return "LightCylinder.scn"
            } else {
                return "DarkCylinder.scn"
            }
        case "Pyramid":
            if colorScheme == .dark {
                return "LightPyramid.scn"
            } else {
                return "DarkPyramid.scn"
            }
        case "Cone":
            if colorScheme == .dark {
                return "LightCone.scn"
            } else {
                return "DarkCone.scn"
            }
        default:
            return ""
        }
    }
}

struct ShapesCalc_Previews: PreviewProvider {
    static var previews: some View {
        ShapesCalc()
    }
}
