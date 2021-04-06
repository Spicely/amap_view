package com.muka.amap_navi
import android.app.Activity
import android.os.Bundle
import android.util.Log
import android.view.View
import com.amap.api.navi.AMapNavi
import com.amap.api.navi.AMapNaviListener
import com.amap.api.navi.AMapNaviView
import com.amap.api.navi.AMapNaviViewListener
import com.amap.api.navi.enums.NaviType
import com.amap.api.navi.model.*


class AmapNaviActivity: Activity(), AMapNaviListener, AMapNaviViewListener {
    private var mAMapNaviView: AMapNaviView? = null
    private var mAMapNavi: AMapNavi? = null
    private var startLatLng: NaviLatLng? = null
    private var endLatLng: NaviLatLng? = null
    private var naviType: Int ? = null

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContentView(R.layout.activity_basic_navi)
//        Log.e("调试信息", "当前为导航页面")
        val bundle = this.intent.extras
        var startLat = bundle.getDouble("startLat")
        var startLng = bundle.getDouble("startLng")
        if (startLat != 0.0 && startLng != 0.0) {
            startLatLng = NaviLatLng(startLat, startLng)
        }
        endLatLng = NaviLatLng(bundle.getDouble("endLat"),bundle.getDouble("endLng"))
        naviType = bundle.getInt("naviType")
        mAMapNaviView = findViewById<View>(R.id.navi_view) as AMapNaviView
        mAMapNaviView?.onCreate(Bundle())
        mAMapNaviView?.setAMapNaviViewListener(this)
        mAMapNavi = AMapNavi.getInstance(applicationContext)
        mAMapNavi?.setUseInnerVoice(true)
        mAMapNavi?.addAMapNaviListener(this)
    }
    override fun onResume() {
        super.onResume()
        mAMapNaviView?.onResume()
    }

    override fun onPause() {
        super.onPause()
        mAMapNaviView?.onPause()
    }

    override fun onDestroy() {
        super.onDestroy()
        mAMapNaviView?.onDestroy()
        //since 1.6.0 不再在naviview destroy的时候自动执行AMapNavi.stopNavi();请自行执行
        mAMapNavi?.stopNavi()
    }

    override fun onNaviInfoUpdate(p0: NaviInfo?) {
    }

    override fun onCalculateRouteSuccess(p0: IntArray?) {
        Log.e("调试信息", "路径计算完成");
        mAMapNavi?.startNavi(NaviType.GPS);
    }

    override fun onCalculateRouteSuccess(p0: AMapCalcRouteResult?) {
        Log.e("调试信息", "路径计算完成");
        mAMapNavi?.startNavi(NaviType.GPS);
    }

    override fun onCalculateRouteFailure(p0: Int) {
    }

    override fun onCalculateRouteFailure(p0: AMapCalcRouteResult?) {
    }

    override fun onServiceAreaUpdate(p0: Array<out AMapServiceAreaInfo>?) {
    }

    override fun onGpsSignalWeak(p0: Boolean) {
    }

    override fun onEndEmulatorNavi() {
    }

    override fun onArrivedWayPoint(p0: Int) {
    }

    override fun onArriveDestination() {
    }

    override fun onPlayRing(p0: Int) {
    }

    override fun onTrafficStatusUpdate() {
    }

    override fun onGpsOpenStatus(p0: Boolean) {
    }

    override fun updateAimlessModeCongestionInfo(p0: AimLessModeCongestionInfo?) {
    }

    override fun showCross(p0: AMapNaviCross?) {
    }

    override fun onGetNavigationText(p0: Int, p1: String?) {
    }

    override fun onGetNavigationText(p0: String?) {
    }

    override fun updateAimlessModeStatistics(p0: AimLessModeStat?) {
    }

    override fun hideCross() {
    }

    override fun onInitNaviFailure() {
    }

    override fun onInitNaviSuccess() {
        Log.e("调试信息", "初始化完成");
        Log.e("调试信息", "计算导航路线");
//        Log.e("调试信息", endLatLng.toString());
        Log.e("调试信息", naviType.toString());
        if (naviType == 2) {
            if (startLatLng != null) {
                mAMapNavi?.calculateRideRoute(startLatLng, endLatLng)
            } else {
                Log.e("调试信息", endLatLng.toString());
                mAMapNavi?.calculateRideRoute(endLatLng)
            }
        } else {
            if (startLatLng != null) {
                mAMapNavi?.calculateWalkRoute(startLatLng, endLatLng)
            } else {
                mAMapNavi?.calculateWalkRoute(endLatLng)
            }
        }
    }

    override fun onReCalculateRouteForTrafficJam() {
    }

    override fun updateIntervalCameraInfo(p0: AMapNaviCameraInfo?, p1: AMapNaviCameraInfo?, p2: Int) {
    }

    override fun hideLaneInfo() {
    }

    override fun showModeCross(p0: AMapModelCross?) {
    }

    override fun updateCameraInfo(p0: Array<out AMapNaviCameraInfo>?) {
    }

    override fun hideModeCross() {
    }

    override fun onLocationChange(p0: AMapNaviLocation?) {
    }

    override fun onReCalculateRouteForYaw() {
    }

    override fun onStartNavi(p0: Int) {
    }

    override fun notifyParallelRoad(p0: Int) {
    }

    override fun OnUpdateTrafficFacility(p0: Array<out AMapNaviTrafficFacilityInfo>?) {
    }

    override fun OnUpdateTrafficFacility(p0: AMapNaviTrafficFacilityInfo?) {
    }

    override fun onNaviRouteNotify(p0: AMapNaviRouteNotifyData?) {
    }

    override fun showLaneInfo(p0: Array<out AMapLaneInfo>?, p1: ByteArray?, p2: ByteArray?) {
    }

    override fun showLaneInfo(p0: AMapLaneInfo?) {
    }

    override fun onNaviTurnClick() {
    }

    override fun onScanViewButtonClick() {
    }

    override fun onLockMap(p0: Boolean) {
    }

    override fun onMapTypeChanged(p0: Int) {
    }

    override fun onNaviCancel() {
    }

    override fun onNaviViewLoaded() {
    }

    override fun onNaviBackClick(): Boolean {
        finish()
        return true
    }

    override fun onNaviMapMode(p0: Int) {
    }

    override fun onNextRoadClick() {
    }

    override fun onNaviViewShowMode(p0: Int) {
    }

    override fun onNaviSetting() {
    }
}