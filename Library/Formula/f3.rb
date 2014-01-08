require 'formula'

class F3 < Formula
  homepage 'http://oss.digirati.com.br/f3/'
  url 'https://github.com/AltraMayor/f3/archive/v2.2.tar.gz'
  sha1 '25a98e620206ef8c8c47db4d6972e1348f7f7b98'

  def install
    system "make mac"
    bin.install 'f3read', 'f3write'
  end
end
