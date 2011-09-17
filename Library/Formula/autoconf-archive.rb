require 'formula'

class AutoconfArchive < Formula
  url 'http://ftpmirror.gnu.org/autoconf-archive/autoconf-archive-2011.07.17.tar.bz2'
  homepage 'http://savannah.gnu.org/projects/autoconf-archive/'
  md5 '3251d5829824abeb5f1dad2c7c13cf83'

  def install
    system './configure', "--prefix=#{prefix}"
    system 'make install'
  end
end
