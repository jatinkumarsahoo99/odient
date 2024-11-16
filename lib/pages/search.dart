import 'package:dtcameo/pages/detailspage.dart';
import 'package:dtcameo/provider/searchprovider.dart';
import 'package:dtcameo/utils/color.dart';
import 'package:dtcameo/utils/dimens.dart';
import 'package:dtcameo/utils/utils.dart';
import 'package:dtcameo/widget/mynetworkimmage.dart';
import 'package:dtcameo/widget/mytext.dart';
import 'package:dtcameo/widget/nodata.dart';
import 'package:dtcameo/widget/customwidget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Search extends StatefulWidget {
  const Search({super.key});

  @override
  State<Search> createState() => _SearchState();
}

class _SearchState extends State<Search> {
  late Searchprovider searchProvider;
  final ScrollController _scrollController = ScrollController();
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    searchProvider = Provider.of<Searchprovider>(context, listen: false);
    _scrollController.addListener(_scrollListener);
    super.initState();
    getApi(0);
  }

  /* scroller controller code and add listner */
  _scrollListener() async {
    if (!_scrollController.hasClients) return;
    if (_scrollController.offset >=
            _scrollController.position.maxScrollExtent &&
        !_scrollController.position.outOfRange &&
        (searchProvider.isMorePage ?? false)) {
      await searchProvider.setLoadMore(true);
      getApi(0);
    }
  }

  Future<void> getApi(int? pageNo) async {
    if (_searchController.text == "") {
      /* Trending Api  */
      await searchProvider.getTranding((pageNo ?? 0) + 1);
    } else {
      /* Artist Api  */
      await searchProvider.getArtist(_searchController.text, (pageNo ?? 0) + 1);
    }
  }

  @override
  void dispose() {
    searchProvider.clearProvider();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: colorPrimaryDark,
      appBar: appBar(),
      body: buildSearch(),
    );
  }

  AppBar appBar() {
    return AppBar(
      leading: Utils.backButton(context),
      backgroundColor: colorPrimaryDark,
      iconTheme: const IconThemeData(color: white),
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: TextFormField(
              controller: _searchController,
              textInputAction: TextInputAction.go,
              keyboardType: TextInputType.text,
              style: TextStyle(
                  fontStyle: FontStyle.normal,
                  fontSize: Dimens.textMedium,
                  fontWeight: FontWeight.w500,
                  color: white),
              onChanged: (value) async {
                searchProvider.clearProvider();
                getApi(0);
              },
              decoration: InputDecoration(
                hintText: 'Search',
                hintStyle: TextStyle(
                    fontStyle: FontStyle.normal,
                    fontSize: Dimens.textMedium,
                    fontWeight: FontWeight.w500,
                    color: white),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(25),
                  borderSide: BorderSide.none,
                ),
                filled: true,
                fillColor: colorPrimary,
                contentPadding: const EdgeInsets.symmetric(horizontal: 16),
                prefixIcon: const Icon(Icons.search, color: white),
              ),
            ),
          ),
          const SizedBox(
            width: 15,
          ),
          InkWell(
            onTap: () {
              _searchController.clear();
              searchProvider.artistList?.clear();
            },
            child: MyText(
                text: "cancel",
                multilanguage: true,
                fontstyle: FontStyle.normal,
                fontsize: Dimens.textTitle,
                color: white,
                fontwaight: FontWeight.w400),
          )
        ],
      ),
    );
  }

  Widget buildSearch() {
    return Consumer<Searchprovider>(
      builder: (context, searchprovider, child) {
        if (searchprovider.loaded) {
          return buildSearchShimmer();
        } else {
          if (searchprovider.artistList != null &&
              (searchprovider.artistList?.length ?? 0) > 0) {
            return SingleChildScrollView(
              controller: _scrollController,
              padding: const EdgeInsets.only(left: 15, right: 15),
              child: Column(
                children: [
                  ListView.builder(
                    itemCount: searchprovider.artistList?.length,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: InkWell(
                          onTap: () {
                            Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => DetailsPage(
                                  id: searchprovider.artistList?[index].id
                                          .toString() ??
                                      ""),
                            ));
                          },
                          child: Row(
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(200),
                                child: MyNetworkImage(
                                  imgWidth: 50,
                                  imgHeight: 50,
                                  imageUrl:
                                      searchprovider.artistList?[index].image ??
                                          "",
                                  fit: BoxFit.fill,
                                ),
                              ),
                              const SizedBox(width: 12),
                              Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  MyText(
                                    text: searchprovider
                                            .artistList?[index].fullName ??
                                        "",
                                    color: white,
                                    maxline: 2,
                                    overflow: TextOverflow.ellipsis,
                                    fontwaight: FontWeight.w600,
                                    fontsize: Dimens.textTitle,
                                  ),
                                  MyText(
                                    color: white,
                                    text: searchprovider
                                            .artistList?[index].profession ??
                                        "",
                                    maxline: 2,
                                    overflow: TextOverflow.ellipsis,
                                    fontwaight: FontWeight.w300,
                                    fontsize: Dimens.textSmall,
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),

                  /* Pagination loader */
                  Consumer<Searchprovider>(
                    builder: (context, searchProvider, child) {
                      if (searchProvider.loadMore) {
                        return Container(
                          height: 80,
                          padding: const EdgeInsets.all(20),
                          alignment: Alignment.center,
                          child: Utils.pageLoader(),
                        );
                      } else {
                        return const SizedBox.shrink();
                      }
                    },
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            );
          } else {
            return const NoData();
          }
        }
      },
    );
  }

  Widget buildSearchShimmer() {
    return ListView.builder(
      itemCount: 6,
      shrinkWrap: true,
      padding: const EdgeInsets.fromLTRB(15, 0, 15, 0),
      physics: const AlwaysScrollableScrollPhysics(),
      itemBuilder: (context, index) {
        return const Row(
          children: [
            CustomWidget.circular(height: 50, width: 50),
            Column(
              children: [
                CustomWidget.roundcorner(height: 17, width: 100),
                CustomWidget.roundcorner(height: 15, width: 70),
              ],
            )
          ],
        );
      },
    );
  }
}
