import '../library.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  int _selectedIndex = 0;

  void _onDrawerItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
    Navigator.pop(context);
  }

  @override
  void initState() {
    super.initState();
  }

  final List<Widget> _pages = [
    HomePage(),
  ];

  @override
  Widget build(BuildContext context) {
    double dh = MediaQuery.of(context).size.height;
    double dw = MediaQuery.of(context).size.width;
    return GetBuilder<CommonController>(
        init: CommonController(),
        builder: (commonController) {
          return Scaffold(
            backgroundColor: blackColor,
            appBar: AppBar(
              backgroundColor: blackColor,
              leading: Builder(builder: (BuildContext context) {
                return IconButton(
                  icon: Icon(
                    Icons.menu_rounded,
                    color: whiteColor,
                    size: dh * .04,
                  ),
                  onPressed: () {
                    Scaffold.of(context).openDrawer();
                  },
                );
              }),
            ),
            drawer: Drawer(
              backgroundColor: blackColor,
              child: Column(
                children: <Widget>[
                  DrawerHeader(
                    decoration: BoxDecoration(color: celodon),
                    child: SizedBox(
                      width: dw,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('11:11',
                              style: Theme.of(context)
                                  .textTheme
                                  .titleLarge!
                                  .copyWith(
                                    fontSize: dh * 0.09,
                                  )),
                          Align(
                            alignment: Alignment.bottomRight,
                            child: Text('I TOLD THE STARS ABOUT YOU!',
                                style: Theme.of(context).textTheme.titleSmall),
                          ),
                          Align(
                            alignment: Alignment.bottomRight,
                            child: Text('11/11/24 11:11 AM',
                                style: Theme.of(context).textTheme.titleSmall),
                          ),
                        ],
                      ),
                    ),
                  ),
                  ListTile(
                    leading: Icon(Icons.chat_rounded,
                        color: Theme.of(context)
                            .iconTheme
                            .color), // You can change the color
                    title: Text(
                        'Chat With ${commonController.partnerName.value}',
                        style: Theme.of(context).textTheme.titleMedium),
                    onTap: () => _onDrawerItemTapped(
                        0), // Change this to the index of the page
                  ),
                  Spacer(),
                  ListTile(
                    title: Text('🎶 Time to take a break? \nSign out now! 🎧',
                        style: Theme.of(context).textTheme.displayLarge),
                    onTap: () async {
                      commonController.signOut();
                    }, // Change this to the index of the page
                  ),
                ],
              ),
            ),
            body: _pages[_selectedIndex],
          );
        });
  }
}
