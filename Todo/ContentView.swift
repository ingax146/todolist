//
//  ContentView.swift
//  Todo
//
//  Created by Ingemar Axelsson on 2024-11-11.
//

import SwiftUI
import SwiftData

struct TodoItemSummaryView : View {
    @State var item: TodoItem
    
    var body : some View {
        VStack(alignment: .leading) {
            Text(item.title)
                .font(.headline)
                .strikethrough(item.completed, color: .primary)
            Text(item.content)
                .font(.subheadline)
        }
        .onTapGesture {
            item.completed.toggle()
        }
    }
}

struct EditTodoItemView: View {
    @State var item: TodoItem
    
    var body : some View {
        List {
            TextField("Title", text: $item.title)
                .font(.headline)
            LabeledContent("Description") {
                TextEditor(text: $item.content)
                    .frame(alignment:.leading)
            }
            Toggle("Completed", isOn: $item.completed)
        }
    }
}

extension Bool : @retroactive Comparable {
    public static func < (lhs: Bool, rhs: Bool) -> Bool {
        !lhs && rhs
    }
}

struct ContentView: View {
    @Environment(\.modelContext) private var modelContext
    @Query(sort: [SortDescriptor(\TodoItem.completed)]) private var items: [TodoItem]
    
    @State private var newItem: TodoItem = TodoItem(title: "", description: "")
    @State private var showNewItemSheet: Bool = false
    
    var body: some View {
        NavigationSplitView {
            List {
                ForEach(items) { item in
                    TodoItemSummaryView(item: item)
                }
                .onDelete(perform: deleteItems)
            }
            .toolbar {
                ToolbarItem {
                    Button(action: {
                        showNewItemSheet.toggle()
                    }) {
                        Label("Add Item", systemImage: "plus")
                    }.sheet(isPresented: $showNewItemSheet) {
                        VStack {
                            EditTodoItemView(item: newItem)
                            HStack {
                                Button("Discard", action: {
                                    showNewItemSheet.toggle()
                                    newItem = TodoItem(title: "", description:"")
                                })
                                .buttonStyle(.bordered)
                                .padding()
                                Spacer()
                                Button("Add", action: {
                                    addItem()
                                    showNewItemSheet.toggle()
                                    newItem = TodoItem(title: "", description:"")
                                }).disabled(newItem.title.isEmpty)
                                .buttonStyle(.bordered)
                                .padding()
                            }
                        }
                    }
                }
            }
        } detail: {
            Text("Select an item")
        }
    }

    private func addItem() {
        withAnimation {
            modelContext.insert(newItem)
        }
    }

    private func deleteItems(offsets: IndexSet) {
        withAnimation {
            for index in offsets {
                modelContext.delete(items[index])
            }
        }
    }
}

#Preview {
    ContentView()
        .modelContainer(for: TodoItem.self, inMemory: true)
}
