enum LocationServiceError: Error {
    case invalidResource
    case invalidURL
    case wrapped(Error)
}
