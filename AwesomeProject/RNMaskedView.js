import React, {Component} from 'react';
import PropTypes from 'prop-types';
import {View, requireNativeComponent} from 'react-native';

class RNMaskedView extends Component {
  constructor(props) {
    super(props);
  }

  _onTextChanged = (event) => {
    console.log('--- EMIT RECEIVER _afterTextChanged ---');
    if (this.props.onTextChanged) {
      this.props.onTextChanged(event.nativeEvent.text);
    }
  };

  _onFocusChange = (event) => {
    console.log('--- EMIT RECEIVER _onFocusChange ---');
    if (this.props.onFocusChange) {
      console.log('--- EMIT RECEIVER INSIDE  ---');
      this.props.onFocusChange(event.nativeEvent.text, event.nativeEvent.focus);
    }
  };

  _onLimitReached = (event) => {
    console.log('--- EMIT RECEIVER _onLimitReached ---');
    if (this.props.onLimitReached) {
      this.props.onLimitReached(event.nativeEvent.text);
    }
  };

  render() {
    return (
      <RNMaskedEditText
        {...this.props}
        onTextChanged={this._onTextChanged}
        onFocusChange={this._onFocusChange}
        onLimitReached={this._onLimitReached}
      />
    );
  }
}

RNMaskedView.propTypes = {
  pattern: PropTypes.string,
  digits: PropTypes.string,
  error: PropTypes.string,
  hint: PropTypes.string,
  textValue: PropTypes.string,
  hiddenChar: PropTypes.string,
  onTextChanged: PropTypes.func,
  onFocusChange: PropTypes.func,
  onLimitReached: PropTypes.func,
  ...View.prototype,
};

const RNMaskedEditText = requireNativeComponent(
  'RNMaskedEditText',
  RNMaskedView,
);

module.exports = RNMaskedView;
