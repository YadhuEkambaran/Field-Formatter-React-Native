# Field-Formatter-React-Native
It is project for formatting TextField/EditText. The react component that can format the number or text data.

It is able to format any number formatting. 

 and specify the digits to be allowed in the keyboard through *digits* property
For specifiing pattern
```
pattern={'#### #### #### ####'}
```
or
```
pattern={'##/##'}
```
or
```
pattern={'(###) ### ####'}
```
Note: always use *#* as the placeholder for pattern

For specifing digits to be allowed in the field
```
digits={'1234567890 '}
```
or
```
digits={'1234567890/'}
```
or
```
digits={'1234567890() '}
```

For giving a hint 
```
hint={'Card number'}
```

For showing error beneath the edittext line
```
error={'Error text '}
```

There are three callbacks for getting details from components

- onTextChanged
- onFocusChange
- onLimitReached

#### onTextChanged
This gets called for every text change the user makes. it returns the entire text of the field.

#### onFocusChange
This gets called for focus change.

#### onLimitReached
This gets called when the text reaches the limit based the length of the pattern.


## This is an EXAMPLE
Here the component is formatting a Credit card number.
```
<RNMaskedView
        style={styles.patternText}
        hint={'Card Number'}
        digits={'0987654321 '}
        pattern={'#### #### #### ####'}
        error={'Error text here'}
        onTextChanged={(text) => {
          console.log('CARDNO -- ' + text);
        }}
        onFocusChange={(text, focus) => {
          if (!focus) {
            console.log('CARDNO -- ' + text);
          }
        }}
        onLimitReached={(text) => {
          console.log('CARDNO -- ' + text);
        }}
        textValue={tempCardNo}
      />
 ```
