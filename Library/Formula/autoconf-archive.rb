require 'formula'

class AutoconfArchive < Formula
  url 'http://ftpmirror.gnu.org/autoconf-archive/autoconf-archive-2011.12.21.tar.bz2'
  mirror 'http://ftp.gnu.org/gnu/autoconf-archive/autoconf-archive-2011.12.21.tar.bz2'
  homepage 'http://savannah.gnu.org/projects/autoconf-archive/'
  md5 'd209c2f6034c07835987e4741fd504c0'

  def install
    system './configure', "--prefix=#{prefix}"
    system 'make install'
  end
end
