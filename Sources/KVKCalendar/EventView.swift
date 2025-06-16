//
//  EventView.swift
//  KVKCalendar
//
//  Created by Sergei Kviatkovskii on 02/01/2019.
//

#if os(iOS)

import UIKit

open class EventView: EventViewGeneral {
    
    public var stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 3
        stackView.alignment = .top
        return stackView
    }()
        
    public var textView: UITextView = {
        let text = UITextView()
        text.backgroundColor = .clear
        text.isScrollEnabled = false
        text.isUserInteractionEnabled = false
        text.textContainer.lineBreakMode = .byTruncatingTail
        
        text.textContainerInset = .zero
        text.textContainer.lineFragmentPadding = 0
        
        return text
    }()
    
    public init(
        event: Event,
        style: Style,
        frame: CGRect,
        padding: UIEdgeInsets = .zero
    ) {
        super.init(style: style, event: event, frame: frame)
        
        stackView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(stackView)
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: topAnchor, constant: padding.top),
            stackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: padding.left),
            stackView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -padding.bottom),
            stackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -padding.right)
        ])
        
        textView.font = style.timeline.eventFont
        textView.text = event.title.timeline
        stackView.addArrangedSubview(textView)
        
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
        fatalError()
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
