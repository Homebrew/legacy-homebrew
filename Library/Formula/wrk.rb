require 'formula'

class Wrk < Formula
  homepage 'https://github.com/wg/wrk'
  url 'https://github.com/wg/wrk/archive/1.1.1.tar.gz'
  sha1 '47713b26b17f6d461dcfaaa6eea841f201fdf75d'

  def install
    system "make"
    bin.install "wrk"
  end

  def test
    system "#{bin}/wrk -c 1 -r 1 -t 1 http://www.github.com/"
  end
end
