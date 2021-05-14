# SwiftUIcon

**SwiftUIIcon** is a library that provides scripts and preview helpers for drawing and generating your iOS, iPad OS, and macOS app icons in SwiftUI using shape and path drawing primitives.

By defining your app's icon in code, SwiftUIcon can generate all image sizes you need, show you real-time previews of your icon changes and can even allow you to integrate your icon right into your app's view hierarchy.

<p align="center">
  <img src="https://user-images.githubusercontent.com/2525/118079196-9904ca80-b36c-11eb-8b76-b402b1acbeb0.gif">
</p>

## Getting Started

1. Add SwiftUIcon to your project using Swift Package Manager. Add the library to the app target.
2. Create an `Icon.swift` file in your project. It must have a `View` called `Icon`. Check out [the example](Example/IconHarness/Icon.swift) for a more complex icon, but this could help get you started:

```Swift
struct Icon: View {
    var body: some View {
        IconStack { canvas in
            Color.blue
        }
    }
}

#if DEBUG
struct Icon_Previews : PreviewProvider {
    static var previews: some View {
        IconPreviews(icon: Icon())
    }
}
#endif
```

3. Add a Run Script build phase before your Copy Resources phase calling the `build-script.sh` included in the package. You'll need to specify the path to your `Icon.swift` as the Input File (probably `$(PROJECT_DIR)/$(PRODUCT_NAME)/Icon.swift`) and the `Assets.xcassets` as the output file (probably `$(PROJECT_DIR)/$(PRODUCT_NAME)/Assets.xcassets`):

```bash
"${BUILD_ROOT%Build/*}SourcePackages/checkouts/SwiftUIcon/build-script.sh"
```
<p align="center">
  <img src="https://user-images.githubusercontent.com/2525/118078783-b71dfb00-b36b-11eb-8607-3024145ad097.jpg">
</p>

## Adding Your Icon

You can now edit the contents of the `IconStack` wrapper helper view inside of `Icon.swift` and add any shapes, paths or colors you want to build your icon. See [Apple's SwiftUI Drawing Tutorial](https://developer.apple.com/tutorials/swiftui/drawing-paths-and-shapes) for more info on drawing using SwiftUI.

The `IconStack` is essentially a `ZStack` with a `.center` alignment that provides a `CanvasProxy` value to relatively position elements based on an assumed 1024x1024 canvas size. This is helpful because the `Icon` is rendered individually at all the required icon sizes, so anything that has a fixed size will not scale properly. Any place where you would normally have a hard-coded number like `42`, you should instead use `canvas[42]`. You can also scale fonts and other elements manually using the `CanvasProxy.scale` property. As an example, `Text("Testing").font(Font.system(size: 200 * canvas.scale))` should get you a properly scaled `Text` element.

## Limitations

* It's a bit of a hack, but [Velos](https://velosmobile.com/) is currently using it in a project 👍
* Since the run script essentially concatenates all the Swift files and runs it as a macOS script, any elements you use in your Icon will be rendered using your Mac's version of SwiftUI. Because of this, there might be some differences or changes between macOS versions or between macOS and iOS that could manifest in your Icon. You should probably also stay away from putting UI elements like `Slider` in your Icon too 😉

## License
MIT

## Contact
* Email - zac@velosmobile.com
* Github - [@zac](https://github.com/zac) / [@velos](https://github.com/velos)
* Twitter - [@zacwhite](https://twitter.com/zacwhite) / [@velosmobile](https://twitter.com/velosmobile)
