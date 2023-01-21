import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Elastic Sidebar',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const ElasticSidebar(),
    );
  }
}

class ElasticSidebar extends StatefulWidget {
  const ElasticSidebar({super.key});

  @override
  State<ElasticSidebar> createState() => _ElasticSidebarState();
}

class _ElasticSidebarState extends State<ElasticSidebar> {
  Offset offset = const Offset(0, 0);
  bool isSidebarOpen = false;

  @override
  Widget build(BuildContext context) {
    Size mediaQuery = MediaQuery.of(context).size;
    double sidebarSize = mediaQuery.width * 0.65;
    double menuHeight = mediaQuery.height / 2;

    return Scaffold(
      body: Container(
        width: mediaQuery.width,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color.fromRGBO(255, 65, 108, 1.0),
              Color.fromRGBO(255, 75, 73, 1.0)
            ],
          ),
        ),
        child: Stack(
          children: [
            Center(
              child: MaterialButton(
                color: Colors.white,
                child: const Text("Elastic Sidebar"),
                onPressed: () {
                  if (!isSidebarOpen) {
                    setState(() => isSidebarOpen = true);
                  }
                },
              ),
            ),
            AnimatedPositioned(
              duration: const Duration(milliseconds: 1500),
              left: isSidebarOpen ? 0 : -sidebarSize + 20,
              top: 0,
              curve: Curves.elasticOut,
              child: SizedBox(
                width: sidebarSize,
                height: mediaQuery.height,
                child: GestureDetector(
                  onPanUpdate: (details) {
                    if (details.localPosition.dx <= sidebarSize) {
                      setState(() => offset = details.localPosition);
                    }
                    if (!isSidebarOpen) {
                      setState(() => isSidebarOpen = true);
                    }
                  },
                  onPanEnd: (details) =>
                      setState(() => offset = const Offset(0, 0)),
                  child: Stack(
                    children: [
                      CustomPaint(
                        size: Size(sidebarSize, mediaQuery.height),
                        painter: DrawerPainter(offset: offset),
                      ),
                      Container(
                        width: sidebarSize,
                        height: mediaQuery.height,
                        color: Colors.white,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            SizedBox(height: mediaQuery.height * 0.05),
                            Container(
                              height: mediaQuery.height * 0.25,
                              alignment: Alignment.center,
                              child: Icon(
                                Icons.person_pin,
                                size: mediaQuery.height * 0.15,
                                color: const Color.fromRGBO(255, 75, 73, 1.0),
                              ),
                            ),
                            const Divider(thickness: 1),
                            Container(
                              height: menuHeight,
                              width: double.infinity,
                              color: Colors.white,
                              child: Column(
                                children: [
                                  MyButton(
                                    text: "Profile",
                                    icon: Icons.person,
                                    height: menuHeight / 6,
                                  ),
                                  MyButton(
                                    text: "Payments",
                                    icon: Icons.payment,
                                    height: menuHeight / 6,
                                  ),
                                  MyButton(
                                    text: "Notifications",
                                    icon: Icons.notifications,
                                    height: menuHeight / 6,
                                  ),
                                  MyButton(
                                    text: "Settings",
                                    icon: Icons.settings,
                                    height: menuHeight / 6,
                                  ),
                                  MyButton(
                                    text: "Files",
                                    icon: Icons.attach_file,
                                    height: menuHeight / 5,
                                  ),
                                ],
                              ),
                            )
                          ],
                        ),
                      ),
                      AnimatedPositioned(
                        right: isSidebarOpen ? 10 : sidebarSize,
                        bottom: 20,
                        duration: const Duration(milliseconds: 400),
                        child: IconButton(
                          onPressed: () {
                            setState(() => isSidebarOpen = false);
                          },
                          icon: const Icon(
                            Icons.keyboard_backspace,
                            size: 25,
                            color: Colors.black54,
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class MyButton extends StatelessWidget {
  const MyButton({
    super.key,
    required this.text,
    required this.icon,
    required this.height,
  });
  final String text;
  final IconData icon;
  final double height;

  @override
  Widget build(BuildContext context) {
    return MaterialButton(
      height: height,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        mainAxisSize: MainAxisSize.max,
        children: [
          Icon(icon, color: Colors.black45, size: 20),
          const SizedBox(width: 10),
          Text(
            text,
            style: const TextStyle(color: Colors.black54, fontSize: 18),
          )
        ],
      ),
      onPressed: () {},
    );
  }
}

class DrawerPainter extends CustomPainter {
  DrawerPainter({required this.offset});
  final Offset offset;

  double getPointX(double width) {
    if (offset.dx == 0) {
      return width;
    }
    return offset.dx > width ? offset.dx : width + 75;
  }

  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.fill;
    Path path = Path();
    path.moveTo(-size.width, 0);
    path.lineTo(size.width, 0);
    path.quadraticBezierTo(
        getPointX(size.width), offset.dy, size.width, size.height);
    path.lineTo(-size.width, size.height);
    path.close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
