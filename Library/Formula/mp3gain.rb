require 'formula'

class Mp3gain < Formula
  url 'http://downloads.sourceforge.net/project/mp3gain/mp3gain/1.5.1/mp3gain-1_5_1-src.zip'
  version "1.5.1"
  homepage 'http://mp3gain.sourceforge.net'
  md5 '71a43bd183bc2a2c37fbf4a633ffb7aa'

  def install
    system "make"
    bin.install 'mp3gain'
  end
end

