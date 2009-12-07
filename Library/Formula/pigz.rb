require 'formula'

class Pigz <Formula
  url 'http://www.zlib.net/pigz/pigz-2.1.5.tar.gz'
  homepage 'http://www.zlib.net/pigz/'
  md5 '580873165ef3a369674f0c0af4c96d67'

  def install
    system "make"
    bin.install "pigz"
    bin.install "unpigz"
  end
end
