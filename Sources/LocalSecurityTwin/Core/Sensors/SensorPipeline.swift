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

    func collectWithOnlineUpdateAwareness(in context: SensorContext = .live()) -> [SensorRun] {
        var runs: [SensorRun] = []
        runs.reserveCapacity(sensors.count)

        for sensor in sensors {
            if let refreshableSensor = sensor as? any UpdateAwarenessRefreshingSensor {
                runs.append(refreshableSensor.runWithOnlineRefresh(in: context))
            } else {
                runs.append(sensor.run(in: context))
            }
        }

        return runs
    }

    func refreshRememberedStartupState(in context: SensorContext = .live()) throws {
        for sensor in sensors {
            guard let refreshableSensor = sensor as? any StartupBaselineRefreshingSensor else {
                continue
            }

            try refreshableSensor.refreshRememberedStartupState(in: context)
        }
    }
}

extension SensorPipeline: @unchecked Sendable {}

extension SensorPipeline {
    static func live(fileManager: FileManager = .default) -> SensorPipeline {
        SensorPipeline(
            sensors: [
                LaunchAgentInventorySensor(fileManager: fileManager),
                SystemProfileSensor(),
                UpdateAwarenessSensor(),
            ]
        )
    }
}
