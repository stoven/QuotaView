import Foundation
import QuotaViewWidgetContract
import XCTest
@testable import QuotaView

@MainActor
final class WidgetSnapshotWriterTests: XCTestCase {
    func testProjectorPublishesOnlySanitizedWidgetFields() throws {
        let now = Date(timeIntervalSince1970: 1_785_100_000)
        let presentation = makePresentation(
            remainingPercent: 72,
            now: now
        )

        let snapshot = QuotaViewWidgetSnapshotProjector().makeSnapshot(
            presentation: presentation,
            isAvailable: true,
            localeIdentifier: "zh-Hans",
            now: now
        )
        let provider = try XCTUnwrap(snapshot.provider)
        let window = try XCTUnwrap(provider.primaryWindow)

        XCTAssertEqual(snapshot.availability, .available)
        XCTAssertEqual(snapshot.localeIdentifier, "zh-Hans")
        XCTAssertEqual(provider.providerID, "codex")
        XCTAssertEqual(provider.plan, "Plus")
        XCTAssertEqual(window.usedFraction, 0.28)
        XCTAssertEqual(window.remainingFraction, 0.72)
        XCTAssertEqual(provider.availableResetCredits, 2)
        XCTAssertEqual(
            provider.auxiliaryMetrics,
            [
                WidgetAuxiliaryMetric(
                    id: WidgetAuxiliaryMetricIdentifier
                        .creditsBalance,
                    label: "Credits 余额",
                    formattedValue: "10"
                ),
                WidgetAuxiliaryMetric(
                    id: WidgetAuxiliaryMetricIdentifier.todayTokens,
                    label: "今日 Tokens",
                    formattedValue: "4.2万"
                ),
                WidgetAuxiliaryMetric(
                    id: WidgetAuxiliaryMetricIdentifier
                        .lifetimeTokens,
                    label: "累计 Tokens",
                    formattedValue: "900万"
                )
            ]
        )

        let encoded = try WidgetSnapshotCodec().encode(snapshot)
        let encodedText = try XCTUnwrap(
            String(data: encoded, encoding: .utf8)
        )
        XCTAssertFalse(encodedText.contains("lifetimeTokens"))
        XCTAssertFalse(encodedText.contains("recentDailyTokens"))
        XCTAssertFalse(encodedText.contains("creditBalance"))
        XCTAssertFalse(encodedText.contains("account"))
        XCTAssertFalse(encodedText.contains("authorization"))
        XCTAssertFalse(encodedText.contains("prompt"))
    }

    func testCompactTokenFormatterUsesLocalizedUnits() {
        let chinese = CompactTokenCountFormatter(
            localeIdentifier: "zh-Hans"
        )
        let english = CompactTokenCountFormatter(
            localeIdentifier: "en"
        )

        XCTAssertEqual(chinese.string(from: nil), "—")
        XCTAssertEqual(chinese.string(from: 0), "0")
        XCTAssertEqual(chinese.string(from: 9_999), "9999")
        XCTAssertEqual(chinese.string(from: 10_000), "1万")
        XCTAssertEqual(chinese.string(from: 42_000), "4.2万")
        XCTAssertEqual(chinese.string(from: 9_000_000), "900万")
        XCTAssertEqual(chinese.string(from: 418_700_000), "4.2亿")
        XCTAssertEqual(chinese.string(from: 6_500_000_000), "65亿")
        XCTAssertEqual(chinese.string(from: -15_000), "-1.5万")

        XCTAssertEqual(english.string(from: 999), "999")
        XCTAssertEqual(english.string(from: 1_000), "1K")
        XCTAssertEqual(english.string(from: 418_700_000), "418.7M")
        XCTAssertEqual(english.string(from: 6_500_000_000), "6.5B")
    }

    func testCompactTokenFormatterKeepsChineseSubWanValuesExact() {
        let chinese = CompactTokenCountFormatter(
            localeIdentifier: "zh-CN"
        )
        let english = CompactTokenCountFormatter(
            localeIdentifier: "en"
        )

        XCTAssertEqual(
            chinese.string(
                from: 999,
                abbreviatesValuesBelowFirstUnit: true
            ),
            "999"
        )
        XCTAssertEqual(
            english.string(
                from: 999,
                abbreviatesValuesBelowFirstUnit: true
            ),
            "<1K"
        )
        XCTAssertFalse(
            chinese.string(from: Int64.min).isEmpty
        )
    }

    func testProjectorDoesNotKeepProviderDataWhenUnavailable() {
        let now = Date(timeIntervalSince1970: 1_785_100_000)
        let snapshot = QuotaViewWidgetSnapshotProjector().makeSnapshot(
            presentation: makePresentation(
                remainingPercent: 72,
                now: now
            ),
            isAvailable: false,
            localeIdentifier: "en",
            now: now
        )

        XCTAssertEqual(snapshot.availability, .unavailable)
        XCTAssertNil(snapshot.provider)
        XCTAssertNil(snapshot.updatedAt)
    }

    func testProjectorUsesPlaceholdersForMissingOptionalMetrics()
        throws {
        let now = Date(timeIntervalSince1970: 1_785_100_000)
        let snapshot = QuotaViewWidgetSnapshotProjector()
            .makeSnapshot(
                presentation: makePresentation(
                    remainingPercent: 72,
                    now: now,
                    creditBalance: nil,
                    lifetimeTokens: nil,
                    recentDailyTokens: nil
                ),
                isAvailable: true,
                localeIdentifier: "en",
                now: now
            )
        let provider = try XCTUnwrap(snapshot.provider)

        XCTAssertEqual(snapshot.availability, .available)
        XCTAssertEqual(
            provider.auxiliaryMetrics.map(\.formattedValue),
            ["—", "—", "—"]
        )
    }

    func testWriterStoresAtomicallyAndBoundsTimelineReloads() throws {
        let temporaryDirectory = FileManager.default.temporaryDirectory
            .appendingPathComponent(UUID().uuidString, isDirectory: true)
        try FileManager.default.createDirectory(
            at: temporaryDirectory,
            withIntermediateDirectories: true
        )
        defer {
            try? FileManager.default.removeItem(
                at: temporaryDirectory
            )
        }

        var reloadKinds: [String] = []
        let writer = QuotaViewWidgetSnapshotWriter(
            appGroupIdentifier: "group.test.quotaview",
            containerURLProvider: { _ in temporaryDirectory },
            timelineReloader: { reloadKinds.append($0) }
        )
        let now = Date(timeIntervalSince1970: 1_785_100_000)

        XCTAssertTrue(
            writer.publish(
                presentation: makePresentation(
                    remainingPercent: 72,
                    now: now
                ),
                isAvailable: true,
                localeIdentifier: "en",
                now: now
            )
        )
        XCTAssertEqual(
            reloadKinds,
            [QuotaViewWidgetConfiguration.kind]
        )

        let stored = try WidgetSnapshotFileStore(
            containerURL: temporaryDirectory
        ).read(now: now.addingTimeInterval(10))
        XCTAssertEqual(
            stored.provider?.primaryWindow?.remainingFraction,
            0.72
        )

        XCTAssertTrue(
            writer.publish(
                presentation: makePresentation(
                    remainingPercent: 72,
                    now: now
                ),
                isAvailable: true,
                localeIdentifier: "en",
                now: now.addingTimeInterval(60)
            )
        )
        XCTAssertEqual(reloadKinds.count, 1)

        XCTAssertTrue(
            writer.publish(
                presentation: makePresentation(
                    remainingPercent: 71,
                    now: now
                ),
                isAvailable: true,
                localeIdentifier: "en",
                now: now.addingTimeInterval(120)
            )
        )
        XCTAssertEqual(reloadKinds.count, 2)
    }

    private func makePresentation(
        remainingPercent: Int,
        now: Date,
        creditBalance: String? = "10",
        lifetimeTokens: Int64? = 9_000_000,
        recentDailyTokens: Int64? = 42_000
    ) -> CurrentCodexPresentation {
        CurrentCodexPresentation(
            availability: .ready,
            planType: "plus",
            usedPercent: 100 - remainingPercent,
            remainingPercent: remainingPercent,
            windowDurationMinutes: 10_080,
            resetsAt: now.addingTimeInterval(3_600),
            sparkQuota: nil,
            creditBalance: creditBalance,
            hasCredits: creditBalance != nil,
            unlimitedCredits: false,
            availableResetCredits: 2,
            lifetimeTokens: lifetimeTokens,
            recentDailyTokens: recentDailyTokens,
            recentDailyDate: "2026-07-29",
            tokenActivity: [],
            lastUpdatedAt: now
        )
    }
}
