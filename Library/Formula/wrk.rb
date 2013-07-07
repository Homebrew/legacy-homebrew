require 'formula'

class Wrk < Formula
  homepage 'https://github.com/wg/wrk'
  url 'https://github.com/wg/wrk/archive/2.0.0.tar.gz'
  sha1 'f4d3562ef41b8470e368b542686af3f42618aa67'

  def install
    system "make"
    bin.install "wrk"
  end

  test do
    system *%W{#{bin}/wrk -c 1 -r 1 -t 1 http://www.github.com/}
  end
end
