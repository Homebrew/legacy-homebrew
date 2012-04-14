require 'formula'

class AutoconfArchive < Formula
  url 'http://ftpmirror.gnu.org/autoconf-archive/autoconf-archive-2012.04.07.tar.bz2'
  mirror 'http://ftp.gnu.org/gnu/autoconf-archive/autoconf-archive-2012.04.07.tar.bz2'
  homepage 'http://savannah.gnu.org/projects/autoconf-archive/'
  md5 'e842c5b9fae021007bd70550362e5e80'

  def install
    system './configure', "--prefix=#{prefix}"
    system 'make install'
  end
end
