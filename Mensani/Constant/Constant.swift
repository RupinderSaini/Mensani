//
//  Constant.swift
//  Mensani
//
//  Created by apple on 08/05/23.
//

import Foundation
import UIKit
import SwiftyJSON
func getDataFrom(JSON json: JSON) -> Data? {
    do {
        return try json.rawData(options: .prettyPrinted)
    } catch _ {
        return nil
    }
}
var mainStoryboard: UIStoryboard{
    return UIStoryboard(name:"Main",bundle: Bundle.main)
}
struct Constant {
    
    static let ACCEPT = "Accept"
    static let APP_JSON = "application/json"
    static let AUTHORIZATION = "Authorization"
    
    static let API_TOKEN = "api_token"
    static let IS_LOGGEDIN = "IS_LOGGEDIN"
    static let USER_UNIQUE_ID = "USER_UNIQUE_ID"
    static let SUCCESS = "SUCCESS"
    static let FAILED = "FAILED"
    static let SPLASH_IMAGE = "SPLASH_IMAGE"
    static let START_PRIMARY_GOAL = "START_PRIMARY_GOAL"
    static let START_SECONDARY_GOAL = "START_SECONDARY_GOAL"
    static let DREAM_GOAL = "DREAM_GOAL"
    static let TEAM = "TEAM"
    static let SEASON_PRIMARY_GOAL = "SEASON_PRIMARY_GOAL"
    static let SEASON_SECONDARY_GOAL = "SEASON_SECONDARY_GOAL"
    
    //User profile
    static let NAME = "USER_NAME"
    static let EMAIL = "USER_EMAIL"
    static let IMAGE = "USER_IMAGE"
    static let SPORTS = "SPORTS"
    static let SPORTS_ID = "SPORTSid"
    static let TEAMCOLOR = "teamcolor"
    static let TEAM_TYPE = "teamTYPE"
    static let TIME_JOINED = "TIME_JOINED"
    static let SUBSCRIPTION_ID = "SUBSCRIPTION_ID"
    
    
    //ADMIN POINTS
    static let START_SELF_POINT = "START_SELF_POINT"
    static let START_GOAL_POINT = "START_GOAL_POINT"
    static let VISUALIZATION_POINTS = "VISUALIZATION_POINTS"
    static let PERFORMANCE_POINTS = "PERFORMANCE_POINTS"
    
    //WELLBEING
    static let WELLBEING_MOOD = "Wellbeing"
    static let WELLBEING_THOUGHTS = "WELLBEING_THOUGHTS"
    
    //SEASON_SELFTALK
    static let CHALLENGE = "Challane"
    static let ROLE_MODEL = "ROlemode"
    static let ROLE_IMAGE = "ROleimage"
    static let RECORDING = "recording"
    
    //ADD PERMISSION OR NOT
    static let PERFORMACE_ADD = "performanceadd"
    static let IMPROVEMENT_ADD = "improadd"
    static let VISUAL_ADD = "visulaadd"
    static let SELF_ADD = "selfadd"
    
    //IMPROVEMENT
    static let IMPROVEMENT = "improvement"
    
    static let VIEW_SELECTED = "view_selected"
    
//    static let baseURL = "https://phpstack-1020308-3605009.cloudwaysapps.com/" Mentalitraining live
    static let baseURL = "https://phpstack-102119-3874918.cloudwaysapps.com/"
    static let loginAPI = "api/Athlete/login"
    static let logoutAPI = "api/Athlete/logout"
    static let deleteAPI = "api/Athlete/delete_athlete_account"
    static let signUpAPI = "api/Athlete/signup"
    static let teamAPI = "api/Athlete/team_list"
    static let otpSignUpAPI = "api/Athlete/send_otp"
   
    static let forgotAPI = "api/Athlete/forget_password"
    static let verifyOTPAPI = "api/Athlete/verify_otp"
    static let resetPasswordAPI = "api/Athlete/reset_password"
    static let notificationAPI = "api/Athlete/view_notification"
    
    static let chnagePasswordAPI = "api/Athlete/change_password"
    static let addSeasonGoalsAPI = "api/Athlete/season_goals"
    static let addDreamGoalsAPI = "api/Athlete/dreams_goals"
    static let addStartGoalsAPI = "api/Athlete/start_goals"

    static let addPerformanceAPI = "api/Athlete/post_performance"
    static let addPerformanceNewAPI = "api/Athlete/post_performance_new"
    static let getPerformanceAPI = "api/Athlete/view_performances"
    static let deletePerformanceAPI = "api/Athlete/delete_performance"
    
    static let addImproveAPI = "api/Athlete/post_improvement"
    static let getImproveAPI = "api/Athlete/view_improvements"
    static let deleteImproveAPI = "api/Athlete/delete_improvement"
   
    static let homeAPI = "api/Athlete/home_screen"
    
    static let sportsAPI = "api/Athlete/view_sports"
    static let profileUpdateApi = "api/Athlete/edit_profile"
   
    static let recordSelfAPI = "api/Athlete/start_selftalk"
    static let recordVisualAPI = "api/Athlete/visualization"
    
    static let viewSelfAPI = "api/Athlete/view_start_selftalk"
    static let viewVisualAPI = "api/Athlete/view_visualization"
    
    static let wellbeingAPI = "api/Athlete/wellbeing"
    static let seasonSelfTalkAPI = "api/Athlete/self_talks"
   
    static let subscriptionAPI = "api/Athlete/subscription_plan"
    static let cancelSubscriptionAPI = "api/Athlete/athelete_subscription_cancel"
    static let supportAPI = "api/Athlete/view_category"
   
    static let deleteAudioAPI = "api/Athlete/delete_start_selftalk"
    static let deleteVisualAPI = "api/Athlete/delete_visualization"
    static let therapistAPI = "api/Athlete/view_therapist_support"
    static let therapistVideoAPI = "api/Athlete/therapist_support_video"
    static let therapistProfileAPI = "api/Athlete/therapist_profile"
   
    static let therapistReviewAPI = "api/Athlete/therapist_for_review"
    static let appointmentSlotAPI = "api/Athlete/appointment_slot_new_latest"
  static let addPointsViewAPI = "api/Athlete/view_points_added"
    
    static let appointListAPI = "api/Athlete/booking"
    static let appointPastListAPI = "api/Athlete/past_bookings"
   
    static let notiDeleteAPI = "api/Athlete/delete_notification"
    
    static let notificationReceived = "notificationReceived"
    static let pointsAddAPI = "api/Athlete/view_points_added"
    
}
