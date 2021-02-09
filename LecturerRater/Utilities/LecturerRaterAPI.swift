import Foundation


class LecturerRaterAPI {
    
    private static let domain: String = "http://23.111.202.183:5000"
    
    
    private static func signUpOrIn(sublink signUpOrInSublink: String, username: String, password: String,
        completionHandler completion: @escaping (String?, String?) -> Void) {
        var request = URLRequest(url: URL(string: LecturerRaterAPI.domain + signUpOrInSublink)!)
        
        request.httpMethod = "POST"
        request.httpBody = [
            "username": username,
            "password": password
        ].map { "\($0.key)=\($0.value)" } .joined(separator: "&").data(using: .utf8)
        
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            guard let data = data, let response = response as? HTTPURLResponse, error == nil else {
                DispatchQueue.main.async { completion(nil, "Couldn't connect to server.") }
                return
            }
            
            guard let json = try? JSONSerialization.jsonObject(with: data) as? [String: String] else {
                DispatchQueue.main.async { completion(nil, "Couldn't parse received data.") }
                return
            }
            
            guard (200...299) ~= response.statusCode else {
                DispatchQueue.main.async { completion(nil, json["message"]) }
                return
            }
            
            DispatchQueue.main.async { completion(json["token"], nil) }
        } .resume()
    }
    
    
    public static func signUp(username: String, password: String,
        _ completion: @escaping (String?, String?) -> Void) {
        LecturerRaterAPI.signUpOrIn(sublink: "/sign-up", username: username, password: password, completionHandler: completion)
    }
    
    public static func signIn(username: String, password: String,
        _ completion: @escaping (String?, String?) -> Void) {
        LecturerRaterAPI.signUpOrIn(sublink: "/sign-in", username: username, password: password, completionHandler: completion)
    }
    
    
    public static func getRatings(ofLecturer lecturer: String? = nil,
        _ completion: @escaping ([Rating]?, String?) -> Void) {
        let lecturerParameter: String = (lecturer == nil) ? "" : ("?lecturer=" + lecturer!)
        
        URLSession.shared.dataTask(with: URL(string: LecturerRaterAPI.domain + "/ratings" + lecturerParameter)!) { (data, response, error) in
            guard let data = data, let response = response as? HTTPURLResponse, error == nil else {
                DispatchQueue.main.async { completion(nil, "Couldn't connect to server.") }
                return
            }
            
            guard let json = try? JSONSerialization.jsonObject(with: data) as? [String: Any] else {
                DispatchQueue.main.async { completion(nil, "Couldn't parse received data.") }
                return
            }
            
            guard (200...299) ~= response.statusCode else {
                DispatchQueue.main.async { completion(nil, json["message"] as? String) }
                return
            }
            
            guard let jsonRatings = json["ratings"] as? [[String: String]] else {
                DispatchQueue.main.async { completion(nil, "Couldn't recognise format of ratings list.") }
                return
            }
            
            let ratings: [Rating] = jsonRatings.map {
                Rating(
                    id: Int($0["id"]!)!,
                    userId: Int($0["user_id"]!)!,
                    lecturer: $0["lecturer"]!,
                    value: Int($0["value"]!)!,
                    text: $0["text"]!
                )
            }
            
            DispatchQueue.main.async { completion(ratings, nil) }
        } .resume()
    }
    
    public static func getMyRatings(usingToken token: String,
        _ completion: @escaping ([Rating]?, String?) -> Void) {
        var request = URLRequest(url: URL(string: LecturerRaterAPI.domain + "/my-ratings")!)
        
        request.httpMethod = "POST"
        request.httpBody = [
            "token": token
        ].map { "\($0.key)=\($0.value)" } .joined(separator: "&").data(using: .utf8)
        
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            guard let data = data, let response = response as? HTTPURLResponse, error == nil else {
                DispatchQueue.main.async { completion(nil, "Couldn't connect to server.") }
                return
            }
            
            guard let json = try? JSONSerialization.jsonObject(with: data) as? [String: Any] else {
                DispatchQueue.main.async { completion(nil, "Couldn't parse received data.") }
                return
            }
            
            guard (200...299) ~= response.statusCode else {
                DispatchQueue.main.async { completion(nil, json["message"] as? String) }
                return
            }
            
            guard let jsonRatings = json["ratings"] as? [[String: String]] else {
                DispatchQueue.main.async { completion(nil, "Couldn't recognise format of ratings list.") }
                return
            }
            
            let ratings: [Rating] = jsonRatings.map {
                Rating(
                    id: Int($0["id"]!)!,
                    userId: Int($0["user_id"]!)!,
                    lecturer: $0["lecturer"]!,
                    value: Int($0["value"]!)!,
                    text: $0["text"]!
                )
            }
            
            DispatchQueue.main.async { completion(ratings, nil) }
        } .resume()
    }
    
    
    public static func createRating(_ rating: Rating, usingToken token: String,
        _ completion: @escaping (String?) -> Void) {
        var request = URLRequest(url: URL(string: LecturerRaterAPI.domain + "/create-rating")!)
        
        request.httpMethod = "POST"
        request.httpBody = [
            "token": token,
            "lecturer": rating.lecturer,
            "value": rating.value,
            "text": rating.text
        ].map { "\($0.key)=\($0.value)" } .joined(separator: "&").data(using: .utf8)
        
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            guard let data = data, let response = response as? HTTPURLResponse, error == nil else {
                DispatchQueue.main.async { completion("Couldn't connect to server.") }
                return
            }
            
            guard let json = try? JSONSerialization.jsonObject(with: data) as? [String: Any] else {
                DispatchQueue.main.async { completion("Couldn't parse received data.") }
                return
            }
            
            guard (200...299) ~= response.statusCode else {
                DispatchQueue.main.async { completion(json["message"] as? String) }
                return
            }
            
            DispatchQueue.main.async { completion(nil) }
        } .resume()
    }
    
    public static func removeRating(withId ratingId: Int, usingToken token: String,
        _ completion: @escaping (String?) -> Void) {
        var request = URLRequest(url: URL(string: LecturerRaterAPI.domain + "/remove-rating")!)
        
        request.httpMethod = "POST"
        request.httpBody = [
            "token": token,
            "rating-id": ratingId
        ].map { "\($0.key)=\($0.value)" } .joined(separator: "&").data(using: .utf8)
        
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            guard let data = data, let response = response as? HTTPURLResponse, error == nil else {
                DispatchQueue.main.async { completion("Couldn't connect to server.") }
                return
            }
            
            guard let json = try? JSONSerialization.jsonObject(with: data) as? [String: Any] else {
                DispatchQueue.main.async { completion("Couldn't parse received data.") }
                return
            }
            
            guard (200...299) ~= response.statusCode else {
                DispatchQueue.main.async { completion(json["message"] as? String) }
                return
            }
            
            DispatchQueue.main.async { completion(nil) }
        } .resume()
    }
    
}
