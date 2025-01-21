package com

import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import com.google.android.play.core.appupdate.AppUpdateManagerFactory
import com.google.android.play.core.install.model.UpdateAvailability
import android.content.IntentSender.SendIntentException
import android.util.Log

class MainActivity: FlutterActivity() {

    private val METHOD_CHANNEL = "pbgpl/meterReader"
    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        val appUpdateManager = AppUpdateManagerFactory.create(this)

        /*        val appUpdateInfoTask  = appUpdateManager.appUpdateInfo*/
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, METHOD_CHANNEL).setMethodCallHandler {
                request: MethodCall, response: MethodChannel.Result ->
            if (request.method == "getAppUpdate") {
                Log.i("NumberGenerated", "Function has generated zero.-------------------------");
                try {
                    appUpdateManager.appUpdateInfo.addOnSuccessListener { appUpdateInfo ->
                        try {
                            Log.i("NumberGenerated", "Function has generated Enter.-------------------------");
                            if (appUpdateInfo.updateAvailability() === UpdateAvailability.UPDATE_AVAILABLE) {
                                Log.i("NumberGenerated", "Function has generated Done.-------------------------");
                                response.success("success");
                            }else{
                                Log.i("NumberGenerated", "Function has generated Fauil.-------------------------");
                                response.success("fail");
                            }
                        } catch (e: SendIntentException) {
                            Log.i("NumberGenerated", "Function has generated SendIntentException.-------------------------");
                            Log.e("in_app_update", "Could not start update flow", e)
                            response.success(e)
                        }
                        Log.i("NumberGenerated", "Function has generated All Complete.-------------------------");

                    }
                    Log.i("NumberGenerated", "Function has generated All By Pass.-------------------------");

                }catch (ex: Exception) {
                    Log.i("NumberGenerated", "Function has generated All Complete.-------------------------");
                    response.success("fail Exception")
                }

            } else {
                response.success("fail Else")
            }
        }
    }
}
