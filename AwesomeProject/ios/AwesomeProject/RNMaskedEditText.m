//
//  RNMaskedEditText.m
//  AwesomeProject
//
//  Created by Yadhukrishnan Ekambaran on 2021-01-27.
//

#import <React/RCTViewManager.h>
 
@interface RCT_EXTERN_MODULE(RNMaskedEditTextManager, RCTViewManager)
RCT_EXPORT_VIEW_PROPERTY(pattern, NSString)
RCT_EXPORT_VIEW_PROPERTY(digits, NSString)
RCT_EXPORT_VIEW_PROPERTY(hint, NSString)
RCT_EXPORT_VIEW_PROPERTY(error, NSString)
RCT_EXPORT_VIEW_PROPERTY(textValue, NSString)
RCT_EXPORT_VIEW_PROPERTY(hiddenChar, NSString)
RCT_EXPORT_VIEW_PROPERTY(onFocusChange, RCTBubblingEventBlock)
RCT_EXPORT_VIEW_PROPERTY(onLimitReached, RCTBubblingEventBlock)
RCT_EXPORT_VIEW_PROPERTY(onTextChanged, RCTBubblingEventBlock)
@end

