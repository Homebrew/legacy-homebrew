require 'formula'

class F3 < Formula
  homepage 'http://oss.digirati.com.br/f3/'
  url 'https://github.com/AltraMayor/f3/tarball/v2.0'
  sha1 '16399962722440a8c2edd84cb337c7eb151d9b11'

  def install
    system "make mac"
    bin.install 'f3read', 'f3write'
  end
end
