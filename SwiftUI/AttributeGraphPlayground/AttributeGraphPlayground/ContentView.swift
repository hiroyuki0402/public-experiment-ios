//
//  ContentView.swift
//  AttributeGraphPlayground
//
//  Created by SHIRAISHI HIROYUKI on 2026/04/10.
//

import SwiftUI

struct ContentView: View {

    var body: some View {
        print("body が呼ばれた")

        let graph = AttributeGraph()
        let a = graph.input(name: "A", 10)
        let b = graph.input(name: "B", 20)
        let c = graph.rule(name: "C") {
            print("Cの計算が走った")
            return a.wrappedValue + b.wrappedValue
        }











        
        return Text("hello")
    }
}

#Preview {
    ContentView()
}
