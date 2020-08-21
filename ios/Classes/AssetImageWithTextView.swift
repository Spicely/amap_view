//
//  AssetImageWithTextView.swift
//  amap_view
//
//  Created by Spicely on 2020/8/21.
//

import Foundation
import AMapNaviKit

public class AssetImageWithTextView: MAAnnotationView {
    override init(annotation: MAAnnotation!, reuseIdentifier: String!) {
        super.init(annotation: annotation, reuseIdentifier: reuseIdentifier)
        let img = self.image
        
        self.addSubview(img)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
