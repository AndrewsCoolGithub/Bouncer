//
//  SuiteHeaderCell.swift
//  Bouncer2
//
//  Created by Andrew Kestler on 11/12/22.
//

import UIKit
import Combine

 class SuiteHeaderButton: UIView {
     
    
     
     var section: EventSuiteDetail.Section!
     
     @Published var state: Bool = true
     var cancellable = Set<AnyCancellable>()
     
     private let label: UILabel = {
         let label = UILabel(frame: CGRect(x: .makeWidth(20), y: .wProportioned(5), width: .makeWidth(100), height: .wProportioned(30)))
         label.font = .poppinsMedium(size: .makeWidth(18))
         label.textAlignment = .left
         return label
     }()
     
     private let imageView: UIImageView = {
         let imageView = UIImageView(frame:  CGRect(x: .makeWidth(368), y: .wProportioned(5), width: .wProportioned(30), height: .wProportioned(30)))
         let imageConfig = UIImage.SymbolConfiguration(pointSize: .wProportioned(23))
         imageView.image = UIImage(systemName: "chevron.down", withConfiguration: imageConfig)
         imageView.contentMode = .center
         imageView.tintColor = .white
         return imageView
     }()
     
     func setup(_ section: EventSuiteDetail.Section, _ suiteDetailVM: EventSuiteDetailVM){
         self.section = section
         self.frame = CGRect(x: 0, y: 0, width: .makeWidth(414), height: .wProportioned(40))

         backgroundColor = .greyColor()
         addSubview(label)
         addSubview(imageView)
         
         
         suiteDetailVM.$detailType.receive(on: DispatchQueue.main).sink { [weak self] detailType in
             switch suiteDetailVM.detailType {
             case .open:
                 self?.label.text = EventSuiteDetailVM.OpenSection(section)!.rawValue
             case .exclusive:
                 self?.label.text = EventSuiteDetailVM.ExclusiveSection(section)!.rawValue
             }
         }.store(in: &cancellable)
         
         
         suiteDetailVM.$data.receive(on: DispatchQueue.main).sink { [weak self] data in
             let down = !data[section]!.isHidden
             let imageConfig = UIImage.SymbolConfiguration(pointSize: .wProportioned(23))
             if down{
                 self?.imageView.image = UIImage(systemName: "chevron.down", withConfiguration: imageConfig)
             }else{
                 self?.imageView.image = UIImage(systemName: "chevron.right", withConfiguration: imageConfig)
             }
         }.store(in: &cancellable)
     }
     
     deinit{
         cancellable.forEach({$0.cancel()})
     }
}
