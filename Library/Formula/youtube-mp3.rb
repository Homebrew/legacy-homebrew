require 'formula'

class YoutubeMp3 < Formula
  url 'https://raw.github.com/dejay/youtube-mp3/master/youtube-mp3'
  homepage 'http://dejay.github.com'
  md5 '0b631b4fa33cc1e104665ba1871232f8'

  depends_on 'ffmpeg'
  depends_on 'youtube-dl'
end