import SwiftUI
import FeedbacksKit

struct ContentView: View {

    @State private var showFeedbackForm = false

    let notionSubmitService = NotionSubmitService(
        apiKey: "your-secret",
        databaseId: "your-database-id",
        notionVersion: "2022-06-28"
    )

    var body: some View {
        Button("Send feedback") {
            showFeedbackForm = true
        }
        .sheet(isPresented: $showFeedbackForm) {
            FeedbackForm(service: notionSubmitService)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
