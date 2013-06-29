require 'formula'

class AutoconfArchive < Formula
  homepage 'http://savannah.gnu.org/projects/autoconf-archive/'
  url 'http://ftpmirror.gnu.org/autoconf-archive/autoconf-archive-2013.04.06.tar.bz2'
  mirror 'http://ftp.gnu.org/gnu/autoconf-archive/autoconf-archive-2013.04.06.tar.bz2'
  sha1 'e52250911531c0ba0382c823c544e00e38750240'

  def install
    system "./configure", "--prefix=#{prefix}"
    system 'make install'
  end
end
