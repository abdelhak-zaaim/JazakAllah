import android.content.BroadcastReceiver
import android.content.Context
import android.content.Intent
import android.content.pm.PackageManager

class AlarmReceiver : BroadcastReceiver() {
    override fun onReceive(context: Context, intent: Intent) {
        // This method is called when the BroadcastReceiver is receiving an Intent broadcast.
        // You can add your alarm action here.
        // For example, you can start the main activity of your app:

        val pm = context.packageManager
        val launchIntent = pm.getLaunchIntentForPackage("com.islamway.islamway")
        context.startActivity(launchIntent)
    }
}