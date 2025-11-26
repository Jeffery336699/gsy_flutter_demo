import 'package:flutter/material.dart';

///Stack + Positioned例子
class PositionedDemoPage extends StatelessWidget {
  const PositionedDemoPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("PositionedDemoPage"),
      ),
      body: Container(
        width: MediaQuery.sizeOf(context).width,
        height: MediaQuery.sizeOf(context).height,
        margin: const EdgeInsets.all(15),
        child: Stack(
          children: <Widget>[
            MaterialButton(
              onPressed: () {},
              color: Colors.blue,
              child: Text('1', style: Theme.of(context).textTheme.headlineSmall),
            ),
            Positioned(
                left: MediaQuery.sizeOf(context).width / 2,
                child: MaterialButton(
                  onPressed: () {},
                  color: Colors.greenAccent,
                  child: Text('2', style: Theme.of(context).textTheme.headlineSmall),
                )),
            Positioned(
              left: MediaQuery.sizeOf(context).width / 5,
              top: MediaQuery.sizeOf(context).height / 4 * 3,
              child: MaterialButton(
                onPressed: () {},
                color: Colors.yellow,
                child: Text('3', style: Theme.of(context).textTheme.headlineSmall),
              ),
            ),
            Positioned(
              left: MediaQuery.sizeOf(context).width / 2 - Theme.of(context).buttonTheme.minWidth / 2,
              top: MediaQuery.sizeOf(context).height / 2 - MediaQuery.paddingOf(context).top - kToolbarHeight,
              child: MaterialButton(
                onPressed: () {},
                color: Colors.redAccent,
                child: Text('4', style: Theme.of(context).textTheme.headlineSmall),
              ),
            ),
            Positioned(
              left: MediaQuery.sizeOf(context).width / 2 - Theme.of(context).buttonTheme.minWidth / 2,
              top: (MediaQuery.sizeOf(context).height - MediaQuery.paddingOf(context).top - kToolbarHeight) / 2,
              child: MaterialButton(
                onPressed: () {},
                color: Colors.purpleAccent,
                child: Text('5', style: Theme.of(context).textTheme.headlineSmall),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
