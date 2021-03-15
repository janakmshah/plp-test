import XCTest
@testable import RetailApp

class BadgeIdentifierTests: XCTestCase {
    
    func test_badgeToDisplay_returnsCorrectBadgeName() {
        let userOffers = UserOffers(availableBadges: [Badge(name: "badge_name", types: ["BADGE_TYPE"])], offers: [Offer(id: "999", title: "", type: "BADGE_TYPE")])
        let offerIds = ["999"]
        XCTAssertEqual("badge_name", BadgeIdentifer.badgeToDisplay(userOffers: userOffers, offerIds: offerIds))
    }
    
    func test_badgeIsNil_whenNoMatchingIds() {
        let userOffers = UserOffers(availableBadges: [Badge(name: "badge_name", types: ["BADGE_TYPE"])], offers: [Offer(id: "999", title: "", type: "BADGE_TYPE")])
        let offerIds = ["2"]
        XCTAssertNil(BadgeIdentifer.badgeToDisplay(userOffers: userOffers, offerIds: offerIds))
    }
    
    func test_badgeIsHighestPriority_whenMultipleBadgesAvailable() {
        let userOffers = UserOffers(availableBadges: [Badge(name: "badge_name", types: ["BADGE_TYPE", "PRIORITY_2"]),
                                                            Badge(name: "badge_name_2", types: ["ANOTHER_BADGE", "YAY"])],
                                    offers: [Offer(id: "999", title: "", type: "ANOTHER_BADGE"),
                                             Offer(id: "1", title: "", type: "PRIORITY_2")])
        let offerIds = ["999", "1"]
        XCTAssertEqual("badge_name", BadgeIdentifer.badgeToDisplay(userOffers: userOffers, offerIds: offerIds))
    }
        
}
