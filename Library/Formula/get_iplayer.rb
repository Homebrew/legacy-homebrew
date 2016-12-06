require 'formula'

class GetIplayer < Formula
  homepage 'http://www.infradead.org/get_iplayer'
  url 'ftp://ftp.infradead.org/pub/get_iplayer/get_iplayer-2.82.tar.gz'
  md5 '9301597594380e5c3e76a3026601f045'

  head 'git://git.infradead.org/get_iplayer.git'

  def install
    prefix.install 'README-get_iplayer.cgi.txt'
    bin.install 'get_iplayer', 'get_iplayer.cgi'
    man1.install 'get_iplayer.1'
    (prefix/'etc/get_iplayer/options').write 'packagemanager homebrew'
    inreplace "#{bin}/get_iplayer", '/etc/get_iplayer/options', "#{HOMEBREW_PREFIX}/etc/get_iplayer/options"
    inreplace "#{bin}/get_iplayer.cgi", '/usr/bin/get_iplayer', "#{HOMEBREW_PREFIX}/bin/get_iplayer"
  end

  def caveats; <<-EOS.undent
    Installing get_iplayer Dependencies

    get_iplayer uses the following helper applications:

      rtmpdump: downloading all programmes
      atomicparsley: metadata tagging for MP4 video and AAC audio
      ffmpeg: re-muxing FLV to MP4 video and AAC audio
      id3v2: metadata tagging for MP3 audio
      mplayer: re-muxing FLV to MP3 audio

    Media file formats correspond to programme types as follows:

      MP4 video: BBC TV
      AAC audio: BBC national radio
      MP3 audio: BBC local and regional radio

    All get_iplayer dependencies may be installed with Homebrew, but the
    installation commands vary according to the version of Xcode you use.
    Below are suggested installation commands for get_iplayer dependencies
    using several versions of Xcode.  You may need to adjust these commands
    to accommodate future changes in the formulae for dependencies.

    Xcode 4.1 and Xcode 4.2 upgrade (installed over 4.1):

      brew install --use-clang rtmpdump
      brew install atomicparsley
      brew install --use-clang ffmpeg
      brew install id3v2
      brew install --use-gcc mplayer

    Xcode 4.2 standalone (not installed over 4.1):

      brew tap homebrew/dupes
      brew install apple-gcc42
      brew install --use-clang rtmpdump
      brew install atomicparsley
      brew install --use-clang ffmpeg
      brew install id3v2
      brew install --use-gcc mplayer

    Xcode 4.3 standalone:

      brew tap homebrew/dupes
      brew install apple-gcc42
      brew install rtmpdump
      brew install atomicparsley
      brew install ffmpeg
      brew install id3v2
      brew install --use-gcc mplayer


    Using the Web PVR Manager

    1. Run in terminal window:

      get_iplayer.cgi --listen 127.0.0.1 --port 1935

    2. Open in web browser:

      http://127.0.0.1:1935

    EOS
  end

end
