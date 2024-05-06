package cn.privchat.messenger;
import android.util.Log;

import com.igexin.sdk.IUserLoggerInterface;
public class DebugLogger implements IUserLoggerInterface{
    @Override
    public void log(String s) {
        // 在这里处理调试日志的输出，例如打印到Logcat中
        Log.d("PushDebugLog", s);
    }
}
