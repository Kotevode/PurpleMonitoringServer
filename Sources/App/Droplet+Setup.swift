@_exported import Vapor
import Model

extension Droplet {
    
    enum ConfigError: Error {
        case couldNotLoadProgramsFromConfig
        case coultNotLoadNodeInfoFromConfig
    }
    
    public func setup() throws {
        try collection(Routes.self)
        try loadPrograms()
    }
    
    private func loadPrograms() throws {
        guard let programs = self.config["programs", "available"]?.array else {
            throw ConfigError.couldNotLoadProgramsFromConfig
        }
        try programs.forEach { config in
            try Program(node: config.makeNode(in: nil)).save()
        }
        guard let nodes = self.config["nodes", "available"]?.array else {
            throw ConfigError.couldNotLoadProgramsFromConfig
        }
        try nodes.forEach { config in
            try Node(node: config.makeNode(in: nil)).save()
        }
    }
}
