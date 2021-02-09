package com.awesomeproject.components;

import android.util.Log;
import android.view.View;
import android.widget.EditText;

import com.facebook.react.bridge.Arguments;
import com.facebook.react.bridge.ReactApplicationContext;
import com.facebook.react.bridge.WritableMap;
import com.facebook.react.common.MapBuilder;
import com.facebook.react.uimanager.SimpleViewManager;
import com.facebook.react.uimanager.ThemedReactContext;
import com.facebook.react.uimanager.annotations.ReactProp;
import com.facebook.react.uimanager.events.RCTEventEmitter;
import com.google.android.material.textfield.TextInputLayout;

import java.util.HashMap;
import java.util.Map;

import androidx.annotation.NonNull;
import androidx.annotation.Nullable;

public class RNMaskedEditTextModule extends SimpleViewManager<TextInputLayout> {

    private final static String TAG = "RNMaskedEditTextModule";

    private final ReactApplicationContext mCallerContext;

    public RNMaskedEditTextModule(ReactApplicationContext reactContext) {
        mCallerContext = reactContext;
    }

    @NonNull
    @Override
    public String getName() {
        return "RNMaskedEditText";
    }

    @NonNull
    @Override
    protected synchronized TextInputLayout createViewInstance(@NonNull ThemedReactContext reactContext) {
        TextInputLayout inputLayout = new TextInputLayout(reactContext);
        inputLayout.setId(View.generateViewId());
        FormatterEditText editText = new FormatterEditText(reactContext);
        editText.setFormatterListener(new FormatterEditText.OnFormatterListener() {
            @Override
            public void onTextChange(String text) {
                WritableMap map = Arguments.createMap();
                map.putString("text", text);
                mCallerContext.getJSModule(RCTEventEmitter.class).receiveEvent(inputLayout.getId(),
                        "onTextChanged", map);
            }

            @Override
            public void onEndReached(String text) {
                WritableMap event = Arguments.createMap();
                event.putString("text", text);
                mCallerContext.getJSModule(RCTEventEmitter.class).receiveEvent(inputLayout.getId(),
                        "onLimitReached", event);
            }

            @Override
            public void onFocusChanged(String text, boolean focus) {
                WritableMap map = Arguments.createMap();
                map.putString("text", text);
                map.putBoolean("focus", focus);
                mCallerContext.getJSModule(RCTEventEmitter.class).receiveEvent(inputLayout.getId(),
                        "onFocusChange", map);
            }
        });
        inputLayout.addView(editText);
        return inputLayout;
    }

    @Nullable
    @Override
    public Map<String, Object> getExportedCustomDirectEventTypeConstants() {
        Map<String, Object> map = new HashMap<>();
        map.put("onTextChanged", MapBuilder.of("registrationName", "onTextChanged"));
        map.put("onFocusChange", MapBuilder.of("registrationName", "onFocusChange"));
        map.put("onLimitReached", MapBuilder.of("registrationName", "onLimitReached"));
        return map;
    }

    @ReactProp(name = "hint")
    public void setHint(TextInputLayout layout, String hint) {
        layout.setHint(hint);
    }

    @ReactProp(name = "error")
    public void setError(TextInputLayout layout, String error) {
        layout.setError(error);
    }

    @ReactProp(name = "pattern")
    public void setPattern(TextInputLayout inputLayout, String pattern) {
        FormatterEditText editText = (FormatterEditText) inputLayout.getEditText();
        editText.setPattern(pattern);
    }

    @ReactProp(name = "digits")
    public void setDigits(TextInputLayout inputLayout, String digits) {
        FormatterEditText editText = (FormatterEditText) inputLayout.getEditText();
        editText.setDigits(digits);
    }

    @ReactProp(name = "textValue")
    public void setText(TextInputLayout inputLayout, String textValue) {
        EditText editText = inputLayout.getEditText();
        Log.d(TAG, "--- setText -- " + textValue);
        if (editText != null && textValue.length() > 0) {
            Log.d(TAG, "--- setText IF--");
            editText.setText(textValue);
        }
    }

    @ReactProp(name = "hiddenChar")
    public void setHiddenCharacter(TextInputLayout inputLayout, String hiddenChar) {
        FormatterEditText editText = (FormatterEditText) inputLayout.getEditText();
        if (editText != null && hiddenChar.length() > 0) {
            editText.setHiddenCharacter(hiddenChar);
            editText.setEnabled(false);
        }
    }
}
