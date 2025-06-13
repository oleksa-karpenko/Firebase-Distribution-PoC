//
//  Mocks.swift
//  FBDistributionPoC
//
//  Created by Oleksandr Karpenko on 13.06.2025.
//

@testable import FBDistributionPoC

struct MockVersionProvider: AppVersionProviding {
    var version: String
    var buildNumber: String
    
    init(version: String = "1.2.3", buildNumber: String = "456") {
        self.version = version
        self.buildNumber = buildNumber
    }
    
    func getAppVersionString() -> String { version }
    func getBuildNumber() -> String { buildNumber }
}
