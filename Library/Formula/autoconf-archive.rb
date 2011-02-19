require 'formula'

class AutoconfArchive < Formula
  url 'http://ftpmirror.gnu.org/autoconf-archive/autoconf-archive-2011.01.02.tar.bz2'
  homepage 'http://savannah.gnu.org/projects/autoconf-archive/'
  md5 '2c6875364757ac301d0e8429791f0c4c'

  def install
    system './configure', "--prefix=#{prefix}"
    system 'make install'
  end
end
