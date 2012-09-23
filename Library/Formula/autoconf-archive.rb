require 'formula'

class AutoconfArchive < Formula
  url 'http://ftpmirror.gnu.org/autoconf-archive/autoconf-archive-2012.09.08.tar.bz2'
  mirror 'http://ftp.gnu.org/gnu/autoconf-archive/autoconf-archive-2012.09.08.tar.bz2'
  homepage 'http://savannah.gnu.org/projects/autoconf-archive/'
  sha1 '2e6b427bc8fbcd69bd0d9a568678cdc7e2f36d03'

  def install
    system './configure', "--prefix=#{prefix}"
    system 'make install'
  end
end
