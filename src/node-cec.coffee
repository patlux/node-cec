{spawn,exec}   = require 'child_process'
{EventEmitter} = require 'events'

# -------------------------------------------------------------------------- #
#    #NodeCEC
# -------------------------------------------------------------------------- #

emitLines      = require './lib/emitLines'
@CEC           = require './lib/cectypes'

CEC = @CEC

class @NodeCec extends EventEmitter

  constructor: ( @cecName=null ) ->
    @ready = false
    @stdinHandlers = [

      {
        contains: 'waiting for input'
        callback: ( line ) => @emit( 'ready', @ )
      }

      {
        match: /^TRAFFIC:/g
        callback: @processTraffic
      }

    ]

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

  send: ( message ) ->
    @client.stdin.write( message )

  sendCommand: ( command... ) ->
    command = command.map( (hex) -> hex.toString(16) )
    command = command.join( ':' )
    @send( 'tx ' + command )

  processLine: ( line ) ->
    @emit( 'line', line )

    for handler in @stdinHandlers

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

    command = traffic.substr( traffic.indexOf(']\t') + 2 ) # "<< 0f:..:.."
    command = command.substr( command.indexOf( ' ' ) + 1 ) # "0f:..:.."

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

    # no opcode?
    unless packet.tokens?.length > 1
      @emit( 'POLLING', packet )
      return

    switch packet.opcode

      # -------------------------------------------------------------------------- #
      #    #OSD

      when CEC.Opcode.SET_OSD_NAME
        break unless packet.args.length >= 1
        osdname = String.fromCharCode.apply( null, packet.args )
        @emit( 'SET_OSD_NAME', packet, osdname )
        return true



      # -------------------------------------------------------------------------- #
      #    #SOURCE / ADDRESS

      when CEC.Opcode.ROUTING_CHANGE # SOURCE CHANGED
        break unless packet.args.length >= 4
        from = packet.args[0] << 8 | packet.args[1]
        to   = packet.args[2] << 8 | packet.args[3]
        @emit( 'ROUTING_CHANGE', packet, from, to )
        return true

      when CEC.Opcode.ACTIVE_SOURCE
        break unless packet.args.length >= 2
        source   = packet.args[0] << 8 | packet.args[1]
        @emit( 'ACTIVE_SOURCE', packet, source )
        return true

      when CEC.Opcode.REPORT_PHYSICAL_ADDRESS
        break unless packet.args.length >= 2
        source = packet.args[0] << 8 | packet.args[1]
        @emit( 'REPORT_PHYSICAL_ADDRESS', packet, source, packet.args[2] )
        return true



      # -------------------------------------------------------------------------- #
      #    #OTHER

      else

        opcodes = CEC.Opcode
        for key, opcode of opcodes when opcode == packet.opcode
          @emit( key, packet, packet.args... ) if key?.length > 0
          return true



    # emit unhandled packet
    @emit( 'packet', packet )

    # not handled
    return false
