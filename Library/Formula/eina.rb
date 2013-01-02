require 'formula'

class Eina < Formula
  homepage 'http://trac.enlightenment.org/e/wiki/Eina'
  url 'http://download.enlightenment.org/releases/eina-1.7.1.tar.gz'
  sha1 '6d5d7344aed93a71edf9c7cccf3d3c8bc28043a7'

  head 'http://svn.enlightenment.org/svn/e/trunk/eina/'

  depends_on 'pkg-config' => :build

  if build.head?
    depends_on :autoconf
    depends_on :automake
    depends_on :libtool
  end

  def install
    system "./autogen.sh" if build.head?
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make install"
  end
end
