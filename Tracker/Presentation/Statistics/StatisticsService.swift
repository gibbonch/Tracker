//
//  StatisticService.swift
//  Tracker
//
//  Created by Александр Торопов on 26.01.2025.
//

import Foundation

final class StatisticsService {
    
    // MARK: - StatisticsError
    
    enum StatisticsError: Error {
        case failedToCalculateStatistics
    }
    
    // MARK: - Properties
    
    var onStatisticsUpdate: Binding<Result<[Statistic], Error>>?
    
    private(set) var statistics: [Statistic]
    private let trackerRecordProvider: TrackerRecordProvider
    private let trackerStore: TrackerStoring
    private let calendar = Calendar.current
    
    init(trackerRecordProvider: TrackerRecordProvider, trackerStore: TrackerStoring) {
        self.trackerRecordProvider = trackerRecordProvider
        self.trackerStore = trackerStore
        statistics = [
            .bestPeriod(days: 0),
            .perfectDays(days: 0),
            .completedTrackers(count: 0),
            .averageValue(points: 0)
        ]
        trackerRecordProvider.delegate = self
        trackerRecordProvider.performFetch()
    }
    
    // MARK: - Public Methods
    
    func statisticsCount() -> Int {
        statistics.count
    }
    
    // MARK: - Private Methods
    
    private func updateStatistics(_ records: [TrackerRecord]) {
        statistics = [
            .bestPeriod(days: calculateBestPeriod(records: records)),
            .perfectDays(days: calculatePerfectDays(records: records)),
            .completedTrackers(count: calculateCompletedTrackers(records: records)),
            .averageValue(points: calculateAverageValue(records: records))
        ]
    }
    
    private func calculateBestPeriod(records: [TrackerRecord]) -> Int {
        guard !records.isEmpty else { return 0 }
        
        let dates = records.map { $0.date }.sorted()
        var bestPeriod = 1
        var currentPeriod = 1
        
        for i in 1..<dates.count {
            if let nextDate = Calendar.current.date(byAdding: .day, value: 1, to: dates[i - 1]),
               nextDate == dates[i] {
                currentPeriod += 1
            } else {
                bestPeriod = max(bestPeriod, currentPeriod)
                currentPeriod = 1
            }
        }
        bestPeriod = max(bestPeriod, currentPeriod)
        return bestPeriod
    }

    
    private func calculatePerfectDays(records: [TrackerRecord]) -> Int {
        var cnt = 0
        let dates = Set(records.map{ $0.date })
        for date in dates {
            let trackersOnDate = trackerStore.fetchTrackers(on: date)
            let recordsOnDate = records.filter { $0.date == date }
            if trackersOnDate.count == recordsOnDate.count {
                cnt += 1
            }
        }
        return cnt
    }
    
    private func calculateCompletedTrackers(records: [TrackerRecord]) -> Int {
        return records.count
    }
    
    private func calculateAverageValue(records: [TrackerRecord]) -> Int {
        if records.isEmpty {
            return 0
        }
        let daysCount = Set(records.map{ $0.date }).count
        return records.count / daysCount
    }
}

// MARK: - TrackerRecordProviderDelegate

extension StatisticsService: TrackerRecordProviderDelegate {
    func didChangeTrackerRecords(_ records: [TrackerRecord]) {
        updateStatistics(records)
        if statistics.isEmpty {
            onStatisticsUpdate?(.failure(StatisticsError.failedToCalculateStatistics))
        } else {
            onStatisticsUpdate?(.success(statistics))
        }
    }
}
