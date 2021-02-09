package com.awesomeproject.components;

import android.content.Context;
import android.text.Editable;
import android.text.InputFilter;
import android.text.InputType;
import android.text.SpannableStringBuilder;
import android.text.TextWatcher;
import android.text.method.DigitsKeyListener;
import android.util.Log;
import android.view.View;

import androidx.appcompat.widget.AppCompatEditText;

public class FormatterEditText extends AppCompatEditText {

    private static final String TAG = "FormatterEditText";
    private String mPattern;
    private String mDigits;
    private int mPrevLength = 0;
    private String mHiddenChar ;
    private OnFormatterListener mListener;

    private String regex =  "[^[0-9][A-Z][a-z]]";

    public FormatterEditText(Context context) {
        super(context);
        mPattern = "";
        mDigits = "";
        mHiddenChar = "";
        addTextChangedListener(watcher);
        OnFocusChangeListener focusChange = (view, focus) -> {
            if (mListener != null) {
                String text = getText().toString();
                mListener.onFocusChanged(text, focus);
            }
        };
        setOnFocusChangeListener(focusChange);
    }

    public void setFormatterListener(OnFormatterListener listener) {
        mListener = listener;
    }

    public void setPattern(String pattern) {
        mPattern = pattern;
        updateFilters();
    }

    public void setDigits(String digits) {
        mDigits = digits;
        if (mDigits.length() > 0) {
            setKeyListener(DigitsKeyListener.getInstance(digits));
            if (isAlphabetExist(digits)) {
                setInputType(InputType.TYPE_TEXT_FLAG_CAP_WORDS);
            } else {
                setInputType(InputType.TYPE_CLASS_NUMBER);
            }
        }
        updateFilters();
    }

    public void setHiddenCharacter(String hiddenChar) {
        mHiddenChar = hiddenChar;
        if (mHiddenChar != null && mHiddenChar.length() > 0) {
            regex = "[^[0-9][A-Z][a-z][" + mHiddenChar + "]]";
        }
    }

    private void updateFilters() {
        if (mPattern.length() > 0) {
            setFilters(new InputFilter[]{new InputFilter.LengthFilter(mPattern.length()), inputFilter});
        }
    }

    private final TextWatcher watcher = new TextWatcher() {
        @Override
        public void beforeTextChanged(CharSequence charSequence, int i, int i1, int i2) {

        }

        @Override
        public void onTextChanged(CharSequence charSequence, int start, int after, int count) {
            formatter(charSequence, start);
        }

        @Override
        public void afterTextChanged(Editable editable) {
            if (mListener != null) {
                mListener.onTextChange(editable.toString());
            }

            if (mPattern.length() > 0 && editable.length() == mPattern.length()) {
                mListener.onEndReached(editable.toString());
            }
        }
    };

    private final InputFilter inputFilter = (charSequence, i, i1, spanned, i2, i3) -> {
        if (charSequence.toString().matches("[ ,./]")) {
            return "";
        }

        return null;
    };

    private void formatter(CharSequence sequence,
                           int start) {
        if (mPattern == null || mPattern.length() == 0) {
            return;
        }
        char[] patternChars = mPattern.toCharArray();

        SpannableStringBuilder charBuilder = new SpannableStringBuilder(sequence);
        System.out.println("--- REGEX --- " + regex);
        String formattingText = charBuilder.toString().replaceAll(regex, "");
        if (formattingText.length() <= 0) {
            return;
        }

        SpannableStringBuilder builder = new SpannableStringBuilder();
        int patternPosition = 0;
        for (int i = 0; i < formattingText.length(); i++) {
            char textChar = formattingText.charAt(i);
            if (mPattern.length() > 0) {
                if (isInt(textChar)) {
                    char patternChar = patternChars[patternPosition++];
                    while (patternChar != '#') {
                        builder.append(patternChar);
                        patternChar = patternChars[patternPosition++];
                    }

                    char letter = Character.toUpperCase(textChar);
                    builder.append(letter);
                }
            } else {
                char letter = Character.toUpperCase(textChar);
                builder.append(letter);
            }
        }

        int position = builder.length();
        if (mPrevLength > builder.length() && !isAlphabetExist(builder.toString())) {
            position = getPosition(mPattern, start);
        }

        mPrevLength = builder.length();
        removeTextChangedListener(watcher);
        setText(builder);
        setSelection(position);
        addTextChangedListener(watcher);
    }

    private int getPosition(String pattern, int position) {
        char[] patternChars = pattern.toCharArray();
        if (position == 0 || position == 1) {
            return position;
        }

        if (patternChars[position - 1] == '#') {
            return position;
        }
        return getPosition(pattern, --position);
    }

    private boolean isInt(char number) {
        try {
            Integer.parseInt(number + "");
            return true;
        } catch (Exception e) {
            return isChar(number);
        }
    }

    private boolean isAlphabetExist(String text) {
        for (int i = 0; i < text.length(); i++) {
            char letter = text.charAt(i);
            if (isChar(letter)) {
                return true;
            }
        }

        return false;
    }

    private boolean isChar(char letter) {
        return (letter >= 'A' && letter <= 'Z') || (letter >= 'a' && letter <= 'z') || (mHiddenChar.length() > 0);
    }

    public interface OnFormatterListener {
        void onTextChange(String text);
        void onEndReached(String text);
        void onFocusChanged(String text, boolean focus);
    }

}
