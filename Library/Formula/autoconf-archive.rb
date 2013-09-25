require 'formula'

class AutoconfArchive < Formula
  homepage 'http://savannah.gnu.org/projects/autoconf-archive/'
  url 'http://ftpmirror.gnu.org/autoconf-archive/autoconf-archive-2013.06.09.tar.bz2'
  mirror 'http://ftp.gnu.org/gnu/autoconf-archive/autoconf-archive-2013.06.09.tar.bz2'
  sha1 'e851014dc958fd7d3ae9b42ae370b7304e3dbad5'

  def install
    system "./configure", "--prefix=#{prefix}"
    system 'make install'
  end
end
