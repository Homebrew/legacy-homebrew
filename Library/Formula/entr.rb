require 'formula'

class Entr < Formula
  url 'http://entrproject.org/code/entr-1.9.tar.gz'
  homepage 'https://bitbucket.org/eradman/entr'
  version '1.9'
  sha1 'b339dd1710addac2e69885681e95f19129ec6576'

  def install
    system "./configure"
    system "make test"
    system "make PREFIX=#{prefix} MANPREFIX=#{man} install"
  end
end
