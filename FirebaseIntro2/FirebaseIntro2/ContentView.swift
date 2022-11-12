//
//  ContentView.swift
//  FirebaseIntro2
//
//  Created by Dani Yalda on 2022-10-26.
//

import SwiftUI
import Firebase

struct ContentView: View {
    var db = Firestore.firestore()
    @State var atext: String = ""
    @State var items = [Item]()
    
    
    func textCheck() -> Bool {
        if atext.count  >= 1 {
            return true
        }
        return false
    }
    
    func addItemToStore(item: Item) {
        
        do {
            _ = try db.collection("test").addDocument(from: item)
        } catch{
            print("Error saving data")
        }
        
    }
    
    func listenToStore() {
        db.collection("test").addSnapshotListener{
            snapshot, error in
            
            guard let snapshot = snapshot else{
                return
            }
            
            if let error = error {
                print ("Error occurred \(error)")
                return
            }
            
            items.removeAll()
            
            for document in snapshot.documents{
                
                let result = Result {
                    try document.data(as: Item.self)
                }
                
                switch result {
                case .success(let item):
                    items.append(item)
                    atext = ""
                case .failure(let error):
                    print("Error retrieving following document: \(error)")
                    break
                }
                
                
            }
            
        }
    }
    
    
    
    
    
    
    var body: some View {
        NavigationView {
            
            VStack(){
            List(){
                
                ForEach(items) {
                    item in
                    Text(item.name).onTapGesture {
                        print(item)
                    }
                    
                }.onDelete{
                    IndexSet in
                    
                    let indexes = IndexSet.map{$0}
                    
                    for index in indexes {
                        let item = items[index]
                        
                        if let id = item.id{
                            db.collection("test").document(id).delete()
                        }
                        
                    }
                }
                    
            }
                
                
                
                
                
                
                HStack{
                    TextField("add your task", text: $atext)
                        .padding()
                        .background(Color.gray.opacity(0.2))
                        .cornerRadius(6)
                        .font(.headline)
                    
                    
                    Button(action: {
                        if  textCheck() {
                            addItemToStore(item: Item(name: atext))
                        }
                        
                        
                    }, label: {
                        Image(systemName: "plus")
                            .padding()
                            .frame(maxWidth: 50)
                            .background(textCheck() ? Color.blue : Color.gray)
                            .cornerRadius(4)
                            .font(.headline)
                            .foregroundColor(.white)
                        
                        
                        
                        
                        
                        
                    })
                    .disabled(!textCheck())
                    
                }.navigationTitle("ToDo")
                    .padding()
            }
            
        }.onAppear{
            listenToStore()
        
        
    }
    

            }
           
            
           
            
            
            
        }
            
    
    
    struct ContentView_Previews: PreviewProvider {
        static var previews: some View {
            ContentView()
        }
    }

