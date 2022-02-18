import React, { useEffect } from 'react'
import { Text, View } from 'react-native'
import { setup } from 'ux-feedback'

const App = () => {
  useEffect(() => {
    setup({
      appID: {
        ios: 'Hahahaha',
        android: 'Android hahahah'
      },
      settings: {
        globalDelayTimer: 100,
        uiBlocked: true,
        closeOnSwipe: true,
        reconnectTimeout: 0,
      }
    })
    .then((status) => {
      console.log(status);
    });
  });

  return (
    <View>
      <Text style={{ color: 'black' }}>
        Init app
      </Text>
    </View>
  )
}

export default App
