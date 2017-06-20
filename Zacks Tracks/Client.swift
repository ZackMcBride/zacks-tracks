struct Client {

    static let SampleClient = Client(uuid: "12345", appVersion: "0.0.1", bundleName: "test", deviceModel: "iPhone 8", deviceSystemVersion: "10.3")

    let uuid: String
    let appVersion: String
    let bundleName: String
    let deviceModel: String
    let deviceSystemVersion: String
}

