import Darwin

public struct IpAddress {
    public enum Result {
        case SameSubnet
        case DifferentSubnet
    }

    public let addressString: String
    public let addressValue: UInt32

    public init?(_ ipAddress: String) {
        var internetAddress = in_addr()
        guard inet_pton(AF_INET, ipAddress, &internetAddress) == 1 else { return nil }
        self.addressString = ipAddress
        self.addressValue = internetAddress.s_addr
    }

    public func isOnTheSameSubnet(asSecondIpAddress secondIpAddress: IpAddress,
                                  subnetMask: SubnetMask) -> Result {

        let maskedFirstAddress = addressValue & subnetMask.addressValue
        let maskedSecondAddress = secondIpAddress.addressValue & subnetMask.addressValue

        return maskedFirstAddress == maskedSecondAddress ? .SameSubnet : .DifferentSubnet
    }

    public static func deviceIpAddress() -> IpAddress? {
        return nil
    }
}
