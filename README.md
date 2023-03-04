# FeedbacksKit

A simple user feedback form right into your app.

Submit user feedbacks to your own database, or use the provided Notion service to store feedbacks to a Notion database.

This is an MVP, feel free to improve it.

## Media
https://user-images.githubusercontent.com/25299469/222914315-c0e1ed8f-ddc7-4479-a2ec-5cfcc78c4987.mp4

## Usage

Check out the [demo project](https://github.com/Kaww/FeedbacksKit/blob/cc23c2a9cc858fdd9203c2c420bc18e43a8276ae/FeedbacksKitDemo/FeedbacksKitDemo/ContentView.swift).

### View

```swift
Button("Send feedback") {
    showFeedbackForm = true
}
.sheet(isPresented: $showFeedbackForm) {
    FeedbackForm(service: notionSubmitService)
}
```

### Submission

Feedbacks are submitted with using a `SubmitService`.
You can define your own `SubmitService` by providing a object that conforms to the protocol.
```swift
public protocol SubmitService {
    func submit(formData: FeedbackFormData) async throws
}
```
A default implementation using [Notion API](https://developers.notion.com) is also available.

### How to use the `NotionSubmitService`.

- [Create a new integration](https://www.notion.so/my-integrations) on your Notion account. This service requires only insert capabilities. Save the `Internal Integration Token` for later.
- On your Notion workspace, create a new full page database, with the title property beeing called `email`
<img width="714" alt="Screenshot 2023-03-04 at 16 31 38" src="https://user-images.githubusercontent.com/25299469/222914799-56a05226-1049-4e64-ac91-b7481c6f75d8.png">

- Tap the "..." button on the top right of the page, then "+ Add connections". Your new connection should appear here, select it.
<img width="483" alt="Screenshot 2023-03-04 at 16 34 12" src="https://user-images.githubusercontent.com/25299469/222914941-8086b357-fec3-4f9f-a6a0-f8deb75dbf02.png">

- In your code, instanciate a NotionSubmitService and pass it to the `FeedbackForm` View. You will need :
  - Your `Internal Integration Token` from the integration page.
  - Your database ID. To find it, copy your database link from the share button on the Notion page. The database ID is the between your user name and the fist `?`: `https://www.notion.so/your-name/your-database-id?v=...`
  - The current notion API version. You can find it on the [Notion API Documentation](https://developers.notion.com/reference/post-page)
```swift
let notionSubmitService = NotionSubmitService(
    apiKey: "your-secret",
    databaseId: "your-database-id",
    notionVersion: "2022-06-28"
)
```
