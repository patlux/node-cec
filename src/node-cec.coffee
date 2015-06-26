{spawn,exec}   = require 'child_process'
{EventEmitter} = require 'events'
emitLines      = require './lib/emitLines'
@CEC      = require './lib/cectypes'

CEC = @CEC

# -------------------------------------------------------------------------- #
#    #NodeCEC
# -------------------------------------------------------------------------- #

class @NodeCec extends EventEmitter

  constructor: ( @cecName=null ) ->
    @ready = false

    @defineHandlers()

  start: ( @clientName = 'cec-client', @params... ) ->

    if @cecName?
      @params.push '-o'
      @params.push @cecName

    @client = spawn( @clientName, @params )
    emitLines( @client.stdout )

    @client.on( 'close', @onClose )

    @client.stdout.on( 'line', (line) =>

      @emit( 'data', line )
      @processLine( line )

    )

  stop: () ->
    @emit( 'stop', @ )

    @client.kill('SIGINT')
    exec( 'killall -9 ' + @clientName )

  onClose: () =>
    @emit( 'stop', @ )

  send: ( command ) ->
    @client.stdin.write( command )

  processLine: ( line ) ->

    for handler in @handlers

      if handler.contains?
        if line.indexOf( handler.contains ) >= 0
          handler.callback( line )

      else if handler.match?
        matches = line.match( handler.match )
        if matches?.length > 0
          handler.callback( line )

      else if handler.fn?
        if handler.fn( line )
          handler.callback( line )





  # -------------------------------------------------------------------------- #
  #    #TRAFFIC
  # -------------------------------------------------------------------------- #

  processTraffic: ( traffic ) =>
    packet = {}

    packet.line = traffic

    command = traffic.substr( traffic.indexOf(']\t') + 2 ) # << 0f:..:..

    packet.in = command.indexOf('>>') == 0

    command = command.substr( command.indexOf( ' ' ) + 1 ) # 0f:..:..
    tokens = command.split(':') # 0f .. ..

    if tokens?
      packet.tokens = tokens

    if tokens?.length > 0
      packet.source = tokens[0][0]
      packet.target = tokens[0][1]

    if tokens?.length > 1
      packet.opcode = parseInt( tokens[1], 16 )
      packet.args = tokens[2..tokens.length].map( (hexString) -> parseInt( hexString, 16 ) )


    @processPacket( packet )


  processPacket: ( packet ) ->

    unless packet.tokens?.length > 1
      @emit( 'POLLING', packet )
      return

    @emit( 'packet', packet )

    switch packet.opcode

      when CEC.Opcode.REPORT_POWER_STATUS
        list_status = [ 'ON', 'OFF', 'Standby to ON', 'ON to Standby' ]
        status = list_status[ packet.args[0] ]
        @emit( 'REPORT_POWER_STATUS', packet, status )

      # -------------------------------------------------------------------------- #
      #    #OSD

      when CEC.Opcode.SET_OSD_NAME
        osdname = String.fromCharCode.apply( null, packet.args )
        @emit( 'SET_OSD_NAME', packet, osdname )

      # -------------------------------------------------------------------------- #
      #    #SOURCE

      when CEC.Opcode.ROUTING_CHANGE
        from = packet.args[0..1].map (hex) -> hex.toString(16)
        to = packet.args[2..3].map (hex) -> hex.toString(16)
        @emit( 'ROUTING_CHANGE', packet, from, to )

      when CEC.Opcode.ACTIVE_SOURCE
        @emit( 'ACTIVE_SOURCE', packet, packet.args.join('') )

      # -------------------------------------------------------------------------- #
      #    #VENDOR

      when CEC.Opcode.DEVICE_VENDOR_ID
        args_vendorId = packet.args[0] + packet.args[1] + packet.args[2]
        packetVendorName = ''

        for vendorName, vendorId of CEC.VendorId when vendorId == args_vendorId
          packetVendorName = vendorName

        @emit( 'DEVICE_VENDOR_ID', packet, packetVendorName, args_vendorId )



      # -------------------------------------------------------------------------- #
      #    #OTHER

      when CEC.Opcode.REPORT_PHYSICAL_ADDRESS
        arg_address = packet.args[0] + packet.args[1]
        address = arg_address
        types = [ 'TV', 'Recording Device', 'Reserved', 'Tuner', 'Playback Device', 'Audio System' ]
        type = types[ packet.args[2] ]
        @emit( 'REPORT_PHYSICAL_ADDRESS', packet, address, type )

      else

        opcodes = CEC.Opcode
        for key, opcode of opcodes when opcode == packet.opcode
          @emit( key, packet ) if key?.length > 0



  @toAddressStr: ( address ) ->


  # -------------------------------------------------------------------------- #
  #    #HANDLERS
  # -------------------------------------------------------------------------- #

  defineHandlers: () ->

    @handlers = [

      {
        contains: 'waiting for input'
        callback: ( line ) => @emit( 'ready', @ )
      }

      {
        match: /^TRAFFIC:/g
        callback: @processTraffic
      }

      {
        match: /key pressed: (.+)\s\(/
        callback: ( line ) => @emit( 'debug', line )
      }

    ]
