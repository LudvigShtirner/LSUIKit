// Apple
import UIKit
import SpriteKit

public final class ShapeMorphingView: LSView {
    // MARK: - UI
    private let skView = SKView()
    fileprivate let scene = SKScene()
    
    // MARK: - Data
    private var currentImage: UIImage?
    private var currentIcon: SKSpriteNode?
    private let filter = MetaBallEffectFilter()
    
    // MARK: - Overrides
    public override func layoutSubviews() {
        super.layoutSubviews()
        skView.frame = bounds
        if let image = currentImage {
            setImage(image, duration: 0.3)
        }
    }
    
    // MARK: - BaseView
    public override func setupUI() {
        scene.scaleMode = .resizeFill
        scene.physicsWorld.gravity = .zero
        scene.shouldEnableEffects = true
        scene.filter = filter
        
        addSubview(skView)
        skView.presentScene(scene)
        skView.allowsTransparency = true
    }
    
    public override func setupColors() {
        scene.backgroundColor = .clear
        skView.backgroundColor = UIColor(red: .random(in: (0...255)),
                                         green: .random(in: (0...255)),
                                         blue: .random(in: (0...255)),
                                         alpha: 1.0)
    }
    
    // MARK: - Interface methods
    public func setImage(_ image: UIImage,
                         duration: TimeInterval = .zero) {
        currentImage = image
        animateIconChange(image: image,
                          duration: duration)
    }
    
    // MARK: - Private methods
    private func animateIconChange(image: UIImage,
                                   duration: CGFloat) {
        let newIconShape = makeNode(from: image)
        newIconShape.position = CGPoint(x: bounds.midX,
                                        y: bounds.midY)
        newIconShape.alpha = 0
        scene.addChild(newIconShape)
        
        let oldIconShape = currentIcon
        currentIcon = nil
        currentIcon = newIconShape
        
        if duration == 0 {
            newIconShape.alpha = 1
            oldIconShape?.removeFromParent()
            return
        }
        let fadeDuration = duration * 0.25
        animateBlur(to: 10, duration: fadeDuration)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + fadeDuration * 0.6) { [weak self] in
            let swapDuration = duration * 0.5
            newIconShape.run(SKAction.fadeAlpha(to: 1, duration: swapDuration))
            oldIconShape?.run(SKAction.fadeAlpha(to: 0, duration: swapDuration))
            
            DispatchQueue.main.asyncAfter(deadline: .now() + swapDuration * 0.6) { [weak self] in
                self?.animateBlur(to: 0, duration: fadeDuration)
                DispatchQueue.main.asyncAfter(deadline: .now() + fadeDuration) {
                    oldIconShape?.removeFromParent()
                }
            }
        }
    }
    
    private func animateBlur(to targetBlur: Float,
                             duration: CGFloat) {
        let from = filter.blur
        let blurFade = SKAction.customAction(withDuration: duration) { [weak self] node, elapsed in
            let percent = elapsed / duration
            let difference = targetBlur - from
            let currentBlur = from + (difference * Float(percent))
            self?.filter.blur = currentBlur
            self?.scene.shouldEnableEffects = true
        }
        scene.run(blurFade)
    }
    
    private func makeNode(from image: UIImage) -> SKSpriteNode {
        let iconSize = bounds.size
        let texture = SKTexture(image: image.resized(within: iconSize))
        return SKSpriteNode(texture: texture,
                            size: iconSize)
    }
}

// MARK: - SwiftUI Preview
import SwiftUI

struct ShapeMorphingViewContainerPreviews: PreviewProvider {
    @MainActor
    fileprivate class ShapeMorphingViewExample: LSView {
        let changeButton = LSButton(type: .system)
        let morphingView = ShapeMorphingView()
        
        override func setupUI() {
            
            addSubview(morphingView)
            morphingView.backgroundColor = .gray
            
            addSubview(changeButton)
            changeButton.setImage(UIImage(systemName: "play.fill")!,
                                  for: .normal)
            changeButton.tintColor = .red
            changeButton.onEvent(.touchUpInside) { [weak self] in
                let buttonNames: [String] = [
                    "circle.fill",
                    "heart.fill",
                    "star.fill",
                    "bell.fill",
                    "bookmark.fill",
                    "tag.fill",
                    "bolt.fill",
                    "play.fill",
                    "pause.fill",
                    "squareshape.fill",
                    "key.fill",
                    "hexagon.fill",
                    "gearshape.fill",
                    "car.fill"
                ]
                let name = buttonNames.shuffled().first!
                let image = UIImage(systemName: name)!
                self?.morphingView.setImage(image, duration: 0.8)
                self?.morphingView.scene.backgroundColor = UIColor(red: .random(in: (0...255)),
                                                                   green: .random(in: (0...255)),
                                                                   blue: .random(in: (0...255)),
                                                                   alpha: 1.0)
                self?.changeButton.setImage(image, for: .normal)
            }
        }
        
        override func setupConstraints() {
            morphingView.snp.makeConstraints { make in
                make.directionalEdges.equalToSuperview()
            }
            changeButton.snp.makeConstraints { make in
                make.bottom.equalToSuperview().inset(16)
                make.height.equalTo(88)
                make.leading.trailing.equalToSuperview().inset(8)
            }
        }
    }
    
    static var previews: some View {
        SwiftUIPreview {
            ShapeMorphingViewExample()
        }
            .previewLayout(.device)
            .edgesIgnoringSafeArea(.vertical)
    }
}

