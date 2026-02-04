final class NetworkClient {

    private let session: Session

    init(interceptor: RequestInterceptor? = nil) {
        self.session = Session(interceptor: interceptor)
    }

    func get<T: Decodable>(_ url: String) async throws -> T {
        try await request(url, method: .get, parameters: Optional<Data>.none)
    }

    func post<T: Decodable, B: Encodable>(_ url: String, body: B) async throws -> T {
        try await request(url, method: .post, parameters: body)
    }