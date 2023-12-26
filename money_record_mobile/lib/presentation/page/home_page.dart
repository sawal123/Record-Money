import 'package:d_chart/d_chart.dart';
import 'package:d_view/d_view.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:money_record_mobile/config/app_asset.dart';
import 'package:money_record_mobile/config/app_color.dart';
import 'package:money_record_mobile/config/session.dart';
import 'package:money_record_mobile/presentation/controller/c_user.dart';
import 'package:money_record_mobile/presentation/page/auth/login_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<OrdinalData> ordinalList = [
    OrdinalData(domain: 'Mon', measure: 3),
    OrdinalData(domain: 'Tue', measure: 5),
    OrdinalData(domain: 'Wed', measure: 9),
    OrdinalData(domain: 'Thu', measure: 6.5),
    OrdinalData(domain: 'Sat', measure: 6.5),
    OrdinalData(domain: 'Sun', measure: 6.5),
  ];

  List<OrdinalData> ordinalDataList = [
    OrdinalData(domain: 'Mon', measure: 40, color: Colors.blue[500]),
    OrdinalData(domain: 'Sat', measure: 60, color: Colors.blue[300]),
  ];

  @override
  Widget build(BuildContext context) {
    final ordinalGroup = [
      OrdinalGroup(
        id: '1',
        data: ordinalList,
      ),
    ];
    final cUser = Get.put(CUser());
    return Scaffold(
        endDrawer: Drawer(
            child: ListView(
          children: [
            DrawerHeader(
              padding: EdgeInsets.fromLTRB(16, 20, 16, 20),
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
                                  style: TextStyle(
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
              onTap: () {},
              leading: Icon(Icons.add),
              horizontalTitleGap: 0,
              title: Text('Tambah Baru'),
              trailing: Icon(Icons.navigate_next),
            ),
            const Divider(height: 1),
            ListTile(
              onTap: () {},
              leading: Icon(Icons.south_west),
              horizontalTitleGap: 0,
              title: Text('Pemasukan'),
              trailing: Icon(Icons.navigate_next),
            ),
            const Divider(height: 1),
            ListTile(
              onTap: () {},
              leading: Icon(Icons.north_east),
              horizontalTitleGap: 0,
              title: Text('Pengeluaran'),
              trailing: Icon(Icons.navigate_next),
            ),
            const Divider(height: 1),
            ListTile(
              onTap: () {},
              leading: Icon(Icons.history),
              horizontalTitleGap: 0,
              title: Text('Riwayat'),
              trailing: Icon(Icons.navigate_next),
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
              child: ListView(
                padding: EdgeInsets.fromLTRB(20, 0, 20, 30),
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
                              Text("Pemasukan")
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
                              Text("Pengeluaran")
                            ],
                          ),
                          DView.spaceHeight(20),
                          Text("Pemasukan"),
                          Text("Lebih besar 20%"),
                          Text("dari pengeluaran"),
                          DView.spaceHeight(10),
                          Text("Atau setara: "),
                          Text(
                            "Rp20.000.00",
                            style: TextStyle(
                                color: AppColor.primary,
                                fontSize: 18,
                                fontWeight: FontWeight.bold),
                          )
                        ],
                      ),
                    ],
                  )
                ],
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
          DChartPieO(
            data: ordinalDataList,
            configRenderPie: const ConfigRenderPie(
              arcWidth: 30,
            ),
          ),
          Center(
              child: Text(
            "60%",
            style: Theme.of(context).textTheme.headlineMedium,
          )),
        ],
      ),
    );
  }

  AspectRatio weekly(List<OrdinalGroup> ordinalGroup) {
    return AspectRatio(
      aspectRatio: 16 / 9,
      child: DChartBarO(
        areaColor: (group, ordinalData, index) {
          return Colors.green.withOpacity(0.3);
        },
        groupList: ordinalGroup,
      ),
    );
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
            child: Text('Rp 500.000',
                style: Theme.of(context).textTheme.headlineMedium!.copyWith(
                    fontWeight: FontWeight.bold, color: AppColor.secondary)),
          ),
          const Padding(
            padding: EdgeInsets.fromLTRB(16, 0, 16, 30),
            child: Text(
              '+20% dibanding kemarin',
              style: TextStyle(color: Colors.white, fontSize: 16),
            ),
          ),
          Container(
            padding: EdgeInsets.symmetric(vertical: 5),
            margin: EdgeInsets.fromLTRB(16, 0, 0, 16),
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
