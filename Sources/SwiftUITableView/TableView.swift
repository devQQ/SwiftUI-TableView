//
//  TableView.swift
//
//
//  Created by Q Trang on 7/20/20.
//

import SwiftUI
import SwiftUIToolbox

public struct TableView<Contents: RandomAccessCollection, Content: View>: UIViewRepresentable where Contents.Element == ContentViewModel<Content> {
    public class Coordinator: NSObject, UITableViewDataSource, UITableViewDelegate {
        var contents: Contents
        let removePadding: Bool
        let didSelectIndex: ((_ index: Int) -> Void)?
        
        public init(contents: Contents, removePadding: Bool, didSelectIndex: ((_ index: Int) -> Void)?) {
            self.contents = contents
            self.removePadding = removePadding
            self.didSelectIndex = didSelectIndex
        }
        
        public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return contents.count
        }
        
        public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            let cell = tableView.dequeueReusableCell(withIdentifier: "\(HostingCell<Content>.self)", for: indexPath) as! HostingCell<Content>
            let index = contents.index(contents.startIndex, offsetBy: indexPath.row)
            cell.removePadding = removePadding
            cell.content = contents[index].content
            
            return cell
        }
        
        public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
            self.didSelectIndex?(indexPath.row)
        }
        
        public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
            let index = contents.index(contents.startIndex, offsetBy: indexPath.row)
            return contents[index].height != nil ? contents[index].height! : UITableView.automaticDimension
        }
    }
    
    public let contents: Contents
    public let removePadding: Bool
    public let separatorStyle: UITableViewCell.SeparatorStyle
    public let dynamicHeight: Bool
    public let didSelectIndex: ((_ index: Int) -> Void)?
    
    public init(contents: Contents, removePadding: Bool = false, separatorStyle: UITableViewCell.SeparatorStyle = .singleLine, dynamicHeight: Bool = true, didSelectIndex: ((_ index: Int) -> Void)? = nil) {
        self.contents = contents
        self.removePadding = removePadding
        self.separatorStyle = separatorStyle
        self.dynamicHeight = dynamicHeight
        self.didSelectIndex = didSelectIndex
    }
    
    public func makeUIView(context: Context) -> UITableView {
        let tableView = UITableView(frame: .zero)
        tableView.backgroundColor = .clear
        tableView.separatorStyle = separatorStyle
        tableView.register(HostingCell<Content>.self, forCellReuseIdentifier: "\(HostingCell<Content>.self)")
        
        if dynamicHeight {
            tableView.estimatedRowHeight = 44.0
            tableView.rowHeight = UITableView.automaticDimension
        }
        
        tableView.dataSource = context.coordinator
        tableView.delegate = context.coordinator
        
        //Remove extra separator lines at the bottom
        tableView.tableFooterView = UIView()
        //Extend separator lines to full width
        tableView.separatorInset = .zero
        
        return tableView
    }
    
    public func updateUIView(_ uiView: UITableView, context: Context) {
        context.coordinator.contents = contents
        uiView.reloadData()

        uiView.setNeedsLayout()
        uiView.layoutIfNeeded()
        
        uiView.setNeedsUpdateConstraints()
        uiView.updateConstraintsIfNeeded()
        
        UIView.performWithoutAnimation {
            uiView.beginUpdates()
            uiView.endUpdates()
        }
    }
    
    public func makeCoordinator() -> Coordinator {
        Coordinator(contents: contents, removePadding: removePadding, didSelectIndex: didSelectIndex)
    }
}

