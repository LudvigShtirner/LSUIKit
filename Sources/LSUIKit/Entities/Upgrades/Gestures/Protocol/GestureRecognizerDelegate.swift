@MainActor
final class GestureRecognizerDelegate<T: UIGestureRecognizer>: NSObject, UIGestureRecognizerDelegate {
    var shouldBeginAction: (@MainActor (T) -> Bool) = { _ in true }
    var shouldRecognizeSimultaneously: (@MainActor (T, UIGestureRecognizer) -> Bool) = { _, _ in false }
    var shouldRequireFailure: (@MainActor (T, UIGestureRecognizer) -> Bool) = { _, _ in false }
    var shouldBeRequiredToFail: (@MainActor (T, UIGestureRecognizer) -> Bool)?
    var shouldReceiveTouch: (@MainActor (T, UITouch) -> Bool)?
    var shouldReceivePress: (@MainActor (T, UIPress) -> Bool)?
    var shouldReceiveEvent: (@MainActor (T, UIEvent) -> Bool)?

    // MARK: - UIGestureRecognizerDelegate
    
    // called when a gesture recognizer attempts to transition out of UIGestureRecognizerStatePossible. returning NO causes it to transition to UIGestureRecognizerStateFailed
    func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        guard let gr = gestureRecognizer as? T else { return true }
        return shouldBeginAction(gr)
    }
    
    // called when the recognition of one of gestureRecognizer or otherGestureRecognizer would be blocked by the other
    // return YES to allow both to recognize simultaneously. the default implementation returns NO (by default no two gestures can be recognized simultaneously)
    //
    // note: returning YES is guaranteed to allow simultaneous recognition. returning NO is not guaranteed to prevent simultaneous recognition, as the other gesture's delegate may return YES
    func gestureRecognizer(
        _ gestureRecognizer: UIGestureRecognizer,
        shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer
    ) -> Bool {
        guard let gr = gestureRecognizer as? T else { return true }
        return shouldRecognizeSimultaneously(gr, otherGestureRecognizer)
    }
    
    // called once per attempt to recognize, so failure requirements can be determined lazily and may be set up between recognizers across view hierarchies
    // return YES to set up a dynamic failure requirement between gestureRecognizer and otherGestureRecognizer
    //
    // note: returning YES is guaranteed to set up the failure requirement. returning NO does not guarantee that there will not be a failure requirement as the other gesture's counterpart delegate or subclass methods may return YES
    func gestureRecognizer(
        _ gestureRecognizer: UIGestureRecognizer,
        shouldRequireFailureOf otherGestureRecognizer: UIGestureRecognizer
    ) -> Bool {
        guard let gr = gestureRecognizer as? T else { return true }
        return shouldRequireFailure(gr, otherGestureRecognizer)
    }
    
    func gestureRecognizer(
        _ gestureRecognizer: UIGestureRecognizer,
        shouldBeRequiredToFailBy otherGestureRecognizer: UIGestureRecognizer
    ) -> Bool {
        guard let gr = gestureRecognizer as? T else { return true }
        return shouldBeRequiredToFail?(gr, otherGestureRecognizer) ?? false
    }
    
    // called before touchesBegan:withEvent: is called on the gesture recognizer for a new touch. return NO to prevent the gesture recognizer from seeing this touch
    func gestureRecognizer(
        _ gestureRecognizer: UIGestureRecognizer,
        shouldReceive touch: UITouch
    ) -> Bool {
        guard let gr = gestureRecognizer as? T else { return true }
        return shouldReceiveTouch?(gr, touch) ?? true
    }
    
    // called before pressesBegan:withEvent: is called on the gesture recognizer for a new press. return NO to prevent the gesture recognizer from seeing this press
    func gestureRecognizer(
        _ gestureRecognizer: UIGestureRecognizer,
        shouldReceive press: UIPress
    ) -> Bool {
        guard let gr = gestureRecognizer as? T else { return true }
        return shouldReceivePress?(gr, press) ?? true
    }
    
    // called once before either -gestureRecognizer:shouldReceiveTouch: or -gestureRecognizer:shouldReceivePress:
    // return NO to prevent the gesture recognizer from seeing this event
    func gestureRecognizer(
        _ gestureRecognizer: UIGestureRecognizer,
        shouldReceive event: UIEvent
    ) -> Bool {
        guard let gr = gestureRecognizer as? T else { return true }
        return shouldReceiveEvent?(gr, event) ?? true
    }
}
