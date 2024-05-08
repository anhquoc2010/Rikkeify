//
//  Track.swift
//  Rikkeify
//
//  Created by PearUK on 7/5/24.
//

import Foundation

struct Track {
    let id: String
    let name: String
    let shareUrl: String
    let durationMs: Int64
    let durationText: String
    let trackNumber: Int
    let playCount: Int64
    let artists: [Artist]
    let album: Album
    let lyrics: [Lyric]
    let audio: [Audio]
}

//struct Track {
//    let id: String = "6YndJvp5XpMuzmtWLWI8hp"
//    let name: String = "Em Không"
//    let shareUrl: String = "https://open.spotify.com/track/6YndJvp5XpMuzmtWLWI8hp"
//    let durationMs: Int = 316988
//    let durationText: String = "05:16"
//    let trackNumber: Int = 1
//    let playCount: Int = 3181805
//    let artists: [Artist] = [
//        Artist(id: "5ptgjFDE2abY6Xwo4ytufN",
//               name: "Vũ Thanh Vân",
//               visuals: Image(url: "https://i.scdn.co/image/ab6761610000e5ebdd2fd98b7e94a15a4a15bdb6", width: 640, height: 640)
//              )
//    ]
//    let album: Album = Album(id: "5BcRvcyxsejuhRYxiJPuHM",
//                             name: "Em Không",
//                             shareUrl: "https://open.spotify.com/album/5BcRvcyxsejuhRYxiJPuHM",
//                             cover: [
//                                Image(url: "https://i.scdn.co/image/ab67616d0000b27340d109dcad66a52f6cab0655", width: 640, height: 640)
//                             ])
//    let lyrics: [Lyric] = [
//        Lyric(startMs: 2100, durMs: 2410, text: "One, two, three, yah"),
//        Lyric(startMs: 24440, durMs: 9560, text: "Dường như em đã quên khi anh chẳng ghé qua (anh chẳng ghé qua)"),
//        Lyric(startMs: 34000, durMs: 7470, text: "Cùng thật nhiều lý do nhưng anh chọn nói ra (anh chọn nói ra)"),
//        Lyric(startMs: 41470, durMs: 9390, text: "Rằng anh không còn niềm tin vào tình yêu dù cho em đang bên cạnh"),
//        Lyric(startMs: 50860, durMs: 10110, text: "Người đàn ông mà em yêu dù giông bão em vẫn đứng ngay bên cạnh"),
//        Lyric(startMs: 60970, durMs: 3500, text: "Nếu em biết rằng mai sau"),
//        Lyric(startMs: 64470, durMs: 5760, text: "Ta chẳng bên nhau, có gì để mất?"),
//        Lyric(startMs: 70230, durMs: 3670, text: "Và nếu em không để ai đau"),
//        Lyric(startMs: 73900, durMs: 4430, text: "Vậy thì ai lau hai dòng nước mắt?"),
//        Lyric(startMs: 78330, durMs: 5070, text: "Vì em không là gió, em không là mưa"),
//        Lyric(startMs: 83400, durMs: 4620, text: "Em không là giọt nắng ban trưa đọng trên mái nhà"),
//        Lyric(startMs: 88020, durMs: 4810, text: "Em không là đất, em không là cây"),
//        Lyric(startMs: 92830, durMs: 10380, text: "Em sẽ không ở mãi nơi đây đợi anh mỗi ngày"),
//        Lyric(startMs: 118640, durMs: 9300, text: "Dường như anh đã quen với những ngày có em (những ngày có em)"),
//        Lyric(startMs: 127940, durMs: 7370, text: "Chẳng cần đi hái sao nhưng anh lại có em (anh lại có em)"),
//        Lyric(startMs: 135310, durMs: 5850, text: "Người mà anh thầm mong ước vì em cần anh trước"),
//        Lyric(startMs: 141160, durMs: 3620, text: "Em vẫn vậy"),
//        Lyric(startMs: 144780, durMs: 5580, text: "Chỉ là anh chẳng nhìn thấy mình may mắn đến biết mấy"),
//        Lyric(startMs: 150360, durMs: 4830, text: "Anh vẫn vậy"),
//        Lyric(startMs: 155190, durMs: 3490, text: "Nếu em biết rằng mai sau"),
//        Lyric(startMs: 158680, durMs: 5570, text: "Ta chẳng bên nhau, có gì để mất? (Có gì để mất)"),
//        Lyric(startMs: 164250, durMs: 3830, text: "Và nếu em không để ai đau"),
//        Lyric(startMs: 168080, durMs: 4660, text: "Vậy thì ai lau hai dòng nước mắt?"),
//        Lyric(startMs: 172740, durMs: 4680, text: "Em không là gió, em không là mưa"),
//        Lyric(startMs: 177420, durMs: 4800, text: "Em không là giọt nắng ban trưa đọng trên mái nhà"),
//        Lyric(startMs: 182220, durMs: 4660, text: "Em không là đất, em không là cây"),
//        Lyric(startMs: 186880, durMs: 9690, text: "Em sẽ không ở mãi nơi đây đợi anh mỗi ngày"),
//        Lyric(startMs: 196570, durMs: 3680, text: "Eh heh"),
//        Lyric(startMs: 210340, durMs: 4820, text: "Em không là gió, em có thể rơi"),
//        Lyric(startMs: 215160, durMs: 4590, text: "Khi em chạm mặt đất chơi vơi, mình anh đứng nhìn"),
//        Lyric(startMs: 219750, durMs: 4590, text: "Em không trẻ mãi, không có thời gian"),
//        Lyric(startMs: 224340, durMs: 8360, text: "Không mong cầu một chút yêu thương từ anh nữa"),
//        Lyric(startMs: 232700, durMs: 3660, text: "Nếu em biết rằng mai sau"),
//        Lyric(startMs: 236360, durMs: 5550, text: "Ta chẳng bên nhau, có gì để mất?"),
//        Lyric(startMs: 241910, durMs: 3760, text: "Và nếu em không để ai đau"),
//        Lyric(startMs: 245670, durMs: 4560, text: "Vậy thì ai lau hai dòng nước mắt?"),
//        Lyric(startMs: 250230, durMs: 4850, text: "Em không là gió, em không là mưa"),
//        Lyric(startMs: 255080, durMs: 4740, text: "Em không là giọt nắng ban trưa đọng trên mái nhà"),
//        Lyric(startMs: 259820, durMs: 4720, text: "Em không là đất, em không là cây"),
//        Lyric(startMs: 264540, durMs: 5880, text: "Em sẽ không ở mãi nơi đây đợi anh mỗi ngày"),
//        Lyric(startMs: 270420, durMs: 3400, text: "Nếu em biết rằng mai sau"),
//        Lyric(startMs: 273820, durMs: 5940, text: "Ta chẳng bên nhau, có gì để mất?"),
//        Lyric(startMs: 279760, durMs: 3600, text: "Nếu em không để ai đau"),
//        Lyric(startMs: 283360, durMs: 5690, text: "Vậy thì ai lau hai dòng nước mắt?"),
//        Lyric(startMs: 289050, durMs: 3660, text: "Nếu em biết rằng mai sau"),
//        Lyric(startMs: 292710, durMs: 5860, text: "Ta chẳng bên nhau, có gì để mất?"),
//        Lyric(startMs: 298570, durMs: 3660, text: "Nếu em không để ai đau"),
//        Lyric(startMs: 302230, durMs: 7560, text: "Vậy thì ai lau hai dòng nước mắt?")
//    ]
//    let audio: Audio = Audio(quality: "sq",
//                             url: "https://scd.dlod.link/?expire=1715085870995&p=ApYxVdxe4QDZ1UstBkaSln2VZRVhZQ_pvzqD5R6bkCgv54VMRzpMx8mCXOnwz61I0pn3w1tM2OarjsqcZvFoQzieaYFM6Gp5GU4ZIFYZgfpSzTTYDeGEruj22JxhKdUnBzUg_Q5k82drFZN1l_OiTOHR7CvNLFvt_AFjxFNTI7FjLCD-OSa_lxxmRGEpv6DkMvWKlwC3L0qHGP1zhiEKtQ&s=BU2PD9boNYcy08guoDfUl9xk2UseSnOcjhzNfYh2gVc",
//                             durationMs: 317100,
//                             durationText: "05:17",
//                             mimeType: "audio/mpeg",
//                             format: "mp3")
//}
