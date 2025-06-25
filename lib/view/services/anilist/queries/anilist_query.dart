import 'package:geekcontrol/view/services/anilist/entities/anilist_seasons_enum.dart';
import 'package:geekcontrol/view/services/anilist/entities/anilist_types_enum.dart';

class Query {
  static String ratedsQuery(AnilistTypes type) {
    return '''
{
  Page {
    media(sort: POPULARITY_DESC, type: ${type.value}) {
      id
      averageScore
      meanScore
      status
      episodes
      source
      format
      coverImage {
        large
        extraLarge
      }
      type
      title {
        english
        romaji
      }
    }
  }
}
    ''';
  }

  static String releasesQuery(
    AnilistTypes type, {
    String? year,
    String? title,
    AnilistSeasons? season,
  }) {
    return '''
query {
  Page {
    media(${year != null ? 'seasonYear: $year' : 'sort: TRENDING_DESC'}, ${season != null ? 'season: ${season.value}' : ''}, type: ${type.value}) {
      id
      bannerImage
      coverImage {
        extraLarge
      }
      title {
        romaji
        english
      }
      episodes
      source
      chapters 
      volumes
      updatedAt
      status
      season
      seasonYear
      meanScore
      averageScore
      popularity
      nextAiringEpisode {
        id
        airingAt
        episode
      }
      startDate {
        year
        month
        day
      }
      endDate {
        year
        month
        day
      }
      staff {
        edges {
          role
          node {
            name {
              full
            }
          }
        }
      }
    }
  }
}
    ''';
  }

  static String detailsQuery() {
    return '''
query (\$id: Int) {
  Media(id: \$id) {
    id
    title {
      romaji
      english
    }
    description(asHtml: false)
    coverImage {
      large
    }
    bannerImage
    startDate {
      year
      month
      day
    }
    endDate {
      year
      month
      day
    }
    format
    status
    episodes
    chapters
    volumes
    duration
    meanScore
    averageScore
    popularity
    genres
    source
    reviews(limit: 10) {
      nodes {
          body
          summary
          rating
          user {
            name
            avatar {
              large
            }
          }
        }
      }
    recommendations {
      nodes {
          mediaRecommendation {
            id
            coverImage {
              extraLarge
              color
            }
            title {
              english
            }
            description
            bannerImage
          }
        }
      }
    studios {
      nodes {
        name
      }
    }
    characters(perPage: 10) {
      nodes {
        name {
          full
        }
        image {
          large
        }
      }
    }
  }
}
  ''';
  }
}
