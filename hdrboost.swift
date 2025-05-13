// Build with:
//   xcrun swiftc -O -framework AppKit -framework Metal -framework CoreVideo -o hdrboost hdrboost.swift

import AppKit
import Metal
import CoreVideo

// --------------------------------------------------
// 1. Metal layer
// --------------------------------------------------
let device = MTLCreateSystemDefaultDevice()!
let layer  = CAMetalLayer()
layer.device  = device
layer.pixelFormat = .rgba16Float                        // half‑float
layer.colorspace  = CGColorSpace(name: CGColorSpace.extendedLinearSRGB)!
layer.wantsExtendedDynamicRangeContent = true
layer.compositingFilter = "multiply"
layer.isOpaque = false          // critical – tells Quartz to composite behind us
layer.drawableSize = CGSize(width: 1, height: 1)        // 1 × 1 keeps it cheap

// --------------------------------------------------
// 2. Border‑less window that stays fully opaque (alpha 1)
// --------------------------------------------------
let screenFrame = NSScreen.main!.frame
let window = NSWindow(contentRect: screenFrame,
                      styleMask: .borderless,
                      backing: .buffered,
                      defer: false)
window.level = .statusBar                    // one notch below screen‑saver
window.isOpaque = false                      // allows translucency, but:
window.backgroundColor = .clear              // keep actual alpha = 1.0
window.ignoresMouseEvents = true
window.collectionBehavior = [.canJoinAllSpaces, .fullScreenAuxiliary]
window.contentView?.wantsLayer = true
window.contentView?.layer = layer
window.orderFrontRegardless()

// --------------------------------------------------
// 3.  Metal draw‑loop (clears 1 × 1 HDR pixel each vsync)
// --------------------------------------------------
let queue = device.makeCommandQueue()!

var dl: CVDisplayLink?
CVDisplayLinkCreateWithActiveCGDisplays(&dl)


CVDisplayLinkSetOutputHandler(dl!) { _, _, _, _, _ -> CVReturn in
    autoreleasepool {
        guard let drawable = layer.nextDrawable(),
              let cmd      = queue.makeCommandBuffer() else {
            return kCVReturnSuccess
        }

        let maxEDR = NSScreen.main!.maximumExtendedDynamicRangeColorComponentValue
        let target = maxEDR * 0.99          // 99 % of the panel’s head‑room (safer than 100 %)

        let rp = MTLRenderPassDescriptor()
        rp.colorAttachments[0].texture     = drawable.texture
        rp.colorAttachments[0].loadAction  = .clear
        rp.colorAttachments[0].storeAction = .store
        rp.colorAttachments[0].clearColor =
            MTLClearColor(red:  target,
                  green: target,
                  blue:  target,
                  alpha: 1.0)

        if let enc = cmd.makeRenderCommandEncoder(descriptor: rp) {
            enc.endEncoding()
        }
        cmd.present(drawable)
        cmd.commit()
        return kCVReturnSuccess          
    }
    return kCVReturnSuccess                 
}

CVDisplayLinkStart(dl!)

// --------------------------------------------------
// 4.  Hot‑key toggler   (Ctrl‑Opt‑Cmd‑B)
// --------------------------------------------------
var boostOn = true                     // starts ON so you see it at launch

func toggle() {
    if boostOn { window.orderOut(nil) }
    else        { window.orderFrontRegardless() }
    boostOn.toggle()
}
NSEvent.addGlobalMonitorForEvents(matching: .keyDown) { e in
    let mods = e.modifierFlags.intersection(.deviceIndependentFlagsMask)
    if mods == [.control, .option, .command], e.charactersIgnoringModifiers == "b" { 
       toggle()
    }
}

// Debug prints
let edr = NSScreen.main!.maximumPotentialExtendedDynamicRangeColorComponentValue
print("Max EDR scale =", edr)

// NEW:  allow `kill -USR1 <pid>` to toggle
signal(SIGUSR1) { _ in toggle() }

NSApplication.shared.run()
