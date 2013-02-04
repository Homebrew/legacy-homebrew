require 'formula'

class AutoconfArchive < Formula
  homepage 'http://savannah.gnu.org/projects/autoconf-archive/'
  url 'http://ftpmirror.gnu.org/autoconf-archive/autoconf-archive-2013.02.02.tar.bz2'
  mirror 'http://ftp.gnu.org/gnu/autoconf-archive/autoconf-archive-2013.02.02.tar.bz2'
  sha1 '73c004801f0059e97b17db45eacd47a5095cc364'

  def install
    system './configure', "--prefix=#{prefix}"
    system 'make install'
  end
end
