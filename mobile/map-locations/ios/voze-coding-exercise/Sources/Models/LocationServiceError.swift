enum NetworkError: Error {
    case invalidResource
    case invalidURL
    case wrapped(Error)
}
