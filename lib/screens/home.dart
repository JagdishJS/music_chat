import '../library.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    double dh = MediaQuery.of(context).size.height;
    double dw = MediaQuery.of(context).size.width;
    return GetBuilder<CommonController>(
        init: CommonController(),
        builder: (commonController) {
          return Scaffold(
            backgroundColor: blackColor,
            body: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Music makes our love eternal',
                      style: Theme.of(context).textTheme.titleLarge),
                  SizedBox(height: 40),
                  GestureDetector(
                    onTap: () {
                      Get.toNamed("chat");
                    },
                    child: Card(
                      elevation: 2.0,
                      shadowColor: celodon,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      child: Container(
                        height: dh * 0.2,
                        width: dw * 0.9,
                        padding: EdgeInsets.all(8.0),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10.0),
                          boxShadow: [
                            BoxShadow(
                              color: celodon,
                              spreadRadius: 2,
                              blurRadius: 2,
                              offset: Offset(0, 1),
                            ),
                          ],
                        ),
                        child: Row(
                          children: [
                            Container(
                              width: dw * 0.22,
                              height: dh * 0.1,
                              decoration: BoxDecoration(
                                border: Border.all(
                                  color: whiteColor,
                                  width: 3.0,
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    color: green,
                                    spreadRadius: 2,
                                    blurRadius: 3,
                                    offset: Offset(0, 0),
                                  ),
                                ],
                                shape: BoxShape.circle,
                              ),
                              child: ClipOval(
                                child: Image.asset(
                                  'assets/app_logo/isai_janan.jpg',
                                  width: dw * 0.22,
                                  height: dh * 0.1,
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                            SizedBox(width: dw * 0.05),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text("Harmonize with \nyour soulmate",
                                    softWrap: true,
                                    overflow: TextOverflow.visible,
                                    style:
                                        Theme.of(context).textTheme.titleLarge),
                                SizedBox(height: 4.0),
                                Text(commonController.partnerName.value,
                                    softWrap: true,
                                    overflow: TextOverflow.visible,
                                    style:
                                        Theme.of(context).textTheme.titleLarge),
                                Text(commonController.partnerEmail.value,
                                    softWrap: true,
                                    overflow: TextOverflow.visible,
                                    style: Theme.of(context)
                                        .textTheme
                                        .labelMedium),
                                SizedBox(height: 4.0),
                                Text(
                                    'Last seen: \n${commonController.partnerLastSeen.value}',
                                    softWrap: true,
                                    overflow: TextOverflow.visible,
                                    style: Theme.of(context)
                                        .textTheme
                                        .labelMedium),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        });
  }
}
