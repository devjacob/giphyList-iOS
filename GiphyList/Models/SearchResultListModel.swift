//
//  SearchResultModel.swift
//  GiphyList
//
//  Created by 정창현 on 2020/02/29.
//

import Foundation
import RealmSwift

// MARK: - SearchResultModel

class SearchResultListModel: BaseModel {
    var meta: MetaModel

    let data: [SearchItemModel]
    let pagination: Pagination
}

// MARK: - Datum

class SearchItemModel: Codable {
    let type, id: String
    let url: String
    let slug: String
    let bitlyGIFURL, bitlyURL, embedURL: String
    let username: String
    let source: String
    let title, rating, contentURL, sourceTLD: String
    let sourcePostURL: String
    let isSticker: Int
    let importDatetime, trendingDatetime: String
    let images: Images
    let analyticsResponsePayload: String
    let analytics: Analytics?

    enum CodingKeys: String, CodingKey {
        case type, id, url, slug
        case bitlyGIFURL = "bitly_gif_url"
        case bitlyURL = "bitly_url"
        case embedURL = "embed_url"
        case username, source, title, rating
        case contentURL = "content_url"
        case sourceTLD = "source_tld"
        case sourcePostURL = "source_post_url"
        case isSticker = "is_sticker"
        case importDatetime = "import_datetime"
        case trendingDatetime = "trending_datetime"
        case images
        case analyticsResponsePayload = "analytics_response_payload"
        case analytics
    }
}

// MARK: - Analytics

class Analytics: Codable {
    let onload, onclick, onsent: Onclick
}

// MARK: - Onclick

class Onclick: Codable {
    let url: String
}

// MARK: - Images

class Images: Codable {
    let downsizedLarge, fixedHeightSmallStill: ImageItemModel
    let original, fixedHeightDownsampled: FixedHeight
    let downsizedStill, fixedHeightStill, downsizedMedium, downsized: ImageItemModel
    let previewWebp: ImageItemModel
    let originalMp4: DownsizedSmall
    let fixedHeightSmall, fixedHeight: FixedHeight
    let downsizedSmall, preview: DownsizedSmall
    let fixedWidthDownsampled: FixedHeight
    let fixedWidthSmallStill: ImageItemModel
    let fixedWidthSmall: FixedHeight
    let originalStill, fixedWidthStill: ImageItemModel
    let looping: Looping
    let fixedWidth: FixedHeight
    let previewGIF, the480WStill: ImageItemModel

    enum CodingKeys: String, CodingKey {
        case downsizedLarge = "downsized_large"
        case fixedHeightSmallStill = "fixed_height_small_still"
        case original
        case fixedHeightDownsampled = "fixed_height_downsampled"
        case downsizedStill = "downsized_still"
        case fixedHeightStill = "fixed_height_still"
        case downsizedMedium = "downsized_medium"
        case downsized
        case previewWebp = "preview_webp"
        case originalMp4 = "original_mp4"
        case fixedHeightSmall = "fixed_height_small"
        case fixedHeight = "fixed_height"
        case downsizedSmall = "downsized_small"
        case preview
        case fixedWidthDownsampled = "fixed_width_downsampled"
        case fixedWidthSmallStill = "fixed_width_small_still"
        case fixedWidthSmall = "fixed_width_small"
        case originalStill = "original_still"
        case fixedWidthStill = "fixed_width_still"
        case looping
        case fixedWidth = "fixed_width"
        case previewGIF = "preview_gif"
        case the480WStill = "480w_still"
    }
}

// MARK: - The480_WStill

class ImageItemModel: Object, Codable {
    override static func primaryKey() -> String? {
        return "id"
    }

    @objc dynamic var id: Int = 0
    @objc dynamic var url: String = ""
    @objc dynamic var width: String = ""
    @objc dynamic var height: String = ""
    @objc dynamic var size: String?
    @objc dynamic var randomRed: Double
    @objc dynamic var randomGreen: Double
    @objc dynamic var randomBlue: Double
    @objc dynamic var itemID: String?
    @objc dynamic var isSticker: Int

    enum CodingKeys: String, CodingKey {
        case url, width, height, size, id
    }

    required init() {
        itemID = nil
        id = 0
        url = ""
        width = ""
        height = ""
        size = nil
        randomRed = 0
        randomBlue = 0
        randomGreen = 0
        isSticker = 0
    }

    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = 0
        itemID = nil
        isSticker = 0
        url = try container.decodeIfPresent(String.self, forKey: .url) ?? ""
        width = try container.decodeIfPresent(String.self, forKey: .width) ?? ""
        height = try container.decodeIfPresent(String.self, forKey: .height) ?? ""
        size = try container.decodeIfPresent(String.self, forKey: .size) ?? nil
        randomRed = drand48()
        randomBlue = drand48()
        randomGreen = drand48()
    }

    func backgroundColor() -> UIColor {
        return UIColor(red: CGFloat(randomRed), green: CGFloat(randomGreen), blue: CGFloat(randomBlue), alpha: 1.0)
    }

    func isFavorite() -> Bool {
        guard let itemID = itemID else { return false }
        return RealmManager.shared.isFavoriteItem(itemID)
    }
}

// MARK: - DownsizedSmall

class DownsizedSmall: Codable {
    let height: String
    let mp4: String
    let mp4Size, width: String

    enum CodingKeys: String, CodingKey {
        case height, mp4
        case mp4Size = "mp4_size"
        case width
    }
}

// MARK: - FixedHeight

class FixedHeight: Codable {
    let height: String
    let mp4: String?
    let mp4Size: String?
    let size: String
    let url: String
    let webp: String
    let webpSize, width: String
    let frames, hash: String?

    enum CodingKeys: String, CodingKey {
        case height, mp4
        case mp4Size = "mp4_size"
        case size, url, webp
        case webpSize = "webp_size"
        case width, frames, hash
    }
}

// MARK: - Looping

class Looping: Codable {
    let mp4: String
    let mp4Size: String

    enum CodingKeys: String, CodingKey {
        case mp4
        case mp4Size = "mp4_size"
    }
}

// MARK: - Pagination

class Pagination: Codable {
    let totalCount, count, offset: Int

    enum CodingKeys: String, CodingKey {
        case totalCount = "total_count"
        case count, offset
    }
}
