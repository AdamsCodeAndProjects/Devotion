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
    @State private var showNewTaskItem: Bool = false // Stores the actual state of the item view
    
    // FETCHING DATA
    @Environment(\.managedObjectContext) private var viewContext

    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \Item.timestamp, ascending: true)],
        animation: .default)
    private var items: FetchedResults<Item>
    
    // MARK: - FUNCTION
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
                // MARK: - MAIN VIEW
                VStack {
                    // MARK: - HEADER
                    Spacer(minLength: 80)
                    
                    // MARK: - NEW TASK BUTTON
                    Button(action: {
                        showNewTaskItem = true
                    }, label: {
                        Image(systemName: "plus.circle")
                            .font(.system(size: 30, weight: .semibold, design: .rounded))
                        Text("New Task")
                            .font(.system(size: 24, weight: .bold, design: .rounded))
                    })
                    .foregroundColor(.white)
                    .padding(.horizontal, 20)
                    .padding(.vertical, 15)
                    .background(
                        LinearGradient(gradient: Gradient(colors: [Color.pink, Color.blue]), startPoint: .leading, endPoint: .trailing)
                            .clipShape(Capsule())
                    )
                    .shadow(color: Color(red: 0, green: 0, blue: 0), radius: 8, x: 2, y: 4)
                    
                    // MARK: - TASKS
                    
                    if showNewTaskItem {
                        BlankView()
                            .onTapGesture {
                                withAnimation() {
                                    showNewTaskItem = false
                                }
                            }
                        NewTaskItemView(isShowing: $showNewTaskItem)
                    }
                    
                        List {
                            ForEach(items) { item in
                                NavigationLink {
                                    VStack(alignment: .leading) {
                                        Text("Item at \(item.timestamp!, formatter: itemFormatter)")
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
                // MARK: - NEW TASK ITEM
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
                            BackgroundImageView()
                        )
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
