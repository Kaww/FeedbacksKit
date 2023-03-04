import Foundation

public struct NotionSubmitService: SubmitService {
    private let apiKey: String
    private let databaseId: String
    private let notionVersion: String
    private let notionBaseURL: String

    public init(
        apiKey: String,
        databaseId: String,
        notionVersion: String,
        notionBaseUrl: String = "https://api.notion.com/v1/pages"
    ) {
        self.apiKey = apiKey
        self.databaseId = databaseId
        self.notionVersion = notionVersion
        self.notionBaseURL = notionBaseUrl
    }

    public func submit(formData: FeedbackFormData) async throws {
        var request = try buildURLRequest()
        let notionBody = buildNotionBody(formData: formData)
        request.httpBody = try data(from: notionBody)

        let (_, response) = try await URLSession.shared.data(for: request)

        guard
            let response = response as? HTTPURLResponse,
            (200...299).contains(response.statusCode)
        else {
            throw NotionSubmitError()
        }
    }

    private func buildURLRequest() throws -> URLRequest {
        guard let url = URL(string: notionBaseURL) else {
            throw NotionSubmitError()
        }

        var request = URLRequest(url: url)

        request.setValue(apiKey, forHTTPHeaderField: "Authorization")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue(notionVersion, forHTTPHeaderField: "Notion-Version")

        request.httpMethod = "POST"

        return request
    }

    private func buildNotionBody(formData: FeedbackFormData) -> NotionBody {
        NotionBody(
            parent: .init(databaseId: databaseId),
            properties: .init(
                email: .init(
                    title: [
                        .init(
                            text: .init(content: formData.email)
                        )
                    ]
                )
            ),
            children: [
                .init(
                    object: "block",
                    type: "paragraph",
                    paragraph: .init(
                        richText: [
                            .init(
                                type: "text",
                                text: .init(content: formData.message)
                            )
                        ]
                    )
                )
            ]
        )
    }

    private func data(from notionBody: NotionBody) throws -> Data {
        let encoder = JSONEncoder()
        encoder.keyEncodingStrategy = .convertToSnakeCase
        return try encoder.encode(notionBody)
    }

    private struct NotionSubmitError: Error {}
}

private struct NotionBody: Codable {
    let parent: Parent
    let properties: Properties
    let children: [Child]

    struct Parent: Codable {
        let databaseId: String
    }

    struct Properties: Codable {
        let email: Email

        struct Email: Codable {
            let title: [Title]

            struct Title: Codable {
                let text: Text

                struct Text: Codable {
                    let content: String
                }
            }
        }
    }

    struct Child: Codable {
        let object: String
        let type: String
        let paragraph: Paragraph

        struct Paragraph: Codable {
            let richText: [RichText]

            struct RichText: Codable {
                let type: String
                let text: Text

                struct Text: Codable {
                    let content: String
                }
            }
        }
    }
}
