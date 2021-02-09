//
//  RNMaskedEditText.m
//  TiffinFinds
//
//  Created by Noel Abraham on 2021-01-27.
//

//#import "RNMaskedEditText.h"
//
//@implementation RNMaskedEditText
//
//@end

#import <React/RCTViewManager.h>
 
@interface RCT_EXTERN_MODULE(RNMaskedEditTextManager, RCTViewManager)
RCT_EXPORT_VIEW_PROPERTY(pattern, String)
RCT_EXPORT_VIEW_PROPERTY(digits, String)
RCT_EXPORT_VIEW_PROPERTY(hint, String)
RCT_EXPORT_VIEW_PROPERTY(error, String)
RCT_EXPORT_VIEW_PROPERTY(afterTextChanged, RCTBubblingEventBlock)
RCT_EXPORT_VIEW_PROPERTY(onFocusChange, RCTBubblingEventBlock)
RCT_EXPORT_VIEW_PROPERTY(onLimitReached, RCTBubblingEventBlock)
@end
