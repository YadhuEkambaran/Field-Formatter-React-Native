/**
 * Sample React Native App
 * https://github.com/facebook/react-native
 *
 * @format
 * @flow strict-local
 */

import React, { useState } from 'react';
import {
  SafeAreaView,
  StyleSheet,
  Text,
  View,
  StatusBar,
  KeyboardAvoidingView
} from 'react-native';

import {Colors} from 'react-native/Libraries/NewAppScreen';


import RNMaskedView from './RNMaskedView';

const App = () => {

  const [errorText, setError] = useState("");

  const validateCard = (text: String) => {
    
  }
  return (
    <>
      <StatusBar barStyle="dark-content" />
      <SafeAreaView >
        <View style={styles.sectionContainer}>
        <RNMaskedView
            style={styles.patternText}
            hint={'Name on card'}
            digits={'ABCDEFGHIJKLMNOPQRSTUVWXYZ0987654321 '}
            afterTextChanged={(text) => {
              console.log('--- NAME TEXT -- ' + text);
            }}
            onFocusChange={(text, focus) => {
              console.log('--- NAME TEXT -- ' + text);
              console.log('--- NAME FOCUS -- ' + focus);
            }}
          />
        <RNMaskedView
            style={styles.patternText}
            hint={'Card Number'}
            digits={'0987654321 '}
            pattern={'#### #### #### ####'}
            error={errorText}
            onTextChanged={(text) => {
              console.log('--- onTextChanged -- ' + text);
              validateCard(text)
            }}
            onFocusChange={(text, focus) => {
              console.log('onFocusChange -- ' + text);
            }}
            onLimitReached={(text) => {
              console.log('onLimitReached -- ' + text);
            }}
          />
          <RNMaskedView
            style={styles.patternText}
            hint={'Expiry'}
            digits={'0987654321/'}
            pattern={'##/##'}
            onTextChanged={(text) => {
              console.log('--- onTextChanged -- ' + text);
            }}
            onFocusChange={(text, focus) => {
              console.log('onFocusChange -- ' + text);
            }}
            onLimitReached={(text) => {
              console.log('onLimitReached -- ' + text);
            }}
          />

        
          <RNMaskedView
            style={styles.patternText}
            hint={'Mobile number'}
            digits={'0987654321() '}
            pattern={'(###) ### ####'}
            error={errorText}
            onTextChanged={(text) => {
              console.log('--- onTextChanged -- ' + text);
              validateCard(text)
            }}
            onFocusChange={(text, focus) => {
              console.log('onFocusChange -- ' + text);
            }}
            onLimitReached={(text) => {
              console.log('onLimitReached -- ' + text);
            }}
          />

          <RNMaskedView
            style={styles.patternText}
            hint={'PostalCode'}
            digits={'ABCDEFGHIJKLMNOPQRSTUVWXYZ0987654321'}
            pattern={'### ###'}
            onTextChanged={(text) => {
              console.log('--- onTextChanged -- ' + text);
            }}
            onFocusChange={(text, focus) => {
              console.log('onFocusChange -- ' + text);
            }}
            onLimitReached={(text) => {
              console.log('onLimitReached -- ' + text);
            }}
          />
          </View> 
      </SafeAreaView>
    </>
  );
};

const styles = StyleSheet.create({
  scrollView: {
    backgroundColor: Colors.lighter,
  },
  engine: {
    position: 'absolute',
    right: 0,
  },
  body: {
    backgroundColor: Colors.white,
  },
  sectionContainer: {
    marginVertical: 32,
    marginHorizontal: 24,
  },
  sectionTitle: {
    fontSize: 24,
    fontWeight: '600',
    color: Colors.black,
  },
  sectionDescription: {
    marginTop: 8,
    fontSize: 18,
    fontWeight: '400',
    color: Colors.dark,
  },
  highlight: {
    fontWeight: '700',
  },
  footer: {
    color: Colors.dark,
    fontSize: 12,
    fontWeight: '600',
    padding: 4,
    paddingRight: 12,
    textAlign: 'right',
  },
  patternText: {
    width: '80%',
    height: 80,
    marginTop: 4,
    marginHorizontal: 20,
  },
});

export default App;
