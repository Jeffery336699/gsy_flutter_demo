import 'dart:async';
import 'dart:ui' as ui;

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';


class InheritedModelDemo extends StatelessWidget {
  const InheritedModelDemo({super.key});

  @override
  Widget build(BuildContext context) {
    /// MediaQuery.of(context).size
    ///   依赖性: 这个方法会使你的 Widget 依赖于整个 MediaQueryData 对象。MediaQueryData 包含了屏幕尺寸、内边距、视图插入（如键盘）、设备像素比等多种信息。
    ///   重建: 只要 MediaQueryData 中的任何属性发生变化（例如，软键盘弹出导致 viewInsets 改变、屏幕旋转导致 size 改变、系统主题改变导致 platformBrightness 改变），
    ///   调用了 MediaQuery.of(context) 的 Widget 的 build 方法就会被重新触发。
    /// MediaQuery.sizeOf(context)
    ///   依赖性: 这是 MediaQuery.of(context).size 的一个优化版本。它只会使你的 Widget 依赖于 MediaQueryData 的 size 属性。
    ///   重建: 只有当 MediaQueryData.size 发生变化时（例如屏幕旋转），Widget 才会重建。如果仅仅是软键盘弹出（改变 viewInsets）或者主题改变，Widget 不会因此重建。

    /// print("######### MyHomePage ${MediaQuery.of(context).size}");
    print("######### MyHomePage(sizeOf) ${MediaQuery.sizeOf(context)}");
    return Scaffold(
      body: Container(
        alignment: Alignment.center,
        child: InkWell(
          onTap: () {
            Navigator.of(context).push(CupertinoPageRoute(builder: (context) {
              return EditPage();
            }));
          },
          child: const Text(
            "Click22",
            style: TextStyle(fontSize: 50),
          ),
        ),
      ),
    );
  }
}

class EditPage extends StatelessWidget {
  const EditPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("ControllerDemoPage"),
      ),
      extendBody: true,
      body: Column(
        children: [
          const Spacer(),
          Container(
            margin: const EdgeInsets.all(10),
            child: const Center(
              child: TextField(),
            ),
          ),
          const Spacer(),
        ],
      ),
    );
  }
}


