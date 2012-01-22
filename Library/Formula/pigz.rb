require 'formula'

class Pigz < Formula
  url 'http://www.zlib.net/pigz/pigz-2.2.3.tar.gz'
  homepage 'http://www.zlib.net/pigz/'
  md5 '8330a6c6a3e5f1954687aaba4b973a6f'

  def install
    system "make"
    bin.install ["pigz", "unpigz"]
    man1.install ["pigz.1"]
    ln_s 'pigz.1', man1+'unpigz.1'
  end
end
