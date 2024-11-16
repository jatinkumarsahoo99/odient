import 'package:dtcameo/pages/editprofile.dart';
import 'package:dtcameo/pages/videoplayer.dart';
import 'package:dtcameo/provider/profileprovider.dart';
import 'package:dtcameo/utils/color.dart';
import 'package:dtcameo/utils/constant.dart';
import 'package:dtcameo/utils/dimens.dart';
import 'package:dtcameo/utils/utils.dart';
import 'package:dtcameo/widget/mynetworkimmage.dart';
import 'package:dtcameo/widget/mytext.dart';
import 'package:dtcameo/widget/nodata.dart';
import 'package:dtcameo/widget/customwidget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class Profile extends StatefulWidget {
  const Profile({super.key});

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  Profileprovider profileprovider = Profileprovider();

  @override
  void initState() {
    profileprovider = Provider.of<Profileprovider>(context, listen: false);
    _tabController = TabController(length: 2, vsync: this);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      getAPi();
    });
    super.initState();
  }

  Future<void> getAPi() async {
    profileprovider.setLoding(true);
    await profileprovider.getProfile(context, Constant.userId ?? "");
    await profileprovider.getVideo(Constant.userId ?? "");
    await profileprovider.getPrivateVideo(Constant.userId ?? "");
  }

  @override
  void dispose() {
    profileprovider.clearProvider();
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: colorPrimaryDark,
        body: NestedScrollView(
            headerSliverBuilder: (context, innerBoxIsScrolled) {
              return [
                SliverAppBar(
                  pinned: true,
                  floating: true,
                  actionsIconTheme: const IconThemeData(color: white),
                  leading: Utils.backButton(context),
                  automaticallyImplyLeading: false,
                  backgroundColor: colorPrimaryDark,
                  title: MyText(
                    text: "profile",
                    multilanguage: true,
                    fontsize: Dimens.textlargeBig,
                    color: white,
                  ),
                ),
                SliverToBoxAdapter(
                  child: profileDetail(),
                ),
                SliverPersistentHeader(
                    pinned: true,
                    delegate: _SliverAppBarDelegate(TabBar(
                        controller: _tabController,
                        dividerColor: transparent,
                        tabAlignment: TabAlignment.start,
                        indicatorSize: TabBarIndicatorSize.tab,
                        indicatorColor: colorAccent,
                        labelStyle: GoogleFonts.lato(
                            fontSize: Dimens.textSmall,
                            color: colorAccent,
                            fontWeight: FontWeight.w500),
                        unselectedLabelStyle: GoogleFonts.lato(
                            fontSize: Dimens.textSmall,
                            color: white,
                            fontWeight: FontWeight.w500),
                        unselectedLabelColor: white,
                        isScrollable: true,
                        indicator: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            color: transparent,
                            border: Border.all(
                                width: 1,
                                style: BorderStyle.solid,
                                color: colorAccent)),
                        tabs: const [
                          Tab(
                            child: MyText(
                              text: 'pub',
                              multilanguage: true,
                            ),
                          ),
                          Tab(
                            child: MyText(
                              text: 'pvt',
                              multilanguage: true,
                            ),
                          )
                        ])))
              ];
            },
            body: TabBarView(
              controller: _tabController,
              children: [tababrView(), privateVideo()],
            )));
  }

  Widget profileDetail() {
    return Consumer<Profileprovider>(
      builder: (context, profileprovider, child) {
        if (profileprovider.profileLoding) {
          return profileShimmer();
        } else {
          if (profileprovider.profileModel.status == 200 &&
              (profileprovider.profileModel.result?.length ?? 0) > 0) {
            return Stack(
              alignment: Alignment.topCenter,
              children: [
                MyNetworkImage(
                  imgWidth: MediaQuery.of(context).size.width,
                  imgHeight: 210,
                  imageUrl: profileprovider.profileModel.result?[0].image ?? "",
                  fit: BoxFit.fill,
                ),
                const SizedBox(width: 10),
                Padding(
                  padding: const EdgeInsets.fromLTRB(10, 156, 15, 0),
                  child: Column(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(200),
                        child: MyNetworkImage(
                          imgWidth: 100,
                          imgHeight: 100,
                          imageUrl:
                              profileprovider.profileModel.result?[0].image ??
                                  "",
                          fit: BoxFit.fill,
                        ),
                      ),
                      const SizedBox(width: 10),
                      MyText(
                        color: white,
                        text:
                            profileprovider.profileModel.result?[0].fullName ??
                                "",
                        fontsize: Dimens.textlargeBig,
                        fontwaight: FontWeight.w800,
                      ),
                      MyText(
                        color: white,
                        text:
                            profileprovider.profileModel.result?[0].username ??
                                "",
                        fontsize: Dimens.textTitle,
                        fontwaight: FontWeight.w200,
                      ),
                      const SizedBox(height: 10),
                      Container(
                          alignment: Alignment.center,
                          width: 100,
                          height: 30,
                          decoration: BoxDecoration(
                              gradient: const LinearGradient(
                                  colors: [
                                    primaryGradient,
                                    primaryGradient,
                                    colorAccent,
                                    colorAccent,
                                    colorAccent,
                                    colorAccent
                                  ],
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight),
                              borderRadius: BorderRadius.circular(20)),
                          child: TextButton(
                            onPressed: () {
                              Navigator.of(context)
                                  .push(MaterialPageRoute(
                                    builder: (context) => EditProfile(
                                      professionId: profileprovider.profileModel
                                              .result?[0].professionId
                                              .toString() ??
                                          "",
                                      typeEdit: "profileType",
                                    ),
                                  ))
                                  .then(
                                    (value) => getAPi(),
                                  );
                            },
                            child: MyText(
                              text: "edit_prof",
                              color: white,
                              multilanguage: true,
                              fontsize: Dimens.textSmall,
                              fontwaight: FontWeight.w700,
                            ),
                          )),
                      const SizedBox(height: 30),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: MyText(
                          color: white,
                          text: 'your_video',
                          multilanguage: true,
                          fontsize: Dimens.textExtraBig,
                          fontwaight: FontWeight.w800,
                        ),
                      ),
                    ],
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.fromLTRB(0, 423, 0, 0),
                  child: Divider(
                    thickness: 1,
                    height: 10,
                    color: grey,
                  ),
                )
              ],
            );
          } else {
            return const SizedBox.shrink();
          }
        }
      },
    );
  }

  Widget profileShimmer() {
    return Stack(
      alignment: Alignment.topCenter,
      children: [
        CustomWidget.roundcorner(
            height: 210, width: MediaQuery.of(context).size.width),
        const Padding(
          padding: EdgeInsets.fromLTRB(10, 156, 15, 0),
          child: Column(
            children: [
              CustomWidget.circular(height: 100, width: 100),
              SizedBox(height: 4),
              CustomWidget.roundcorner(height: 24, width: 116),
              CustomWidget.roundcorner(height: 19, width: 150),
              CustomWidget.roundcorner(height: 24, width: 100),
            ],
          ),
        ),
      ],
    );
  }

  Widget tababrView() {
    return Consumer<Profileprovider>(
      builder: (context, profileprovider, child) {
        if (profileprovider.videoLoding) {
          return tabShimmer();
        } else {
          if (profileprovider.videoModel.status == 200 &&
              (profileprovider.videoModel.result?.length ?? 0) > 0) {
            return AlignedGridView.count(
              crossAxisCount: 3,
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
              itemCount: profileprovider.videoModel.result?.length,
              padding: const EdgeInsets.fromLTRB(15, 0, 15, 0),
              itemBuilder: (context, index) {
                return InkWell(
                  onTap: () {
                    Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => VideoPlayer(
                        initialIndex: index,
                      ),
                    ));
                  },
                  child: MyNetworkImage(
                      imgHeight: 165,
                      imgWidth: 120,
                      imageUrl:
                          profileprovider.videoModel.result?[index].image ?? "",
                      fit: BoxFit.fill),
                );
              },
            );
          } else {
            return const NoData();
          }
        }
      },
    );
  }

  Widget privateVideo() {
    return Consumer<Profileprovider>(
      builder: (context, profileprovider, child) {
        if (profileprovider.videoPrivate) {
          return tabShimmer();
        } else {
          if (profileprovider.privateVideoModel.status == 200 &&
              (profileprovider.privateVideoModel.result?.length ?? 0) > 0) {
            return AlignedGridView.count(
              crossAxisCount: 3,
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
              itemCount: profileprovider.privateVideoModel.result?.length,
              padding: const EdgeInsets.fromLTRB(15, 0, 15, 0),
              itemBuilder: (context, index) {
                return InkWell(
                  onTap: () {
                    Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => VideoPlayer(
                        initialIndex: index,
                      ),
                    ));
                  },
                  child: MyNetworkImage(
                      imgHeight: 165,
                      imgWidth: 120,
                      imageUrl: profileprovider
                              .privateVideoModel.result?[index].image ??
                          "",
                      fit: BoxFit.fill),
                );
              },
            );
          } else {
            return const NoData();
          }
        }
      },
    );
  }

  Widget tabShimmer() {
    return AlignedGridView.count(
      crossAxisCount: 3,
      itemBuilder: (context, index) {
        return const CustomWidget.roundcorner(
          height: 185,
          width: 120,
        );
      },
    );
  }
}

class _SliverAppBarDelegate extends SliverPersistentHeaderDelegate {
  final TabBar _tabBar;

  const _SliverAppBarDelegate(this._tabBar);

  @override
  double get minExtent => _tabBar.preferredSize.height;

  @override
  double get maxExtent => _tabBar.preferredSize.height;

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Padding(
      padding: const EdgeInsets.only(left: 15),
      child: Container(
        padding: const EdgeInsets.all(10),
        color: colorPrimaryDark,
        child: _tabBar,
      ),
    );
  }

  @override
  bool shouldRebuild(_SliverAppBarDelegate oldDelegate) {
    return false;
  }
}
