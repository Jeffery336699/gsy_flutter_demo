package com.gsy.shuyu.gsy_flutter_demo

import android.content.Context
import android.view.View
import android.widget.FrameLayout
import android.widget.ProgressBar
import io.flutter.plugin.platform.PlatformView
import io.flutter.plugin.platform.PlatformViewFactory
import io.flutter.plugin.common.StandardMessageCodec

/**
 * PlatformView Factory - 创建原生进度条视图
 */
class NativeProgressBarFactory : PlatformViewFactory(StandardMessageCodec.INSTANCE) {

    companion object {
        private val progressBars = mutableListOf<NativeProgressBar>()

        fun updateProgress(progress: Float) {
            progressBars.forEach { it.updateProgress(progress) }
        }
    }

    override fun create(context: Context, viewId: Int, args: Any?): PlatformView {
        val progressBar = NativeProgressBar(context, args)
        progressBars.add(progressBar)
        return progressBar
    }
}

/**
 * 原生进度条 PlatformView
 */
class NativeProgressBar(context: Context, creationParams: Any?) : PlatformView {

    private val container: FrameLayout = FrameLayout(context)
    // 创建水平进度条
    private val progressBar: ProgressBar = ProgressBar(context, null, android.R.attr.progressBarStyleHorizontal).apply {
        max = 100
        // 设置初始进度
        val params = creationParams as? Map<*, *>
        val initialProgress = (params?.get("progress") as? Double) ?: 0.5
        progress = (initialProgress * 100).toInt()

        // 设置样式
        layoutParams = FrameLayout.LayoutParams(
            FrameLayout.LayoutParams.MATCH_PARENT,
            50 // 高度设为 50dp
        ).apply {
            setMargins(40, 0, 40, 0) // 左右边距
        }
    }

    init {
        container.addView(progressBar)
    }

    override fun getView(): View {
        return container
    }

    fun updateProgress(progress: Float) {
        progressBar.progress = (progress * 100).toInt()
    }

    override fun dispose() {
        // 清理资源
    }
}

