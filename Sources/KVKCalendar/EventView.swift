//
//  EventView.swift
//  KVKCalendar
//
//  Created by Sergei Kviatkovskii on 02/01/2019.
//

#if os(iOS)

import UIKit

open class EventView: EventViewGeneral {
    
    public init(
        event: Event,
        style: Style,
        frame: CGRect,
        padding: UIEdgeInsets = .zero
    ) {
        super.init(style: style, event: event, frame: frame)
        
        if #available(iOS 13.4, *) {
            addPointInteraction()
        }
    }
    
    open override func tapOnEvent(gesture: UITapGestureRecognizer) {
        guard !isSelected else {
            delegate?.deselectEvent(event)
            deselectEvent()
            return
        }
        
        delegate?.didSelectEvent(event, gesture: gesture)
        
        if style.event.isEnableVisualSelect {
            selectEvent()
        }
    }
    
    func selectEvent() {
        isSelected = true
    }
    
    func deselectEvent() {
        isSelected = false
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    open func copyView(event: Event, style: Style, frame: CGRect) -> EventView {
        assertionFailure("Must be implemented in subclass")
        return self
    }
}

@available(iOS 13.4, *)
extension EventView: UIPointerInteractionDelegate {
    func addPointInteraction() {
        let interaction = UIPointerInteraction(delegate: self)
        addInteraction(interaction)
    }
    
    public func pointerInteraction(_ interaction: UIPointerInteraction, styleFor region: UIPointerRegion) -> UIPointerStyle? {
        var pointerStyle: UIPointerStyle?
        
        if let interactionView = interaction.view {
            let targetedPreview = UITargetedPreview(view: interactionView)
            pointerStyle = UIPointerStyle(effect: .highlight(targetedPreview))
        }
        return pointerStyle
    }
}

#endif
