require 'formula'

class Wrk < Formula
  homepage 'https://github.com/wg/wrk'
  url 'https://github.com/wg/wrk/tarball/1.0.0'
  sha1 '3b5b13830a4afcc1480895c94596827df4ae1899'

  def install
    system "make"
    bin.install "wrk"
  end

  def test
    system "#{bin}/wrk -c 1 -r 1 -t 1 http://www.github.com/"
  end
end
