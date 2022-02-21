//
//  ContentView.swift
//  CombineWorks
//
//  Created by shehan karunarathna on 2022-02-21.
//

import SwiftUI
import Combine

class CombineDataService{
    @Published var defaultPublisher: String = "First item"
    let currentValuePublisher =  CurrentValueSubject<String,Never>("First Item")
    init(){
        publishFakeData()
    }
    private func publishFakeData(){
        let items  = ["one", "two","three"]
        for i in items.indices{
            DispatchQueue.main.asyncAfter(deadline: .now() + Double(i)) {
                self.defaultPublisher = items[i]
                
            }
        }
       
    }
}

class CombineViewModel:ObservableObject{
    var cancelables = Set<AnyCancellable>()
    @Published var data:[String] = []
    let dataservice = CombineDataService()
    init(){
        addSubascribers()
    }
    
    private func addSubascribers(){
        dataservice.$defaultPublisher
            .sink { completion in
                switch completion{
                case .finished:
                    break
                case .failure(let error):
                    print("ERROR:\(error.localizedDescription)")
                    break
                    
                }
            } receiveValue: { [weak self]returnedVal in
                self?.data.append(returnedVal)
            }
            .store(in: &cancelables)

    }
}

struct ContentView: View {
    @StateObject private var vm = CombineViewModel()
    var body: some View {
        ScrollView{
            VStack{
                ForEach(vm.data, id:\.self){
                    item in
                    Text(item)
                        .font(.largeTitle)
                        .fontWeight(.black)
                }
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
