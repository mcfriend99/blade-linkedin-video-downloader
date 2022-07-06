import http
import os
import colors

def error(m) {
  echo colors.text(m, colors.text_color.red)
  os.exit(1)
}

def success(m) {
  echo colors.text(m, colors.text_color.green)
  os.exit(0)
}

if os.args.length() != 4
  error('usage: linkdin download <link>')

var action = os.args[2]
var value = os.args[3]

if action == 'download' {
  try {
    var r = http.get(value)
    if r.status == 200 {
      var body = r.body.to_string()
      var video = body.match('/<video.*data\\-sources="\\[\\{([^}]+)\\}/')
      if video {
        video = video[1].replace('/&quot;/', '"').
          replace('/&amp;/', '&').
          match('/https?[^"]+/')

        if video {
          video = video[0]

          var n = video.split('?')[0].split('/')
          var name = '${n[-1]}.mp4'

          echo 'Video detected: ${video}'
          echo 'Video name: ${name}'

          var video_request = http.get(video)
          if video_request.status == 200 {
            if file(name, 'wb').write(video_request.body) {
              success('Video successfully downloaded and saved to ${name}')
            } else {
              error('Failed to download video')
            }
          } else {
            error('Could not download video')
          }
        } else {
          error('Could not extract video link')
        }
      } else {
        error('Post does not contain any video')
      }
    } else {
      error('LinkedIn post not found')
    }
  } catch Exception e {
    error(e.message)
  }
} else {
  error('unknown command: ${action}')
}
