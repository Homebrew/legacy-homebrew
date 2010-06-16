require 'formula'

class AutoconfArchive < Formula
  url 'http://download.savannah.nongnu.org/releases/autoconf-archive/autoconf-archive-2010.02.14.tar.bz2'
  homepage 'http://savannah.gnu.org/projects/autoconf-archive/'
  md5 '8dbbc4b75b518ca6d16826be9515a1ac'

  def install
    system './configure', "--prefix=#{prefix}"
    system 'make install'
  end
end
