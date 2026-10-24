package com.example.scamshield

import android.app.Notification
import android.content.Context
import android.content.Intent
import android.os.Build
import android.os.VibrationEffect
import android.os.Vibrator
import android.os.VibratorManager
import android.service.notification.NotificationListenerService
import android.service.notification.StatusBarNotification
import android.util.Log

class ScamNotificationListenerService : NotificationListenerService() {

    companion object {
        const val ACTION_NOTIFICATION_RECEIVED = "com.example.scamshield.NOTIFICATION_RECEIVED"
        private const val TAG = "ScamNotificationService"
    }

    override fun onNotificationPosted(sbn: StatusBarNotification?) {
        super.onNotificationPosted(sbn)
        if (sbn == null) return

        val packageName = sbn.packageName ?: ""
        if (packageName == applicationContext.packageName) return

        val extras = sbn.notification?.extras ?: return
        val title = extras.getCharSequence(Notification.EXTRA_TITLE)?.toString() ?: ""
        val text = extras.getCharSequence(Notification.EXTRA_TEXT)?.toString() ?: ""
        val subText = extras.getCharSequence(Notification.EXTRA_SUB_TEXT)?.toString() ?: ""

        val fullText = "$title $text $subText".trim()
        if (fullText.isEmpty()) return

        Log.d(TAG, "Notification received from $packageName: $fullText")

        val intent = Intent(ACTION_NOTIFICATION_RECEIVED).apply {
            putExtra("packageName", packageName)
            putExtra("title", title)
            putExtra("text", text)
            putExtra("time", System.currentTimeMillis())
        }
        sendBroadcast(intent)

        if (isSuspiciousText(fullText)) {
            triggerVibration()
        }
    }

    private fun isSuspiciousText(text: String): Boolean {
        val lower = text.lowercase()
        val scamKeywords = listOf(
            "kyc", "blocked", "suspend", "otp", "upi pin",
            "claim prize", "lottery", "urgent", "reward", "click here", "http://", "https://"
        )
        return scamKeywords.any { lower.contains(it) }
    }

    private fun triggerVibration() {
        try {
            if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.S) {
                val vibratorManager = getSystemService(Context.VIBRATOR_MANAGER_SERVICE) as? VibratorManager
                vibratorManager?.defaultVibrator?.vibrate(
                    VibrationEffect.createOneShot(400, VibrationEffect.DEFAULT_AMPLITUDE)
                )
            } else {
                @Suppress("DEPRECATION")
                val vibrator = getSystemService(Context.VIBRATOR_SERVICE) as? Vibrator
                @Suppress("DEPRECATION")
                vibrator?.vibrate(VibrationEffect.createOneShot(400, VibrationEffect.DEFAULT_AMPLITUDE))
            }
        } catch (e: Exception) {
            Log.e(TAG, "Vibration failed: ${e.message}")
        }
    }
}
