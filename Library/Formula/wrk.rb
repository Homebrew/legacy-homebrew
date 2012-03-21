require 'formula'

class Wrk < Formula
  homepage 'https://github.com/wg/wrk'
  url 'https://github.com/wg/wrk/zipball/master'
  md5 '6fa352588291937b182e22fc24a205ac'
  version '1.0.0'


  def install
    system "make"
    bin.install "wrk"
  end

  def test
    system "wrk -c 1 -r 1 -t 1 http://www.github.com/"
  end
end
