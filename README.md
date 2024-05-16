## Overview
- We're going to be building a journaling app that allows you to post entries that are managed in multiple books. 
- Part 1 will be creating and showing Entries. 
- Part 2 will be managing Journals
- New things we'll be covering:
    - SwiftUI + CD
    - Relationships
    - Image storage
    - Manual Code Gen
    
## Part 1
### Setup
- Create a new XCode project
    - Name: CoreDataJournal
    - Interface: SwiftUI
    - Storage: Core Data
    - Host in CloudKit: ✅
- Build & Run
- Take a look at the boilerplate code Apple provides

### Model
- Start with the ManagedObjectModel
- Delete the `Item` entity that was already there
- Add a new entity called (`Entry`)
- Should have the following properties: 
    - id: `String`
    - title: `String`
    - body: `String`
    - createdAt: `Date`
    - imageData: `BinaryData`
- Set the CodeGen to `Manual` (we're going to manage the model files ourselves in this project)
### Manual Code Gen
- With the CodeGen set to Manual/None Core Data won't generate the model file for us `Entry.swift`
- The proper way to generate this file is with an XCode tool: Click into the CoreData Model editor then click on Editor > Create NSManagedObject Subclass
- This generates the files for you with the properties set up in the Core Data Model
- One cool thing you can do with manual code generation is editing the model file. 
    - For example, all Core Data properties are optional by default. But once you've generated the file you can take off the question marks on the properties you know will be there.
    - Go ahead and make all the properties non-optional and we'll make sure all the properties are present
    - Just be careful, if you forget to add a property that is not optional, the app will crash. 
    - Also remember, if you change the model, you'll need to delete those `Entry+CoreDataClass` and `Entry+CoreDataProperties` files and regenerate new ones

### Entry creation
- Rename ContentView to EntriesView
- Create a new view called `AddEditEntryView`
- Present this view in a sheet when the user hits the plus button
- Make sure the view has the following aspects:
    - A `TextField` for the title, 
    - A `TextEditor` for the body of the journal entry,
    - A button for image upload
    - A Save button
    - A Cancel button
- Once the user has filled out the title and subtitle let's save the new entry to Core Data
- Use [this link](https://www.hackingwithswift.com/books/ios-swiftui/importing-an-image-into-swiftui-using-phpickerviewcontroller) to get the photo picker working
- If the user uploads a photo (not required) we will upload the photo as binary data
- Then convert it back from Data to Image to display it with the `Entry`

### Journal Controller

- Make a new file `JournalController.swift`
- This is where we'll do a lot of the interfacing with Core Data (similar to Core Data To Do List)
- Make a new function like this `func createNewEntry(title: String, body: String, image: UIImage) {`
    - This function will create an `Entry` in Core Data with the passed in data
    - Remember to use the Core Data initializer for an Entry (`let entry = Entry(context: viewContext)`)
    - This computed property will help:
    ```
        private var viewContext: NSManagedObjectContext {
            PersistenceController.shared.container.viewContext
        }
    ```
- Save ALL the properties of the `Entry`
    - `entry.id = UUID().uuidString`
    - `entry.title = title`
    - `entry.body = body`
    - `entry.createdAt = Date()`
    - `entry.
- Save the view context to commit the changes in the context to the persistant store
- Then dismiss the sheet

### Entries List
- Why doesn't the new entry show up in the `EntriesView`?
- What do we have to do to get it to show up?
- Queue fetch request. We learned a bit about fetch requests in the ToDoList app. 
- But we're in SwiftUI land now!
- Introducing: @FetchRequest property wrapper
- Take a quick read of the apple docs found [here](https://developer.apple.com/documentation/swiftui/fetchrequest)
- Go over to the view that was generated when the xcode project was created `ContentView.swift` or if you renamed it `EntriesView`
- That file contains a fetch request using a `@FetchRequest` property wrapper
- Update the fetch request from fetching `Item`s to fetching `Entry`s
- Update the List to show the Entries from the fetch request
- Add this date formatter so you can display the date the entry was created:
    ```
    var relativeDateFormatter: RelativeDateTimeFormatter = {
    let formatter = RelativeDateTimeFormatter()
    formatter.dateTimeStyle = .numeric
    return formatter
}()
    ```
- Use it like this:
```
  if let relativeString = relativeDateFormatter.string(for: entry.createdAt) {
    Text(relativeString)
  }
```
### Update an Entry
- Finally we need a way to view and update an entry once its been created
- Update the initializer of the `AddEditEntryView` to `init(journal: Journal, entry: Entry? = nil)` 
    - Also make sure to set the initial values on init so whene editing the initilal values are set
- Also add a new property to keep track of that entry that gets passed in `let entry: Entry?`
- In the JournalController add a new function to update a entry if one already exists. `func updateEntry(entry: Entry, title: String, body: String, image: UIImage?)`
- It will be similar to `createNewEntry` but you won't need to set the id, createdAt, or journal since they will already exist
- Then go to the `EntriesView` and add a `.sheet` to present the `AddEditEntryView` and pass in the selected entry

```
    .sheet(item: $selectedEntry) { entry in
        AddEditEntryView(journal: journal, entry: entry)
    }
```
- You'll need this `@State private var selectedEntry: Entry?` to make that sheet work. 
- Set the `selectedEntry` when the user taps on an Entry Cell view

## Part 2 Journals
### Relationship

- Once you've got entries saving and showing its time to take it to the next level. 
- We want the user to be able to create multiple Journals each holding any number of entries
- Let's modify the Managed Object Model to reflect this change. 
- Add a new entity called `Journal` to the core data model
    - Add properties for `id`, `title`, `createdAt`, `colorHex: String` for saving colors. 
    - Set the code gen option to `Manaual/None`
    - Modify the model to create a relationship between a `Journal` and an `Entry`
    - A Journal has multiple entries but an Entry only belongs to a single Journal. So the relationship is a one to many 
    - The Journal relationship should look like this:
        - Relationship: entries
        - Destination: Entry
        - Inverse: journal (you need to go set up the other relationship before this option is available)
        - Type: To Many (A `Journal` has many `Entry` objects)
        - Delete Rule: Cascade (Deleting a Journal cascade deletes the associated Entries)
    - Entry relationship:
        - Relationship: journal
        - Destination: Journal
        - Inverse: entries
        - Type: To One (an `Entry` only has one `Journal`)
        - Delete Rule: Nullify (Deleting an Entry doesnt delete anything else)
- Now remember we are manually managing these entities. 
    - So we'll need to delete the `Entry` files and generate new ones. Both Entry and Journal will our  (Editor > Create NSManagedObject Subclass)

### Journal List
- Create two new files: `JournalsView.swift` and `AddEditJournalView.swift`
- The JournalsView:
    - Will be kind of similar to the `EntriesView`
    - It will use a fetch request to request the Journals of the user
    - It will display those Journals in a list
    - Each 'cell' should show the title of the journal, and the number of entries as the subtitle
    - It should be a Navigationlink that links to a Entries view. 
- But now we can make some changes to utilize this new relationship
- Relationships allow you to access the parent or children of an entity
- So if you have a journal, you can access its entries through its relationship
- By default a relationship is represented by this type: `NSSet` which is an unordered collection. and also optional since a `Journal` may not have any `Entry`ies
- Add this to the `extension Journal {` to have an array of Journal Entries easily accesible
    ```
    var entriesArray: [Entry] {
        guard let all = entries?.allObjects as? [Entry] else { return [] }
        return Array(all)
    }
    ```
- Remove the fetch request in the `EntriesView`
- Instead pass in a `Journal` into the `EntriesView` on initialization
- Show the list of entries like this: `List(journal.entriesArray) { entry in `

### Journal Creation
- The last part is creating new Journals (you're so close, hang in there)
- The `AddEditJournalView` will be similar to the `AddEditEntryView`
    - It should have a textfield so the user can write the title
    - A save button to save a new Journal to Core Data
    - And something new we get to learn: ColorPicker
    - Color Picker is a new Apple api that is easy to use
    - Just add a state variable for the selected color: `@State private var selectedColor: UIColor`
        - UIColor instead of SwiftUI.Color will make it easier to save to Core Data here in a minute
    - Then add a ColorPicker to the view like this:
        - `ColorPicker("Set Journal Color", selection: $selectedColor, supportsOpacity: false)`
    - When the user hits the save button, call a new function in the Journal Controller
        - `func createNewJournal(title: String, color: Color)`
        - Inside this func, once again, use the Core Data initializer to create a new Journal
        - Give the new Journal an id (UUID().uuidString), a title from the title param, createdAt of the current date.
        - What about the color of the journal?

### Saving Color
- How do we save a color to Core Data?
- Well, there's more than one way. 
- For today, we'll just convert the color to a hex value and save it as a string. Then convert that hex string back to a color 
- We need to use values that are compatible with Core Data
- So we'll convert the color to a hex to save into CD and then convert from hex String back to a color 
- Grab the code found in sections 1 and 2 of [this blog post](https://ditto.live/blog/swift-hex-color-extension) and paste it into a new file called `ColorExtensions`
    - They will help you make these conversation to and from a hex string
- In the JournalsView, add to the view that shows each Journal Cell. 
```
    if let hex = journal.colorHex, let color = Color(hex: hex) {
        RoundedRectangle(cornerRadius: 8)
            .foregroundStyle(color)
            .frame(width: 40, height: 40)
    }
```
- This is what mine looks like 👆

### Part 2 Notes
- Go to the app declaration in `CoreDataJournalApp.swift`
    - Make `JournalsView` the root view instead of `EntriesView`
-  Don't forget to delete the NavigationStack in the `EntriesView` so avoid a double nav
- Don't forget to make the association between an `Entry` and a `Journal` when you create an `Entry.`
    - i.e. entry.journal = journal 
    - That means you'll need to pass in a Journal to the `AddEditEntryView` so you have it when you create a new `Entry`
- Make sure the `journal` property you pass in to the `EntriesView` is an `@ObservedObject` so the list of entries updates when you make a new one
