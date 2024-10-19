//
// HomeView.swift
// Zap
//
// Created by Zigao Wang on 9/21/24.
//

import SwiftUI
import AVFoundation

struct HomeView: View {
    @StateObject var viewModel = NotesViewModel()
    @EnvironmentObject var appearanceManager: AppearanceManager
    @State private var showingSettings = false

    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                if viewModel.notes.isEmpty {
                    Text("No notes available")
                        .foregroundColor(.secondary)
                        .padding()
                } else {
                    List {
                        ForEach(viewModel.notes) { note in
                            NoteRowView(note: note)
                        }
                        .onDelete(perform: viewModel.deleteNotes)
                    }
                    .listStyle(InsetGroupedListStyle())
                }

                if let errorMessage = viewModel.errorMessage {
                    Text(errorMessage)
                        .foregroundColor(.red)
                        .padding()
                }

                // Organize and Plan button
                Button(action: {
                    viewModel.organizeAndPlanNotes()
                }) {
                    HStack {
                        Image(systemName: "wand.and.stars")
                        Text(viewModel.isSummarizing ? "Organizing..." : "Organize & Plan")
                    }
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(viewModel.isSummarizing ? Color.gray : Color.purple)
                    .foregroundColor(.white)
                    .cornerRadius(10)
                }
                .disabled(viewModel.isSummarizing)
                .padding()

                // Command button
                CommandButton(viewModel: viewModel)
                    .padding()
            }
            .navigationTitle("Zap Notes")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        showingSettings = true
                    }) {
                        Image(systemName: "gear")
                    }
                }
            }
            .sheet(isPresented: $showingSettings) {
                SettingsView()
            }
        }
        .accentColor(appearanceManager.accentColor)
        .font(.system(size: appearanceManager.fontSizeValue))
        .environmentObject(viewModel)
    }
}

struct TextInputView: View {
    @Binding var content: String
    let onSave: () -> Void
    
    var body: some View {
        NavigationView {
            TextEditor(text: $content)
                .padding()
                .navigationTitle("New Note")
                .navigationBarItems(
                    leading: Button("Cancel") {
                        content = ""
                        onSave()
                    },
                    trailing: Button("Save") {
                        onSave()
                    }
                )
        }
    }
}
