import AppKit
import SwiftUI

enum MenuBarQuotaIconState: Equatable {
    case unavailable
    case available(remainingFraction: Double)

    init(remainingPercent: Int?) {
        guard let remainingPercent else {
            self = .unavailable
            return
        }
        self = .available(
            remainingFraction: MenuBarQuotaIconModel.clampedFraction(
                remainingPercent: remainingPercent
            )
        )
    }

    var remainingFraction: Double? {
        guard case .available(let remainingFraction) = self else {
            return nil
        }
        return remainingFraction
    }
}

enum MenuBarQuotaIconModel {
    static let canvasSize = NSSize(width: 20, height: 16)
    static let visibleGlyphSize = NSSize(width: 15, height: 16)
    static let animationDuration: TimeInterval = 0.18

    static func clampedFraction(remainingPercent: Int) -> Double {
        Double(min(max(remainingPercent, 0), 100)) / 100
    }

    static func interpolatedFraction(
        from start: Double,
        to end: Double,
        progress: Double
    ) -> Double {
        let clampedProgress = min(max(progress, 0), 1)
        return start + (end - start) * clampedProgress
    }

    static func easeOutProgress(_ progress: Double) -> Double {
        let clampedProgress = min(max(progress, 0), 1)
        return 1 - pow(1 - clampedProgress, 3)
    }

    static func waterlineY(remainingFraction: Double) -> CGFloat {
        let clampedFraction = min(max(remainingFraction, 0), 1)
        return innerFillBounds.maxY
            - CGFloat(clampedFraction) * innerFillBounds.height
    }

    fileprivate static let innerFillBounds = NSRect(
        x: 2.65,
        y: 3.28,
        width: 9.70,
        height: 10.00
    )
}

@MainActor
enum MenuBarQuotaIconRenderer {
    static func image(for state: MenuBarQuotaIconState) -> NSImage {
        let image = NSImage(
            size: MenuBarQuotaIconModel.canvasSize,
            flipped: true
        ) { _ in
            drawFill(for: state)
            drawUnavailableMarkIfNeeded(for: state)
            drawTideWindowOutline()
            return true
        }
        image.isTemplate = true
        return image
    }

    private static func drawFill(for state: MenuBarQuotaIconState) {
        guard let fraction = state.remainingFraction,
              fraction > 0
        else {
            return
        }

        let fillBounds = MenuBarQuotaIconModel.innerFillBounds
        let clipPath = NSBezierPath(ovalIn: fillBounds)

        NSGraphicsContext.saveGraphicsState()
        clipPath.addClip()
        NSColor.black.setFill()

        if fraction >= 1 {
            clipPath.fill()
        } else {
            let waterline = MenuBarQuotaIconModel.waterlineY(
                remainingFraction: fraction
            )
            let amplitude = CGFloat(sin(.pi * fraction)) * 0.48
            let width = fillBounds.width
            let left = fillBounds.minX - 1
            let right = fillBounds.maxX + 1

            let tide = NSBezierPath()
            tide.move(
                to: NSPoint(
                    x: left,
                    y: waterline + amplitude * 0.06
                )
            )
            tide.curve(
                to: NSPoint(
                    x: fillBounds.minX + width * 0.54,
                    y: waterline + amplitude * 0.20
                ),
                controlPoint1: NSPoint(
                    x: fillBounds.minX + width * 0.22,
                    y: waterline - amplitude * 0.85
                ),
                controlPoint2: NSPoint(
                    x: fillBounds.minX + width * 0.36,
                    y: waterline + amplitude * 0.85
                )
            )
            tide.curve(
                to: NSPoint(
                    x: right,
                    y: waterline + amplitude * 0.10
                ),
                controlPoint1: NSPoint(
                    x: fillBounds.minX + width * 0.70,
                    y: waterline - amplitude * 0.55
                ),
                controlPoint2: NSPoint(
                    x: fillBounds.minX + width * 0.86,
                    y: waterline - amplitude * 0.35
                )
            )
            tide.line(
                to: NSPoint(
                    x: right,
                    y: fillBounds.maxY + 1
                )
            )
            tide.line(
                to: NSPoint(
                    x: left,
                    y: fillBounds.maxY + 1
                )
            )
            tide.close()
            tide.fill()
        }

        NSGraphicsContext.restoreGraphicsState()
    }

    private static func drawUnavailableMarkIfNeeded(
        for state: MenuBarQuotaIconState
    ) {
        guard state == .unavailable else { return }

        let mark = NSBezierPath()
        mark.move(to: NSPoint(x: 5.35, y: 8.45))
        mark.line(to: NSPoint(x: 9.65, y: 8.45))
        mark.lineWidth = 1.35
        mark.lineCapStyle = .round
        NSColor.black.setStroke()
        mark.stroke()
    }

    private static func drawTideWindowOutline() {
        let outline = NSBezierPath()
        outline.move(to: NSPoint(x: 6.15, y: 2.10))
        outline.curve(
            to: NSPoint(x: 1.25, y: 8.18),
            controlPoint1: NSPoint(x: 3.18, y: 2.75),
            controlPoint2: NSPoint(x: 1.25, y: 5.18)
        )
        outline.curve(
            to: NSPoint(x: 7.50, y: 14.50),
            controlPoint1: NSPoint(x: 1.25, y: 11.72),
            controlPoint2: NSPoint(x: 4.03, y: 14.50)
        )
        outline.curve(
            to: NSPoint(x: 13.75, y: 8.18),
            controlPoint1: NSPoint(x: 10.97, y: 14.50),
            controlPoint2: NSPoint(x: 13.75, y: 11.72)
        )
        outline.curve(
            to: NSPoint(x: 8.85, y: 2.10),
            controlPoint1: NSPoint(x: 13.75, y: 5.18),
            controlPoint2: NSPoint(x: 11.82, y: 2.75)
        )
        outline.curve(
            to: NSPoint(x: 6.15, y: 2.10),
            controlPoint1: NSPoint(x: 8.62, y: 3.38),
            controlPoint2: NSPoint(x: 6.38, y: 3.38)
        )
        outline.close()
        outline.lineWidth = 1.50
        outline.lineCapStyle = .round
        outline.lineJoinStyle = .round
        NSColor.black.setStroke()
        outline.stroke()
    }
}

struct MenuBarBrandIcon: View {
    let state: MenuBarQuotaIconState

    var body: some View {
        Image(nsImage: MenuBarQuotaIconRenderer.image(for: state))
            .frame(
                width: MenuBarQuotaIconModel.canvasSize.width,
                height: MenuBarQuotaIconModel.canvasSize.height
            )
    }
}
