package cn.privchat.messenger;
import android.os.Bundle;
import android.os.PersistableBundle;
import com.igexin.sdk.IUserLoggerInterface;
import androidx.annotation.Nullable;
import com.igexin.sdk.PushManager;
import io.flutter.embedding.android.FlutterActivity;

public class MainActivity extends FlutterActivity {
    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        PushManager.getInstance().initialize(this);
        if (BuildConfig.DEBUG) {
            PushManager.getInstance().setDebugLogger(this, new DebugLogger());
        }
    }
}
