//
//  JCSOrderController.m
//  Type Keto
//
//  Created by Lambda_School_Loaner_95 on 4/25/19.
//  Copyright © 2019 Type Keto LLC. All rights reserved.
//

#import "JCSOrderController.h"


//static NSString *baseURLString = @"https://api.moltin.com/v2/orders";

@interface JCSOrderController()
@property (nonatomic, copy) NSMutableArray *internalOrders;

@property (nonatomic, copy) NSMutableString *orderDateInternal;
@property (nonatomic, copy) NSMutableString *orderIDInternal;
@property (nonatomic, copy) NSMutableString *orderShippingStatusInternal;
@property (nonatomic, copy) NSMutableString *orderPaymentStatusInternal;
@property (nonatomic, copy) NSMutableString *orderPaymentTotalInternal;
@property (nonatomic, copy) NSMutableString *orderShippingAddressInternal;
@property (nonatomic, copy) NSMutableArray *orderItemsInternal;

@end

@implementation JCSOrderController

- (instancetype)init
{
    self = [super init];
    if (self) {
        _internalOrders = [[NSMutableArray alloc] init];
        _orderDateInternal = [[NSMutableString alloc] init];
        _orderIDInternal = [[NSMutableString alloc] init];
        _orderShippingStatusInternal = [[NSMutableString alloc] init];
        _orderPaymentStatusInternal = [[NSMutableString alloc] init];
        _orderPaymentTotalInternal = [[NSMutableString alloc] init];
        _orderShippingAddressInternal = [[NSMutableString alloc] init];
        _orderItemsInternal = [[NSMutableArray alloc] init];
    }
    return self;
}
- (void)fetchOrderByRequest:(NSURLRequest *)request completion:(void (^)(NSError * _Nullable))completion {
    
   /* NSMutableString *token;
    
    
    NSString *orderIDString = [NSString stringWithFormat:@":%@", orderID];
    NSURL *baseURL = [NSURL URLWithString:baseURLString];
    NSURL *orderURL = [baseURL URLByAppendingPathComponent:orderIDString];
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:orderURL];
    
    [request addValue:@"application/json" forHTTPHeaderField:@"Accept"];
    [request addValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    */
    
    NSURLSessionTask *task = [[NSURLSession sharedSession] dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        
        if (error) {
            NSLog(@"Error fetching orders: %@", error);
            completion(error);
            return;
        }
        
        NSError *jsonError;
        NSDictionary *dictionary = [NSJSONSerialization JSONObjectWithData:data options:0 error:&jsonError];
        if (!dictionary) {
            NSLog(@"Error decoding dict: %@", error);
            completion(error);
            return;
        }
        
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"];
        
        NSMutableArray *orders = [[NSMutableArray alloc] init];
        
        NSDictionary *dataDictionary = dictionary[@"data"];
        NSMutableString *orderShippingStatus = dataDictionary[@"shipping"];
        NSMutableString *orderPaymentStatus = dataDictionary[@"payment"];
        NSMutableString *orderID = dataDictionary[@"id"];
        
        
        NSDictionary *metaDict = dataDictionary[@"meta"];
        NSDictionary *shippingAddressDict = dataDictionary[@"shipping_address"];
        
        NSDictionary *timestampDict = metaDict[@"timestamps"];
        NSDate *orderTimestamp = timestampDict[@"created_at"];
        NSMutableString *orderDate = [dateFormatter stringFromDate:orderTimestamp];
        
        NSDictionary *priceDict = metaDict[@"display_price"];
        NSDictionary *withTaxDict = priceDict[@"with_tax"];
        NSMutableString *paymentTotal = withTaxDict[@"formatted"];
        
        NSString *addressFirstLine = shippingAddressDict[@"line_1"];
        NSString *addressSecondLine = shippingAddressDict[@"line_2"];
        NSString *cityLine = shippingAddressDict[@"city"];
        NSString *postcodeLine = shippingAddressDict[@"postcode"];
        
        NSMutableString *shippingAddress = [NSMutableString stringWithFormat:@"%@ \n%@ \n%@, %@", addressFirstLine, addressSecondLine, cityLine, postcodeLine];
        
        self.orderDateInternal = orderDate;
        self.orderIDInternal = orderID;
        self.orderShippingStatusInternal = orderShippingStatus;
        self.orderPaymentStatusInternal = orderPaymentStatus;
        self.orderPaymentTotalInternal = paymentTotal;
        self.orderShippingAddressInternal = shippingAddress;
        completion(nil);
    }];
    [task resume];
    
}

- (NSString *)orderDate {
    return self.orderDateInternal;
}
- (NSString *)orderID {
    return self.orderIDInternal;
}
- (NSString *)orderShippingStatus {
    return self.orderShippingStatusInternal;
}
- (NSString *)orderPaymentStatus {
    return self.orderPaymentStatusInternal;
}
- (NSString *)orderPaymentTotal {
    return self.orderPaymentTotalInternal;
}
- (NSString *)orderShippingAddress {
    return self.orderShippingAddressInternal;
}






@end
