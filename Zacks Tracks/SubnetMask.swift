import Foundation

public struct SubnetMask {
    public let addressString: String
    public let addressValue: UInt32

    public init?(_ ipAddress: String) {
        var internetAddress = in_addr()
        guard inet_pton(AF_INET, ipAddress, &internetAddress) == 1 && SubnetMask.isValid(subnetMask: ipAddress) else { return nil }
        self.addressString = ipAddress
        self.addressValue = internetAddress.s_addr
    }

    private static func isValid(subnetMask: String) -> Bool {
        // http://stackoverflow.com/a/17401261/743608

        let subnetValue = subnetMask.components(separatedBy: ".").reduce(UInt32(0)) { ($0 << 8) + UInt32($1)! }
        let y: UInt32 = ~subnetValue
        let z: UInt32 = y + 1

        return (z & y) == 0
    }
}
