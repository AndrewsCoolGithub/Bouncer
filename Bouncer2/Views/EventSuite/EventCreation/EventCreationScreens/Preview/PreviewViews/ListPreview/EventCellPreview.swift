//
//  EventCellPreview.swift
//  Bouncer2
//
//  Created by Andrew Kestler on 5/11/22.
//

import Foundation
import UIKit

class EventCellPreview: UIViewController{
    
    weak var cell: EventCellView?
    
    init(event: EventDraft, image: UIImage){
        super.init(nibName: nil, bundle: nil)
        let cell = EventCellView(event: event, image: image)
       
        cell.layer.cornerRadius = .makeWidth(25)
        view.addSubview(cell)
        
        self.cell = cell
    }
    
    func updateView(){
      
        if let cell = cell {
            print("Update")
            cell.updateView()
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
