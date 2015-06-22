# https://gist.github.com/TooTallNate/1785026

#
# A quick little thingy that takes a Stream instance and makes
# it emit 'line' events when a newline is encountered.
#   *
#   Usage:
#   ‾‾‾‾‾
#  emitLines(process.stdin)
#  process.stdin.resume()
#  process.stdin.setEncoding('utf8')
#  process.stdin.on('line', function (line) {
#    console.log(line event:', line)
#  })
#


emitLines = ( stream ) ->
  backlog = ''

  stream.on 'data', (data) ->
    backlog += data

    n = backlog.indexOf('\n')

    # got a \n? emit one or more 'line' events
    while (~n)
      stream.emit( 'line', backlog.substring( 0, n ) )
      backlog = backlog.substring( n + 1 )
      n = backlog.indexOf( '\n' )

  stream.on 'end', () ->
    stream.emit( 'line', backlog ) if backlog

module.exports = emitLines
