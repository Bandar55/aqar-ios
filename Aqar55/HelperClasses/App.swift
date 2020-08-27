//
//  App.swift
//  Aqar55
//
//  Created by Dacall soft on 08/04/19.
//  Copyright © 2019 Callsoft. All rights reserved.
//

import Foundation
import UIKit


struct App {
    
    static func currencyConverterInComma(_ price: Int) -> String{
        
        let numberFormatter = NumberFormatter()
        numberFormatter.groupingSeparator = ","
        numberFormatter.groupingSize = 3
        numberFormatter.usesGroupingSeparator = true
        return numberFormatter.string(from: price as NSNumber)!
    }
    
    
    struct URLs {
        
        static let apiCallForGetTakeTourContent = "getStaticContent"
        static let apiCallForGetCategoryList = "categoryList"
        static let apiCallForGetSubCategoryList = "subcategoryList"
        static let apiCallForSignup = "userSignUp"
        static let apiCallForLogin = "userSignin"
        static let apiCallForCheckExistance = "checkUser"
        static let apiCallForGetContentByType = "getStaticContentByType"
        static let apiCallForSignout = "userSignout"
        static let apiCallForPostProperty = "postProperty"
        static let apiCallForInactiveList = "myPropertyInactiveList"
        static let apiCallForActiveList = "listDiffProperty"
        static let apiCallForPropertyListing = "propertylisting"
        static let apiCallForGetUserDetail = "getUserDetails"
        static let apiCallForGetPropertyDetails = "getPropertyDetails"
        static let apiCallForSortProperty = "sortProperty"
        static let apiCallForGetPropertyCategoryListing = "propertyCategoryListing"
        static let apiCallForPropertySearchByKeywords = "propertySearchByKeywords"
        static let apiCallForGetpropertyCategory = "getpropertyCategory"
        static let apiCallForDeleteProperty = "deleteProperty"
        static let apiCallForUpdatePropertyDays = "updatePropertyDays"
        static let apiCallForCountProperties = "totalPropertyOfUser"
        static let apiCallForCreateBusinessOrProfessional = "createBusinessOrProfessional"
        static let getBusinessOrProfessionalProfile = "getBusinessOrProfessionalProfile"
        static let apiCallForUpdateBusinessAndProfessional = "updateBusinessOrProfessionalProfile"
        static let apiCallForDeleteProfiles = "deleteBusinessProfessionalProfile"
        static let apiCallForFilterRentSale = "searchSaleOrRent"
        static let apiCallForGetAllIds = "allProperty"
        static let apiCallForFilterBusinessAndProfessional = "searchBusinessProfessional"
        
        static let apiCallForLikeDislike = "likedPost"
        static let apiCallForFetchLikeDislikeList = "listLikedPost"
        static let apiCallForFetchRecentList = "recentPost"
        
        static let apiCallForSearchByPlace = "searchByGooglePlaceApi"
        static let apiCallForCheckSignupExist = "checkSignupExist"
        static let apiCallForGetSetting = "appSetting"
        static let apiCallForChangeNotiStatus = "notificationSetting"
        static let apiCallForUpdateSetting = "updateSetting"
        
        static let apiCallForGetProfessionalPropertyListing = "professionalPropertyListing"
        
        static let apiCallForUpdateProfileNormalUser = "updateNormalProfile"
        static let apiCallForGetViewsCount = "viewedBusinessProfessional"
        static let apiCallForSortProfessionalPropertyListing = "sortTotalPostedProperty"
        
        static let apiCallForChatDetails = "chatDetails"
        static let apiCallForChatList = "chatUserList"
        
        static let apiCallForContactAdmin = "contactAdmin"
        static let apiCallForContactAdminDetail = "getAdminContactDetails"
        
        static let apiCallForBlockUser = "blockUser"
        static let apiCallForDeleteChat = "chatDelete"
        
        static let apiCallForEditProperty = "updateProperty"
        static let apiCallForGetNotificationList = "notificationList"
        
        static let apiCallForUpdateParticularProperty = "updateParticularProperty"
        static let apiCallForUpdateParticularProfile = "updateParticularProfile"
        static let apiCallForGetBussinessProfessionalDetail = "getBusinessOrProfessionalDetails"
    }
}
