class Wiki {
  Wiki({this.content, this.published, this.summary, this.url});

  final String published;
  final String summary;
  final String content;
  final String url;

  static final WIKI_REGEX = RegExp(r'\s?<a href="(.*)">(.*)</a>\.?\s?', multiLine: true, dotAll: true);

  String get disclaimer {
    return 'User-contributed text is available under the Creative Commons By-SA License; additional terms may apply. This information is from Last.fm. Please reffer to their website for more information';
  }

  String get summaryFiltered {
    return summary.replaceAll(WIKI_REGEX, '');
  }

  String get contentFiltered {
    return content.split(WIKI_REGEX)[0];
  }

  factory Wiki.fromJSON(Map<String, dynamic> json) {
    return Wiki(
      published: json['published'],
      summary: json['summary'],
      content: json['content'],
      url: json['links']['link']['href']
    );
  }

  factory Wiki.fromJSONWithoutURL(Map<String, dynamic> json, String url) {
    return Wiki(
        published: json['published'],
        summary: json['summary'],
        content: json['content'],
        url: url
    );
  }
}