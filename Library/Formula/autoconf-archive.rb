require 'formula'

class AutoconfArchive < Formula
  homepage 'http://savannah.gnu.org/projects/autoconf-archive/'
  url 'http://ftpmirror.gnu.org/autoconf-archive/autoconf-archive-2013.11.01.tar.bz2'
  mirror 'http://ftp.gnu.org/gnu/autoconf-archive/autoconf-archive-2013.11.01.tar.bz2'
  sha1 '9320f7fa59cda416920f5d6cc7784ace0f557050'

  def install
    system "./configure", "--prefix=#{prefix}"
    system 'make install'
  end
end
