{spawn,exec}        = require 'child_process'
{EventEmitter} = require 'events'
emitLines      = require './lib/emitLines'
@CecBus      = require './lib/cec-bus'

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
      packet.opcode = tokens[1]
      packet.args = command.substr( command.indexOf(packet.opcode + ':' ) + packet.opcode.length + 1  ).split( ':' )


    @emit( 'packet', packet )





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
