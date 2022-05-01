//
//  Icon+PreviewHelpers.swift
//
//  Created by Zac White.
//  Copyright © 2020 Velos Mobile LLC / https://velosmobile.com / All rights reserved.
//

import SwiftUI

@available(iOS 13.0, OSX 10.15, tvOS 13.0, watchOS 6.0, *)
public struct IconPreviews<Icon: View>: View {
    var icon: () -> Icon
    
    public init(icon: @autoclosure @escaping () -> Icon) {
        self.icon = icon
    }
    
    public var body: some View {
        Group {
            icon()
                .previewIcon()
                .previewLayout(.sizeThatFits)

            icon()
                .previewHomescreen()
                .background(
                    LinearGradient(
                        gradient: Gradient(colors: [.purple, .orange]),
                        startPoint: .bottom,
                        endPoint: .top
                    )
                )
                .previewLayout(.fixed(width: 500, height: 500))
        }
    }
}

@available(iOS 13.0, OSX 10.15, tvOS 13.0, watchOS 6.0, *)
private enum Constants {
    static let radiusFactor: CGFloat = 4.3
    static let appNameFont: Font = .system(size: 18, weight: .medium)
    static let iconDimension: CGFloat = 100
    static let stackDimension: CGFloat = 1024
}

@available(iOS 13.0, OSX 10.15, tvOS 13.0, watchOS 6.0, *)
public struct IconStack<IconContent>: View where IconContent: View {

    public var body: some View {
        return GeometryReader { proxy in
            ZStack(alignment: .center) {
                let canvas = CanvasProxy(proxy: proxy, expected: CGSize(width: Constants.stackDimension, height: Constants.stackDimension))
                self.content(canvas).environment(\.canvas, canvas)
            }
            .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity, alignment: .top)
        }
        .edgesIgnoringSafeArea(.all)
        .aspectRatio(1, contentMode: .fit)
        .clipped()
    }

    public var content: (CanvasProxy) -> IconContent

    public init(@ViewBuilder content: @escaping (CanvasProxy) -> IconContent) {
        self.content = content
    }
}

@available(iOS 13.0, OSX 10.15, tvOS 13.0, watchOS 6.0, *)
public struct CanvasProxy {
    private let proxy: GeometryProxy
    public let expected: CGSize

    init(proxy: GeometryProxy, expected: CGSize) {
        self.proxy = proxy
        self.expected = expected
    }

    /// The size of the container view.
    public var actual: CGSize {
        return proxy.size
    }

    public var scale: CGFloat {
        return self.actual.width / self.expected.width
    }

    public subscript(_ points: CGFloat) -> CGFloat {
        return points * scale
    }
}

@available(iOS 13.0, OSX 10.15, tvOS 13.0, watchOS 6.0, *)
extension View {

    /// Frames the icon and adds a continuous rounded rectangle to approximate the real icon shape.
    /// - Parameter dimension: <#dimension description#>
    /// - Returns: <#description#>
    public func frameIcon(dimension: CGFloat = 200) -> some View {
        self
            .frame(width: dimension, height: dimension)
            .clipShape(RoundedRectangle(cornerRadius: dimension / Constants.radiusFactor, style: .continuous))
    }
}

@available(iOS 13.0, OSX 10.15, tvOS 13.0, watchOS 6.0, *)
extension View {

    /// Previews the icon using `.previewLayout()` with a `.fixed(width:height:)` layout, clipping to an approximation of the Apple icon shape
    /// - Parameter dimension: The width and height to use when laying out the icon. Defaults to 500
    /// - Returns: A View suitible for previewing in SwiftUI previews
    public func previewIcon(dimension: CGFloat = 500) -> some View {
        self
            .previewLayout(.fixed(width: dimension, height: dimension))
            .clipShape(RoundedRectangle(cornerRadius: dimension / Constants.radiusFactor, style: .continuous))
    }

    /// A View representing the app's name
    /// - Parameter name: The name to use
    /// - Returns: A View with text for the passed in name
    private func app(name: String) -> some View {
        Text(name)
            .foregroundColor(.white)
            .font(Constants.appNameFont)
            .shadow(color: Color.black.opacity(0.2), radius: 4, x: 0, y: 0)
    }

    /// A fake icon for use in the `previewHomescreenIcon(dimension:)` function
    /// - Parameters:
    ///   - color: The color to use as the background
    ///   - dimension: The width and height to use when laying out the icon. Defaults to 100
    ///   - name: The name of the fake app
    /// - Returns: A View which fakes the icon of another app
    private func fakeIcon(_ color: Color, dimension: CGFloat = 100, name: String) -> some View {
        VStack(spacing: 10) {
            RoundedRectangle(cornerRadius: Constants.iconDimension / Constants.radiusFactor, style: .continuous)
                .fill(color)
                .frame(width: dimension, height: dimension)
                .padding([.leading, .trailing], 20)
            app(name: name)
        }
    }

    /// Previews the icon as a 'homescreen' icon with the icon and app name with approximately correct padding
    /// - Parameter dimension: The dimension to make the icon in the preview
    /// - Returns: A View suitable for preview of just your app's icon on the homescreen
    public func previewHomescreenIcon(dimension: CGFloat = 100) -> some View {
        VStack(spacing: 10) {
            self.previewIcon(dimension: Constants.iconDimension)
                .frame(width: Constants.iconDimension, height: Constants.iconDimension)
                .padding([.leading, .trailing], 20)
            app(name: (Bundle.main.infoDictionary?["CFBundleName"] as? String) ?? "Your App")
        }
    }

    /// Previews an entire Homescreen with 9 apps where your app's icon is the middle icon
    /// - Returns: A View suitable for preview of your app plus several other fake app icons
    public func previewHomescreen() -> some View {
        let spacingX: CGFloat = 10
        let spacingY: CGFloat = 30
        return VStack(spacing: spacingY) {
            HStack(spacing: spacingX) {
                fakeIcon(Color.white, dimension: Constants.iconDimension, name: "Other App")
                fakeIcon(Color.purple, dimension: Constants.iconDimension, name: "Other App")
                fakeIcon(Color.red, dimension: Constants.iconDimension, name: "Other App")
            }
            HStack(spacing: spacingX) {
                fakeIcon(Color.gray, dimension: Constants.iconDimension, name: "Other App")
                previewHomescreenIcon(dimension: Constants.iconDimension)
                fakeIcon(Color.green, dimension: Constants.iconDimension, name: "Other App")
            }
            HStack(spacing: spacingX) {
                fakeIcon(Color.orange, dimension: Constants.iconDimension, name: "Other App")
                fakeIcon(Color.pink, dimension: Constants.iconDimension, name: "Other App")
                fakeIcon(Color.black, dimension: Constants.iconDimension, name: "Other App")
            }
        }
        .padding(50)
    }
}

// MARK: - Canvas environment

private struct CanvasKey: EnvironmentKey {
    static var defaultValue: CanvasProtocol = EmptyCanvasProxy()
}

@available(iOS 13.0, OSX 10.15, tvOS 13.0, watchOS 6.0, *)
extension EnvironmentValues {

    /// Returns canvas related to the current icon.
    ///
    /// If accessed from a view that is outside of ``IconStack`` hierarchy, will give canvas that returns original values.
    @available(iOS 13.0, OSX 10.15, tvOS 13.0, watchOS 6.0, *)
    public internal(set) var canvas: CanvasProtocol {
        get { self[CanvasKey.self] }
        set { self[CanvasKey.self] = newValue }
    }
}

// MARK: Canvas protocol

public protocol CanvasProtocol {
    var scale: CGFloat { get }
    subscript(_ points: CGFloat) -> CGFloat { get }
}

@available(iOS 13.0, OSX 10.15, tvOS 13.0, watchOS 6.0, *)
extension CanvasProxy: CanvasProtocol {}

private struct EmptyCanvasProxy: CanvasProtocol {
    var scale: CGFloat { 1 }

    subscript(points: CGFloat) -> CGFloat {
        points
    }
}
