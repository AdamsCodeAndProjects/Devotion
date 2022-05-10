//
//  ContentView.swift
//  Devotion
//
//  Created by adam janusewski on 5/10/22.
//

import SwiftUI
import CoreData

struct ContentView: View {
    // MARK: - PROPERTY
    
    @State var task: String = ""
    private var isButtonDisabled: Bool {
        task.isEmpty
    }  //  Checks whether we left no value in the text field
    
    // FETCHING DATA
    @Environment(\.managedObjectContext) private var viewContext

    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \Item.timestamp, ascending: true)],
        animation: .default)
    private var items: FetchedResults<Item>
    
    // MARK: - FUNCTION
    
    private func addItem() {
        withAnimation {
            let newItem = Item(context: viewContext)
            newItem.timestamp = Date()
            newItem.task = task
            newItem.completion = false
            newItem.id = UUID()
            do {
                try viewContext.save()
            } catch {
                let nsError = error as NSError
                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
            }
            task = ""
            hideKeyboard()
        }
    }

    private func deleteItems(offsets: IndexSet) {
        withAnimation {
            offsets.map { items[$0] }.forEach(viewContext.delete)
            do {
                try viewContext.save()
            } catch {
                let nsError = error as NSError
                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
            }
        }
    }
    
    // MARK: - BODY

    var body: some View {
        
        NavigationView {
            ZStack {
                VStack {
                    VStack(spacing: 16) {
                        // TASK Field
                        TextField("New Task", text: $task)
                            .padding()
                            .background(
                                Color(UIColor.systemGray6)
                            )
                            .cornerRadius(10)
                        
                        // SAVE Button
                        Button(action: {
                            addItem()
                        }, label: {
                            Spacer()
                            Text("SAVE")
                            Spacer()
                        })
                        .disabled(isButtonDisabled)
                        .padding()
                        .font(.headline)
                        .foregroundColor(.white)
                        .background(isButtonDisabled ? Color.gray : Color.pink)  // if disabled, gray
                        .cornerRadius(10)
                    }
                    .padding()
                        List {
                            ForEach(items) { item in
    //                            VStack(alignment: .leading) {
                                NavigationLink {
                                    VStack(alignment: .leading) {
    //                                    Text(item.task ?? "")
    //                                        .font(.headline)
    //                                        .fontWeight(.bold)
                                        Text("Item at \(item.timestamp!, formatter: itemFormatter)")
    //                                        .font(.footnote)
    //                                        .foregroundColor(.gray)
                                        }
                                    } label: {
                                        VStack(alignment: .leading) {
                                            Text(item.task ?? "")
                                                .font(.headline)
                                                .fontWeight(.bold)
                                            Text(item.timestamp!, formatter: itemFormatter)
                                                .font(.footnote)
                                                .foregroundColor(.gray)
                                        }
                                    }
                                }
                                .onDelete(perform: deleteItems)
                        }  // List
                        .listStyle(InsetGroupedListStyle())
                        .shadow(color: Color(red: 0, green: 0, blue: 0), radius: 12, x: 5, y: 5)
                        .padding(.vertical, 0)
                        .frame(maxWidth: 640)
                } // VStack
            }
            .onAppear() {
                UITableView.appearance().backgroundColor = UIColor.clear
            }
                        .navigationBarTitle("Daily Tasks", displayMode: .large)
                        .toolbar {
                            ToolbarItem(placement: .navigationBarTrailing) {
                                EditButton()
                            }
                    }
                        .background(
                            backgroundGradient.ignoresSafeArea(.all)
                        )
            Text("Select an item")
            
        } // Navigation
        .navigationViewStyle(StackNavigationViewStyle()) // Will only show a single column view at a time
    }
}

// MARK: PREVIEW

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}
