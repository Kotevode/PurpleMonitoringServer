@_exported import Vapor

extension Droplet {
    
    enum ConfigError: Error {
        case couldNotLoadProgramsFromConfig
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
    }
}
