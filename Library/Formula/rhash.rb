require 'formula'

class Rhash < Formula
  homepage 'http://rhash.anz.ru/'
  url 'http://downloads.sourceforge.net/project/rhash/rhash/1.2.9/rhash-1.2.9-src.tar.gz'
  sha1 '83c0e74a39a7824f430ef24c107e3474831d0acf'

  def install
    system 'make', 'install', "PREFIX=#{prefix}",
                              "DESTDIR=#{prefix}",
                              "CC=#{ENV.cc}"
  end
end
