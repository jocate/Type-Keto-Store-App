//
//  JCSOrderController.h
//  Type Keto
//
//  Created by Lambda_School_Loaner_95 on 4/25/19.
//  Copyright © 2019 Type Keto LLC. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_SWIFT_NAME(OrderController)
NS_ASSUME_NONNULL_BEGIN

@interface JCSOrderController : NSObject


/*
 var orderDate: String?
 var orderID: String?
 var orderShippingStatus: String?
 var orderPaymentStatus: String?
 var orderPaymentTotal: String?
 var orderShippingAddress: String?
 var orderItems: String?

 */



- (instancetype)init;

@property (nonatomic, readonly) NSArray *orders;
@property (nonatomic, readonly) NSString *orderDate;
@property (nonatomic, readonly) NSString *orderID;
@property (nonatomic, readonly) NSString *orderShippingStatus;
@property (nonatomic, readonly) NSString *orderPaymentStatus;
@property (nonatomic, readonly) NSString *orderPaymentTotal;
@property (nonatomic, readonly) NSString *orderShippingAddress;
@property (nonatomic, readonly) NSArray *orderItems;

-(void)fetchOrderByRequest:(NSURLRequest *)request completion:(void (^)(NSError *_Nullable))completion;

@end

NS_ASSUME_NONNULL_END
