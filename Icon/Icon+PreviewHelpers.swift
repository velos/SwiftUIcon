//
//  Icon+PreviewHelpers.swift
//
//  Created by Zac White.
//  Copyright © 2020 Velos Mobile LLC / https://velosmobile.com / All rights reserved.
//

import SwiftUI

private enum Constants {
    static let radiusFactor: CGFloat = 4.3
    static let appNameFont: Font = .system(size: 18, weight: .medium)
    static let iconDimension: CGFloat = 100
    static let stackDimension: CGFloat = 1024
}

public struct IconStack<IconContent>: View where IconContent: View {

    public var body: some View {
        return GeometryReader { proxy in
            ZStack(alignment: .center) {
                self.content(CanvasProxy(proxy: proxy, expected: CGSize(width: Constants.stackDimension, height: Constants.stackDimension)))
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
