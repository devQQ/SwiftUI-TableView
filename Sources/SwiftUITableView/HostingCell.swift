//
//  HostingCell.swift
//  
//
//  Created by Q Trang on 7/20/20.
//

import SwiftUI

public class HostingCell<Content: View>: UITableViewCell {
    private var hostingController: UIHostingController<Content>?
    public var removePadding = false
    
    public var content: Content? {
        get {
            return hostingController?.rootView
        }
        
        set {
            guard let content = newValue else { return }
            
            guard hostingController == nil else {
                hostingController?.rootView = content
                hostingController?.view.setNeedsLayout()
                hostingController?.view.setNeedsUpdateConstraints()
                hostingController?.view.setNeedsDisplay()
                return
            }
            
            hostingController = UIHostingController(rootView: content)
            let view = hostingController!.view!
            view.translatesAutoresizingMaskIntoConstraints = false
            
            contentView.addSubview(hostingController!.view)
            
            if removePadding {
                NSLayoutConstraint.activate([view.leftAnchor.constraint(equalTo: contentView.leftAnchor),
                                             view.rightAnchor.constraint(equalTo: contentView.rightAnchor),
                                             view.topAnchor.constraint(equalTo: contentView.topAnchor),
                                             view.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)])
            } else {
                NSLayoutConstraint.activate([view.leadingAnchor.constraint(equalTo: layoutMarginsGuide.leadingAnchor),
                                             view.trailingAnchor.constraint(equalTo: contentView.layoutMarginsGuide.trailingAnchor),
                                             view.topAnchor.constraint(equalTo: contentView.layoutMarginsGuide.topAnchor),
                                             view.bottomAnchor.constraint(equalTo: contentView.layoutMarginsGuide.bottomAnchor)])
            }
        }
    }
}

