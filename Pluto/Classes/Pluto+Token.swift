//
//  Pluto+Token.swift
//  Pluto
//
//  Created by Meng Li on 2019/01/01.
//  Copyright © 2018 MuShare. All rights reserved.
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.

import Alamofire
import SwiftyJSON

extension Pluto {
    
    public func getToken(completion: @escaping (String?) -> Void) {
        let expire = DefaultsManager.shared.expire
        guard
            let jwt = DefaultsManager.shared.jwt,
            expire - Int(Date().timeIntervalSince1970) > 5 * 60
        else {
            refreshToken(completion: completion)
            return
        }
        completion(jwt)
    }
    
    func refreshToken(completion: @escaping (String?) -> Void) {
        guard
            let userId = DefaultsManager.shared.userId,
            let refreshToken = DefaultsManager.shared.refreshToken
        else {
            completion(nil)
            return
        }
        AF.request(
            url(from: "api/auth/refresh"),
            method: .post,
            parameters: [
                "refresh_token": refreshToken,
                "user_id": userId,
                "device_id": devideId,
                "app_id": appId
            ],
            encoding: JSONEncoding.default
        ).responseJSON {
            let response = PlutoResponse($0)
            if response.statusOK() {
                let body = response.getBody()
                guard let jwt = body["jwt"].string else {
                    completion(nil)
                    return
                }
                DefaultsManager.shared.jwt = jwt
                completion(jwt)
            }
        }
    }
    
}