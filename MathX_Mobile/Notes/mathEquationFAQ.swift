//
//  mathEquationFAQ.swift
//  MathX_Mobile
//
//  Created by Tristan on 19/04/2023.
//

import SwiftUI
import LaTeXSwiftUI

struct mathEquationFAQ: View {
    let latexstart = String("\\[")
    let latexend = String("\\]")
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        NavigationStack {
            VStack {
                List {
                    DisclosureGroup {
                        LaTeX("Math Rendering allows you to input mathematical equations using LaTeX. Example: \\[x=\\frac{1}{2}\\]")
                            .parsingMode(.onlyEquations)
                            .blockMode(.alwaysInline)
                            .padding(.vertical, 7.5)
                    } label: {
                        Text("What is Math Rendering?")
                            .padding(.vertical, 7.5)
                    }
                    
                    DisclosureGroup {
                        VStack {
                            Text("You can start LaTeX equations using \(latexstart), $, or $$ and end it with \(latexend), $, or $$ respectively.\n\nNote: starting and ending types have to be the same. Example: \(latexstart) cannot be ended with $$.")
                            HStack {
                                Text("\n\(latexstart)\\frac{1}{2}\(latexend)")
                                Spacer()
                                LaTeX("\\[\\frac{1}{2}\\]")
                            }
                        }
                        .padding(.vertical, 7.5)
                    } label: {
                        Text("How do you type LaTeX equations?")
                            .padding(.vertical, 7.5)
                    }
                    
                    DisclosureGroup {
                        VStack {
                            HStack {
                                Text("Indices/Index - \(latexstart)\\4^7\(latexend)")
                                Spacer()
                                LaTeX("4^7")
                                    .parsingMode(.all)
                                    .blockMode(.alwaysInline)
                            }
                            .padding(.vertical, 7.5)
                            
                            HStack {
                                Text("Fractions - \(latexstart)\\frac{3}{7}\(latexend)")
                                Spacer()
                                LaTeX("\\frac{3}{7}")
                                    .parsingMode(.all)
                                    .blockMode(.alwaysInline)
                            }
                            .padding(.vertical, 7.5)

                            HStack {
                                Text("Square root -\n\(latexstart)x=\\pm\\sqrt[4]{b^2-4ac}\(latexend)")
                                Spacer()
                                LaTeX("\\sqrt[4]{b^2-4ac}")
                                    .parsingMode(.all)
                                    .blockMode(.alwaysInline)
                            }
                            .padding(.vertical, 7.5)
                            
                            HStack {
                                Text("You can also search online for more LaTeX functions.")
                                    .padding(.vertical, 7.5)
                                Spacer()
                            }
                        }
                    } label: {
                        Text("What are some examples of LaTeX?")
                            .padding(.vertical, 7.5)
                    }
                    
                    DisclosureGroup {
                        Text("Your texts will be rendered in plain text, and appear as normal characters. You can always choose to enable/disable Math Rendering later on.")
                            .padding(.vertical, 7.5)
                    } label: {
                        Text("What if I don't want to use Math Rendering?")
                            .padding(.vertical, 7.5)
                    }
                    
                    DisclosureGroup {
                        Text("To edit your notes when Math Rendering is enabled, press the \"Edit\" button in the top right hand corner of your note. Non-Math Rendering notes can be edited without needing to click on the \"Edit\" button.")
                            .padding(.vertical, 7.5)
                    } label: {
                        Text("Why can't I edit my notes when Math Rendering is enabled?")
                            .padding(.vertical, 7.5)
                    }
                    
                    DisclosureGroup {
                        Text("Leave a line when Math Rendering is enabled:\n\nIf your line ends with a LaTeX equation, add a space at the end of your line. Example: \"\(latexstart)x=\\frac{2}{5}\(latexend) \"\n\nIf your line starts with a LaTeX equation, add a space at the start of your line. Example: \" \(latexstart)x=\\frac{2}{5}\(latexend)\"")
                            .padding(.vertical, 7.5)
                    } label: {
                        Text("Why wont my texts leave a line when Math Rendering is enabled?")
                            .padding(.vertical, 7.5)
                    }
                }
            }
            .navigationTitle("Math Rendering FAQ")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                Button {
                    dismiss.callAsFunction()
                } label: {
                    Image(systemName: "xmark")
                }
            }
        }
    }
}

struct mathEquationFAQ_Previews: PreviewProvider {
    static var previews: some View {
        mathEquationFAQ()
    }
}
