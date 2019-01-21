//
//  UICollectionView+Placeholder.h
//  MasterBoard
//
//  Created by 赵俊明 on 2019/1/20.
//  Copyright © 2019 赵俊明. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

#if NS_BLOCKS_AVAILABLE
typedef  UIView * _Nonnull (^JRPlaceHolderBlock)(UICollectionView * _Nonnull sender);
typedef void (^JRPlaceHolderNormalBlock)(UICollectionView * _Nonnull sender);
#endif

#ifndef JR_STRONG
#if __has_feature(objc_arc)
#define JR_STRONG strong
#else
#define JR_STRONG retain
#endif
#endif

@interface UICollectionView (Placeholder)
NS_ASSUME_NONNULL_BEGIN
/**
 *  this is the tableview's place holder view, when the tableView's data is empty, call addSubView: with the jr_placeHolderView on tableView.
 */
@property (nonatomic, JR_STRONG) UIView * _Nullable jr_placeHolderView;

/**
 *  Configure the category method, Call the first block when data is empty. Call the second block when data is empty.
 *
 *  @param block  After call the block need to return a view as a subView on the tableView, in the block, you can call a coherent method as configuring the tableView, such as the prohibition scrolling and display an error message, and finally must return a view, as the tableView's placeHolder view.
 *  @param normal Block called when tableView's data is normal, the main purpose is to restore tableView style, such as previously set up scrolling is disabled, this time need to re-set.
 */
- (void)configurePlaceHolderBlock:(JRPlaceHolderBlock)block normalBlock:(_Nullable JRPlaceHolderNormalBlock)normal;

@end
NS_ASSUME_NONNULL_END
