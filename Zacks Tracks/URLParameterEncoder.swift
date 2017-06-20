import Foundation

/// Taken form https://github.com/Alamofire/Alamofire/blob/master/Source/ParameterEncoding.swift
public class URLParameterEncoder {
    public static func encode(urlRequest: URLRequest, parameters: [String: AnyObject]?) {
        var urlRequest = urlRequest
        guard let parameters = parameters else {
            return
        }

        var urlVars = [String]()

        func query(parameters: [String: AnyObject]) -> String {
            var components: [(String, String)] = []

            for key in parameters.keys.sorted(by: <) {
                let value = parameters[key]!
                components += queryComponents(key: key, value)
            }

            return (components.map { "\($0)=\($1)" } as [String]).joined(separator: "&")
        }

        if var urlComponents = URLComponents(url: urlRequest.url!, resolvingAgainstBaseURL: false) {

            let percentEncodedQuery = (urlComponents.percentEncodedQuery.map { $0 + "&" } ?? "") + query(parameters: parameters)

            urlComponents.percentEncodedQuery = percentEncodedQuery
            urlRequest.url = urlComponents.url
        }
    }

    private static func queryComponents(key: String, _ value: AnyObject) -> [(String, String)] {
        var components: [(String, String)] = []

        if let dictionary = value as? [String: AnyObject] {
            for (nestedKey, value) in dictionary {
                components += queryComponents(key: "\(key)[\(nestedKey)]", value)
            }
        } else if let array = value as? [AnyObject] {
            for value in array {
                components += queryComponents(key: "\(key)[]", value)
            }
        } else {
            components.append((escape(string: key), escape(string: "\(value)")))
        }

        return components
    }

    /**
     Returns a percent-escaped string following RFC 3986 for a query string key or value.

     RFC 3986 states that the following characters are "reserved" characters.

     - General Delimiters: ":", "#", "[", "]", "@", "?", "/"
     - Sub-Delimiters: "!", "$", "&", "'", "(", ")", "*", "+", ",", ";", "="

     In RFC 3986 - Section 3.4, it states that the "?" and "/" characters should not be escaped to allow
     query strings to include a URL. Therefore, all "reserved" characters with the exception of "?" and "/"
     should be percent-escaped in the query string.

     - parameter string: The string to be percent-escaped.

     - returns: The percent-escaped string.
     */
    private static func escape(string: String) -> String {
//        let generalDelimitersToEncode = ":#[]@" // does not include "?" or "/" due to RFC 3986 - Section 3.4
//        let subDelimitersToEncode = "!$&'()*+,;="
//
//        let allowedCharacterSet = ""
//        allowedCharacterSet.removeCharactersInString(generalDelimitersToEncode + subDelimitersToEncode)
//
//        return string.stringByAddingPercentEncodingWithAllowedCharacters(allowedCharacterSet) ?? string
        return ""
    }
}
