require 'formula'

class AutoconfArchive < Formula
  url 'http://ftpmirror.gnu.org/autoconf-archive/autoconf-archive-2012.04.07.tar.bz2'
  mirror 'http://ftp.gnu.org/gnu/autoconf-archive/autoconf-archive-2012.04.07.tar.bz2'
  homepage 'http://savannah.gnu.org/projects/autoconf-archive/'
  sha1 'ca15d09f63b26b146f8be12a740a148d8deb4066'

  def install
    system './configure', "--prefix=#{prefix}"
    system 'make install'
  end
end
