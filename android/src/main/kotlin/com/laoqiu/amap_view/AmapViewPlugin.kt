package com.laoqiu.amap_view

import android.app.Activity
import android.app.Application
import android.os.Bundle
import io.flutter.plugin.common.PluginRegistry.Registrar
import java.util.concurrent.atomic.AtomicInteger

class AmapViewPlugin(registrar: Registrar) : Application.ActivityLifecycleCallbacks {

    private val state = AtomicInteger(0)
    private val registrarActivityHashCode: Int

    companion object {

        internal val CREATED = 1
        // internal val STARTED = 2
        internal val RESUMED = 3
        internal val PAUSED = 4
        internal val STOPPED = 5
        internal val DESTROYED = 6

        @JvmStatic
        fun registerWith(registrar: Registrar) {
            if (registrar.activity() == null) {
                // When a background flutter view tries to register the plugin, the registrar has no activity.
                // We stop the registration process as this plugin is foreground only.
                return
            }

            val plugin = AmapViewPlugin(registrar)
            registrar.activity().application.registerActivityLifecycleCallbacks(plugin)
            registrar
                    .platformViewRegistry()
                    .registerViewFactory(
                            "plugins.laoqiu.com/amap_view", AmapFactory(plugin.state, registrar))

            // 注册定位组件
            AmapLocationFactory(registrar)

            // 注册导航组件
            AmapNaviFactory(registrar)

            // 注册搜索组件
            AmapSearchFactory(registrar)

            // 注册工具
            AmapUtilsFactory(registrar)
        }
    }

    override fun onActivityCreated(activity: Activity, savedInstanceState: Bundle?) {
        if (activity.hashCode() != registrarActivityHashCode) {
            return
        }
        state.set(CREATED)
    }

    override fun onActivityStarted(activity: Activity) {
        if (activity.hashCode() != registrarActivityHashCode) {
            return
        }
    }

    override fun onActivityResumed(activity: Activity) {
        if (activity.hashCode() != registrarActivityHashCode) {
            return
        }
        state.set(RESUMED)
    }

    override fun onActivityPaused(activity: Activity) {
        if (activity.hashCode() != registrarActivityHashCode) {
            return
        }
        state.set(PAUSED)
    }

    override fun onActivityStopped(activity: Activity) {
        if (activity.hashCode() != registrarActivityHashCode) {
            return
        }
        state.set(STOPPED)
    }

    override fun onActivitySaveInstanceState(activity: Activity, outState: Bundle) {}

    override fun onActivityDestroyed(activity: Activity) {
        if (activity.hashCode() != registrarActivityHashCode) {
            return
        }
        state.set(DESTROYED)
    }

    init {
        this.registrarActivityHashCode = registrar.activity().hashCode()
    }

}