import Foundation


class LecturerRaterAPI {
    
    private static let domain: String = "http://23.111.202.183:5000"
    
    
    private static func signUpOrIn(sublink signUpOrInSublink: String, username: String, password: String,
        completionHandler completion: @escaping (String?, String?) -> Void) {
        let urlString: String = LecturerRaterAPI.domain + signUpOrInSublink
        
        guard let url = URL(string: urlString) else {
            completion(nil, "Couldn't create link.")
            return
        }
        
        var request = URLRequest(url: url)
        
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
        var urlString: String = LecturerRaterAPI.domain + "/ratings"
        
        if let lecturer = lecturer { urlString += ("?lecturer=" + lecturer) }
        
        guard let url = URL(string: urlString) else {
            completion(nil, "Couldn't create link.")
            return
        }
        
        URLSession.shared.dataTask(with: url) { (data, response, error) in
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
        let urlString: String = LecturerRaterAPI.domain + "/my-ratings"
        
        guard let url = URL(string: urlString) else {
            completion(nil, "Couldn't create link.")
            return
        }
        
        var request = URLRequest(url: url)
        
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
        let urlString: String = LecturerRaterAPI.domain + "/create-rating"
        
        guard let url = URL(string: urlString) else {
            completion("Couldn't create link.")
            return
        }
        
        var request = URLRequest(url: url)
        
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
        let urlString: String = LecturerRaterAPI.domain + "/remove-rating"
        
        guard let url = URL(string: urlString) else {
            completion("Couldn't create link.")
            return
        }
        
        var request = URLRequest(url: url)
        
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
