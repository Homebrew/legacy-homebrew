require 'formula'

class F3 < Formula
  homepage 'http://oss.digirati.com.br/f3/'
  url 'https://github.com/AltraMayor/f3/tarball/v2.0'
  md5 '52c068d685e4256fe56458350e203f7b'

  def install
    system "make mac"
    bin.install 'f3read', 'f3write'
  end
end
