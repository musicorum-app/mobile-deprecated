import 'package:flutter/material.dart';
import 'package:musicorum/api/lastfm.dart';
import 'package:musicorum/api/models/artist.dart';
import 'package:musicorum/api/models/artist_resource.dart';
import 'package:musicorum/components/content_item_list.dart';
import 'package:musicorum/components/items/artist_list_item.dart';
import 'package:musicorum/components/items/view_more_list_item.dart';
import 'package:musicorum/components/title.dart';
import 'package:musicorum/constants/colors.dart';
import 'package:musicorum/constants/common.dart';
import 'package:musicorum/pages/extended_items_list.dart';

class DiscoverPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return new DiscoverPageState();
  }
}

const int MAX_ITEMS_COUNT = 3;

enum DiscoverViewState {
  IDLE,
  LOADING,
  RESULTS,
  ERROR,
}

class DiscoverPageState extends State<DiscoverPage> {
  DiscoverViewState _viewState = DiscoverViewState.IDLE;

  _DiscoverResults _results;
  String _query;

  final border =
      OutlineInputBorder(borderSide: BorderSide(color: Colors.transparent));

  search(String query) async {
    if (query == '') return;
    setState(() {
      _viewState = DiscoverViewState.LOADING;
      _query = query;
    });

    final _artists = await LastfmAPI.searchArtists(query, limit: 10);

    setState(() {
      _results = _DiscoverResults(artists: _artists);
      _viewState = DiscoverViewState.RESULTS;
    });

    await _results.fetchResources();
    setState(() {});
  }

  handleChange(String query) {
    if ((_viewState != DiscoverViewState.IDLE ||
            _viewState != DiscoverViewState.LOADING) &&
        query != _query) {
      setState(() {
        _viewState = DiscoverViewState.IDLE;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        children: [
          PageTitle('Discover'),
          Container(
            padding: EdgeInsets.symmetric(horizontal: LIST_PADDING),
            child: Column(
              children: [
                TextField(
                  decoration: InputDecoration(
                      contentPadding: const EdgeInsets.symmetric(
                          horizontal: 14.0, vertical: 6.0),
                      filled: true,
                      fillColor: Color(0xFffffff),
                      border: border,
                      focusedBorder: border,
                      enabledBorder: border,
                      hintText: 'Search something...'),
                  style: TextStyle(color: Colors.white),
                  textInputAction: TextInputAction.search,
                  onSubmitted: search,
                  onChanged: handleChange,
                ),
                SizedBox(
                  height: 10,
                ),
                DiscoverView(_viewState, _results, _query)
              ],
            ),
          )
        ],
      ),
    );
  }
}

class DiscoverView extends StatelessWidget {
  DiscoverView(this._viewState, this._results, this._query);

  final DiscoverViewState _viewState;
  final _DiscoverResults _results;
  final String _query;
  final duration = Duration(milliseconds: 500);

  @override
  Widget build(BuildContext context) {
    if (_viewState == DiscoverViewState.IDLE)
      return AnimatedOpacity(
        opacity: _viewState == DiscoverViewState.IDLE ? 1.0 : 0.0,
        duration: duration,
        child: Text('Idle'),
      );
    if (_viewState == DiscoverViewState.LOADING)
      return AnimatedOpacity(
        opacity: _viewState == DiscoverViewState.LOADING ? 1.0 : 0.0,
        duration: duration,
        child: Container(
          height: 100,
          child: Center(
            child: CircularProgressIndicator(),
          ),
        ),
      );
    if (_viewState == DiscoverViewState.RESULTS)
      return AnimatedOpacity(
        opacity: _viewState == DiscoverViewState.RESULTS ? 1.0 : 0.0,
        duration: duration,
        child: Column(
          children: [
            ContentItemList(
              name: 'Artists',
              items: _results.hasArtists
                  ? [
                      ..._results.artistsItems.take(MAX_ITEMS_COUNT),
                      ViewMoreListItem(
                        onTap: () {
                          ExtendedItemsListPage.openItemsPage(context,
                              _query, 'Search results', _results.artistsItems);
                        },
                      )
                    ]
                  : [
                      Center(
                        child: Text('Nothing found.'),
                      )
                    ],
            )
          ],
        ),
      );
    if (_viewState == DiscoverViewState.ERROR)
      return AnimatedOpacity(
        opacity: _viewState == DiscoverViewState.ERROR ? 1.0 : 0.0,
        duration: duration,
        child: Text('Error'),
      );
    else
      return Container();
  }
}

class _DiscoverResults {
  _DiscoverResults({this.artists});

  final List<Artist> artists;

  Future<void> fetchResources() async {
    await ArtistResource.getResources(artists);
  }

  bool get hasArtists {
    return artists != null && artists.length > 0;
  }

  get artistsItems {
    return artists.map((e) => ArtistListItem(artist: e, user: null)).toList();
  }
}
