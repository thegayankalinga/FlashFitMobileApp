//
//  PasswordHasher.swift
//  FlashFitMobileApp
//
//  Created by Gayan Kalinga on 2023-08-12.
//

import Foundation
import CommonCrypto

public class PasswordHasher
{
    static func computeHash(password: String, salt: String, pepper: String, iteration: Int) -> String {
            if iteration <= 0 {
                return password
            }

            guard let data = (password + salt + pepper).data(using: .utf8) else {
                return password
            }

            var digest = [UInt8](repeating: 0, count: Int(CC_SHA256_DIGEST_LENGTH))
            data.withUnsafeBytes { buffer in
                _ = CC_SHA256(buffer.baseAddress, CC_LONG(buffer.count), &digest)
            }

            let hashData = Data(digest)
            let hash = hashData.base64EncodedString()

            return computeHash(password: hash, salt: salt, pepper: pepper, iteration: iteration - 1)
        }

        static func generateSalt() -> String {
            var byteValueOfSalt = [UInt8](repeating: 0, count: 16)
            _ = SecRandomCopyBytes(kSecRandomDefault, byteValueOfSalt.count, &byteValueOfSalt)

            let saltData = Data(byteValueOfSalt)
            let saltString = saltData.base64EncodedString()

            return saltString
        }
}
    

