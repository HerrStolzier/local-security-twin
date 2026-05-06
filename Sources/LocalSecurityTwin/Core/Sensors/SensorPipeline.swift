import Foundation

struct SensorPipeline {
    let sensors: [any FindingSensor]

    func collect(in context: SensorContext = .live()) -> [SensorRun] {
        var runs: [SensorRun] = []
        runs.reserveCapacity(sensors.count)

        for sensor in sensors {
            runs.append(sensor.run(in: context))
        }

        return runs
    }
}

extension SensorPipeline {
    static func live(fileManager: FileManager = .default) -> SensorPipeline {
        SensorPipeline(
            sensors: [
                LaunchAgentInventorySensor(fileManager: fileManager),
            ]
        )
    }
}
