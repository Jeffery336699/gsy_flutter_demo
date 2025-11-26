import Flutter
import UIKit

/// PlatformView Factory - 创建原生进度条视图
class NativeProgressBarFactory: NSObject, FlutterPlatformViewFactory {
    private var messenger: FlutterBinaryMessenger
    private static var progressBars: [NativeProgressBar] = []

    init(messenger: FlutterBinaryMessenger) {
        self.messenger = messenger
        super.init()
    }

    func create(
        withFrame frame: CGRect,
        viewIdentifier viewId: Int64,
        arguments args: Any?
    ) -> FlutterPlatformView {
        let progressBar = NativeProgressBar(
            frame: frame,
            viewIdentifier: viewId,
            arguments: args,
            binaryMessenger: messenger
        )
        NativeProgressBarFactory.progressBars.append(progressBar)
        return progressBar
    }

    func createArgsCodec() -> FlutterMessageCodec & NSObjectProtocol {
        return FlutterStandardMessageCodec.sharedInstance()
    }

    static func updateProgress(_ progress: Float) {
        for progressBar in progressBars {
            progressBar.updateProgress(progress)
        }
    }
}

/// 原生进度条 PlatformView
class NativeProgressBar: NSObject, FlutterPlatformView {
    private var _view: UIView
    private var progressView: UIProgressView

    init(
        frame: CGRect,
        viewIdentifier viewId: Int64,
        arguments args: Any?,
        binaryMessenger messenger: FlutterBinaryMessenger?
    ) {
        _view = UIView(frame: frame)
        _view.backgroundColor = .clear

        // 创建 UIProgressView
        progressView = UIProgressView(progressViewStyle: .default)
        progressView.translatesAutoresizingMaskIntoConstraints = false

        // 设置初始进度
        var initialProgress: Float = 0.5
        if let params = args as? [String: Any],
           let progress = params["progress"] as? Double {
            initialProgress = Float(progress)
        }
        progressView.progress = initialProgress

        // 设置样式
        progressView.progressTintColor = .systemBlue
        progressView.trackTintColor = .systemGray4
        progressView.transform = CGAffineTransform(scaleX: 1, y: 2.5) // 增加高度

        super.init()

        _view.addSubview(progressView)

        // 设置约束
        NSLayoutConstraint.activate([
            progressView.leadingAnchor.constraint(equalTo: _view.leadingAnchor, constant: 20),
            progressView.trailingAnchor.constraint(equalTo: _view.trailingAnchor, constant: -20),
            progressView.centerYAnchor.constraint(equalTo: _view.centerYAnchor)
        ])
    }

    func view() -> UIView {
        return _view
    }

    func updateProgress(_ progress: Float) {
        DispatchQueue.main.async {
            self.progressView.setProgress(progress, animated: true)
        }
    }
}

