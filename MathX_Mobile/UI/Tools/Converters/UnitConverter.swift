import SwiftUI

struct UnitConverterView: View {
    
    @State var selection = "Length"
    @State var stateselection = "Length"
    @State var unitSelection = "Metres"
    @State var unitConvertedToSelection = "Metres"
    
    @State private var input = ""
    
    let units = ["Length", "Area", "Volume", "Mass", "Speed", "Temperature"]
    let length = ["Metres", "Kilometres", "Inches", "Feet", "Yards", "Miles"]
    let area = ["Acres", "Hectares", "Square Metres", "Square Kilometres", "Square Inches", "Square Feet"]
    let volume = ["Cubic Centimetres", "Cubic Metres", "Cubic Inches", "Cubic Feet", "Cups", "Fluid Ounces", "Gallons", "Millilitres", "Litres", "Teaspoons", "Tablespoons", "Pints"]
    let mass = ["Grams", "Kilograms", "Ounces", "Pounds", "Metric Tons", "Carats"]
    let speed = ["m/s", "km/h", "mi/h", "knots"]
    let temperature = ["Celsius", "Fahrenheit", "Kelvin"]
    
    var unitConverter: String {
        var returnValue = ""
        
        if length.contains(unitSelection) {
            let measurement = Measurement(value: Double(input) ?? 0, unit: getUnitLengthType(for: unitSelection))
            returnValue = "\(measurement.converted(to: getUnitLengthType(for: unitConvertedToSelection)))"
        } else if area.contains(unitSelection) {
            let measurement = Measurement(value: Double(input) ?? 0, unit: getUnitAreaType(for: unitSelection))
            returnValue = "\(measurement.converted(to: getUnitAreaType(for: unitConvertedToSelection)))"
        } else if volume.contains(unitSelection) {
            let measurement = Measurement(value: Double(input) ?? 0, unit: getUnitVolumeType(for: unitSelection))
            returnValue = "\(measurement.converted(to: getUnitVolumeType(for: unitConvertedToSelection)))"
        } else if mass.contains(unitSelection) {
            let measurement = Measurement(value: Double(input) ?? 0, unit: getUnitMassType(for: unitSelection))
            returnValue = "\(measurement.converted(to: getUnitMassType(for: unitConvertedToSelection)))"
        } else if speed.contains(unitSelection) {
            let measurement = Measurement(value: Double(input) ?? 0, unit: getUnitSpeedType(for: unitSelection))
            returnValue = "\(measurement.converted(to: getUnitSpeedType(for: unitConvertedToSelection)))"
        } else if temperature.contains(unitSelection) {
            let measurement = Measurement(value: Double(input) ?? 0, unit: getUnitTemperatureType(for: unitSelection))
            returnValue = "\(measurement.converted(to: getUnitTemperatureType(for: unitConvertedToSelection)))"
        }
        
        return returnValue
    }
    
    var body: some View {
        VStack {
            Form {
                Section {
                    Picker("", selection: $selection) {
                        ForEach(units, id: \.self) { unit in
                            Image(systemName: getSymbolForUnit(for: unit))
                                .tag(unit)
                        }
                    }
                    .pickerStyle(.segmented)
                    .onChange(of: selection) { _ in
                        withAnimation {
                            stateselection = selection
                        }
                    }
                }
                
                Section(header: Text(stateselection)) {
                    HStack {
                        TextField("Enter value", text: $input)
                            .keyboardType(.decimalPad)
                        
                        Spacer()
                        
                        Picker("", selection: $unitSelection) {
                            ForEach(getUnitSubUnits(unit: stateselection), id: \.self) { unit in
                                Text(unit)
                                    .tag(unit)
                            }
                        }
                        .fixedSize()
                        .pickerStyle(.menu)
                    }
                }
                
                Section(header: Text("Results")) {
                    HStack {
                        ScrollView(.horizontal, showsIndicators: false) {
                            Text(input.isEmpty ? "" : unitConverter)
                                .lineLimit(1)
                                .multilineTextAlignment(.leading)
                        }
                        
                        Spacer()
                        
                        Picker("", selection: $unitConvertedToSelection) {
                            ForEach(getUnitSubUnits(unit: stateselection), id: \.self) { unit in
                                Text(unit)
                                    .tag(unit)
                            }
                        }
                        .fixedSize()
                        .pickerStyle(.menu)
                    }
                }
            }
            .scrollDismissesKeyboard(.interactively)
        }
        .navigationTitle("Unit Converter")
        .onChange(of: selection) { _ in
            if selection == "Length" {
                unitSelection = "Metres"
                unitConvertedToSelection = "Metres"
            } else if selection == "Area" {
                unitSelection = "Acres"
                unitConvertedToSelection = "Acres"
            } else if selection == "Volume" {
                unitSelection = "Cubic Centimetres"
                unitConvertedToSelection = "Cubic Centimetres"
            } else if selection == "Mass" {
                unitSelection = "Grams"
                unitConvertedToSelection = "Grams"
            } else if selection == "Speed" {
                unitSelection = "m/s"
                unitConvertedToSelection = "m/s"
            } else if selection == "Temperature" {
                unitSelection = "Celsius"
                unitConvertedToSelection = "Celsius"
            }
        }
        
    }
    
    func getUnitSubUnits(unit: String) -> [String] {
        switch unit {
        case "Length":
            return length
        case "Area":
            return area
        case "Mass":
            return mass
        case "Speed":
            return speed
        case "Volume":
            return volume
        case "Temperature":
            return temperature
        default:
            return []
        }
    }
    
    func getUnitLengthType(for unit: String) -> UnitLength {
        switch unit {
        case "Metres":
            return UnitLength.meters
        case "Kilometres":
            return UnitLength.kilometers
        case "Inches":
            return UnitLength.inches
        case "Feet":
            return UnitLength.feet
        case "Yards":
            return UnitLength.yards
        case "Miles":
            return UnitLength.miles
        default:
            return UnitLength.baseUnit()
        }
    }
    
    func getUnitAreaType(for unit: String) -> UnitArea {
        switch unit {
        case "Acres":
            return UnitArea.acres
        case "Hectares":
            return UnitArea.hectares
        case "Square Metres":
            return UnitArea.squareMeters
        case "Square Kilometres":
            return UnitArea.squareKilometers
        case "Square Inches":
            return UnitArea.squareInches
        case "Square Feet":
            return UnitArea.squareFeet
        default:
            return UnitArea.baseUnit()
        }
    }
    
    func getUnitVolumeType(for unit: String) -> UnitVolume {
        switch unit {
        case "Cubic Centimetres":
            return UnitVolume.cubicCentimeters
        case "Cubic Metres":
            return UnitVolume.cubicMeters
        case "Cubic Inches":
            return UnitVolume.cubicInches
        case "Cubic Feet":
            return UnitVolume.cubicFeet
        case "Cups":
            return UnitVolume.cups
        case "Fluid Ounces":
            return UnitVolume.fluidOunces
        case "Gallons":
            return UnitVolume.gallons
        case "Millilitres":
            return UnitVolume.milliliters
        case "Litres":
            return UnitVolume.liters
        case "Teaspoons":
            return UnitVolume.teaspoons
        case "Tablespoons":
            return UnitVolume.tablespoons
        case "Pints":
            return UnitVolume.pints
        default:
            return UnitVolume.baseUnit()
        }
    }
    
    func getUnitMassType(for unit: String) -> UnitMass {
        switch unit {
        case "Grams":
            return UnitMass.grams
        case "Kilograms":
            return UnitMass.kilograms
        case "Ounces":
            return UnitMass.ounces
        case "Pounds":
            return UnitMass.pounds
        case "Metric Tons":
            return UnitMass.metricTons
        case "Carats":
            return UnitMass.carats
        default:
            return UnitMass.baseUnit()
        }
    }
    
    func getUnitSpeedType(for unit: String) -> UnitSpeed {
        switch unit {
        case "m/s":
            return UnitSpeed.metersPerSecond
        case "km/h":
            return UnitSpeed.kilometersPerHour
        case "mi/h":
            return UnitSpeed.milesPerHour
        case "knots":
            return UnitSpeed.knots
        default:
            return UnitSpeed.baseUnit()
        }
    }
    
    func getUnitTemperatureType(for unit: String) -> UnitTemperature {
        switch unit {
        case "Celsius":
            return UnitTemperature.celsius
        case "Fahrenheit":
            return UnitTemperature.fahrenheit
        case "Kelvin":
            return UnitTemperature.kelvin
        default:
            return UnitTemperature.baseUnit()
        }
    }
    
    func getSymbolForUnit(for unit: String) -> String {
        switch unit {
        case "Length": return "ruler.fill"
        case "Area": return "square.dashed.inset.filled"
        case "Volume": return "cube.fill"
        case "Mass": return "scalemass.fill"
        case "Speed": return "speedometer"
        case "Temperature": return "medical.thermometer.fill"
        default: return ""
        }
    }
}

struct UnitConverterView_Previews: PreviewProvider {
    static var previews: some View {
        UnitConverterView()
    }
}

