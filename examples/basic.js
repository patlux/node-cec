// -------------------------------------------------------------------------- //
// Example: basic.js
// For more cec-events: http://www.cec-o-matic.com/
// -------------------------------------------------------------------------- //

var nodecec = require( '../' );

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
