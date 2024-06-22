//
//  FiretoreDBHelper.swift
//  Group10NatureWalkSession
//
//  Created by BINAYA THAPA MAGAR on 2024-06-21.
//

import Foundation
import FirebaseFirestore

class FirestoreDBHelper : ObservableObject {
    
    // MARK: Properties
    
    private static var shared: FirestoreDBHelper?
    private let db: Firestore
    private var listener: ListenerRegistration?
    
    //Field names for collection document JSON object to avoid typing mistake in functions
//    private let COLLECTION_NAME = "UserLibrary"
//    private let COLLECTION_BOOKS = "Books"
//    private let FIELD_TITLE = "title"
//    private let FIELD_AUTHOR = "author"
//    private let FIELD_FICTION = "isFiction"
//    private let FIELD_DATE = "dateAdded"
    
//    @Published var bookList = [Book]()
    
    // MARK: Initializers
    
    init(db: Firestore) {
        self.db = db
    }
    
    // MARK: Static methods
    
    static func getInstance() -> FirestoreDBHelper {
        if shared == nil {
            shared = FirestoreDBHelper(db: Firestore.firestore())
        }
        return shared!
    }
    
    // MARK: Other methods
    
//    func insertBook(newBook : Book) {
//                
//        if let userEmail = getUserEmail(), !userEmail.isEmpty {
//            do {
//                try self.db
//                    .collection(COLLECTION_NAME)
//                    .document(userEmail)
//                    .collection(COLLECTION_BOOKS)
//                    .addDocument(from: newBook)
//            } catch let error {
//                print(#function, "Unable to insert the document to firestore: \(error)")
//            }
//        } else {
//            print(#function, "No logged in user")
//        }
//        
//    }
//    
//    func getAllBooks() {
//        
//        //Option 1 to get logged in user email
//        
//        if let userEmail = getUserEmail(), !userEmail.isEmpty {
//            self.db
//                .collection(COLLECTION_NAME)
//                .document(userEmail)
//                .collection(COLLECTION_BOOKS)
//                .addSnapshotListener { querySnapshot, error in
//                    if error == nil {
//                        self.updateBooksList(with: querySnapshot)
//                    } else {
//                        print(#function, "Failed to fetch the user's book collection: \(error!)")
//                    }
//                }
//        } else {
//            print(#function, "No logged in user")
//        }
//        
//        //Option 2
//        
//    }
//    
//    func deleteBook(bookToDelete : Book) {
//        if let userEmail = getUserEmail(), !userEmail.isEmpty {
//            guard let bookId = bookToDelete.id else {
//                print(#function, "Book Id is nil")
//                return
//            }
//            self.db
//                .collection(COLLECTION_NAME)
//                .document(userEmail)
//                .collection(COLLECTION_BOOKS)
//                .document(bookId)
//                .delete { error in
//                    if let error {
//                        print(#function, "Unable to delete document: \(error)")
//                    } else {
//                        print(#function, "Successfully deleted document: \(bookId) | \(bookToDelete.title)")
//                    }
//                }
//        } else {
//            print(#function, "No logged in user")
//        }
//    }
//    
//    func updateBook(bookToUpdate : Book) {
//        if let userEmail = getUserEmail(), !userEmail.isEmpty {
//            guard let bookId = bookToUpdate.id else {
//                print(#function, "Book ID is nil")
//                return
//            }
//            self.db
//                .collection(COLLECTION_NAME)
//                .document(userEmail)
//                .collection(COLLECTION_BOOKS)
//                .document(bookId)
//                .updateData([
//                    FIELD_TITLE: bookToUpdate.title,
//                    FIELD_AUTHOR: bookToUpdate.author,
//                    FIELD_FICTION: bookToUpdate.isFiction
//                ]) { error in
//                    
//                    if let error {
//                        print(#function, "Failed to update document: \(bookId) | \(bookToUpdate.title) | \(error)")
//                    } else {
//                        print(#function, "Successfully updated document: \(bookId) | \(bookToUpdate.title)")
//                    }
//                    
//                }
//        } else {
//            print(#function, "No logged in user")
//        }
//    }
//    
//    func removeCollectionListener() {
//        listener?.remove()
//        listener = nil
//        bookList.removeAll()
//    }
//    
//    private func updateBooksList(with querySnapshot: QuerySnapshot?) {
//        guard let querySnapshot else {
//            print(#function, "No result received from firestore.")
//            return
//        }
//        querySnapshot.documentChanges.forEach { documentChange in
//            do {
//                let document = documentChange.document
//                var newBook = try document.data(as: Book.self)
//                newBook.id = document.documentID
//                let index = self.bookList.firstIndex(where: { $0.id == document.documentID })
//                switch documentChange.type {
//                case .added:
//                    print(#function, "New document added to the collection...Append the new book to the list")
//                    if index == nil {
//                        self.bookList.append(newBook)
//                    }
//                case .modified:
//                    print(#function, "Document modified in the collection...Change/Replace the book in the list")
//                    var updatedBook = try document.data(as: Book.self)
//                    updatedBook.id = document.documentID
//                    if let index {
//                        self.bookList[index] = updatedBook
//                    }
//                case .removed:
//                    self.bookList.removeAll(where: { $0.id == document.documentID })//Method 1
//                    //Method 2
//                    //if let index {
//                    //  self.bookList.remove(at: index)
//                    //}
//                    print(#function, "Document removed in the collection...Delete the book in the list")
//                }
//                print(#function, "Book: \(newBook)")
//            } catch let e {
//                print(#function, "Unable to access the document change: \(e)")
//            }
//        }
//    }
//    
//    private func getUserEmail() -> String? {
//        UserDefaults.standard.string(forKey: FireAuthHelper.emailKey)
//    }
    
}
