//
//  Reuseable.swift
//  DYZB
//
//  Created by wangjiayu on 2019/4/17.
//  Copyright © 2019 wangjiayu. All rights reserved.
//

import UIKit

protocol Reuseable {
    //定义协议属性
    static var reuseIdentifier:String { get }
    static var nib:UINib? { get }
}

extension Reuseable {
    //默认实现
    static var reuseIdentifier:String { return "k\(self)ID" }
    static var nib:UINib? { return nil }
}

// MARK: - 扩展UITableView 注册cell,headerView,footerView 及 获取 cell,headerView,footerView 的方法
extension UITableView {
    //注册 cell
    func register<T:UITableViewCell>(_ cell:T.Type) where T:Reuseable {
        if let nib = T.nib { //通过nib方式注册
            register(nib, forCellReuseIdentifier: T.reuseIdentifier)
        }else {              //通过代码方式注册
            register(cell, forCellReuseIdentifier: T.reuseIdentifier)
        }
    }

    //从缓存池中取 cell
    func dequeueReusableCell<T:Reuseable>(indexPath:IndexPath) -> T{
       return dequeueReusableCell(withIdentifier: T.reuseIdentifier, for: indexPath) as! T
    }
    
    //注册组头/组尾
    func register<T:UITableViewHeaderFooterView>(viewClass:T.Type) where T:Reuseable {
        if let nib = T.nib { //通过nib方式注册
            register(nib, forHeaderFooterViewReuseIdentifier: T.reuseIdentifier)
        }else {              //通过代码方式注册
            register(viewClass, forHeaderFooterViewReuseIdentifier: T.reuseIdentifier)
        }
    }
    
    //从缓存池中取组头/组尾
    func dequeueReusableHeaderFooterView<T:Reuseable>() -> T {
        return dequeueReusableHeaderFooterView(withIdentifier: T.reuseIdentifier) as! T
    }
}

// MARK: - 扩展UICollectionView 注册cell,headerView,footerView 及 获取 cell,headerView,footerView 的方法
extension UICollectionView {
    
    //注册 cell
    func register<T:UICollectionViewCell>(_ cell:T.Type) where T:Reuseable{
        if let nib = T.nib { //通过nib方式注册
            register(nib, forCellWithReuseIdentifier: T.reuseIdentifier)
        } else {             //通过代码方式注册
            register(cell, forCellWithReuseIdentifier: T.reuseIdentifier)
        }
    }
    
    //从缓存池中取 cell
    func dequeueReusableCell<T:Reuseable>(indexPath:IndexPath) -> T {
        return dequeueReusableCell(withReuseIdentifier: T.reuseIdentifier, for: indexPath) as! T
    }
    
    
    //注册组头/组尾
    func register<T:UICollectionReusableView>(_ viewClass:T.Type , forSupplementaryViewOfKind: String) where T:Reuseable {
        if let nib = T.nib {   //通过nib方式注册
            register(nib, forSupplementaryViewOfKind: forSupplementaryViewOfKind, withReuseIdentifier: T.reuseIdentifier)
        }else {                //通过代码方式注册
            register(viewClass, forSupplementaryViewOfKind: forSupplementaryViewOfKind, withReuseIdentifier: T.reuseIdentifier)
        }
    }
    
    //从缓存池中取组头/组尾
    func dequeueReusableSupplementaryView<T:Reuseable>(ofKind:String,indexPath:IndexPath) -> T {
        return dequeueReusableSupplementaryView(ofKind: ofKind, withReuseIdentifier: T.reuseIdentifier, for: indexPath) as! T
    }
}
