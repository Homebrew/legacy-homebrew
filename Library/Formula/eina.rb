require 'formula'

class Eina < Formula
  homepage 'http://trac.enlightenment.org/e/wiki/Eina'
  url 'http://download.enlightenment.org/releases/eina-1.1.0.tar.gz'
  md5 'fedb3814427827c1bb777edea3c86298'

  head 'http://svn.enlightenment.org/svn/e/trunk/eina/'

  depends_on 'pkg-config' => :build

  if ARGV.build_head? and MacOS.xcode_version >= "4.3"
    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  def install
    system "./autogen.sh" if ARGV.build_head?
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make install"
  end
end
