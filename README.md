# node-cec
cec-client wrapper in nodejs

## Install

```bash
npm install --save node-cec
```

## Example

#### Output

![](https://cloud.githubusercontent.com/assets/4481570/15092052/2fce287a-145e-11e6-928b-9ed1fa9caadb.jpg)

#### Source

```javascript
// -------------------------------------------------------------------------- //
// Example: basic.js
// For more cec-events: http://www.cec-o-matic.com/
// -------------------------------------------------------------------------- //

var nodecec = require( 'node-cec' );

var NodeCec = nodecec.NodeCec;
var CEC     = nodecec.CEC;

var cec = new NodeCec( 'node-cec-monitor' );


// -------------------------------------------------------------------------- //
//- KILL CEC-CLIENT PROCESS ON EXIT

process.on( 'SIGINT', function() {
  if ( cec != null ) {
    cec.stop();
  }
  process.exit();
});


// -------------------------------------------------------------------------- //
//- CEC EVENT HANDLING

cec.once( 'ready', function(client) {
  console.log( ' -- READY -- ' );
  client.sendCommand( 0xf0, CEC.Opcode.GIVE_DEVICE_POWER_STATUS );
});

cec.on( 'REPORT_POWER_STATUS', function (packet, status) {
  var keys = Object.keys( CEC.PowerStatus );

  for (var i = keys.length - 1; i >= 0; i--) {
    if (CEC.PowerStatus[keys[i]] == status) {
      console.log('POWER_STATUS:', keys[i]);
      break;
    }
  }

});

cec.on( 'ROUTING_CHANGE', function(packet, fromSource, toSource) {
  console.log( 'Routing changed from ' + fromSource + ' to ' + toSource + '.' );
});


// -------------------------------------------------------------------------- //
//- START CEC CLIENT

// -m  = start in monitor-mode
// -d8 = set log level to 8 (=TRAFFIC) (-d 8)
// -br = logical address set to `recording device`
cec.start( 'cec-client', '-m', '-d', '8', '-b', 'r' );
```



# License

The MIT License (MIT)

Copyright (c) 2015 Patrick Wozniak

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in
all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
THE SOFTWARE.
