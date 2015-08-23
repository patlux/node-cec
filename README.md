# node-cec
cec-client wrapper in nodejs

## Install

```bash
npm install --save node-cec
```

## Example

```coffeescript
{ NodeCec, CEC } = require( 'node-cec' )

cec = new NodeCec( 'node-cec-monitor' )

cec.once( 'ready', ( client ) ->
  console.log ' -- READY -- '
  client.sendCommand( 0xf0, CEC.Opcode.GIVE_DEVICE_POWER_STATUS )
)

# events from: http://www.cec-o-matic.com/
cec.on( 'REPORT_POWER_STATUS', ( packet, status ) ->
  for power_status_name, power_status of CEC.PowerStatus when power_status == status
    console.log "POWER_STATUS: #{power_status_name}"
    break
)

cec.on( 'ROUTING_CHANGE', ( packet, fromSource, toSource ) ->

  console.log( "Routing changed from #{fromSource} to #{toSource}." )

)

# -m  = start in monitor-mode
# -d8 = set log level to 8 (=TRAFFIC) (-d 8)
# -br = logical address set to `recording device`
cec.start( 'cec-client', '-m', '-d', '8', '-b', 'r' )
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
