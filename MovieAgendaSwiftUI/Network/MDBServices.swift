    //
    //  TMDBServices.swift
    //  MovieAgenda
    //
    //  Created by Ricardo Venieris on 17/10/22.
    //

import Foundation
import CodableExtensions

protocol MDBRequestType {
    associatedtype SomeType: RawRepresentable where SomeType.RawValue: StringProtocol
}
    
extension MDB {
    static var service = Service(apiKey:"95b336b6369a2ad868d199034d34fc0c")
    static var genres:[Int:String] = [:]
    
    class Service {
        enum ReqError:Error {
            case invalidURLRequest
            case resultTypeUnmatchedWithExpected
            case unknownError
        }
        enum RequestType:String {
            case lists
            
            case movieFavorites         = "/movie/favorites"
            case movieRecommendations   = "/movie/recommendations"
            case movieWatchlist         = "/movie/watchlist"
            case movieRated             = "/movie/rated"
            
            case tvFavorites            = "/tv/favorites"
            case tvRecommendations      = "/tv/recommendations"
            case tvWatchlist            = "/tv/watchlist"
            case tvRated                = "/tv/rated"
            
            case trendingAllDay         = "/trending/all/day"
            case trendingAllWeek        = "/trending/all/week"
            case trendingMovieDay       = "/trending/movie/day"
            case trendingMovieWeek      = "/trending/movie/week"
            case trendingTvDay          = "/trending/tv/day"
            case trendingTvWeek         = "/trending/tv/week"
            case trendingPersonDay      = "/trending/person/day"
            case trendingPersonWeek     = "/trending/person/week"
            case dummy
        }

            // -- MARK: Privates
        private let key = tmdbKey
        private var posterUrlPrefix:String {MDB.Request.imageUrlPrefix}
        private var dataRequestUrlPrefix:String {MDB.Request.dataRequestUrlPrefix}
        private let apiVersion = "3"
        private var apiUrlPrefix:String { "\(dataRequestUrlPrefix)/\(apiVersion)" }
        private var lastMovieResult:MDB.Media?
        private var _innerPage = 0
        
        private var headers:[String:String] = [:]
        
        let sessionConfiguration = URLSessionConfiguration.default// URLSessionConfiguration.default

        private var apiKey: String
        
        private var lastRequest:[RequestType:Int] = [:]
        
        
            // MARK: Constructor (Public init)
        init(apiKey: String) {
            self.apiKey = apiKey
            headers["Authorization" ] = "Bearer \(apiKey)"
            headers["Content-Type"  ] = "application/json"
        }
        
        
        
        private func getURL(for requestType: RequestType, page:Int?)->URL? {
            let urlString = self.apiUrlPrefix + requestType.rawValue + "?api_key=\(self.apiKey)" + "&page=\(page ?? 1)"
            print(urlString)
            guard let url = URL(string: urlString) else { return nil }
            return url
        }
        
        private func setRequestPage(for requestType: RequestType, page:Int? = nil) {
            lastRequest[requestType] = page ?? lastRequest[requestType]?.nextInt ?? 1
        }

        func request(requestType: RequestType, page:Int? = nil,
                     then completion: @escaping (Result<MDB.Request, Error>)->Void) {
            
            if requestType == .dummy {
                guard let result = try? MDB.Request.load(fromString: dummyData) else {
                    completion(.failure(ReqError.resultTypeUnmatchedWithExpected))
                    return
                }
                completion(.success(result))
                return
            }
            
            setRequestPage(for: requestType, page: page)
            guard let url = getURL(for: requestType, page: lastRequest[requestType]) else {
                completion(.failure(ReqError.invalidURLRequest))
                return
            }
            
            let request = URLRequest(url: url)
            let task = URLSession.shared.dataTask(with: request,
                                                  completionHandler: { data, urlResponse, error in
                if let data {
                    guard let result = try? MDB.Request.load(from: data) else {
                        completion(.failure(ReqError.resultTypeUnmatchedWithExpected))
                        return
                    }
                    completion(.success(result))
                    return
                }
                    // else -> Error
                if let error {
                    completion(.failure(error))
                    debugPrint(String(describing: urlResponse))
                }
                
            })
            task.resume()
        }
        
        func requestImage(from path: String?,
                          then completion: @escaping (Result<Data, Error>)->Void) {
            guard let path = path,
                  let url = URL(string: posterUrlPrefix+path) else {
                completion(.failure(ReqError.unknownError))
                return
            }
            
            let request = URLRequest(url: url)
            
            let task = URLSession.shared.dataTask(with: request, completionHandler: {data, urlResponse, error in
                if let data = data {
                    completion(.success(data))
                    return
                }
                if let error = error {
                    completion(.failure(error))
                    debugPrint(urlResponse ?? "no urlResponse")
                }
                
            })
            
            task.resume()
        }
    }

    
static let dummyData = { """
 {
  "page": 1,
  "results": [
    {
      "adult": false,
      "backdrop_path": "/1rO4xoCo4Z5WubK0OwdVll3DPYo.jpg",
      "id": 84773,
      "name": "The Lord of the Rings: The Rings of Power",
      "original_language": "en",
      "original_name": "The Lord of the Rings: The Rings of Power",
      "overview": "Beginning in a time of relative peace, we follow an ensemble cast of characters as they confront the re-emergence of evil to Middle-earth. From the darkest depths of the Misty Mountains, to the majestic forests of Lindon, to the breathtaking island kingdom of Númenor, to the furthest reaches of the map, these kingdoms and characters will carve out legacies that live on long after they are gone.",
      "poster_path": "/mYLOqiStMxDK3fYZFirgrMt8z5d.jpg",
      "media_type": "tv",
      "genre_ids": [
        10765,
        10759,
        18
      ],
      "popularity": 4787.462,
      "first_air_date": "2022-09-01",
      "vote_average": 7.682,
      "vote_count": 1177,
      "origin_country": [
        "US"
      ]
    },
    {
      "adult": false,
      "backdrop_path": "/etj8E2o0Bud0HkONVQPjyCkIvpv.jpg",
      "id": 94997,
      "name": "House of the Dragon",
      "original_language": "en",
      "original_name": "House of the Dragon",
      "overview": "The Targaryen dynasty is at the absolute apex of its power, with more than 15 dragons under their yoke. Most empires crumble from such heights. In the case of the Targaryens, their slow fall begins when King Viserys breaks with a century of tradition by naming his daughter Rhaenyra heir to the Iron Throne. But when Viserys later fathers a son, the court is shocked when Rhaenyra retains her status as his heir, and seeds of division sow friction across the realm.",
      "poster_path": "/z2yahl2uefxDCl0nogcRBstwruJ.jpg",
      "media_type": "tv",
      "genre_ids": [
        10765,
        18,
        10759
      ],
      "popularity": 6684.611,
      "first_air_date": "2022-08-21",
      "vote_average": 8.535,
      "vote_count": 1821,
      "origin_country": [
        "US"
      ]
    },
    {
      "adult": false,
      "backdrop_path": "/9GvhICFMiRQA82vS6ydkXxeEkrd.jpg",
      "id": 92783,
      "name": "She-Hulk: Attorney at Law",
      "original_language": "en",
      "original_name": "She-Hulk: Attorney at Law",
      "overview": "Jennifer Walters navigates the complicated life of a single, 30-something attorney who also happens to be a green 6-foot-7-inch superpowered hulk.",
      "poster_path": "/hJfI6AGrmr4uSHRccfJuSsapvOb.jpg",
      "media_type": "tv",
      "genre_ids": [
        35,
        10765
      ],
      "popularity": 2493.03,
      "first_air_date": "2022-08-18",
      "vote_average": 6.831,
      "vote_count": 1089,
      "origin_country": [
        "US"
      ]
    },
    {
      "adult": false,
      "backdrop_path": "/qtfMr08KQsWXnCHY0a96N8NpQ2l.jpg",
      "id": 30984,
      "name": "Bleach",
      "original_language": "ja",
      "original_name": "ブリーチ",
      "overview": "For as long as he can remember, Ichigo Kurosaki has been able to see ghosts. But when he meets Rukia, a Soul Reaper who battles evil spirits known as Hollows, he finds his life is changed forever. Now, with a newfound wealth of spiritual energy, Ichigo discovers his true calling: to protect the living and the dead from evil.",
      "poster_path": "/2EewmxXe72ogD0EaWM8gqa0ccIw.jpg",
      "media_type": "tv",
      "genre_ids": [
        10759,
        16,
        10765
      ],
      "popularity": 422.115,
      "first_air_date": "2004-10-05",
      "vote_average": 8.354,
      "vote_count": 1284,
      "origin_country": [
        "JP"
      ]
    },
    {
      "adult": false,
      "backdrop_path": "/ajztm40qDPqMONaSJhQ2PaNe2Xd.jpg",
      "id": 83867,
      "name": "Star Wars: Andor",
      "original_language": "en",
      "original_name": "Star Wars: Andor",
      "overview": "The tale of the burgeoning rebellion against the Empire and how people and planets became involved. In an era filled with danger, deception and intrigue, Cassian Andor embarks on the path that is destined to turn him into a rebel hero.",
      "poster_path": "/59SVNwLfoMnZPPB6ukW6dlPxAdI.jpg",
      "media_type": "tv",
      "genre_ids": [
        10765,
        10759,
        10768
      ],
      "popularity": 723.621,
      "first_air_date": "2022-09-21",
      "vote_average": 7.92,
      "vote_count": 150,
      "origin_country": [
        "US"
      ]
    },
    {
      "adult": false,
      "backdrop_path": "/kUYeG86YRdx9ef3kCTabuuIRQ90.jpg",
      "id": 210232,
      "name": "The Watcher",
      "original_language": "en",
      "original_name": "The Watcher",
      "overview": "A family moves into their suburban dream home, only to discover they've inherited a nightmare.",
      "poster_path": "/6RrseODZo2e66XOzC1XMzMuecnf.jpg",
      "media_type": "tv",
      "genre_ids": [
        18,
        9648
      ],
      "popularity": 395.473,
      "first_air_date": "2022-10-13",
      "vote_average": 7.67,
      "vote_count": 56,
      "origin_country": [
        "US"
      ]
    },
    {
      "adult": false,
      "backdrop_path": "/5DUMPBSnHOZsbBv81GFXZXvDpo6.jpg",
      "id": 114410,
      "name": "Chainsaw Man",
      "original_language": "ja",
      "original_name": "チェンソーマン",
      "overview": "Denji has a simple dream—to live a happy and peaceful life, spending time with a girl he likes. This is a far cry from reality, however, as Denji is forced by the yakuza into killing devils in order to pay off his crushing debts. Using his pet devil Pochita as a weapon, he is ready to do anything for a bit of cash.",
      "poster_path": "/npdB6eFzizki0WaZ1OvKcJrWe97.jpg",
      "media_type": "tv",
      "genre_ids": [
        16,
        10759,
        10765,
        35
      ],
      "popularity": 471.086,
      "first_air_date": "2022-10-12",
      "vote_average": 8.651,
      "vote_count": 63,
      "origin_country": [
        "JP"
      ]
    },
    {
      "adult": false,
      "backdrop_path": "/5vUux2vNUTqwCzb7tVcH18XnsF.jpg",
      "id": 113988,
      "name": "Dahmer – Monster: The Jeffrey Dahmer Story",
      "original_language": "en",
      "original_name": "Dahmer – Monster: The Jeffrey Dahmer Story",
      "overview": "Across more than a decade, 17 teen boys and young men were murdered by convicted killer Jeffrey Dahmer. How did he evade arrest for so long?",
      "poster_path": "/f2PVrphK0u81ES256lw3oAZuF3x.jpg",
      "media_type": "tv",
      "genre_ids": [
        18,
        80
      ],
      "popularity": 5865.9,
      "first_air_date": "2022-09-21",
      "vote_average": 8.292,
      "vote_count": 981,
      "origin_country": [
        "US"
      ]
    },
    {
      "adult": false,
      "backdrop_path": "/wvdWb5kTQipdMDqCclC6Y3zr4j3.jpg",
      "id": 1402,
      "name": "The Walking Dead",
      "original_language": "en",
      "original_name": "The Walking Dead",
      "overview": "Sheriff's deputy Rick Grimes awakens from a coma to find a post-apocalyptic world dominated by flesh-eating zombies. He sets out to find his family and encounters many other survivors along the way.",
      "poster_path": "/xf9wuDcqlUPWABZNeDKPbZUjWx0.jpg",
      "media_type": "tv",
      "genre_ids": [
        10759,
        18,
        10765
      ],
      "popularity": 1443.081,
      "first_air_date": "2010-10-31",
      "vote_average": 8.112,
      "vote_count": 13805,
      "origin_country": [
        "US"
      ]
    },
    {
      "adult": false,
      "backdrop_path": "/rjnnQOSntiuiHIbYKy4oessqaKA.jpg",
      "id": 126254,
      "name": "The Midnight Club",
      "original_language": "en",
      "original_name": "The Midnight Club",
      "overview": "At a manor with a mysterious history, the 8 members of the Midnight Club meet each night at midnight to tell sinister stories – and to look for signs of the supernatural from the beyond.",
      "poster_path": "/2Y4F9BHkacKIMnDBZI3GGKpG1If.jpg",
      "media_type": "tv",
      "genre_ids": [
        18,
        9648
      ],
      "popularity": 444.507,
      "first_air_date": "2022-10-07",
      "vote_average": 7.265,
      "vote_count": 51,
      "origin_country": [
        "US"
      ]
    },
    {
      "adult": false,
      "backdrop_path": "/wNKwOtq27yfN13SKKV07NwkpBA3.jpg",
      "id": 80752,
      "name": "See",
      "original_language": "en",
      "original_name": "See",
      "overview": "A virus has decimated humankind. Those who survived emerged blind. Centuries later when twins are born with the mythic ability to see, their father must protect his tribe against a threatened queen.",
      "poster_path": "/lKDIhc9FQibDiBQ57n3ELfZCyZg.jpg",
      "media_type": "tv",
      "genre_ids": [
        18,
        10765,
        10759
      ],
      "popularity": 571.308,
      "first_air_date": "2019-11-01",
      "vote_average": 8.255,
      "vote_count": 1830,
      "origin_country": [
        "US"
      ]
    },
    {
      "adult": false,
      "backdrop_path": "/zNugnnR5KEmq9EzLcl0Me1UmHYk.jpg",
      "id": 120089,
      "name": "SPY x FAMILY",
      "original_language": "ja",
      "original_name": "SPY×FAMILY",
      "overview": "Master spy Twilight is the best at what he does when it comes to going undercover on dangerous missions in the name of a better world. But when he receives the ultimate impossible assignment—get married and have a kid—he may finally be in over his head! Not one to depend on others, Twilight has his work cut out for him procuring both a wife and a child for his mission to infiltrate an elite private school. What he doesn't know is that the wife he's chosen is an assassin and the child he's adopted is a telepath!",
      "poster_path": "/3r4LYFuXrg3G8fepysr4xSLWnQL.jpg",
      "media_type": "tv",
      "genre_ids": [
        16,
        35,
        10759
      ],
      "popularity": 664.403,
      "first_air_date": "2022-04-09",
      "vote_average": 8.711,
      "vote_count": 821,
      "origin_country": [
        "JP"
      ]
    },
    {
      "adult": false,
      "backdrop_path": "/4J6kXERGYlwXNAIUTIdRSo8ci83.jpg",
      "id": 95341,
      "name": "Shantaram",
      "original_language": "en",
      "original_name": "Shantaram",
      "overview": "Escaped convict Lin Ford flees to the teeming streets of 1980s Bombay, looking to disappear. Working as a medic for the city’s poor and neglected, Lin finds unexpected love, connection, and courage on the long road to redemption.",
      "poster_path": "/gaomekdTBr2nDitlHfROB67eUg6.jpg",
      "media_type": "tv",
      "genre_ids": [
        80,
        18,
        10759
      ],
      "popularity": 117.6,
      "first_air_date": "2022-10-13",
      "vote_average": 8.2,
      "vote_count": 19,
      "origin_country": [
        "US"
      ]
    },
    {
      "adult": false,
      "backdrop_path": "/uGy4DCmM33I7l86W7iCskNkvmLD.jpg",
      "id": 60625,
      "name": "Rick and Morty",
      "original_language": "en",
      "original_name": "Rick and Morty",
      "overview": "Rick is a mentally-unbalanced but scientifically gifted old man who has recently reconnected with his family. He spends most of his time involving his young grandson Morty in dangerous, outlandish adventures throughout space and alternate universes. Compounded with Morty's already unstable family life, these events cause Morty much distress at home and school.",
      "poster_path": "/cvhNj9eoRBe5SxjCbQTkh05UP5K.jpg",
      "media_type": "tv",
      "genre_ids": [
        16,
        35,
        10765,
        10759
      ],
      "popularity": 1511.996,
      "first_air_date": "2013-12-02",
      "vote_average": 8.731,
      "vote_count": 7224,
      "origin_country": [
        "US"
      ]
    },
    {
      "adult": false,
      "backdrop_path": "/suopoADq0k8YZr4dQXcU6pToj6s.jpg",
      "id": 1399,
      "name": "Game of Thrones",
      "original_language": "en",
      "original_name": "Game of Thrones",
      "overview": "Seven noble families fight for control of the mythical land of Westeros. Friction between the houses leads to full-scale war. All while a very ancient evil awakens in the farthest north. Amidst the war, a neglected military order of misfits, the Night's Watch, is all that stands between the realms of men and icy horrors beyond.",
      "poster_path": "/u3bZgnGQ9T01sWNhyveQz0wH0Hl.jpg",
      "media_type": "tv",
      "genre_ids": [
        10765,
        18,
        10759
      ],
      "popularity": 1063.455,
      "first_air_date": "2011-04-17",
      "vote_average": 8.427,
      "vote_count": 19464,
      "origin_country": [
        "US"
      ]
    },
    {
      "adult": false,
      "backdrop_path": "/3O5voBAoeQ9kipZCKmx6uDfiRLc.jpg",
      "id": 136699,
      "name": "Glitch",
      "original_language": "ko",
      "original_name": "글리치",
      "overview": "A young woman joins forces with a UFO enthusiast to investigate her boyfriend’s sudden disappearance and stumbles into a wild conspiracy.",
      "poster_path": "/dspwDOosidQT85oPDDHMM9zmaLw.jpg",
      "media_type": "tv",
      "genre_ids": [
        18,
        35,
        9648,
        10765
      ],
      "popularity": 520.913,
      "first_air_date": "2022-10-07",
      "vote_average": 7.7,
      "vote_count": 22,
      "origin_country": [
        "KR"
      ]
    },
    {
      "adult": false,
      "backdrop_path": "/5kkw5RT1OjTAMh3POhjo5LdaACZ.jpg",
      "id": 90462,
      "name": "Chucky",
      "original_language": "en",
      "original_name": "Chucky",
      "overview": "After a vintage Chucky doll turns up at a suburban yard sale, an idyllic American town is thrown into chaos as a series of horrifying murders begin to expose the town’s hypocrisies and secrets. Meanwhile, the arrival of enemies — and allies — from Chucky’s past threatens to expose the truth behind the killings, as well as the demon doll’s untold origins.",
      "poster_path": "/iF8ai2QLNiHV4anwY1TuSGZXqfN.jpg",
      "media_type": "tv",
      "genre_ids": [
        80,
        10765
      ],
      "popularity": 1480.652,
      "first_air_date": "2021-10-12",
      "vote_average": 7.859,
      "vote_count": 3305,
      "origin_country": [
        "US"
      ]
    },
    {
      "adult": false,
      "backdrop_path": "/sokTOq0zAmPS7wCR4qd4Kca35x7.jpg",
      "id": 69478,
      "name": "The Handmaid's Tale",
      "original_language": "en",
      "original_name": "The Handmaid's Tale",
      "overview": "Set in a dystopian future, a woman is forced to live as a concubine under a fundamentalist theocratic dictatorship. A TV adaptation of Margaret Atwood's novel.",
      "poster_path": "/tFTJ3YbOor3BtabI96QehXxEBii.jpg",
      "media_type": "tv",
      "genre_ids": [
        10765,
        18
      ],
      "popularity": 313.597,
      "first_air_date": "2017-04-26",
      "vote_average": 8.241,
      "vote_count": 2151,
      "origin_country": [
        "US"
      ]
    },
    {
      "adult": false,
      "backdrop_path": "/3UbHGmu9vIMSC5uNfnGt7DjetqT.jpg",
      "id": 105248,
      "name": "Cyberpunk: Edgerunners",
      "original_language": "ja",
      "original_name": "サイバーパンク：エッジランナーズ",
      "overview": "In a dystopia riddled with corruption and cybernetic implants, a talented but reckless street kid strives to become a mercenary outlaw — an edgerunner.",
      "poster_path": "/4CgMd3q8vy4bodVqS2Mp9epORmU.jpg",
      "media_type": "tv",
      "genre_ids": [
        16,
        10759,
        10765
      ],
      "popularity": 290.221,
      "first_air_date": "2022-09-13",
      "vote_average": 8.7,
      "vote_count": 482,
      "origin_country": [
        "JP"
      ]
    },

  ],
  "total_pages": 1000,
  "total_results": 20000
}
"""
        
    }()
}

