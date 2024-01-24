import 'package:d_chart/d_chart.dart';
import 'package:d_view/d_view.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:money_record_mobile/config/app_asset.dart';
import 'package:money_record_mobile/config/app_color.dart';
import 'package:money_record_mobile/config/app_format.dart';
import 'package:money_record_mobile/config/session.dart';
import 'package:money_record_mobile/presentation/controller/c_home.dart';
import 'package:money_record_mobile/presentation/controller/c_user.dart';
import 'package:money_record_mobile/presentation/page/auth/login_page.dart';
import 'package:money_record_mobile/presentation/page/history/add_history_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final cUser = Get.put(CUser());
  final cHome = Get.put(CHome());
  String stringPercent = '';

  @override
  void initState() {
    cHome.getAnalysis(cUser.data.idUser!);
    super.initState();
    stringPercent = cHome.monthPercent;
  }

  @override
  Widget build(BuildContext context) {
    final cUser = Get.put(CUser());

    List<OrdinalData> ordinalList = List.generate(7, (index) {
      return OrdinalData(
          domain: cHome.weekText()[index], measure: cHome.week[index]);
    });
    final ordinalGroup = [
      OrdinalGroup(
        id: '1',
        data: ordinalList,
      ),
    ];
    return Scaffold(
        endDrawer: Drawer(
            child: ListView(
          children: [
            DrawerHeader(
              padding: const EdgeInsets.fromLTRB(16, 20, 16, 20),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Image.asset(AppAsset.profile),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Obx(() {
                              return Text(cUser.data.name ?? '',
                                  style: const TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold));
                            }),
                            Obx(() {
                              return Text(
                                cUser.data.email ?? '',
                              );
                            })
                          ],
                        ),
                      ),
                    ],
                  ),
                  Material(
                    color: AppColor.primary,
                    borderRadius: BorderRadius.circular(30),
                    child: InkWell(
                      onTap: () {
                        Session.clearUser();
                        Get.off(() => const LoginPage());
                      },
                      borderRadius: BorderRadius.circular(30),
                      child: const Padding(
                        padding:
                            EdgeInsets.symmetric(horizontal: 24, vertical: 8),
                        child: Text(
                          "Logout",
                          style: TextStyle(
                              color: Colors.white, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const Divider(height: 1),
            ListTile(
              onTap: () {
                Get.to(() => AddHistoryPage())?.then((value) {
                  if (value ?? false) {
                    cHome.getAnalysis(cUser.data.idUser!);
                  }
                });
              },
              leading: const Icon(Icons.add),
              horizontalTitleGap: 0,
              title: const Text('Tambah Baru'),
              trailing: const Icon(Icons.navigate_next),
            ),
            const Divider(height: 1),
            ListTile(
              onTap: () {},
              leading: const Icon(Icons.south_west),
              horizontalTitleGap: 0,
              title: const Text('Pemasukan'),
              trailing: const Icon(Icons.navigate_next),
            ),
            const Divider(height: 1),
            ListTile(
              onTap: () {},
              leading: const Icon(Icons.north_east),
              horizontalTitleGap: 0,
              title: const Text('Pengeluaran'),
              trailing: const Icon(Icons.navigate_next),
            ),
            const Divider(height: 1),
            ListTile(
              onTap: () {},
              leading: const Icon(Icons.history),
              horizontalTitleGap: 0,
              title: const Text('Riwayat'),
              trailing: const Icon(Icons.navigate_next),
            ),
            const Divider(height: 1),
          ],
        )),
        body: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 50, 20, 30),
              child: Row(
                children: [
                  DView.spaceHeight(),
                  Image.asset(AppAsset.profile),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('Hi,',
                            style: TextStyle(
                                fontSize: 20, fontWeight: FontWeight.bold)),
                        Obx(() {
                          return Text(
                            cUser.data.name ?? '',
                            style: const TextStyle(
                                fontSize: 20, fontWeight: FontWeight.bold),
                          );
                        })
                      ],
                    ),
                  ),
                  Builder(builder: (ctx) {
                    return Material(
                      color: AppColor.chart,
                      borderRadius: BorderRadius.circular(5),
                      child: InkWell(
                        onTap: () {
                          Scaffold.of(ctx).openEndDrawer();
                        },
                        child: const Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Icon(
                            Icons.menu,
                            color: AppColor.bg,
                          ),
                        ),
                      ),
                    );
                  })
                ],
              ),
            ),
            Expanded(
              child: RefreshIndicator(
                onRefresh: () async {
                  cHome.getAnalysis(cUser.data.idUser!);
                },
                child: ListView(
                  padding: const EdgeInsets.fromLTRB(20, 0, 20, 30),
                  children: [
                    Text(
                      'Pengeluaran Hari Ini',
                      style: Theme.of(context)
                          .textTheme
                          .titleLarge
                          ?.copyWith(fontWeight: FontWeight.bold),
                    ),
                    DView.spaceHeight(),
                    cardToday(context),
                    DView.spaceHeight(30),
                    Center(
                      child: Container(
                        height: 5,
                        width: 80,
                        decoration: BoxDecoration(
                            color: AppColor.bg,
                            borderRadius: BorderRadius.circular(30)),
                      ),
                    ),
                    DView.spaceHeight(30),
                    Text("Pengeluaran Minggu Ini",
                        style: Theme.of(context).textTheme.titleLarge!.copyWith(
                            fontWeight: FontWeight.bold,
                            color: const Color.fromARGB(255, 0, 0, 0))),
                    weekly(ordinalGroup),
                    DView.spaceHeight(),
                    Text("Perbandingan Bulan Ini",
                        style: Theme.of(context).textTheme.titleLarge!.copyWith(
                            fontWeight: FontWeight.bold,
                            color: const Color.fromARGB(255, 0, 0, 0))),
                    Row(
                      children: [
                        SizedBox(
                          width: MediaQuery.of(context).size.width * 0.5,
                          height: MediaQuery.of(context).size.width * 0.5,
                          child: monthly(context),
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Container(
                                  height: 16,
                                  width: 16,
                                  color: AppColor.primary,
                                ),
                                DView.spaceWidth(8),
                                const Text("Pemasukan")
                              ],
                            ),
                            DView.spaceHeight(10),
                            Row(
                              children: [
                                Container(
                                  height: 16,
                                  width: 16,
                                  color: AppColor.chart,
                                ),
                                DView.spaceWidth(8),
                                const Text("Pengeluaran")
                              ],
                            ),
                            DView.spaceHeight(20),
                            Obx(() {
                              return Text(cHome.monthPercent);
                            }),
                            DView.spaceHeight(10),
                            const Text("Atau setara: "),
                            Obx(() {
                              return (Text(
                                AppFormat.currency(
                                    cHome.differentMonth.toString()),
                                style: const TextStyle(
                                    color: AppColor.primary,
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold),
                              ));
                            })
                          ],
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ),
          ],
        ));
  }

  AspectRatio monthly(BuildContext context) {
    return AspectRatio(
      aspectRatio: 16 / 9,
      child: Stack(
        children: [
          // final data = cHome.ordinalDataList;
          Obx(() {
            return (DChartPieO(
              data: [
                OrdinalData(
                  domain: 'income',
                  measure: cHome.monthIncome,
                  color: Colors.blue[500],
                ),
                OrdinalData(
                  domain: 'outcome',
                  measure: cHome.monthOutcome,
                  color: Colors.blue[300],
                ),
                if (cHome.monthIncome == 0 && cHome.monthOutcome == 0)
                  OrdinalData(
                    domain: 'nol',
                    measure: 1,
                    color: const Color.fromARGB(255, 188, 209, 226),
                  ),
              ],
              configRenderPie: const ConfigRenderPie(
                arcWidth: 30,
              ),
            ));
          }),

          Center(child: Obx(() {
            return (Text(
              '${cHome.percentIncome}%',
              style: Theme.of(context).textTheme.headlineMedium,
            ));
          }))
        ],
      ),
    );
  }

  AspectRatio weekly(List<OrdinalGroup> ordinalGroup) {
    return AspectRatio(
        aspectRatio: 16 / 9,
        child: Obx(() {
          return (DChartBarO(
            areaColor: (group, ordinalData, index) {
              return Colors.green.withOpacity(0.3);
            },
            groupList: [
              OrdinalGroup(
                id: '1',
                data: List.generate(7, (index) {
                  return OrdinalData(
                      domain: cHome.weekText()[index],
                      measure: cHome.week[index]);
                }),
              ),
            ],
          ));
        }));
  }

  Material cardToday(BuildContext context) {
    return Material(
      borderRadius: BorderRadius.circular(16),
      elevation: 4,
      color: AppColor.primary,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 20, 16, 4),
            child: Obx(() {
              return (Text(
                AppFormat.currency(cHome.today.toString()),
                style: Theme.of(context).textTheme.headlineMedium!.copyWith(
                    fontWeight: FontWeight.bold, color: AppColor.secondary),
              ));
            }),
          ),
          Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 30),
              child: Obx(() {
                return (Text(
                  '${cHome.todayPercent}',
                  style: const TextStyle(color: Colors.white, fontSize: 16),
                ));
              })),
          Container(
            padding: const EdgeInsets.symmetric(vertical: 5),
            margin: const EdgeInsets.fromLTRB(16, 0, 0, 16),
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(8),
                bottomLeft: Radius.circular(8),
              ),
            ),
            child: const Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text(
                  'Selengkapnya',
                  style: TextStyle(color: AppColor.primary),
                ),
                Icon(
                  Icons.navigate_next,
                  color: AppColor.primary,
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
