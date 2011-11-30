require 'formula'

class AutoconfArchive < Formula
  url 'http://ftpmirror.gnu.org/autoconf-archive/autoconf-archive-2011.09.17.tar.bz2'
  mirror 'http://ftp.gnu.org/gnu/autoconf-archive/autoconf-archive-2011.09.17.tar.bz2'
  homepage 'http://savannah.gnu.org/projects/autoconf-archive/'
  md5 'a753535afdc49e09effae2de3bce0a61'

  def install
    system './configure', "--prefix=#{prefix}"
    system 'make install'
  end
end
