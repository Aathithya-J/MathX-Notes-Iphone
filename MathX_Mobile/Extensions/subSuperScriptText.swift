import SwiftUI

//Rule:
//_{} subscript
//^{} superscript
//mainFont
//script font
//

struct SubSuperScriptText: View {
    let inputString: String
    let bodyFont: Font
    let subScriptFont: Font
    let baseLine: CGFloat
    var body: some View {
        var string = inputString
        var text = Text("")
        while let validIndex = string.firstIndex(where: { (char) -> Bool in  return (char == "_" || char == "^") }) {
            
            let mySubstringP1 = string[..<validIndex]
            var mySubstringP2 = string[validIndex...]
            text = text + Text(mySubstringP1) //add normal string to text
            //subscript
            
            if mySubstringP2.count < 3 { //no possible  sub or super
                return text + Text(mySubstringP2).font(bodyFont)
            }
            
            var subscriptType = mySubstringP2.first!
            mySubstringP2 = mySubstringP2.dropFirst() ///remove ^ _
            
            var subScriptString = ""
            if mySubstringP2.first != "{"  { //not a subscript
                subScriptString.append(String(subscriptType))
                subscriptType = Character(" ") //no subscript
            } else if let subStringIndex = mySubstringP2.firstIndex(where: { (char) -> Bool in  return (char == "}") })  {
                mySubstringP2 = mySubstringP2.dropFirst() ///remove {
                subScriptString = String(mySubstringP2[..<subStringIndex])
                mySubstringP2 = mySubstringP2[subStringIndex...].dropFirst() //remove }
            } else {
                return Text("") //not balance string
            }
            
            switch subscriptType {
            case "^":
                text = text + Text(subScriptString)
                    .font(subScriptFont)
                                  .baselineOffset(baseLine)
            case "_":
                text = text + Text(subScriptString)
                    .font(subScriptFont)
                                  .baselineOffset(-1 * baseLine)
            default:
                text = text + Text(subScriptString).font(bodyFont)
            }
            string = String(mySubstringP2)
        }
        text = text + Text(string).font(bodyFont)
        return text
    }
}

struct SubSuperScriptText_Previews: PreviewProvider {
    static var previews: some View {
        ScrollView {
            VStack(alignment: .leading) {
                Text("Chemistry").font(.title3).padding([.top, .bottom])
                SubSuperScriptText(inputString: "2NaOH + H_{2}SO_{4} → 2H_{2}O + Na_{2}SO_{4}", bodyFont: .callout, subScriptFont: .caption, baseLine: 6.0)
                Text("Maths").font(.title3).padding([.top, .bottom])
                SubSuperScriptText(inputString: "x^{2} + 20x + 100 = 0", bodyFont: .callout, subScriptFont: .caption, baseLine: 6.0)
                SubSuperScriptText(inputString: "x^{2} + 10x + 10x + 100 = 0", bodyFont: .callout, subScriptFont: .caption, baseLine: 6.0)
                SubSuperScriptText(inputString: "x(x + 10) + 10(x + 10) = 0", bodyFont: .callout, subScriptFont: .caption, baseLine: 6.0)
                SubSuperScriptText(inputString: "(x + 10)(x + 10) = 0", bodyFont: .callout, subScriptFont: .caption, baseLine: 6.0)
                SubSuperScriptText(inputString: "x = -10", bodyFont: .callout, subScriptFont: .caption, baseLine: 6.0)
                SubSuperScriptText(inputString: "Demo^{TM}", bodyFont: .callout, subScriptFont: .caption, baseLine: 6.0)
                Spacer()
            }.padding([.leading, .trailing])
        }
    }
}
