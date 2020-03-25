//
//  MapManager.h
//  Driver
//
//  Created by caesar on 2020/1/17.
//  Copyright © 2020 caesar. All rights reserved.
//


#import <Foundation/Foundation.h>
NS_ASSUME_NONNULL_BEGIN

@interface MapManager : NSObject

/**
 *isLoadToUnload : 是否是从"装货地到卸货地"
 *loadLat : 装货地纬度
 *loadLng : 装货地经度
 *loadAddress : 装货地名称
 */
@property (nonatomic,copy) NSString *loadLat;
@property (nonatomic,copy) NSString *loadLng;
@property (nonatomic,copy) NSString *loadAddress;
@property (nonatomic, assign) BOOL isLoadToUnload;
/**
 *longitude :经度
 *latitude : 纬度
 *destinationName : 目的地
*/

- (void)mapArrayInitWithLatitude:(double)latitude andLongitude:(double)longitude andDestinationName:(NSString *)destinationName;

@end

NS_ASSUME_NONNULL_END
