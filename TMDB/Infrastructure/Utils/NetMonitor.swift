import Foundation
import Network

public enum ConnectionType {
    case wifi
    case ethernet
    case cellular
    case unknown
}

class NetMonitor {
    static public let shared = NetMonitor()
    private var monitor: NWPathMonitor
    private var queue = DispatchQueue.global()
    var netOn: Bool = true
    var connType: ConnectionType = .wifi

    private init() {
        self.monitor = NWPathMonitor()
        self.queue = DispatchQueue.global(qos: .background)
        self.monitor.start(queue: queue)
    }

    func startMonitoring() {
        self.monitor.pathUpdateHandler = { path in
            self.netOn = path.status == .satisfied
            self.connType = self.checkConnectionTypeForPath(path)
        }
    }

    func stopMonitoring() {
        self.monitor.cancel()
    }

    func checkConnectionTypeForPath(_ path: NWPath) -> ConnectionType {
        if path.usesInterfaceType(.wifi) {
            return .wifi
        } else if path.usesInterfaceType(.wiredEthernet) {
            return .ethernet
        } else if path.usesInterfaceType(.cellular) {
            return .cellular
        }

        return .unknown
    }
}
