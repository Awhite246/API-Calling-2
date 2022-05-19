//
//  ContentView.swift
//  API Calling
//
//  Created by Student on 5/16/22.
//

import SwiftUI

struct ContentView: View {
    @State private var facts = [DogFacts]()
    @State private var alert = false
    @State private var dogFactsNum = 1.0
    var body: some View {
        NavigationView {
            VStack {
                Text("Dog Fact Amount")
                    .fontWeight(.bold)
                Slider(value: $dogFactsNum, in: 1...5, step: 1)
                    .padding()
                //ScrollView {
                    List(facts) { fact in
                        NavigationLink(
                            destination: Text(fact.fact)
                                .padding(),
                            label: {
                                Text("Fact")
                            })
                        
                    }
                //}
            }
            .navigationBarTitle("Dog Facts")
        }
        .onAppear(perform: {
            getDogFacts(num : 1)
        })
        .onChange(of: dogFactsNum, perform: { value in
            getDogFacts(num: Int(dogFactsNum))
        })
        .alert(isPresented: $alert, content: {
            Alert(title: Text("Loading Error"),
                  message: Text("There was a problem loading the data"),
                  dismissButton: .default(Text("OK")))
        })
    }
    func getDogFacts(num : Int) {
        facts.removeAll()
        let apiLink = "https://dog-api.kinduff.com/api/facts?number=\(num)"
        if let url = URL(string: apiLink) {
            if let data = try? Data(contentsOf: url) {
                let json = try! JSON(data: data)
                if json["success"] == true {
                    let contents = json["facts"].arrayValue
                    for item in contents {
                        let dogFact = DogFacts(fact: "\(item)")
                        facts.append(dogFact)
                    }
                    return
                }
            }
        }
        alert = true
    }
}
struct DogFacts: Identifiable {
    let id = UUID()
    var fact : String
}
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
